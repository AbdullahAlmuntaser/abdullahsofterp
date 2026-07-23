import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class WarehousesDao extends DatabaseAccessor<AppDatabase> {
  WarehousesDao(super.db);

  Future<List<Warehouse>> getAllWarehouses() => select(db.warehouses).get();

  Stream<List<Warehouse>> watchWarehouses() => select(db.warehouses).watch();

  Future<Warehouse?> getWarehouseById(String id) =>
      (select(db.warehouses)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> createWarehouse(WarehousesCompanion warehouse) =>
      into(db.warehouses).insert(warehouse);

  Future<bool> updateWarehouse(Warehouse warehouse) =>
      update(db.warehouses).replace(warehouse);

  Future<int> deleteWarehouse(String id) =>
      (delete(db.warehouses)..where((t) => t.id.equals(id))).go();

  Future<bool> hasStock(String warehouseId) async {
    final query = select(db.productBatches)
      ..where(
        (t) =>
            t.warehouseId.equals(warehouseId) &
            t.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
      );
    final results = await query.get();
    return results.isNotEmpty;
  }

  Future<void> setDefaultWarehouse(String id) async {
    await transaction(() async {
      await (update(db.warehouses)..where((t) => t.isDefault.equals(true))).write(
        const WarehousesCompanion(isDefault: Value(false)),
      );
      await (update(db.warehouses)..where((t) => t.id.equals(id))).write(
        const WarehousesCompanion(isDefault: Value(true)),
      );
    });
  }
}
