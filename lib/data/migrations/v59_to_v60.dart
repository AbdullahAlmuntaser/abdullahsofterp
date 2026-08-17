import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV59ToV60(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement('ALTER TABLE hr_employees ADD COLUMN contract_expiry TEXT');
  } catch (e) {
    debugPrint('DB Migration v60: hr_employees.contract_expiry: $e');
  }
  try {
    await db.customStatement('ALTER TABLE hr_employees ADD COLUMN attachments TEXT');
  } catch (e) {
    debugPrint('DB Migration v60: hr_employees.attachments: $e');
  }
}
