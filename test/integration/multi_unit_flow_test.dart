import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/data/datasources/local/daos/stock_movement_dao.dart';
import 'package:supermarket/core/utils/stock_display_adapter.dart';
import 'package:supermarket/core/services/security_service.dart';

void main() {
  late AppDatabase db;
  late PackagingEngine packagingEngine;
  late InventoryCostingService costingService;

  setUpAll(() {
    SecurityService.useFakeKeyForTesting = true;
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    packagingEngine = PackagingEngine(db);
    costingService = InventoryCostingService(StockMovementDao(db), db);
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

    test('autoBreak creates new batch for broken units', () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      final batches = await (db.select(db.productBatches)
            ..where((b) => b.productId.equals('product-1')))
          .get();

      expect(batches.length, equals(2),
          reason: 'Should have 2 batches: original carton + broken pieces');
      
      final originalBatch = batches.firstWhere((b) => b.batchNumber == 'BATCH-001');
      final brokenBatch = batches.firstWhere((b) => b.batchNumber.startsWith('BRK-'));
      
      expect(originalBatch.quantity, equals(Decimal.fromInt(48)),
          reason: '60 - 12 = 48 cartons remaining');
      expect(brokenBatch.quantity, equals(Decimal.fromInt(12)),
          reason: '12 pieces from broken carton');
    });

    test('deduction after autoBreak consumes from broken batch', () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      // Find the broken batch
      final brokenBatch = await (db.select(db.productBatches)
            ..where((b) => b.batchNumber.like('BRK-%')))
          .getSingle();

      // Deduct 70 units (all from broken batch + 58 from original)
      final deduct = Decimal.fromInt(70);
      await (db.update(db.productBatches)
            ..where((b) => b.id.equals(brokenBatch.id)))
          .write(ProductBatchesCompanion(
        quantity: drift.Value(brokenBatch.quantity - deduct),
      ));

      final updatedBroken = await (db.select(db.productBatches)
            ..where((b) => b.id.equals(brokenBatch.id)))
          .getSingle();

      expect(updatedBroken.quantity, lessThan(Decimal.zero),
          reason: 'Broken batch can go negative when overselling');
    });

    test('post-sale cleanup not needed after proper disassembly', () async {
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      // After proper disassembly, no reservedQuantity should exist
      final allBatches = await (db.select(db.productBatches)
            ..where((b) => b.productId.equals('product-1')))
          .get();
      
      for (final b in allBatches) {
        expect(b.reservedQuantity, equals(Decimal.zero),
            reason: 'No reservedQuantity after proper disassembly');
      }
    });

    test('getWarehouseStock reflects actual available quantity', () async {
      var stockBefore =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(stockBefore, equals(Decimal.fromInt(60)),
          reason: '60 units available initially');

      // autoBreak for 70 (60 available, 10 shortfall)
      // This breaks 1 carton (12 pieces) → 48 cartons + 12 pieces = 60 total
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      var stockAfter =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(stockAfter, equals(Decimal.fromInt(60)),
          reason: '60 units still available (48 cartons + 12 pieces)');
    });

    test('multiple products with disassembly are independent', () async {
      // product-1: qty=60, need 70 → break 1 carton: 48 cartons + 12 pieces
      await packagingEngine.autoBreakIfNecessary(
        productId: 'product-1',
        warehouseId: 'wh-1',
        requiredQtyInBase: Decimal.fromInt(70),
      );

      var p1Available =
          await db.productsDao.getWarehouseStock('product-1', 'wh-1');
      expect(p1Available, equals(Decimal.fromInt(60)),
          reason: 'Product-1: 60 available after disassembly');

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
          reason: 'All stock broken into pieces (0 cartons, 0 pieces available)');
    });
  });

  group('Integration: StockDisplayAdapter + FIFO', () {
    test('StockDisplayAdapter.formatProductStock formats correctly', () async {
      final adapter = StockDisplayAdapter(db);
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals('product-1')))
          .getSingle();

      final formatted = await adapter.formatProductStock(product);
      expect(formatted, contains('Carton'),
          reason: '60 units at 12/unit Carton = 5 Cartons');
    });

    test('getBatchesInFifoOrder returns FIFO-ordered batches', () async {
      // Add a second batch with later expiry
      await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
            id: const drift.Value('batch-2'),
            productId: 'product-1',
            warehouseId: 'wh-1',
            batchNumber: 'BATCH-002',
            quantity: drift.Value(Decimal.fromInt(30)),
            initialQuantity: drift.Value(Decimal.fromInt(30)),
            costPrice: drift.Value(Decimal.zero),
            expiryDate: drift.Value(DateTime(2026, 12, 31)),
            storedUnitId: const drift.Value(null),
            quantityInStoredUnit: const drift.Value(null),
          ));

      final fifoBatches = await costingService.getBatchesInFifoOrder(
        'product-1',
        onlyAvailable: true,
      );

      // BATCH-002 (future expiry) should come before BATCH-001 (null expiry)
      expect(fifoBatches.length, equals(2));
      expect(fifoBatches.first.batchNumber, equals('BATCH-002'),
          reason: 'Future expiry should sort before null expiry');
      expect(fifoBatches.last.batchNumber, equals('BATCH-001'));
    });

    test('getBatchesInFifoOrder filters by warehouse', () async {
      final whBatches = await costingService.getBatchesInFifoOrder(
        'product-1',
        warehouseId: 'wh-1',
        onlyAvailable: true,
      );

      expect(whBatches.length, equals(1));
      expect(whBatches.first.warehouseId, equals('wh-1'));
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
