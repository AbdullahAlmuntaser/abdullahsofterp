import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

class ManufacturingConfig {
  Decimal overheadPercentage;
  Decimal scrapFactor;
  Decimal yieldFactor;

  ManufacturingConfig({
    Decimal? overheadPercentage,
    Decimal? scrapFactor,
    Decimal? yieldFactor,
  }) : overheadPercentage = overheadPercentage ?? Decimal.zero,
      scrapFactor = scrapFactor ?? Decimal.one,
      yieldFactor = yieldFactor ?? Decimal.one;
}

class ManufacturingService {
  final AppDatabase db;
  ManufacturingConfig config;

  ManufacturingService(this.db, {ManufacturingConfig? config})
      : config = config ?? ManufacturingConfig();

  Future<List<BillOfMaterial>> getBomForProduct(String productId) {
    return (db.select(db.billOfMaterials)
          ..where((tbl) => tbl.finishedProductId.equals(productId)))
        .get();
  }

  Future<List<BillOfMaterial>> getAllBoms() {
    return db.select(db.billOfMaterials).get();
  }

  Future<void> addComponent(
    String finishedProductId,
    String componentProductId,
    Decimal quantity,
  ) async {
    await db.into(db.billOfMaterials).insert(
          BillOfMaterialsCompanion.insert(
            finishedProductId: finishedProductId,
            componentProductId: componentProductId,
            quantity: Value(quantity),
          ),
        );
  }

  Future<void> updateComponentQuantity(String id, Decimal quantity) async {
    await (db.update(db.billOfMaterials)..where((tbl) => tbl.id.equals(id)))
        .write(BillOfMaterialsCompanion(quantity: Value(quantity)));
  }

  Future<void> removeComponent(String id) async {
    await (db.delete(db.billOfMaterials)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> clearBomForProduct(String productId) async {
    await (db.delete(db.billOfMaterials)
          ..where((tbl) => tbl.finishedProductId.equals(productId)))
        .go();
  }

  Future<void> createProductionOrder({
    required String finishedProductId,
    required Decimal quantity,
    String? warehouseId,
    String? note,
  }) async {
    await db.transaction(() async {
      final orderId = const Uuid().v4();
      final bom = await (db.select(db.billOfMaterials)
            ..where((t) => t.finishedProductId.equals(finishedProductId)))
          .get();

      if (bom.isEmpty) throw Exception('لا توجد مكونات لهذا المنتج');

      final adjustedQty = (quantity / config.yieldFactor).toDecimal();

      await db.into(db.productionOrders).insert(
            ProductionOrdersCompanion.insert(
              id: Value(orderId),
              finishedProductId: finishedProductId,
              plannedQuantity: Value(adjustedQty),
              warehouseId: Value(warehouseId),
              note: Value(note),
            ),
          );

      for (var item in bom) {
        final requiredQty =
            (item.quantity * adjustedQty / config.scrapFactor).toDecimal();
        await db.into(db.productionOrderItems).insert(
              ProductionOrderItemsCompanion.insert(
                productionOrderId: orderId,
                componentProductId: item.componentProductId,
                plannedQuantity: Value(requiredQty),
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

      final whId = order.warehouseId;
      if (whId == null || whId.isEmpty) {
        throw Exception('المستودع مطلوب لإتمام أمر الإنتاج.');
      }

      Decimal totalCost = Decimal.zero;
      for (var item in items) {
        final allBatches = await (db.select(db.productBatches)
              ..where((b) => b.productId.equals(item.componentProductId))
              ..where((b) => b.warehouseId.equals(whId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.expiryDate),
                (t) => OrderingTerm.asc(t.createdAt),
              ]))
            .get();
        final batches = allBatches
            .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
            .toList();

        Decimal remaining = item.plannedQuantity;
        Decimal available = batches.fold<Decimal>(
            Decimal.zero, (sum, b) => sum + (b.quantity - b.reservedQuantity));

        if (available < remaining) {
          final productName =
              await _getProductName(item.componentProductId);
          throw Exception(
              'المخزون غير كافٍ: $productName');
        }

        for (var batch in batches) {
          if (remaining <= Decimal.zero) break;
          final batchAvailable = batch.quantity - batch.reservedQuantity;
          final deduct = remaining > batchAvailable ? batchAvailable : remaining;
          final deductFromReserved =
              batch.reservedQuantity >= deduct ? deduct : batch.reservedQuantity;
          await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id)))
              .write(ProductBatchesCompanion(
            quantity: Value(batch.quantity - deduct),
            reservedQuantity: Value(batch.reservedQuantity - deductFromReserved),
          ));
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

      final overheadCost =
          (totalCost * config.overheadPercentage / Decimal.fromInt(100)).toDecimal();
      final totalWithOverhead = totalCost + overheadCost;
      final effectiveYield =
          order.plannedQuantity * config.yieldFactor;
      final unitCost = effectiveYield > Decimal.zero
          ? (totalWithOverhead / effectiveYield).toDecimal()
          : Decimal.zero;

      final finishedBatchId = const Uuid().v4();
      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: Value(finishedBatchId),
              productId: order.finishedProductId,
              warehouseId: whId,
              batchNumber: 'PROD-${orderId.substring(0, 8)}',
              quantity: Value(effectiveYield),
              initialQuantity: Value(effectiveYield),
              costPrice: Value(unitCost),
            ),
          );

      await db.stockMovementDao.insertStockMovement(
        StockMovementsCompanion.insert(
          productId: order.finishedProductId,
          quantity: effectiveYield,
          cost: Value(totalWithOverhead),
          type: 'PRODUCTION_OUTPUT',
          referenceId: Value(orderId),
          batchId: Value(finishedBatchId),
          movementDate: Value(DateTime.now()),
        ),
      );

      await (db.update(db.productionOrders)..where((t) => t.id.equals(orderId)))
          .write(
        ProductionOrdersCompanion(
          status: const Value('COMPLETED'),
          actualQuantity: Value(effectiveYield),
        ),
      );
    });
  }

  Future<String> assemble({
    required String finishedProductId,
    required Decimal producedQuantity,
    required String warehouseId,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    await db.transaction(() async {
      final components = await getBomForProduct(finishedProductId);
      if (components.isEmpty) {
        throw Exception('لا توجد مكونات مُعرفة لهذا المنتج');
      }

      for (final component in components) {
        final requiredQty =
            (component.quantity * producedQuantity / config.scrapFactor).toDecimal();
        final allBatches = await (db.select(db.productBatches)
              ..where((b) =>
                  b.productId.equals(component.componentProductId) &
                  b.warehouseId.equals(warehouseId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.expiryDate),
                (t) => OrderingTerm.asc(t.createdAt),
              ]))
            .get();
        final batches = allBatches
            .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
            .toList();

        Decimal totalAvailable =
            batches.fold<Decimal>(Decimal.zero, (sum, b) => sum + (b.quantity - b.reservedQuantity));
        if (totalAvailable < requiredQty) {
          final name = await _getProductName(component.componentProductId);
          throw Exception(
            'المخزون غير كافٍ: $name — المطلوب: $requiredQty، المتاح: $totalAvailable',
          );
        }

        await _consumeFromBatches(
          component.componentProductId,
          warehouseId,
          requiredQty,
          'ASSEMBLY_CONSUME',
          finishedProductId,
        );
      }

      final finalBatchNumber =
          batchNumber ?? 'ASM-${DateTime.now().millisecondsSinceEpoch}';
      final baseCost = await _calculateAssemblyCost(components, producedQuantity);
      final overheadCost =
          (baseCost * config.overheadPercentage / Decimal.fromInt(100)).toDecimal();
      final totalCost = baseCost + overheadCost;
      final effectiveOutput =
          producedQuantity * config.yieldFactor;

      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              productId: finishedProductId,
              warehouseId: warehouseId,
              batchNumber: finalBatchNumber,
              quantity: Value(effectiveOutput),
              initialQuantity: Value(effectiveOutput),
              costPrice: Value(totalCost),
              expiryDate: Value(expiryDate),
            ),
          );

      await db.into(db.inventoryTransactions).insert(
            InventoryTransactionsCompanion.insert(
              productId: finishedProductId,
              warehouseId: warehouseId,
              batchId: Value(finalBatchNumber),
              quantity: Value(effectiveOutput),
              type: 'ASSEMBLY_PRODUCE',
              referenceId:
                  'ASSEMBLY-${DateTime.now().millisecondsSinceEpoch.toString()}',
            ),
          );
    });

    return 'تم تجميع $producedQuantity وحدة بنجاح';
  }

  Future<void> _consumeFromBatches(
    String productId,
    String warehouseId,
    Decimal quantity,
    String type,
    String referenceId,
  ) async {
    Decimal remaining = quantity;
    final allBatches = await (db.select(db.productBatches)
          ..where((b) =>
              b.productId.equals(productId) &
              b.warehouseId.equals(warehouseId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.expiryDate),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
    final batches = allBatches
        .where((b) => (b.quantity - b.reservedQuantity) > Decimal.zero)
        .toList();

    for (final batch in batches) {
      if (remaining <= Decimal.zero) break;
      final available = batch.quantity - batch.reservedQuantity;
      final consumeQty = available < remaining ? available : remaining;
      final deductFromReserved =
          batch.reservedQuantity >= consumeQty ? consumeQty : batch.reservedQuantity;
      remaining -= consumeQty;

      await (db.update(db.productBatches)..where((b) => b.id.equals(batch.id)))
          .write(ProductBatchesCompanion(
        quantity: Value(batch.quantity - consumeQty),
        reservedQuantity: Value(batch.reservedQuantity - deductFromReserved),
      ));

      await db.into(db.inventoryTransactions).insert(
            InventoryTransactionsCompanion.insert(
              productId: productId,
              warehouseId: warehouseId,
              batchId: Value(batch.id),
              quantity: Value(-consumeQty),
              type: type,
              referenceId: referenceId,
            ),
          );
    }
  }

  Future<Decimal> _calculateAssemblyCost(
      List<BillOfMaterial> components, Decimal producedQuantity) async {
    Decimal totalCost = Decimal.zero;
    for (final component in components) {
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals(component.componentProductId)))
          .getSingleOrNull();
      if (product != null) {
        totalCost += (product.buyPrice * component.quantity * producedQuantity);
      }
    }
    return totalCost;
  }

  Future<String> _getProductName(String productId) async {
    final product =
        await (db.select(db.products)..where((p) => p.id.equals(productId)))
            .getSingleOrNull();
    return product?.name ?? productId;
  }
}
