import 'package:drift/drift.dart';
import '../app_database.dart';

class StockMovementDao extends DatabaseAccessor<AppDatabase> {
  StockMovementDao(super.db);

  Future<int> insertStockMovement(StockMovementsCompanion entry) =>
      into(db.stockMovements).insert(entry);
  Future<StockMovement?> getStockMovementById(String id) => (select(db.stockMovements)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
  Future<List<StockMovement>> getAllStockMovements() =>
      select(db.stockMovements).get();
  Future<bool> updateStockMovement(StockMovement entry) =>
      update(db.stockMovements).replace(entry);
  Future<int> deleteStockMovement(String id) =>
      (delete(db.stockMovements)..where((tbl) => tbl.id.equals(id))).go();
  Future<List<StockMovement>> getStockMovementsByProduct(String productId) =>
      (select(db.stockMovements)..where((tbl) => tbl.productId.equals(productId)))
          .get();

  Future<List<StockMovement>> getProductMovementReport({
    required String productId,
    required DateTime startDate,
    required DateTime endDate,
    String? warehouseId,
  }) {
    var query = select(db.stockMovements)
      ..where((t) => t.productId.equals(productId))
      ..where((t) => t.movementDate.isBetweenValues(startDate, endDate));

    if (warehouseId != null) {
      query.where((t) =>
          t.fromWarehouseId.equals(warehouseId) |
          t.toWarehouseId.equals(warehouseId));
    }

    return (query..orderBy([(t) => OrderingTerm(expression: t.movementDate)]))
        .get();
  }
}
