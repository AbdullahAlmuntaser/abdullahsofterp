import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/concurrency_exception.dart';
import 'package:uuid/uuid.dart';

class ProductionService {
  final AppDatabase db;

  ProductionService(this.db);

  Future<void> createProductionOrder({
    required String finishedProductId,
    required Decimal quantity,
    String? warehouseId,
    String? note,
  }) async {
    await db.transaction(() async {
      final orderId = const Uuid().v4();

      // 1. Get BOM for this product
      final bom = await (db.select(db.billOfMaterials)
            ..where((t) => t.finishedProductId.equals(finishedProductId)))
          .get();

      if (bom.isEmpty) throw Exception('No BOM found for this product');

      // 2. Create Order
      await db.into(db.productionOrders).insert(
            ProductionOrdersCompanion.insert(
              id: Value(orderId),
              finishedProductId: finishedProductId,
              plannedQuantity: Value(quantity),
              warehouseId: Value(warehouseId),
              note: Value(note),
            ),
          );

      // 3. Create Order Items from BOM
      for (var item in bom) {
        await db.into(db.productionOrderItems).insert(
              ProductionOrderItemsCompanion.insert(
                productionOrderId: orderId,
                componentProductId: item.componentProductId,
                plannedQuantity: Value(item.quantity * quantity),
              ),
            );
      }
    });
  }

  Future<void> completeProductionOrder(String orderId) async {
    await db.transaction(() async {
      final order = await (db.select(db.productionOrders)
            ..where((t) => t.id.equals(orderId)))
          .getSingle();
      final items = await (db.select(db.productionOrderItems)
            ..where((t) => t.productionOrderId.equals(orderId)))
          .get();

      // 1. Consume Raw Materials from actual batches
      Decimal totalCost = Decimal.zero;
      for (var item in items) {
        final allBatches = await (db.select(db.productBatches)
              ..where(
                  (b) => b.productId.equals(item.componentProductId)))
            .get();
        final batches = allBatches
            .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
            .toList();

        Decimal remaining = item.plannedQuantity;
        for (var batch in batches) {
          if (remaining <= Decimal.zero) break;
          final available = batch.quantity - batch.reservedQuantity;
          final deduct = remaining > available ? available : remaining;
          final deductFromReserved =
              batch.reservedQuantity >= deduct ? deduct : batch.reservedQuantity;

          final changes = await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
              .write(ProductBatchesCompanion(
            quantity: Value(batch.quantity - deduct),
            reservedQuantity: Value(batch.reservedQuantity - deductFromReserved),
          ).copyWith(version: Value(batch.version + 1)));
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch ${batch.id} was modified by another transaction');
          }

          await db.stockMovementDao.insertStockMovement(
            StockMovementsCompanion.insert(
              productId: item.componentProductId,
              quantity: -deduct,
              type: 'PRODUCTION_CONSUME',
              referenceId: Value(orderId),
              batchId: Value(batch.id),
              movementDate: Value(DateTime.now()),
            ),
          );

          totalCost += deduct * batch.costPrice;
          remaining -= deduct;
        }
      }

      // 2. Create batch for finished good with calculated cost
      final finishedBatchId = const Uuid().v4();
      final unitCost = order.plannedQuantity > Decimal.zero
          ? (totalCost / order.plannedQuantity).toDecimal()
          : Decimal.zero;

      final whId = order.warehouseId;
      if (whId == null || whId.isEmpty) {
        throw Exception('المستودع مطلوب لإتمام أمر الإنتاج.');
      }
      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: Value(finishedBatchId),
              productId: order.finishedProductId,
              warehouseId: whId,
              batchNumber: 'PROD-${orderId.substring(0, 8)}',
              quantity: Value(order.plannedQuantity),
              initialQuantity: Value(order.plannedQuantity),
              costPrice: Value(unitCost),
            ),
          );

      await db.stockMovementDao.insertStockMovement(
        StockMovementsCompanion.insert(
          productId: order.finishedProductId,
          quantity: order.plannedQuantity,
          cost: Value(totalCost),
          type: 'PRODUCTION_OUTPUT',
          referenceId: Value(orderId),
          batchId: Value(finishedBatchId),
          movementDate: Value(DateTime.now()),
        ),
      );

      // 3. Update Order Status
      await (db.update(db.productionOrders)..where((t) => t.id.equals(orderId)))
          .write(
        ProductionOrdersCompanion(
          status: const Value('COMPLETED'),
          actualQuantity: Value(order.plannedQuantity),
        ),
      );
    });
  }
}
