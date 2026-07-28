import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV56ToV57(AppDatabase db, Migrator m) async {
  // Add referenceNumber and paymentTerms columns to Sales table
  try {
    await db.customStatement(
        'ALTER TABLE sales ADD COLUMN reference_number TEXT');
  } catch (e) {
    debugPrint('DB Migration v57: sales.reference_number: $e');
  }
  try {
    await db.customStatement(
        'ALTER TABLE sales ADD COLUMN payment_terms TEXT');
  } catch (e) {
    debugPrint('DB Migration v57: sales.payment_terms: $e');
  }

  // Add representativeId column to Purchases table
  try {
    await db.customStatement(
        'ALTER TABLE purchases ADD COLUMN representative_id TEXT');
  } catch (e) {
    debugPrint('DB Migration v57: purchases.representative_id: $e');
  }
}
