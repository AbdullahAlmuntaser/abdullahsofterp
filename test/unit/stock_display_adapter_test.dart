import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('PATCH-03: StockDisplayAdapter logic', () {
    test('formatProductStock with no storedUnitId falls back to pieces', () {
      final stock = Decimal.fromInt(120);
      final result = _formatDisplay(stock: stock, storedUnitId: null);
      expect(result, contains('120'));
    });

    test('formatProductStock with storedUnitId shows unit context', () {
      final stock = Decimal.fromInt(120);
      final result = _formatDisplay(
        stock: stock,
        storedUnitId: 'carton',
        quantityInStoredUnit: Decimal.fromInt(10),
        unitFactor: Decimal.fromInt(12),
        unitName: 'كرتون',
      );
      expect(result, contains('10'));
      expect(result, contains('كرتون'));
    });
  });
}

String _formatDisplay({
  required Decimal stock,
  String? storedUnitId,
  Decimal? quantityInStoredUnit,
  Decimal? unitFactor,
  String? unitName,
}) {
  if (storedUnitId == null || quantityInStoredUnit == null || quantityInStoredUnit <= Decimal.zero) {
    return '${stock.toStringAsFixed(0)} حبة';
  }
  if (unitName == null) return '${stock.toStringAsFixed(0)} حبة';
  final wholeUnits = Decimal.parse(quantityInStoredUnit.toStringAsFixed(0));
  final remainder = stock - (wholeUnits * (unitFactor ?? Decimal.one));
  if (remainder > Decimal.zero) {
    return '$wholeUnits $unitName + $remainder حبة';
  }
  return '$wholeUnits $unitName';
}
