import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:supermarket/core/constants/account_codes.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/stock_transfer_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/concurrency_exception.dart';

class StockOperationService {
  final AppDatabase db;
  final AuditService _auditService;
  final AppConfigService _configService;
  final PostingEngine _postingEngine;

  StockOperationService(this.db, this._auditService, this._configService, this._postingEngine);

  Future<void> performInventoryAudit({
    required InventoryAuditsCompanion auditCompanion,
    required List<InventoryAuditItemsCompanion> items,
    String? userId,
  }) async {
    await db.transaction(() async {
      final auditRow =
          await db.into(db.inventoryAudits).insertReturning(auditCompanion);
      final auditId = auditRow.id;

      Decimal totalInventoryAdjustmentValue = Decimal.zero;

      for (var item in items) {
        final productId = item.productId.value;
        final actualStock = item.actualStock.value;

        final product = await (db.select(db.products)
          ..where((p) => p.id.equals(productId)))
            .getSingle();
        final systemStockDecimal = product.stock;
        final actualStockDecimal = Decimal.parse(actualStock.toString());
        final differenceDecimal = actualStockDecimal - systemStockDecimal;

        await db.into(db.inventoryAuditItems).insert(
              item.copyWith(
                auditId: drift.Value(auditId),
                systemStock: drift.Value(systemStockDecimal),
                difference: drift.Value(differenceDecimal),
              ),
            );

        if (differenceDecimal != Decimal.zero) {
          await (db.update(db.products)
            ..where((p) => p.id.equals(productId)))
              .write(
                  ProductsCompanion(stock: drift.Value(actualStockDecimal)));

          if (differenceDecimal < Decimal.zero) {
            Decimal remainingToDeduct = differenceDecimal.abs();
            final allBatches = await (db.select(db.productBatches)
                  ..where((b) =>
                      b.productId.equals(productId))
                  ..orderBy([
                    (b) => drift.OrderingTerm(
                          expression: b.createdAt,
                          mode: drift.OrderingMode.asc,
                        ),
                  ]))
                .get();
            final batches = allBatches
                .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
                .toList();

            for (var batch in batches) {
              if (remainingToDeduct <= Decimal.zero) break;
              final available = batch.quantity - batch.reservedQuantity;
              final Decimal deductFromThisBatch =
                  available >= remainingToDeduct
                      ? remainingToDeduct
                      : available;
              final deductFromReserved = batch.reservedQuantity >= deductFromThisBatch
                  ? deductFromThisBatch
                  : batch.reservedQuantity;

              final changes = await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
                  .write(
                ProductBatchesCompanion(
                  quantity:
                      drift.Value(batch.quantity - deductFromThisBatch),
                  reservedQuantity:
                      drift.Value(batch.reservedQuantity - deductFromReserved),
                ).copyWith(version: drift.Value(batch.version + 1)),
              );
              if (changes == 0) {
                throw ConcurrencyException('ProductBatch ${batch.id} was modified by another transaction');
              }
              remainingToDeduct -= deductFromThisBatch;
              totalInventoryAdjustmentValue -=
                  deductFromThisBatch * batch.costPrice;
            }
          } else {
            final defaultWarehouseId =
                await _configService.getDefaultWarehouseId();
            const uuid = Uuid();
            final averageCost = product.buyPrice;
            await db.into(db.productBatches).insert(
                  ProductBatchesCompanion(
                    id: drift.Value(uuid.v4()),
                    productId: drift.Value(productId),
                    warehouseId: drift.Value(defaultWarehouseId),
                    batchNumber:
                        drift.Value('AUDIT-${auditId.substring(0, 8)}'),
                    expiryDate: const drift.Value(null),
                    quantity: drift.Value(differenceDecimal),
                    initialQuantity: drift.Value(differenceDecimal),
                    costPrice: drift.Value(averageCost),
                  ),
                );
            totalInventoryAdjustmentValue +=
                differenceDecimal * averageCost;
          }
        }
      }

      if (totalInventoryAdjustmentValue != Decimal.zero) {
        await _postInventoryAdjustment(
          totalInventoryAdjustmentValue,
          auditId,
        );
      }

      await _auditService.log(
        action: 'INVENTORY_AUDIT',
        targetEntity: 'InventoryAudits',
        entityId: auditId,
        userId: userId,
        details:
            'Performed inventory audit with total value adjustment: $totalInventoryAdjustmentValue',
      );
    });
  }

  Future<void> _postInventoryAdjustment(
    Decimal value,
    String referenceId,
  ) async {
    final dao = db.accountingDao;
    final entryId = const Uuid().v4();

    final inventoryAccount =
        await dao.getAccountByCode(AccountCodes.inventory);
    final adjustmentAccount =
        await dao.getAccountByCode(AccountCodes.cashOverShort);

    if (inventoryAccount == null || adjustmentAccount == null) {
      throw Exception('Missing GL accounts for inventory adjustment.');
    }

    final entry = GLEntriesCompanion.insert(
      id: drift.Value(entryId),
      description: 'Inventory Adjustment (Audit #$referenceId)',
      date: drift.Value(DateTime.now()),
      referenceType: const drift.Value('INVENTORY_ADJUST'),
      referenceId: drift.Value(referenceId),
    );

    List<GLLinesCompanion> lines = [];
    if (value > Decimal.zero) {
      lines.add(GLLinesCompanion.insert(
        entryId: entryId,
        accountId: inventoryAccount.id,
        debit: drift.Value(value.abs()),
        credit: drift.Value(Decimal.zero),
      ));
      lines.add(GLLinesCompanion.insert(
        entryId: entryId,
        accountId: adjustmentAccount.id,
        debit: drift.Value(Decimal.zero),
        credit: drift.Value(value.abs()),
      ));
    } else {
      lines.add(GLLinesCompanion.insert(
        entryId: entryId,
        accountId: adjustmentAccount.id,
        debit: drift.Value(value.abs()),
        credit: drift.Value(Decimal.zero),
      ));
      lines.add(GLLinesCompanion.insert(
        entryId: entryId,
        accountId: inventoryAccount.id,
        debit: drift.Value(Decimal.zero),
        credit: drift.Value(value.abs()),
      ));
    }

    await dao.createEntry(entry, lines);
  }

  Future<void> deductStock({
    required String itemId,
    required Decimal quantity,
    required String warehouseId,
    String? referenceId,
    String? userId,
  }) async {
    await db.transaction(() async {
      final product = await (db.select(db.products)
        ..where((p) => p.id.equals(itemId)))
          .getSingle();

      final allowNegative = await _configService.getBool(
          'allow_negative_stock', defaultValue: false);

      if (!allowNegative && product.stock < quantity) {
        throw Exception(
            'الرصيد الحالي (${product.stock}) غير كافٍ لخصم الكمية ($quantity). العملية مرفوضة.');
      }

      final newStock = product.stock - quantity;

      final productChanges = await (db.update(db.products)
        ..where((p) => p.id.equals(itemId) & p.version.equals(product.version)))
          .write(ProductsCompanion(
            stock: drift.Value(newStock),
          ).copyWith(version: drift.Value(product.version + 1)));
      if (productChanges == 0) {
        throw ConcurrencyException('Product $itemId was modified by another transaction');
      }

      // Deduct from batches using FEFO (earliest expiry first, then earliest created)
      Decimal remainingToDeduct = quantity;
      final allBatches = await (db.select(db.productBatches)
            ..where((b) =>
                b.productId.equals(itemId) &
                b.warehouseId.equals(warehouseId)))
          .get();
      final batches = allBatches
          .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
          .toList();
      batches.sort((a, b) {
        if (a.expiryDate == null && b.expiryDate == null) {
          return a.createdAt.compareTo(b.createdAt);
        }
        if (a.expiryDate == null) return 1;
        if (b.expiryDate == null) return -1;
        final expiryCmp = a.expiryDate!.compareTo(b.expiryDate!);
        if (expiryCmp != 0) return expiryCmp;
        return a.createdAt.compareTo(b.createdAt);
      });

      for (var batch in batches) {
        if (remainingToDeduct <= Decimal.zero) break;
        final available = batch.quantity - batch.reservedQuantity;
        final Decimal deductFromThisBatch =
            available >= remainingToDeduct ? remainingToDeduct : available;
        final deductFromReserved = batch.reservedQuantity >= deductFromThisBatch
            ? deductFromThisBatch
            : batch.reservedQuantity;

        final changes = await (db.update(db.productBatches)
          ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
            .write(
          ProductBatchesCompanion(
            quantity: drift.Value(batch.quantity - deductFromThisBatch),
            reservedQuantity:
                drift.Value(batch.reservedQuantity - deductFromReserved),
          ).copyWith(version: drift.Value(batch.version + 1)),
        );
        if (changes == 0) {
          throw ConcurrencyException('ProductBatch ${batch.id} was modified by another transaction');
        }
        remainingToDeduct -= deductFromThisBatch;
      }

      await db.into(db.stockMovements).insert(
            StockMovementsCompanion.insert(
              productId: itemId,
              quantity: -quantity,
              type: 'SALE',
              referenceId: drift.Value(referenceId),
              transactionId: drift.Value(userId),
            ),
          );

      if (allowNegative && newStock < Decimal.zero) {
        await _auditService.log(
          action: 'NEGATIVE_STOCK_ALLOWED',
          targetEntity: 'Products',
          entityId: itemId,
          userId: userId ?? 'SYSTEM',
          details:
              'تم خصم الكمية $quantity والرصيد أصبح $newStock (مسموح حسب الإعدادات)',
        );
      }
    });
  }

  Future<void> transferStock({
    required String fromWarehouseId,
    required String toWarehouseId,
    required List<StockTransferItemsCompanion> items,
    String? note,
    String? userId,
  }) async {
    final transferItems = items.map((item) => TransferItemData(
      productId: item.productId.value,
      batchId: item.batchId.value,
      quantity: Decimal.parse(item.quantity.value.toString()),
    )).toList();

    final transferService = StockTransferService(db, _postingEngine);
    await transferService.processTransfer(
      fromWarehouseId: fromWarehouseId,
      toWarehouseId: toWarehouseId,
      items: transferItems,
      note: note,
      userId: userId,
    );
  }
}
