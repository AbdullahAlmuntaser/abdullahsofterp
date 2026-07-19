import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class StockDisplayAdapter {
  final AppDatabase _db;

  StockDisplayAdapter(this._db);

  Future<String> formatBatchDisplay(
    ProductBatch batch, {
    List<ProductUnit>? productUnits,
  }) async {
    final storedQty = batch.quantityInStoredUnit;
    if (storedQty == null || batch.storedUnitId == null || storedQty <= Decimal.zero) {
      return '${batch.quantity.toStringAsFixed(0)} حبة';
    }

    final units = productUnits ?? await _getProductUnits(batch.productId);
    final storedUnit = units.where((u) => u.id == batch.storedUnitId).firstOrNull;
    if (storedUnit == null) {
      return '${batch.quantity.toStringAsFixed(0)} حبة';
    }

    final wholeUnits = Decimal.parse(storedQty.toStringAsFixed(0));
    final remainder = (storedQty - wholeUnits) * storedUnit.unitFactor;

    if (remainder > Decimal.zero) {
      return '${wholeUnits.toStringAsFixed(0)} ${storedUnit.unitName} + ${remainder.toStringAsFixed(0)} حبة';
    }
    return '${wholeUnits.toStringAsFixed(0)} ${storedUnit.unitName}';
  }

  Future<String> formatProductStock(
    Product product, {
    String? preferredUnitId,
    List<ProductUnit>? productUnits,
  }) async {
    if (product.stock <= Decimal.zero) {
      return '0 حبة';
    }

    final units = productUnits ?? await _getProductUnits(product.id);
    if (units.isEmpty) {
      return '${product.stock.toStringAsFixed(0)} ${product.unit}';
    }

    final bestUnit = _findBestUnit(units, product.stock, preferredUnitId);
    if (bestUnit == null) {
      return '${product.stock.toStringAsFixed(0)} حبة';
    }

    final unitFactor_ = bestUnit.unitFactor;
    Decimal wholeUnits = Decimal.zero;
    while (product.stock >= (wholeUnits + Decimal.one) * unitFactor_) {
      wholeUnits += Decimal.one;
    }
    final remaining = product.stock - (wholeUnits * unitFactor_);

    if (remaining > Decimal.zero) {
      return '$wholeUnits ${bestUnit.unitName} + $remaining حبة';
    }
    return '$wholeUnits ${bestUnit.unitName}';
  }

  ProductUnit? _findBestUnit(
    List<ProductUnit> units,
    Decimal baseQty,
    String? preferredUnitId,
  ) {
    if (preferredUnitId != null) {
      final preferred = units.where((u) => u.id == preferredUnitId).firstOrNull;
      if (preferred != null && preferred.unitFactor <= baseQty) return preferred;
    }

    ProductUnit? best;
    for (var unit in units) {
      if (unit.unitFactor > Decimal.one && unit.unitFactor <= baseQty) {
        if (best == null || unit.unitFactor > best.unitFactor) {
          best = unit;
        }
      }
    }
    return best;
  }

  Future<List<ProductUnit>> _getProductUnits(String productId) async {
    return (_db.select(_db.productUnits)
          ..where((u) => u.productId.equals(productId))
          ..orderBy(
              [(u) => OrderingTerm(expression: u.unitFactor, mode: OrderingMode.asc)]))
        .get();
  }
}
