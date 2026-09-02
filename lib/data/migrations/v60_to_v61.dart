import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV60ToV61(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement(
      "ALTER TABLE products ADD COLUMN units_per_main_unit TEXT DEFAULT '1'",
    );
  } catch (e) {
    debugPrint('DB Migration v61: products.units_per_main_unit: $e');
  }
  try {
    await db.customStatement(
      "ALTER TABLE products ADD COLUMN unit_sell_price TEXT DEFAULT '0'",
    );
  } catch (e) {
    debugPrint('DB Migration v61: products.unit_sell_price: $e');
  }
}
