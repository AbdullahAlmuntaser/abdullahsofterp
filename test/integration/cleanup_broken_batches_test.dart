import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/security_service.dart';

/// PATCH-08: Tests the BROKEN batch cleanup logic
void main() {
  late AppDatabase db;

  setUpAll(() {
    SecurityService.useFakeKeyForTesting = true;
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('PATCH-08: BROKEN batch cleanup', () {
    test('cleanup merges BROKEN batches back to parents', () async {
      await _seedBrokenBatchData(db);

      // Step 0: Count batches before
      var allBatches = await (db.select(db.productBatches)).get();
      expect(allBatches.length, equals(3),
          reason: '3 batches: parent + 2 BROKEN');
      var brokenBatches = allBatches
          .where((b) => b.batchNumber.startsWith('BROKEN-'))
          .toList();
      expect(brokenBatches.length, equals(2),
          reason: '2 BROKEN batches exist');

      // Step 1: Simulate cleanup - merge BROKEN qty back to parent
      var normalBatches =
          allBatches.where((b) => !b.batchNumber.startsWith('BROKEN-')).toList();
      for (final broken in brokenBatches) {
        final parentBatchNumber = broken.batchNumber
            .replaceAll(RegExp(r'^BROKEN-'), '')
            .replaceAll(RegExp(r'-\d+$'), '');
        final parent = normalBatches.where((b) =>
            b.productId == broken.productId &&
            b.batchNumber == parentBatchNumber &&
            b.warehouseId == broken.warehouseId).firstOrNull;

        if (parent != null) {
          final freshParent = await (db.select(db.productBatches)
                ..where((b) => b.id.equals(parent.id)))
              .getSingle();
          await (db.update(db.productBatches)
                ..where((b) => b.id.equals(freshParent.id)))
              .write(ProductBatchesCompanion(
            quantity: drift.Value(freshParent.quantity + broken.quantity),
          ));
        }
      }

      // Step 2: Delete merged BROKEN batches
      for (final broken in brokenBatches) {
        await (db.delete(db.productBatches)
              ..where((b) => b.id.equals(broken.id)))
            .go();
      }

      // Verify: only parent batches remain
      allBatches = await (db.select(db.productBatches)).get();
      expect(allBatches.length, equals(1),
          reason: 'Only 1 parent batch should remain');
      expect(allBatches.first.batchNumber, equals('BATCH-001'),
          reason: 'Parent batch preserved');

      // Parent should have merged qty: 60 + 20 + 10 = 90
      expect(allBatches.first.quantity, equals(Decimal.fromInt(90)),
          reason: 'Parent qty = original 60 + merged 20 + merged 10 = 90');

      // Step 3: Verify product.stock == SUM(batch.quantity)
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals('product-1')))
          .getSingle();
      final batchSum = allBatches.fold<Decimal>(
          Decimal.zero, (s, b) => s + b.quantity);
      expect(product.stock, equals(batchSum),
          reason: 'product.stock (90) == batch sum (90)');
    });

    test('cleanup handles product with no BROKEN batches', () async {
      await db.into(db.products).insert(ProductsCompanion.insert(
            id: const drift.Value('clean-product'),
            name: 'Clean Product',
            sku: 'CLEAN',
            buyPrice: drift.Value(Decimal.zero),
            sellPrice: drift.Value(Decimal.zero),
            unit: const drift.Value('pcs'),
            stock: drift.Value(Decimal.fromInt(50)),
          ));
      await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
            id: const drift.Value('clean-batch'),
            productId: 'clean-product',
            warehouseId: 'wh-1',
            batchNumber: 'NORMAL-001',
            quantity: drift.Value(Decimal.fromInt(50)),
            initialQuantity: drift.Value(Decimal.fromInt(50)),
            costPrice: drift.Value(Decimal.zero),
          ));

      var allBatches = await (db.select(db.productBatches)).get();
      var brokenBatches = allBatches
          .where((b) => b.batchNumber.startsWith('BROKEN-'))
          .toList();
      expect(brokenBatches, isEmpty, reason: 'No BROKEN batches');

      // Verify still correct
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals('clean-product')))
          .getSingle();
      final batchSum = allBatches.fold<Decimal>(
          Decimal.zero, (s, b) => s + b.quantity);
      expect(product.stock, equals(batchSum), reason: 'Stock integrity OK');
    });

    test('cleanup handles orphaned BROKEN (no parent)', () async {
      await db.into(db.products).insert(ProductsCompanion.insert(
            id: const drift.Value('orphan-prod'),
            name: 'Orphan Product',
            sku: 'ORPHAN',
            buyPrice: drift.Value(Decimal.zero),
            sellPrice: drift.Value(Decimal.zero),
            unit: const drift.Value('pcs'),
            stock: drift.Value(Decimal.fromInt(30)),
          ));
      // BROKEN batch with no matching parent
      await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
            id: const drift.Value('orphan-broken'),
            productId: 'orphan-prod',
            warehouseId: 'wh-1',
            batchNumber: 'BROKEN-NONEXISTENT-12345',
            quantity: drift.Value(Decimal.fromInt(30)),
            initialQuantity: drift.Value(Decimal.fromInt(30)),
            costPrice: drift.Value(Decimal.zero),
          ));

      var allBatches = await (db.select(db.productBatches)).get();
      var brokenBatches = allBatches
          .where((b) => b.batchNumber.startsWith('BROKEN-'))
          .toList();
      expect(brokenBatches.length, equals(1));

      // For orphaned BROKEN with no parent, we keep the batch as-is
      // (the script prints a warning but doesn't delete)
      final orphan = brokenBatches.first;
      final parentBatchNumber = orphan.batchNumber
          .replaceAll(RegExp(r'^BROKEN-'), '')
          .replaceAll(RegExp(r'-\d+$'), '');
      expect(parentBatchNumber, equals('NONEXISTENT'),
          reason: 'Extracted parent number is NONEXISTENT');

      // No parent should match
      final normalBatches =
          allBatches.where((b) => !b.batchNumber.startsWith('BROKEN-')).toList();
      final parent = normalBatches.where((b) =>
          b.productId == orphan.productId &&
          b.batchNumber == parentBatchNumber &&
          b.warehouseId == orphan.warehouseId).firstOrNull;
      expect(parent, isNull, reason: 'No parent found for orphaned BROKEN');

      // Verify product.stock still matches (orphan kept)
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals('orphan-prod')))
          .getSingle();
      expect(product.stock, equals(Decimal.fromInt(30)),
          reason: 'Stock unchanged');
    });

    test('full cleanup flow: merge, delete, verify', () async {
      await _seedBrokenBatchData(db);

      // Count before
      var beforeCount = (await (db.select(db.productBatches)).get()).length;
      expect(beforeCount, equals(3), reason: '3 batches before cleanup');

      var allBatches = await (db.select(db.productBatches)).get();
      var normalBatches =
          allBatches.where((b) => !b.batchNumber.startsWith('BROKEN-')).toList();
      var brokenBatches = allBatches
          .where((b) => b.batchNumber.startsWith('BROKEN-'))
          .toList();

      int mergedCount = 0;
      int deletedCount = 0;

      for (final broken in brokenBatches) {
        final parentBatchNumber = broken.batchNumber
            .replaceAll(RegExp(r'^BROKEN-'), '')
            .replaceAll(RegExp(r'-\d+$'), '');
        final parent = normalBatches.where((b) =>
            b.productId == broken.productId &&
            b.batchNumber == parentBatchNumber &&
            b.warehouseId == broken.warehouseId).firstOrNull;

        if (parent != null) {
          final freshParent = await (db.select(db.productBatches)
                ..where((b) => b.id.equals(parent.id)))
              .getSingle();
          await (db.update(db.productBatches)
                ..where((b) => b.id.equals(freshParent.id)))
              .write(ProductBatchesCompanion(
            quantity: drift.Value(freshParent.quantity + broken.quantity),
          ));
          mergedCount++;
        }

        if (parent != null) {
          await (db.delete(db.productBatches)
                ..where((b) => b.id.equals(broken.id)))
              .go();
          deletedCount++;
        }
      }

      expect(mergedCount, equals(2), reason: '2 BROKEN merged');
      expect(deletedCount, equals(2), reason: '2 BROKEN deleted');

      // Verify after
      var afterCount = (await (db.select(db.productBatches)).get()).length;
      expect(afterCount, equals(1), reason: '1 batch after cleanup');

      // Verify stock integrity
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals('product-1')))
          .getSingle();
      final remainingBatches = await (db.select(db.productBatches)).get();
      final batchSum = remainingBatches.fold<Decimal>(
          Decimal.zero, (s, b) => s + b.quantity);
      expect(product.stock, equals(batchSum),
          reason: 'Stock: ${product.stock} == Batch sum: $batchSum');
      expect(batchSum, equals(Decimal.fromInt(90)),
          reason: 'Final stock = 60 + 20 + 10 = 90');
    });
  });
}

Future<void> _seedBrokenBatchData(AppDatabase db) async {
  await db.into(db.warehouses).insert(WarehousesCompanion.insert(
        id: const drift.Value('wh-1'),
        name: 'Main Warehouse',
      ));

  await db.into(db.products).insert(ProductsCompanion.insert(
        id: const drift.Value('product-1'),
        name: 'Test Product',
        sku: 'TEST',
        buyPrice: drift.Value(Decimal.zero),
        sellPrice: drift.Value(Decimal.zero),
        unit: const drift.Value('pcs'),
        stock: drift.Value(Decimal.fromInt(90)),
      ));

  // Parent batch
  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: const drift.Value('parent-batch'),
        productId: 'product-1',
        warehouseId: 'wh-1',
        batchNumber: 'BATCH-001',
        quantity: drift.Value(Decimal.fromInt(60)),
        initialQuantity: drift.Value(Decimal.fromInt(60)),
        costPrice: drift.Value(Decimal.zero),
      ));

  // BROKEN batches (old format: BROKEN-{parent}-{timestamp})
  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: const drift.Value('broken-1'),
        productId: 'product-1',
        warehouseId: 'wh-1',
        batchNumber: 'BROKEN-BATCH-001-1712345678',
        quantity: drift.Value(Decimal.fromInt(20)),
        initialQuantity: drift.Value(Decimal.fromInt(20)),
        costPrice: drift.Value(Decimal.zero),
      ));

  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: const drift.Value('broken-2'),
        productId: 'product-1',
        warehouseId: 'wh-1',
        batchNumber: 'BROKEN-BATCH-001-1712345679',
        quantity: drift.Value(Decimal.fromInt(10)),
        initialQuantity: drift.Value(Decimal.fromInt(10)),
        costPrice: drift.Value(Decimal.zero),
      ));
}
