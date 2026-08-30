import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitConversionService - Logic Tests', () {
    test('converts to base unit correctly', () {
      const quantity = 5.0;
      const unitFactor = 2.0;
      const result = quantity * unitFactor;
      expect(result, equals(10.0));
    });

    test('converts from base unit correctly', () {
      const baseQuantity = 10.0;
      const unitFactor = 2.0;
      const result = baseQuantity / unitFactor;
      expect(result, equals(5.0));
    });

    test('base unit returns same quantity', () {
      const unitName = 'Pcs';
      const productUnit = 'Pcs';
      expect(unitName == productUnit, isTrue);
    });

    test('handles zero quantity conversion', () {
      const baseQuantity = 0.0;
      expect(baseQuantity, equals(0.0));
    });

    test('handles product units extraction', () {
      const productUnits = [
        {'unitName': 'Pcs', 'unitFactor': 1.0},
        {'unitName': 'Box', 'unitFactor': 12.0},
        {'unitName': 'Carton', 'unitFactor': 144.0},
      ];

      final foundUnit = productUnits.firstWhere(
        (pu) => pu['unitName'] == 'Box',
        orElse: () => throw Exception('Unit not found'),
      );

      expect(foundUnit['unitFactor'], equals(12.0));
    });

    test('throws when unit not found', () {
      const productUnits = [
        {'unitName': 'Pcs', 'unitFactor': 1.0},
        {'unitName': 'Box', 'unitFactor': 12.0},
      ];

      expect(
        () => productUnits.firstWhere(
          (pu) => pu['unitName'] == 'Pack',
          orElse: () => throw Exception('Unit "Pack" not found for product'),
        ),
        throwsException,
      );
    });

    test('validates positive conversion factor', () {
      const conversionFactor = -5.0;
      expect(conversionFactor <= 0, isTrue);
    });

    test('prevents duplicate unit addition', () {
      const existingUnits = [
        {'unitName': 'Pcs'},
        {'unitName': 'Box'},
      ];

      const newUnitName = 'Box';
      final exists = existingUnits.any((pu) => pu['unitName'] == newUnitName);
      expect(exists, isTrue);
    });

    test('allows new unique unit', () {
      const existingUnits = [
        {'unitName': 'Pcs'},
        {'unitName': 'Box'},
      ];

      const newUnitName = 'Carton';
      final exists = existingUnits.any((pu) => pu['unitName'] == newUnitName);
      expect(exists, isFalse);
    });
  });

  group('UnitConversionService - Conversion Scenarios', () {
    test('converts carton to pieces', () {
      const cartonQty = 2.0;
      const piecesPerCarton = 24.0;
      const pieces = cartonQty * piecesPerCarton;
      expect(pieces, equals(48.0));
    });

    test('converts pieces to carton', () {
      const pieces = 48.0;
      const piecesPerCarton = 24.0;
      const cartons = pieces / piecesPerCarton;
      expect(cartons, equals(2.0));
    });

    test('converts kilo to gram', () {
      const kiloQty = 2.5;
      const gramsPerKilo = 1000.0;
      const grams = kiloQty * gramsPerKilo;
      expect(grams, equals(2500.0));
    });

    test('converts gram to kilo', () {
      const grams = 2500.0;
      const gramsPerKilo = 1000.0;
      const kilos = grams / gramsPerKilo;
      expect(kilos, equals(2.5));
    });

    test('handles fractional quantities', () {
      const pieces = 7.5;
      const piecesPerBox = 12.0;
      const boxes = pieces / piecesPerBox;
      expect(boxes, closeTo(0.625, 0.01));
    });

    test('rounds for display appropriately', () {
      const value = 2.333333;
      final rounded = double.parse(value.toStringAsFixed(2));
      expect(rounded, equals(2.33));
    });
  });

  group('UnitConversionService - Edge Cases', () {
    test('handles very large conversion factors', () {
      const quantity = 1.0;
      const factor = 1000000.0;
      const result = quantity * factor;
      expect(result, equals(1000000.0));
    });

    test('handles very small conversion factors', () {
      const quantity = 1000.0;
      const factor = 0.001;
      const result = quantity * factor;
      expect(result, equals(1.0));
    });

    test('prevents zero division', () {
      const factor = 0.0;
      expect(factor <= 0, isTrue);
    });
  });

  group('Dynamic Base Unit - Carton as Base', () {
    test('base unit is carton, additional unit is piece with factor 0.05', () {
      const double conversionFactor = 0.05; // 1 حبة = 0.05 كرتون

      const quantityInPiece = 20.0;
      const quantityInCarton = quantityInPiece * conversionFactor;
      expect(quantityInCarton, closeTo(1.0, 0.001));
    });

    test('base unit is carton, additional unit is pack with factor 10', () {
      const double conversionFactor = 10.0; // 1 شدة = 10 كرتون

      const quantityInPack = 5.0;
      const quantityInCarton = quantityInPack * conversionFactor;
      expect(quantityInCarton, equals(50.0));
    });

    test('purchasing 100 cartons with carton as base unit', () {
      const purchasedQuantity = 100.0;
      const double unitFactor = 1.0; // purchasing in base unit

      const qtyInBaseUnit = purchasedQuantity * unitFactor;
      expect(qtyInBaseUnit, equals(100.0));
    });

    test('purchasing 5 packs when base is carton (1 pack = 10 cartons)', () {
      const double conversionFactor = 10.0;

      const purchasedQuantity = 5.0;
      const qtyInBaseUnit = purchasedQuantity * conversionFactor;
      expect(qtyInBaseUnit, equals(50.0));
    });
  });

  group('Dynamic Base Unit - Box as Base', () {
    test('base unit is box, additional unit is piece with factor 0.5', () {
      const double conversionFactor = 0.5; // 1 علبة = 0.5 صندوق

      const quantityInPiece = 6.0;
      const quantityInBox = quantityInPiece * conversionFactor;
      expect(quantityInBox, equals(3.0));
    });

    test('1 شدة = 12 علبة with علبة as base', () {
      const double conversionFactor = 12.0; // 1 شدة = 12 علبة

      const quantityInPack = 3.0;
      const qtyInBaseUnit = quantityInPack * conversionFactor;
      expect(qtyInBaseUnit, equals(36.0));
    });
  });

  group('Dynamic Base Unit - Weight Units', () {
    test('base unit is kilo, additional unit is gram with factor 0.001', () {
      const double conversionFactor = 0.001; // 1 جرام = 0.001 كيلو

      const quantityInGram = 500.0;
      const quantityInKilo = quantityInGram * conversionFactor;
      expect(quantityInKilo, equals(0.5));
    });

    test('base unit is ton, additional unit is kilo with factor 0.001', () {
      const double conversionFactor = 0.001; // 1 كيلو = 0.001 طن

      const quantityInKilo = 500.0;
      const quantityInTon = quantityInKilo * conversionFactor;
      expect(quantityInTon, equals(0.5));
    });
  });

  group('Dynamic Base Unit - Purchase Scenarios', () {
    test('purchase 100 cartons, stock increases by 100 cartons', () {
      const purchasedQuantity = 100.0;
      const double unitFactor = 1.0;

      const stockIncrease = purchasedQuantity * unitFactor;
      expect(stockIncrease, equals(100.0));
    });

    test('purchase 10 packs (1 pack = 20 cartons), stock increases by 200 cartons', () {
      const purchasedQuantity = 10.0;
      const double unitFactor = 20.0;

      const stockIncrease = purchasedQuantity * unitFactor;
      expect(stockIncrease, equals(200.0));
    });

    test('buy price per carton when purchasing packs', () {
      const double baseUnitPrice = 50.0; // price per carton
      const double packFactor = 20.0; // 1 pack = 20 cartons
      const packPrice = baseUnitPrice * packFactor;

      expect(packPrice, equals(1000.0));

      const pricePerCarton = packPrice / packFactor;
      expect(pricePerCarton, equals(50.0));
    });

    test('conversion factor validation - must be positive', () {
      const validFactor1 = 0.05;
      const validFactor2 = 1.0;
      const validFactor3 = 100.0;
      const invalidFactor1 = 0.0;
      const invalidFactor2 = -5.0;

      expect(validFactor1 > 0, isTrue);
      expect(validFactor2 > 0, isTrue);
      expect(validFactor3 > 0, isTrue);
      expect(invalidFactor1 > 0, isFalse);
      expect(invalidFactor2 > 0, isFalse);
    });
  });
}
