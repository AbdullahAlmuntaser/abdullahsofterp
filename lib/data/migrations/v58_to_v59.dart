import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV58ToV59(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement('ALTER TABLE products ADD COLUMN default_unit_id TEXT');
  } catch (e) {
    debugPrint('DB Migration v59: products.default_unit_id: $e');
  }
}
