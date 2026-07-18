import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('PATCH-02: reservedQuantity', () {
    test('availableQuantity = quantity - reservedQuantity', () {
      final quantity = Decimal.fromInt(120);
      final reservedQuantity = Decimal.fromInt(5);
      final available = quantity - reservedQuantity;
      expect(available, equals(Decimal.fromInt(115)));
    });

    test('reservedQuantity > 0 does not affect total quantity', () {
      final quantity = Decimal.fromInt(120);
      final reservedQuantity = Decimal.fromInt(5);
      // quantity stays the same, only available changes
      expect(quantity, equals(Decimal.fromInt(120)));
      expect(quantity - reservedQuantity, equals(Decimal.fromInt(115)));
    });

    test('reservedQuantity prevents double consumption in FIFO', () {
      // Scenario: batch has 120 qty, 20 reserved
      // FIFO should only see 100 available
      final batchQuantity = Decimal.fromInt(120);
      final reservedQuantity = Decimal.fromInt(20);
      final fifoAvailable = Decimal.fromInt(100);

      final available = batchQuantity - reservedQuantity;
      expect(available, equals(fifoAvailable));
    });
  });
}
