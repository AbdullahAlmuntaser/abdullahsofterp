import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/inventory_costing_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/utils/stock_display_adapter.dart';
import 'dart:developer' as developer;

class BreakResult {
  final String sourceBatchId;
  final String? targetBatchId;
  final Decimal brokenQuantity;
  final Decimal costPerUnit;

  BreakResult({
    required this.sourceBatchId,
    this.targetBatchId,
    required this.brokenQuantity,
    required this.costPerUnit,
  });
}

class PackagingEngine {
  final AppDatabase db;
  final InventoryCostingService? costingService;

  PackagingEngine(this.db, {this.costingService});

  Future<List<ProductUnit>> getPackagingHierarchy(String productId) async {
    return (db.select(db.productUnits)
          ..where((u) => u.productId.equals(productId))
          ..orderBy([
            (u) =>
                OrderingTerm(expression: u.unitFactor, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<BreakResult>> autoBreakIfNecessary({
    required String productId,
    required String warehouseId,
    required Decimal requiredQtyInBase,
  }) async {
    final results = <BreakResult>[];
    if (requiredQtyInBase <= Decimal.zero) return results;

    final hierarchy = await getPackagingHierarchy(productId);
    if (hierarchy.isEmpty) return results;

    final availableBaseQty =
        await _getAvailableQuantity(productId, warehouseId);
    if (availableBaseQty >= requiredQtyInBase) return results;

    Decimal shortfall = requiredQtyInBase - availableBaseQty;
    final sortedDesc = hierarchy
        .where((u) => u.unitFactor > Decimal.one)
        .toList()
      ..sort((a, b) => b.unitFactor.compareTo(a.unitFactor));

    int maxBreaks = 100;
    int breakCount = 0;

    for (final unit in sortedDesc) {
      if (shortfall <= Decimal.zero) break;

      final batches = await _getBatchesHavingAtLeast(
          productId, warehouseId, unit.unitFactor);

      for (final batch in batches) {
        if (shortfall <= Decimal.zero || breakCount >= maxBreaks) break;

        while (shortfall > Decimal.zero && breakCount < maxBreaks) {
          // Reload batch to get current reservedQuantity
          final currentBatch = await (db.select(db.productBatches)
                ..where((b) => b.id.equals(batch.id)))
              .getSingleOrNull();
          if (currentBatch == null) break;
          final available = currentBatch.quantity - currentBatch.reservedQuantity;
          if (available < unit.unitFactor) break;

          final toBreak =
              shortfall >= unit.unitFactor ? unit.unitFactor : shortfall;
          final result = await _breakOnePackage(
            batch: currentBatch,
            packageSize: toBreak,
            productId: productId,
            warehouseId: warehouseId,
          );
          results.add(result);
          shortfall -= result.brokenQuantity;
          breakCount++;
        }
      }
    }

    if (results.isNotEmpty) {
      await _postPackagingBreakGL(results, productId);
    }

    return results;
  }

  Future<BreakResult> _breakOnePackage({
    required ProductBatch batch,
    required Decimal packageSize,
    required String productId,
    required String warehouseId,
  }) async {
    // Reload batch to get current reservedQuantity
    final currentBatch = await (db.select(db.productBatches)
          ..where((b) => b.id.equals(batch.id)))
        .getSingle();

    final actualDeduction =
        packageSize < currentBatch.quantity ? packageSize : currentBatch.quantity;
    final costPerUnit = currentBatch.costPrice;
    final newReserved = currentBatch.reservedQuantity + actualDeduction;

    await (db.update(db.productBatches)..where((b) => b.id.equals(currentBatch.id)))
        .write(ProductBatchesCompanion(
      reservedQuantity: Value(newReserved),
    ));

    developer.log(
      'Reserved $actualDeduction units from batch ${currentBatch.batchNumber} '
      '(total reserved: $newReserved, available: ${currentBatch.quantity - newReserved})',
      name: 'packaging_engine',
    );

    return BreakResult(
      sourceBatchId: currentBatch.id,
      targetBatchId: null,
      brokenQuantity: actualDeduction,
      costPerUnit: costPerUnit,
    );
  }

  Future<Decimal> _getAvailableQuantity(
      String productId, String warehouseId) async {
    final batches = await (db.select(db.productBatches)
          ..where((b) => b.productId.equals(productId))
          ..where((b) => b.warehouseId.equals(warehouseId)))
        .get();
    Decimal total = Decimal.zero;
    for (final b in batches) {
      total += b.quantity - b.reservedQuantity;
    }
    return total;
  }

  Future<List<ProductBatch>> _getBatchesHavingAtLeast(
      String productId, String warehouseId, Decimal minQty) async {
    return (db.select(db.productBatches)
          ..where((b) => b.productId.equals(productId))
          ..where((b) => b.warehouseId.equals(warehouseId))
          ..where(
              (b) => b.quantity.isBiggerOrEqual(Variable(minQty.toString())))
          ..orderBy([
            (b) => OrderingTerm(
                expression: b.expiryDate.isNull(), mode: OrderingMode.asc),
            (b) =>
                OrderingTerm(expression: b.expiryDate, mode: OrderingMode.asc),
            (b) =>
                OrderingTerm(expression: b.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<void> _postPackagingBreakGL(
      List<BreakResult> results, String productId) async {
    if (costingService != null) {
      final method = await costingService!.getProductValuationMethod(productId);
      if (method == InventoryValuationMethod.avco) {
        await costingService!.calculateAverageCost(productId);
      }
    }
  }

  Future<String> formatInventoryBalance(
      String productId, Decimal totalQtyInBase) async {
    try {
      final flag = await AppConfigService(db).getBool(
        AppConfigService.keyMultiUnitV2,
        defaultValue: false,
      );
      if (flag) {
        final adapter = StockDisplayAdapter(db);
        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(productId)))
            .getSingleOrNull();
        if (product != null) {
          return adapter.formatProductStock(product);
        }
      }
      final hierarchy = await getPackagingHierarchy(productId);
      if (hierarchy.isEmpty) return '${totalQtyInBase.toStringAsFixed(0)} حبة';

      const baseUnitSynonyms = {'حبة', 'قطعة', 'pcs', 'piece', 'each', 'unit', 'واحد', 'فردي'};
      final packagingUnits = hierarchy.where((u) =>
          !baseUnitSynonyms.contains(u.unitName) && u.unitFactor > Decimal.one);

      final sortedHierarchy = packagingUnits.toList()
        ..sort((a, b) => b.unitFactor.compareTo(a.unitFactor));
      List<String> parts = [];
      Decimal remaining = totalQtyInBase;

      for (var unit in sortedHierarchy) {
        final factor = unit.unitFactor;
        if (factor <= Decimal.one) continue;
        final count =
            (remaining / factor).toDecimal(scaleOnInfinitePrecision: 0);
        if (count > Decimal.zero) {
          parts.add('${count.toStringAsFixed(0)} ${unit.unitName}');
          remaining -= count * factor;
        }
      }

      if (remaining > Decimal.zero || parts.isEmpty) {
        parts.add('${remaining.toStringAsFixed(0)} حبة');
      }

      return parts.join(' + ');
    } catch (e) {
      return totalQtyInBase.toStringAsFixed(0);
    }
  }

  Future<ProductUnit?> getBestPackagingSuggestion(
      String productId, Decimal quantityInBase) async {
    final hierarchy = await getPackagingHierarchy(productId);
    ProductUnit? bestMatch;
    for (var unit in hierarchy) {
      if (unit.unitFactor > Decimal.one && unit.unitFactor <= quantityInBase) {
        if (bestMatch == null || unit.unitFactor > bestMatch.unitFactor) {
          bestMatch = unit;
        }
      }
    }
    return bestMatch;
  }

  Future<String?> checkRepackPossibility(
      String productId, Decimal quantityInBase) async {
    final hierarchy = await getPackagingHierarchy(productId);
    final largeUnits =
        hierarchy.where((u) => u.unitFactor > Decimal.one).toList();
    if (largeUnits.isEmpty) return null;

    for (var unit in largeUnits.reversed) {
      if (quantityInBase >= unit.unitFactor) {
        return 'يمكنك تجميع ${(quantityInBase / unit.unitFactor).toDecimal(scaleOnInfinitePrecision: 0)} ${unit.unitName}';
      }
    }
    return null;
  }
}
