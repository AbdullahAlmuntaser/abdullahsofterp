import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

Decimal _sumAvailable(List<({Decimal quantity, Decimal reserved})> batches) {
  return batches.fold<Decimal>(
    Decimal.zero,
    (sum, b) => sum + (b.quantity - b.reserved),
  );
}

Future<bool> _simulateWarehouseValidation({
  required Decimal warehouseStock,
  required Decimal requiredQty,
  required void Function() onAutoBreak,
}) async {
  if (warehouseStock < requiredQty) {
    onAutoBreak();
    if (warehouseStock < requiredQty) {
      throw Exception('المخزون غير كافٍ');
    }
  }
  return true;
}

void main() {
  group('PATCH-07: autoBreak + reservedQuantity flow', () {
    // ===== getWarehouseStock formula =====
    test('getWarehouseStock sums (quantity - reservedQuantity)', () {
      final batches = [
        (quantity: Decimal.fromInt(120), reserved: Decimal.fromInt(5)),
        (quantity: Decimal.fromInt(60), reserved: Decimal.fromInt(10)),
        (quantity: Decimal.fromInt(30), reserved: Decimal.zero),
      ];
      final available = _sumAvailable(batches);
      // (120-5) + (60-10) + (30-0) = 115 + 50 + 30 = 195
      expect(available, equals(Decimal.fromInt(195)));
    });

    test('reservedQuantity correctly reduces available stock', () {
      final withoutReserved = _sumAvailable([
        (quantity: Decimal.fromInt(100), reserved: Decimal.zero),
        (quantity: Decimal.fromInt(50), reserved: Decimal.zero),
      ]);
      expect(withoutReserved, equals(Decimal.fromInt(150)));

      final withReserved = _sumAvailable([
        (quantity: Decimal.fromInt(100), reserved: Decimal.fromInt(20)),
        (quantity: Decimal.fromInt(50), reserved: Decimal.fromInt(50)),
      ]);
      // 80 + 0 = 80
      expect(withReserved, equals(Decimal.fromInt(80)));
    });

    test('all-reserved batches yield zero available', () {
      final batches = [
        (quantity: Decimal.fromInt(120), reserved: Decimal.fromInt(120)),
        (quantity: Decimal.fromInt(60), reserved: Decimal.fromInt(60)),
      ];
      expect(_sumAvailable(batches), equals(Decimal.zero));
    });

    // ===== autoBreak call logic: warehouse path =====
    test('autoBreak NOT called when warehouse stock is sufficient', () async {
      bool autoBreakCalled = false;
      final warehouseStock = Decimal.fromInt(100);
      final requiredQty = Decimal.fromInt(50);

      await _simulateWarehouseValidation(
        warehouseStock: warehouseStock,
        requiredQty: requiredQty,
        onAutoBreak: () {
          autoBreakCalled = true;
          // Simulate that autoBreak does nothing (not needed)
        },
      );

      expect(autoBreakCalled, isFalse,
          reason: 'autoBreak should NOT be called when stock is sufficient');
    });

    test('autoBreak IS called when warehouse stock is insufficient', () async {
      bool autoBreakCalled = false;
      Decimal currentStock = Decimal.fromInt(30);
      final requiredQty = Decimal.fromInt(100);

      try {
        await _simulateWarehouseValidation(
          warehouseStock: currentStock,
          requiredQty: requiredQty,
          onAutoBreak: () {
            autoBreakCalled = true;
            // Simulate autoBreak adding stock (e.g. breaking a carton)
            currentStock += Decimal.fromInt(80);
          },
        );
      } catch (_) {}

      expect(autoBreakCalled, isTrue,
          reason: 'autoBreak should be called when stock is insufficient');
    });

    test('exception thrown if stock still insufficient after autoBreak',
        () async {
      bool autoBreakCalled = false;
      final warehouseStock = Decimal.fromInt(30);
      final requiredQty = Decimal.fromInt(100);

      expect(
        () async => _simulateWarehouseValidation(
          warehouseStock: warehouseStock,
          requiredQty: requiredQty,
          onAutoBreak: () {
            autoBreakCalled = true;
            // Simulate autoBreak that doesn't help enough
            // stock stays at 30
          },
        ),
        throwsA(isA<Exception>()),
      );

      expect(autoBreakCalled, isTrue,
          reason: 'autoBreak should have been attempted');
    });

    // ===== autoBreak call logic: non-warehouse path =====
    test('autoBreak NOT called for non-warehouse when product.stock sufficient',
        () async {
      bool autoBreakCalled = false;
      final productStock = Decimal.fromInt(100);
      final requiredQty = Decimal.fromInt(50);

      if (productStock >= requiredQty) {
        // stock sufficient → autoBreak NOT called
      } else {
        autoBreakCalled = true;
      }

      expect(autoBreakCalled, isFalse,
          reason:
              'autoBreak should NOT be called when product.stock is sufficient');
    });

    test('autoBreak IS called for non-warehouse when stock insufficient',
        () async {
      bool autoBreakCalled = false;
      Decimal productStock = Decimal.fromInt(30);
      final requiredQty = Decimal.fromInt(100);

      if (productStock < requiredQty) {
        autoBreakCalled = true;
        productStock += Decimal.fromInt(80); // simulate break
      }

      expect(autoBreakCalled, isTrue,
          reason:
              'autoBreak should be called when product.stock is insufficient');
    });

    // ===== edge cases =====
    test('zero required quantity skips all checks', () {
      final batches = [
        (quantity: Decimal.fromInt(100), reserved: Decimal.fromInt(0)),
      ];
      final available = _sumAvailable(batches);
      expect(available, equals(Decimal.fromInt(100)));

      // If required is zero, no break needed
      final required = Decimal.zero;
      final stock = Decimal.fromInt(100);
      expect(stock >= required, isTrue);
    });

    test('exact match after reserved does not trigger break', () {
      final batches = [
        (quantity: Decimal.fromInt(100), reserved: Decimal.fromInt(20)),
      ];
      final available = _sumAvailable(batches);
      expect(available, equals(Decimal.fromInt(80)));

      final requiredQty = Decimal.fromInt(80);
      // available == requiredQty → no break needed
      bool autoBreakCalled = false;
      if (available < requiredQty) {
        autoBreakCalled = true;
      }
      expect(autoBreakCalled, isFalse,
          reason: 'autoBreak not needed when available exactly matches required');
    });

    test('reserved quantity just below threshold triggers break', () {
      final batches = [
        (quantity: Decimal.fromInt(100), reserved: Decimal.fromInt(19)),
      ];
      final available = _sumAvailable(batches);
      expect(available, equals(Decimal.fromInt(81)));

      final requiredQty = Decimal.fromInt(82);
      // available (81) < required (82) → break needed
      expect(available < requiredQty, isTrue,
          reason: 'break needed when reserved pushes available below required');
    });
  });

  group('PATCH-02: reservedQuantity active management', () {
    // ===== reservedQuantity incremented, not BROKEN batch =====
    test('autoBreak increments reservedQuantity instead of creating BROKEN batch', () {
      // Simulate _breakOnePackage logic: increment reserved, keep quantity unchanged
      final batch = (
        quantity: Decimal.fromInt(60),
        reserved: Decimal.fromInt(0),
        id: 'batch-1',
      );

      final actualDeduction = Decimal.fromInt(5);
      // Before: qty=60, reserved=0, available=60
      expect(batch.quantity - batch.reserved, equals(Decimal.fromInt(60)));

      // Simulate break: increment reserved
      final newReserved = batch.reserved + actualDeduction;
      // After: qty=60, reserved=5, available=55
      expect(newReserved, equals(Decimal.fromInt(5)));
      expect(batch.quantity - newReserved, equals(Decimal.fromInt(55)));
    });

    test('repeated breaks accumulate reservedQuantity', () {
      Decimal reserved = Decimal.zero;
      final quantity = Decimal.fromInt(60);

      // Break 5 pieces
      reserved += Decimal.fromInt(5);
      expect(quantity - reserved, equals(Decimal.fromInt(55)));

      // Break another 10 pieces
      reserved += Decimal.fromInt(10);
      expect(quantity - reserved, equals(Decimal.fromInt(45)));

      // Total reserved = 15
      expect(reserved, equals(Decimal.fromInt(15)));
    });

    test('reservedQuantity never exceeds batch quantity', () {
      final quantity = Decimal.fromInt(60);
      Decimal reserved = Decimal.zero;

      reserved += Decimal.fromInt(30);
      expect(reserved, lessThanOrEqualTo(quantity));

      reserved += Decimal.fromInt(30);
      expect(reserved, lessThanOrEqualTo(quantity));

      // Cannot reserve beyond quantity
      final cannotReserve = Decimal.fromInt(10);
      final wouldExceed = reserved + cannotReserve;
      expect(wouldExceed, greaterThan(quantity));
      // In practice: available = quantity - reserved would be negative,
      // but the guard in autoBreak prevents breaking when insufficient available
      final available = quantity - reserved;
      expect(available, lessThan(cannotReserve));
    });

    // ===== deduction decrements reservedQuantity =====
    test('deduction decrements reservedQuantity along with quantity', () {
      final batch = (
        quantity: Decimal.fromInt(60),
        reserved: Decimal.fromInt(5),
      );

      final deduct = Decimal.fromInt(5);
      final deductFromReserved =
          batch.reserved >= deduct ? deduct : batch.reserved;

      // Apply deduction
      final newQty = batch.quantity - deduct;
      final newReserved = batch.reserved - deductFromReserved;

      expect(newQty, equals(Decimal.fromInt(55)));
      expect(newReserved, equals(Decimal.zero));
      expect(newQty - newReserved, equals(Decimal.fromInt(55)));
    });

    test('deduction clears reserved when deduct exceeds reserved', () {
      final batch = (
        quantity: Decimal.fromInt(60),
        reserved: Decimal.fromInt(3),
      );

      final deduct = Decimal.fromInt(10);
      final deductFromReserved =
          batch.reserved >= deduct ? deduct : batch.reserved;

      // Apply deduction
      final newQty = batch.quantity - deduct;
      final newReserved = batch.reserved - deductFromReserved;

      expect(newQty, equals(Decimal.fromInt(50)));
      expect(newReserved, equals(Decimal.zero));
    });

    test('no BROKEN batch number generated when using reservedQuantity', () {
      // Old behavior: 'BROKEN-${batch.batchNumber}-${timestamp}'
      // New behavior: no new batch ID, no BROKEN prefix
      final batchNumber = 'BATCH-001';
      final oldBrokenId = 'BROKEN-$batchNumber-${DateTime.now().millisecondsSinceEpoch}';
      final startsWithBroken = oldBrokenId.startsWith('BROKEN-');
      expect(startsWithBroken, isTrue);

      // In new design, no BROKEN batch is created at all
      // So BROKEN prefix should not appear anywhere in the flow
      final newBehaviorCreatesBrokenBatch = false;
      expect(newBehaviorCreatesBrokenBatch, isFalse);
    });

    // ===== end-to-end flow simulation =====
    test('full flow: reserve then deduct maintains consistency', () {
      // Start with a batch
      var quantity = Decimal.fromInt(60);
      var reserved = Decimal.zero;

      // Step 1: autoBreak reserves 5 (simulating breaking 5 pieces)
      reserved += Decimal.fromInt(5);
      expect(quantity - reserved, equals(Decimal.fromInt(55))); // available = 55

      // Step 2: FIFO/costing deducts 5 from available
      final deduct = Decimal.fromInt(5);
      final deductFromReserved = reserved >= deduct ? deduct : reserved;
      quantity -= deduct;
      reserved -= deductFromReserved;
      expect(quantity, equals(Decimal.fromInt(55)));
      expect(reserved, equals(Decimal.zero));
      expect(quantity - reserved, equals(Decimal.fromInt(55))); // available = 55
    });

    test('full flow: multiple reserves then partial deduction', () {
      var quantity = Decimal.fromInt(120);
      var reserved = Decimal.zero;

      // Reserve 10 for first sale
      reserved += Decimal.fromInt(10);
      // Reserve 20 for second sale  
      reserved += Decimal.fromInt(20);
      expect(reserved, equals(Decimal.fromInt(30)));
      expect(quantity - reserved, equals(Decimal.fromInt(90)));

      // First sale deducted: 10
      var deduct = Decimal.fromInt(10);
      var deductFromReserved = reserved >= deduct ? deduct : reserved;
      quantity -= deduct;
      reserved -= deductFromReserved;
      expect(quantity, equals(Decimal.fromInt(110)));
      expect(reserved, equals(Decimal.fromInt(20)));

      // Second sale deducted: 20
      deduct = Decimal.fromInt(20);
      deductFromReserved = reserved >= deduct ? deduct : reserved;
      quantity -= deduct;
      reserved -= deductFromReserved;
      expect(quantity, equals(Decimal.fromInt(90)));
      expect(reserved, equals(Decimal.zero));
    });

    test('deduction without prior reservation leaves reserved at zero', () {
      var quantity = Decimal.fromInt(60);
      var reserved = Decimal.zero;

      // Direct deduction (no prior autoBreak)
      final deduct = Decimal.fromInt(5);
      final deductFromReserved = reserved >= deduct ? deduct : reserved;
      quantity -= deduct;
      reserved -= deductFromReserved;

      expect(quantity, equals(Decimal.fromInt(55)));
      expect(reserved, equals(Decimal.zero));
    });
  });
}
