// ignore_for_file: avoid_print

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

/// PATCH-08: Clean up existing BROKEN batches.
///
/// Usage:
///   1. BACKUP your database file FIRST
///   2. Run: dart run scripts/cleanup_broken_batches.dart --db-path=<path_to_db>
///
/// This script:
///   - Merges BROKEN batch quantities back into their parent batches
///   - Deletes the BROKEN batch records
///   - Verifies product.stock == SUM(batch.quantity) for all products
///   - Reports any discrepancies

Future<void> main(List<String> args) async {
  String? dbPath;
  for (final arg in args) {
    if (arg.startsWith('--db-path=')) {
      dbPath = arg.substring('--db-path='.length);
    }
  }

  if (dbPath == null) {
    print('Usage: dart run scripts/cleanup_broken_batches.dart --db-path=<path_to_db>');
    print('Example: dart run scripts/cleanup_broken_batches.dart --db-path=/data/data/com.systemmarket/databases/market.db');
    exit(1);
  }

  if (!File(dbPath).existsSync()) {
    print('ERROR: Database file not found: $dbPath');
    exit(1);
  }

  print('=== PATCH-08: Clean Up BROKEN Batches ===');
  print('Database: $dbPath');
  print('');

  // Count broken batches first
  print('Step 0: Counting BROKEN batches...');
  final db = AppDatabase(_openConnection(dbPath));
  try {
    final allBatches = await (db.select(db.productBatches)).get();
    final brokenBatches = allBatches.where((b) => b.batchNumber.startsWith('BROKEN-')).toList();
    final normalBatches = allBatches.where((b) => !b.batchNumber.startsWith('BROKEN-')).toList();

    print('  Total batches: ${allBatches.length}');
    print('  Normal batches: ${normalBatches.length}');
    print('  BROKEN batches: ${brokenBatches.length}');
    print('');

    if (brokenBatches.isEmpty) {
      print('✅ No BROKEN batches found. Nothing to clean up.');
      await db.close();
      exit(0);
    }

    // Step 1: Merge BROKEN quantities back to parent batches
    print('Step 1: Merging BROKEN quantities back to parent batches...');
    int mergedCount = 0;
    for (final broken in brokenBatches) {
      final parentBatchNumber = broken.batchNumber
          .replaceAll(RegExp(r'^BROKEN-'), '')
          .replaceAll(RegExp(r'-\d+$'), '');
      final parent = normalBatches.where((b) =>
          b.productId == broken.productId &&
          b.batchNumber == parentBatchNumber &&
          b.warehouseId == broken.warehouseId).firstOrNull;

      if (parent != null) {
        // Re-fetch parent to get current quantity (may have been updated by previous merge)
        final freshParent = await (db.select(db.productBatches)
              ..where((b) => b.id.equals(parent.id)))
            .getSingle();
        await (db.update(db.productBatches)
              ..where((b) => b.id.equals(freshParent.id)))
            .write(ProductBatchesCompanion(
          quantity: Value(freshParent.quantity + broken.quantity),
        ));
        mergedCount++;
      } else {
        print('  ⚠️  No parent found for BROKEN-${broken.batchNumber} (product: ${broken.productId}), keeping as-is');
      }
    }
    print('  Merged $mergedCount BROKEN batches into parents.');
    print('');

    // Step 2: Delete BROKEN batches
    print('Step 2: Deleting BROKEN batch records...');
    final deleteTargets = brokenBatches.where((b) =>
        normalBatches.any((p) =>
            p.productId == b.productId &&
            p.batchNumber == b.batchNumber.replaceAll(RegExp(r'^BROKEN-'), '').replaceAll(RegExp(r'-\d+$'), '') &&
            p.warehouseId == b.warehouseId)).toList();

    int deletedCount = 0;
    for (final broken in deleteTargets) {
      await (db.delete(db.productBatches)
            ..where((b) => b.id.equals(broken.id)))
          .go();
      deletedCount++;
    }
    print('  Deleted $deletedCount BROKEN batch records.');
    print('');

    // Step 3: Verify data integrity
    print('Step 3: Verifying product.stock == SUM(batch.quantity)...');
    final products = await (db.select(db.products)).get();
    int verified = 0;
    int mismatches = 0;

    for (final product in products) {
      final batches = await (db.select(db.productBatches)
            ..where((b) => b.productId.equals(product.id)))
          .get();
      final batchSum = batches.fold<Decimal>(Decimal.zero, (s, b) => s + b.quantity);
      final diff = (product.stock - batchSum).abs();
      if (diff > Decimal.parse('0.01')) {
        print('  ❌ MISMATCH: ${product.name}: stock=${product.stock}, batch_sum=$batchSum, diff=$diff');
        mismatches++;
      } else {
        verified++;
      }
    }
    print('  Verified: $verified products OK');
    if (mismatches > 0) {
      print('  ⚠️  Mismatches: $mismatches products need manual review');
    }
    print('');

    print('=== Cleanup Complete ===');
    print('Batches before: ${allBatches.length}');
    print('Batches after:  ${allBatches.length - deletedCount}');
    print('BROKEN removed: $deletedCount');
    print('Merged: $mergedCount');

  } finally {
    await db.close();
  }
}

QueryExecutor _openConnection(String dbPath) {
  return NativeDatabase(File(dbPath));
}
