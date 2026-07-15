import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class UnitBreakdown {
  final String unitName;
  final int quantity;
  final Decimal unitFactor;

  UnitBreakdown({
    required this.unitName,
    required this.quantity,
    required this.unitFactor,
  });
}

enum SaleMode {
  retail,
  wholesale,
  mixed,
}

class _ProductUnitExt {
  final String id;
  final String unitName;
  final Decimal unitFactor;
  final bool isDefault;
  final bool allowFraction;
  final bool canSellWholesale;
  final bool canSellRetail;
  final bool isDefaultWholesale;
  final bool isDefaultRetail;
  final bool isDisplayUnit;

  _ProductUnitExt({
    required this.id,
    required this.unitName,
    required this.unitFactor,
    required this.isDefault,
    this.allowFraction = false,
    this.canSellWholesale = true,
    this.canSellRetail = true,
    this.isDefaultWholesale = false,
    this.isDefaultRetail = false,
    this.isDisplayUnit = true,
  });
}

class InventoryDisplayService {
  final AppDatabase db;
  InventoryDisplayService(this.db);

  Future<String> formatForDisplay({
    required Decimal baseQty,
    required String productId,
  }) async {
    if (baseQty <= Decimal.zero) {
      final baseUnit = await _getBaseUnit(productId);
      return '0 ${baseUnit.unitName}';
    }
    final breakdown = await getUnitBreakdown(
      baseQty: baseQty,
      productId: productId,
    );
    return breakdown
        .map((b) => '${b.quantity} ${b.unitName}')
        .join(' + ');
  }

  Future<List<UnitBreakdown>> getUnitBreakdown({
    required Decimal baseQty,
    required String productId,
  }) async {
    final units = await _getProductUnits(productId);
    return _calculateBreakdown(baseQty, units);
  }

  Future<String> suggestBestUnitName({
    required Decimal baseQty,
    required String productId,
    SaleMode mode = SaleMode.retail,
  }) async {
    final units = await _getProductUnits(productId);
    _ProductUnitExt best = units.first;
    for (var unit in units) {
      if (_isUnitVisibleForMode(unit, mode) &&
          unit.unitFactor > Decimal.one &&
          unit.unitFactor <= baseQty &&
          unit.unitFactor > best.unitFactor) {
        best = unit;
      }
    }
    return best.unitName;
  }

  bool _isUnitVisibleForMode(_ProductUnitExt unit, SaleMode mode) {
    switch (mode) {
      case SaleMode.wholesale:
        return unit.canSellWholesale;
      case SaleMode.retail:
        return unit.canSellRetail;
      case SaleMode.mixed:
        return unit.canSellWholesale || unit.canSellRetail;
      default:
        return false;
    }
  }

  Future<_ProductUnitExt> _getBaseUnit(String productId) async {
    final units = await _getProductUnits(productId);
    return units.firstWhere(
      (u) => u.unitFactor == Decimal.one,
      orElse: () => units.first,
    );
  }

  Future<List<_ProductUnitExt>> _getProductUnits(String productId) async {
    final rows = await (db.select(db.productUnits)
          ..where((u) => u.productId.equals(productId))
          ..orderBy([
            (u) => OrderingTerm(
              expression: u.unitFactor,
              mode: OrderingMode.asc,
            )
          ]))
        .get();
    if (rows.isEmpty) {
      return [];
    }
    final flags = await _fetchUnitFlags(productId);
    return rows.map((u) {
      final f = flags[u.id] ?? {};
      return _ProductUnitExt(
        id: u.id,
        unitName: u.unitName,
        unitFactor: u.unitFactor,
        isDefault: u.isDefault,
        allowFraction: (f['allow_fraction'] as int?) == 1,
        canSellWholesale: (f['can_sell_wholesale'] as int?) != 0,
        canSellRetail: (f['can_sell_retail'] as int?) != 0,
        isDefaultWholesale: (f['is_default_wholesale'] as int?) == 1,
        isDefaultRetail: (f['is_default_retail'] as int?) == 1,
        isDisplayUnit: (f['is_display_unit'] as int?) != 0,
      );
    }).toList();
  }

  Future<Map<String, Map<String, Object?>>> _fetchUnitFlags(
      String productId) async {
    try {
      final rows = await (db.customSelect(
        'SELECT id, allow_fraction, can_sell_wholesale, can_sell_retail, '
        'is_default_wholesale, is_default_retail, is_display_unit '
        'FROM product_units WHERE product_id = ?',
        variables: [Variable(productId)],
      ).get());
      return {
        for (var row in rows)
          row.data['id'] as String: {
            'allow_fraction': row.data['allow_fraction'],
            'can_sell_wholesale': row.data['can_sell_wholesale'],
            'can_sell_retail': row.data['can_sell_retail'],
            'is_default_wholesale': row.data['is_default_wholesale'],
            'is_default_retail': row.data['is_default_retail'],
            'is_display_unit': row.data['is_display_unit'],
          },
      };
    } catch (_) {
      return {};
    }
  }

  List<UnitBreakdown> _calculateBreakdown(
      Decimal qty, List<_ProductUnitExt> units) {
    final displayUnits = units
        .where((u) => u.isDisplayUnit && u.unitFactor > Decimal.one)
        .toList()
      ..sort((a, b) => b.unitFactor.compareTo(a.unitFactor));

    List<UnitBreakdown> result = [];
    Decimal remaining = qty;

    for (var unit in displayUnits) {
      final count = (remaining / unit.unitFactor)
          .toDecimal(scaleOnInfinitePrecision: 0);
      if (count > Decimal.zero) {
        result.add(UnitBreakdown(
          unitName: unit.unitName,
          quantity: count.toDouble().toInt(),
          unitFactor: unit.unitFactor,
        ));
        remaining -= count * unit.unitFactor;
      }
    }

    if (remaining > Decimal.zero) {
      final baseUnit = units.firstWhere(
        (u) => u.unitFactor == Decimal.one,
        orElse: () => units.first,
      );
      result.add(UnitBreakdown(
        unitName: baseUnit.unitName,
        quantity: remaining.truncate().toDouble().toInt(),
        unitFactor: Decimal.one,
      ));
    }

    return result;
  }
}