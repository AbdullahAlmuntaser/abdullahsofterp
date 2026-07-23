import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class ProductUnitsDao extends DatabaseAccessor<AppDatabase> {
  ProductUnitsDao(super.db);

  Future<List<ProductUnit>> getAllProductUnits() => select(db.productUnits).get();

  Stream<List<ProductUnit>> watchAllProductUnits() =>
      select(db.productUnits).watch();

  Future<ProductUnit?> getProductUnitById(String id) async {
    return (select(db.productUnits)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ProductUnit>> getUnitsForProduct(String productId) async {
    return (select(db.productUnits)..where((tbl) => tbl.productId.equals(productId)))
        .get();
  }

  Future<int> addProductUnit(ProductUnitsCompanion unit) =>
      into(db.productUnits).insert(unit);

  Future<bool> updateProductUnit(ProductUnitsCompanion unit, String id) {
    return (update(db.productUnits)..where((tbl) => tbl.id.equals(id)))
        .write(unit)
        .then((value) => value > 0);
  }

  Future<int> deleteProductUnit(String id) =>
      (delete(db.productUnits)..where((tbl) => tbl.id.equals(id))).go();
}
