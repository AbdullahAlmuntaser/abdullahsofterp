import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class ManufacturingDao {
  final ManualDatabase _db;
  ManufacturingDao(this._db);

  // ==================== BILL OF MATERIALS ====================
  Future<List<BillOfMaterial>> getBomForProduct(String productId) async {
    final rows = _db.query('''
      SELECT * FROM bill_of_materials WHERE finished_product_id = ?
    ''', [productId]);
    return rows.map((r) => BillOfMaterial.fromMap(r)).toList();
  }

  Future<List<BillOfMaterial>> getAllBoms() async {
    final rows = _db.query('SELECT * FROM bill_of_materials ORDER BY finished_product_id');
    return rows.map((r) => BillOfMaterial.fromMap(r)).toList();
  }

  Future<String> insertBom(String finishedProductId, String componentProductId, Decimal quantity) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO bill_of_materials (id, finished_product_id, component_product_id, quantity)
      VALUES (?, ?, ?, ?)
    ''', [id, finishedProductId, componentProductId, quantity.toString()]);
    return id;
  }

  Future<void> deleteBom(String id) async {
    _db.execute('DELETE FROM bill_of_materials WHERE id = ?', [id]);
  }

  Future<void> deleteAllBomsForProduct(String productId) async {
    _db.execute('DELETE FROM bill_of_materials WHERE finished_product_id = ?', [productId]);
  }

  // BOM with Product names (JOIN)
  Future<List<Map<String, dynamic>>> getBomWithProductNames(String productId) async {
    return _db.query('''
      SELECT b.*, p.name AS component_name, p.sku AS component_sku
      FROM bill_of_materials b
      JOIN products p ON p.id = b.component_product_id
      WHERE b.finished_product_id = ?
    ''', [productId]);
  }

  // ==================== PRODUCTION ORDERS ====================
  Future<List<ProductionOrder>> getAllProductionOrders() async {
    final rows = _db.query('SELECT * FROM production_orders ORDER BY date DESC');
    return rows.map((r) => ProductionOrder.fromMap(r)).toList();
  }

  Future<ProductionOrder?> getProductionOrderById(String id) async {
    final rows = _db.query('SELECT * FROM production_orders WHERE id = ?', [id]);
    return rows.isEmpty ? null : ProductionOrder.fromMap(rows.first);
  }

  Future<String> insertProductionOrder(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO production_orders ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  Future<void> updateProductionOrderStatus(String id, String status) async {
    _db.execute('UPDATE production_orders SET status = ? WHERE id = ?', [status, id]);
  }
}
