import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class GlobalUnitsDao extends DatabaseAccessor<AppDatabase> {
  GlobalUnitsDao(super.db);

  Future<List<GlobalUnit>> getAllUnits() => select(db.globalUnits).get();

  Stream<List<GlobalUnit>> watchAllUnits() => select(db.globalUnits).watch();

  Future<int> addUnit(GlobalUnitsCompanion unit) =>
      into(db.globalUnits).insert(unit);

  Future<bool> updateUnit(GlobalUnit unit) => update(db.globalUnits).replace(unit);

  Future<int> deleteUnit(String id) =>
      (delete(db.globalUnits)..where((t) => t.id.equals(id))).go();
}
