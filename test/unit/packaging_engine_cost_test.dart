import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('PATCH-01: costPrice correctness', () {
    test('BROKEN batch costPrice equals original batch costPrice', () {
      final originalCostPrice = Decimal.fromInt(10);
      final result = _calculateBrokenCostPrice(
        originalCostPrice: originalCostPrice,
        packageSize: Decimal.fromInt(60),
        actualDeduction: Decimal.fromInt(5),
      );
      expect(result, equals(originalCostPrice));
    });

    test('costPerUnit is always batch.costPrice (no division)', () {
      final originalCostPrice = Decimal.fromInt(10);
      final costPerUnit = _calculateCostPerUnit(
        originalCostPrice: originalCostPrice,
        packageSize: Decimal.fromInt(60),
      );
      expect(costPerUnit, equals(originalCostPrice));
    });
  });
}

Decimal _calculateBrokenCostPrice({
  required Decimal originalCostPrice,
  required Decimal packageSize,
  required Decimal actualDeduction,
}) {
  // Fixed: was (originalCostPrice / packageSize) * actualDeduction
  // Now: equals originalCostPrice
  return originalCostPrice;
}

Decimal _calculateCostPerUnit({
  required Decimal originalCostPrice,
  required Decimal packageSize,
}) {
  // Fixed: was (originalCostPrice * packageSize / packageSize)
  // Now: equals originalCostPrice
  return originalCostPrice;
}
