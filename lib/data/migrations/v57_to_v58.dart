import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV57ToV58(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement('ALTER TABLE products ADD COLUMN remote_url TEXT');
  } catch (e) {
    debugPrint('DB Migration v58: products.remote_url: $e');
  }
  try {
    await db.customStatement('ALTER TABLE products ADD COLUMN thumbnail_path TEXT');
  } catch (e) {
    debugPrint('DB Migration v58: products.thumbnail_path: $e');
  }
}
