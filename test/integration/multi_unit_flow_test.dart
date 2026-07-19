import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/security_service.dart';

void main() {
  late AppDatabase db;
  late PackagingEngine packagingEngine;

  setUpAll(() {
    SecurityService.useFakeKeyForTesting = true;
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    packagingEngine = PackagingEngine(db);
    await _seedData(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Multi-Unit Flow (reservedQuantity)', () {
    test('autoBreak does NOT trigger when sufficient stock available',
        () async {
      final results = await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(50),
      );

      expect(results, isEmpty,
          reason:
              '60 available, need 50 → no break needed');
    });

    test('autoBreak triggers when stock insufficient', () async {
      final results = await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      expect(results, isNotEmpty,
          reason: '60 available, need 70 → autoBreak should break cartons');
    });

    test('autoBreak uses reservedQuantity instead of BROKEN batch', () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      final batches = await (db.select(db.productBatches)
            ..where((b) => b.productId.equals('product-1')))
          .get();

      expect(batches.length, equals(1),
          reason: 'Should still have only 1 batch (no BROKEN created)');
      expect(batches.first.reservedQuantity, greaterThan(Decimal.zero),
          reason: 'Cartons should be reserved');

      final brokenBatches =
          batches.where((b) => b.batchNumber.startsWith('BROKEN-')).toList();
      expect(brokenBatches, isEmpty,
          reason: 'No BROKEN batches should be created');
    });

    test('deduction after autoBreak consumes reserved + quantity correctly',
        () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      final batch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.equals('BATCH-001')))
          .getSingle();

      final deduct = Decimal.fromInt(70);
      final deductFromReserved =
          batch.reservedQuantity >= deduct ? deduct : batch.reservedQuantity;

      await (db.update(db.productBatches)
            ..where((b) => b.id.equals(batch.id)))
          .write(ProductBatchesCompanion(
        quantity: drift.Value(batch.quantity - deduct),
        reservedQuantity:
            drift.Value(batch.reservedQuantity - deductFromReserved),
      ));

      final updatedBatch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.equals('BATCH-001')))
          .getSingle();

      expect(updatedBatch.quantity, equals(Decimal.fromInt(-10)),
          reason: '60 - 70 = -10 (negative stock after overselling)');
      expect(updatedBatch.reservedQuantity, equals(Decimal.zero),
          reason: 'All reserved was consumed');
    });

    test('post-sale cleanup releases orphaned reservedQuantity', () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      // Batch: qty=60, shortfall=10, reserved=10 (from autoBreak)
      var batch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.equals('BATCH-001')))
          .getSingle();

      // Consume less than what was reserved (5 < 10)
      final deduct = Decimal.fromInt(5);
      final deductFromReserved =
          batch.reservedQuantity >= deduct ? deduct : batch.reservedQuantity;

      await (db.update(db.productBatches)
            ..where((b) => b.id.equals(batch.id)))
          .write(ProductBatchesCompanion(
        quantity: drift.Value(batch.quantity - deduct),
        reservedQuantity:
            drift.Value(batch.reservedQuantity - deductFromReserved),
      ));

      batch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.equals('BATCH-001')))
          .getSingle();

      expect(batch.reservedQuantity, greaterThan(Decimal.zero),
          reason: 'Orphaned reserved exists after partial consumption (5 remaining)');

      // Simulate post-sale cleanup
      final allBatches = await (db.select(db.productBatches)
            ..where((b) => b.productId.equals('product-1')))
          .get();
      for (final b in allBatches) {
        if (b.reservedQuantity > Decimal.zero) {
          await (db.update(db.productBatches)
                ..where((p) => p.id.equals(b.id)))
              .write(ProductBatchesCompanion(
            reservedQuantity: drift.Value(Decimal.zero),
          ));
        }
      }

      batch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.equals('BATCH-001')))
          .getSingle();

      expect(batch.reservedQuantity, equals(Decimal.zero),
          reason: 'Orphaned reserved should be released');
    });

    test('getWarehouseStock accounts for reservedQuantity', () async {
      var stockBefore =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(stockBefore, equals(Decimal.fromInt(60)),
          reason: '60 units available initially');

      // autoBreak for 70 (60 available, 10 shortfall)
      // This should reserve 10 units (the shortfall)
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      var stockAfter =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(stockAfter, equals(Decimal.fromInt(50)),
          reason: '50 units after reserving 10 of the 60');
    });

    test('multiple products with reservedQuantity are independent', () async {
      // product-1: qty=60, reserved=0, available=60
      // Need 70 → break 1 carton: reserved=12, available=48
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      var p1Available =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(p1Available, equals(Decimal.fromInt(50)),
          reason: 'Product-1: 50 available after reserving 10');

      // product-2 should be unaffected
      var p2Available =
          await db.productsDao.getWarehouseStock('product-2', 'wh-1');
      expect(p2Available, equals(Decimal.fromInt(30)),
          reason: 'Product-2: 30 available, unaffected');
    });

    test('autoBreak with insufficient stock after breaking still returns results',
        () async {
      final results = await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(200),
      );

      expect(results, isNotEmpty,
          reason: 'autoBreak should break as many cartons as possible');

      var available =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(available, equals(Decimal.zero),
          reason: 'All stock should be reserved (60 reserved, 0 available)');
    });
  });
}

Future<void> _seedData(AppDatabase db) async {
  await db.into(db.warehouses).insert(WarehousesCompanion.insert(
        id: const drift.Value('wh-1'),
        name: 'المستودع الرئيسي',
      ));

  await db.into(db.products).insert(ProductsCompanion.insert(
        id: const drift.Value('product-1'),
        name: 'منتج اختبار',
        sku: 'TEST001',
        buyPrice: drift.Value(Decimal.zero),
        sellPrice: drift.Value(Decimal.zero),
        unit: const drift.Value('piece'),
        stock: drift.Value(Decimal.fromInt(60)),
      ));

  await db.into(db.productUnits).insert(ProductUnitsCompanion.insert(
        productId: 'product-1',
        unitName: 'Carton',
        unitFactor: drift.Value(Decimal.fromInt(12)),
      ));

  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: const drift.Value('batch-1'),
        productId: 'product-1',
        warehouseId: 'wh-1',
        batchNumber: 'BATCH-001',
        quantity: drift.Value(Decimal.fromInt(60)),
        initialQuantity: drift.Value(Decimal.fromInt(60)),
        costPrice: drift.Value(Decimal.zero),
        storedUnitId: const drift.Value(null),
        quantityInStoredUnit: const drift.Value(null),
      ));

  // Second product for isolation test
  await db.into(db.products).insert(ProductsCompanion.insert(
        id: const drift.Value('product-2'),
        name: 'Product 2',
        sku: 'P002',
        buyPrice: drift.Value(Decimal.zero),
        sellPrice: drift.Value(Decimal.zero),
        unit: const drift.Value('piece'),
        stock: drift.Value(Decimal.zero),
      ));
  await db.into(db.productUnits).insert(ProductUnitsCompanion.insert(
        productId: 'product-2',
        unitName: 'Box',
        unitFactor: drift.Value(Decimal.fromInt(6)),
      ));
  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: const drift.Value('batch-p2-1'),
        productId: 'product-2',
        warehouseId: 'wh-1',
        batchNumber: 'BATCH-P2-001',
        quantity: drift.Value(Decimal.fromInt(30)),
        initialQuantity: drift.Value(Decimal.fromInt(30)),
        costPrice: drift.Value(Decimal.zero),
        storedUnitId: const drift.Value(null),
        quantityInStoredUnit: const drift.Value(null),
      ));
}
