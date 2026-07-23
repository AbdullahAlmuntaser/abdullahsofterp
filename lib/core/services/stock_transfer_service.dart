import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/concurrency_exception.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

class StockTransferService {
  final AppDatabase db;
  final PostingEngine postingEngine;
  late final AuditService _auditService;

  StockTransferService(this.db, this.postingEngine) {
    _auditService = AuditService(db);
  }

  Future<void> processTransfer({
    required String fromWarehouseId,
    required String toWarehouseId,
    required List<TransferItemData> items,
    String? note,
    String? userId,
  }) async {
    if (fromWarehouseId == toWarehouseId) {
      throw Exception('Source and destination warehouses must be different.');
    }

    await db.transaction(() async {
      final transferId = const Uuid().v4();

      // 1. Record Transfer Header
      await db.into(db.stockTransfers).insert(
            StockTransfersCompanion.insert(
              id: Value(transferId),
              fromWarehouseId: fromWarehouseId,
              toWarehouseId: toWarehouseId,
              transferDate: Value(DateTime.now()),
              note: Value(note),
              status: const Value('COMPLETED'),
            ),
          );

      Decimal transferValue = Decimal.zero;

      for (var item in items) {
        // 2. Get Source Batch
        final sourceBatch = await (db.select(
          db.productBatches,
        )..where((t) => t.id.equals(item.batchId)))
            .getSingle();

        final sourceAvailable =
            sourceBatch.quantity - sourceBatch.reservedQuantity;
        if (sourceAvailable < item.quantity) {
          throw Exception(
            'Insufficient stock in batch ${sourceBatch.batchNumber} for product ${item.productId}. '
            'Available: $sourceAvailable, requested: ${item.quantity}',
          );
        }

        // 3. Update Source Batch (Deduct)
        final deductFromReserved = sourceBatch.reservedQuantity >= item.quantity
            ? item.quantity
            : sourceBatch.reservedQuantity;
        final changes = await (db.update(
          db.productBatches,
        )..where((t) => t.id.equals(sourceBatch.id) & t.version.equals(sourceBatch.version)))
            .write(
          ProductBatchesCompanion(
            quantity: Value(sourceBatch.quantity - item.quantity),
            reservedQuantity:
                Value(sourceBatch.reservedQuantity - deductFromReserved),
          ).copyWith(version: Value(sourceBatch.version + 1)),
        );
        if (changes == 0) {
          throw ConcurrencyException('ProductBatch ${sourceBatch.id} was modified by another transaction');
        }

        transferValue += item.quantity * sourceBatch.costPrice;

        // Record Deduct Transaction
        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: fromWarehouseId,
                batchId: Value(item.batchId),
                quantity: Value(-item.quantity),
                type: 'TRANSFER_OUT',
                referenceId: transferId,
              ),
            );

        // 4. Create or Update Destination Batch
        final existingDestBatch = await (db.select(db.productBatches)
              ..where(
                (t) =>
                    t.productId.equals(item.productId) &
                    t.warehouseId.equals(toWarehouseId) &
                    t.batchNumber.equals(sourceBatch.batchNumber),
              )
              ..limit(1))
            .getSingleOrNull();

        String destBatchId;
        if (existingDestBatch != null) {
          destBatchId = existingDestBatch.id;
          final changes = await (db.update(
            db.productBatches,
          )..where((t) => t.id.equals(destBatchId) & t.version.equals(existingDestBatch.version)))
              .write(
            ProductBatchesCompanion(
              quantity: Value(existingDestBatch.quantity + item.quantity),
              reservedQuantity: Value(existingDestBatch.reservedQuantity),
              storedUnitId: Value(existingDestBatch.storedUnitId),
              quantityInStoredUnit:
                  Value(existingDestBatch.quantityInStoredUnit),
            ).copyWith(version: Value(existingDestBatch.version + 1)),
          );
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch $destBatchId was modified by another transaction');
          }
        } else {
          destBatchId = const Uuid().v4();
          await db.into(db.productBatches).insert(
                ProductBatchesCompanion.insert(
                  id: Value(destBatchId),
                  productId: item.productId,
                  warehouseId: toWarehouseId,
                  batchNumber: sourceBatch.batchNumber,
                  expiryDate: Value(sourceBatch.expiryDate),
                  quantity: Value(item.quantity),
                  initialQuantity: Value(item.quantity),
                  costPrice: Value(sourceBatch.costPrice),
                  storedUnitId: Value(sourceBatch.storedUnitId),
                  quantityInStoredUnit: Value(sourceBatch.quantityInStoredUnit),
                ),
              );
        }

        // Record Add Transaction
        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: toWarehouseId,
                batchId: Value(destBatchId),
                quantity: Value(item.quantity),
                type: 'TRANSFER_IN',
                referenceId: transferId,
              ),
            );

        // 5. Record Transfer Item
        await db.into(db.stockTransferItems).insert(
              StockTransferItemsCompanion.insert(
                id: Value(const Uuid().v4()),
                transferId: transferId,
                productId: item.productId,
                batchId: item.batchId,
                quantity: Value(item.quantity),
              ),
            );
      }

      // 6. GL Entry for stock transfer
      if (transferValue > Decimal.zero) {
        await postingEngine.post(
          type: TransactionType.transfer,
          referenceId: transferId,
          context: {
            'amount': transferValue,
            'fromWarehouseId': fromWarehouseId,
            'toWarehouseId': toWarehouseId,
            'description': 'تحويل مخزون #${transferId.substring(0, 8)}',
            'branchId': fromWarehouseId,
            'date': DateTime.now(),
          },
        );
      }

      // 7. Log Audit
      await _auditService.log(
        action: 'STOCK_TRANSFER',
        targetEntity: 'StockTransfers',
        entityId: transferId,
        userId: userId,
        details:
            'Transferred ${items.length} items from $fromWarehouseId to $toWarehouseId',
      );
    });
  }

  Future<List<Warehouse>> getAllWarehouses() async {
    return await db.select(db.warehouses).get();
  }

  Future<List<ProductBatch>> getBatchesForWarehouse(String warehouseId) async {
    final allBatches = await (db.select(db.productBatches)
          ..where((t) => t.warehouseId.equals(warehouseId)))
        .get();
    return allBatches
        .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
        .toList();
  }
}

class TransferItemData {
  final String productId;
  final String batchId;
  final Decimal quantity;

  TransferItemData({
    required this.productId,
    required this.batchId,
    required this.quantity,
  });
}
