import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class PurchasesDao {
  final ManualDatabase _db;
  PurchasesDao(this._db);

  // ==================== PURCHASES ====================
  Future<List<Purchase>> getAllPurchases() async {
    final rows = _db.query('SELECT * FROM purchases ORDER BY date DESC');
    return rows.map((r) => Purchase.fromMap(r)).toList();
  }

  Future<Purchase?> getPurchaseById(String id) async {
    final rows = _db.query('SELECT * FROM purchases WHERE id = ?', [id]);
    return rows.isEmpty ? null : Purchase.fromMap(rows.first);
  }

  Future<String> insertPurchase(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO purchases ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  Future<void> updatePurchase(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    fields['updated_at'] = "datetime('now')";
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE purchases SET $sets WHERE id = ?', values);
  }

  Future<void> deletePurchase(String id) async {
    _db.transaction(() {
      _db.execute('DELETE FROM purchase_items WHERE purchase_id = ?', [id]);
      _db.execute('DELETE FROM purchases WHERE id = ?', [id]);
    });
  }

  Future<List<Purchase>> getPurchasesByDateRange(DateTime start, DateTime end) async {
    final rows = _db.query('''
      SELECT * FROM purchases WHERE date >= ? AND date <= ? ORDER BY date DESC
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return rows.map((r) => Purchase.fromMap(r)).toList();
  }

  // ==================== PURCHASE ITEMS ====================
  Future<List<PurchaseItem>> getPurchaseItems(String purchaseId) async {
    final rows = _db.query('SELECT * FROM purchase_items WHERE purchase_id = ?', [purchaseId]);
    return rows.map((r) => PurchaseItem.fromMap(r)).toList();
  }

  Future<void> insertPurchaseItems(String purchaseId, List<Map<String, dynamic>> items) async {
    for (final item in items) {
      item['id'] = const Uuid().v4();
      item['purchase_id'] = purchaseId;
      final cols = item.keys.join(', ');
      final placeholders = item.keys.map((_) => '?').join(', ');
      _db.execute('INSERT INTO purchase_items ($cols) VALUES ($placeholders)', item.values.toList());
    }
  }

  // ==================== PURCHASE WITH SUPPLIER (JOIN) ====================
  Future<List<PurchaseWithSupplier>> getPurchasesWithSupplier({
    DateTime? startDate, DateTime? endDate,
  }) async {
    String sql = '''
      SELECT p.*, s.id AS s_id, s.name AS s_name, s.phone AS s_phone
      FROM purchases p
      LEFT JOIN suppliers s ON s.id = p.supplier_id
      WHERE 1=1
    ''';
    final params = <Object?>[];
    if (startDate != null) { sql += ' AND p.date >= ?'; params.add(startDate.toIso8601String()); }
    if (endDate != null) { sql += ' AND p.date <= ?'; params.add(endDate.toIso8601String()); }
    sql += ' ORDER BY p.date DESC';
    final rows = _db.query(sql, params);
    return rows.map((r) {
      final supplier = r['s_id'] != null ? Supplier.fromMap({
        'id': r['s_id'], 'name': r['s_name'], 'phone': r['s_phone'],
        'is_active': 1,
      }) : null;
      return PurchaseWithSupplier(Purchase.fromMap(r), supplier);
    }).toList();
  }

  // ==================== PURCHASE ORDERS ====================
  Future<List<PurchaseOrder>> getAllPurchaseOrders() async {
    final rows = _db.query('SELECT * FROM purchase_orders ORDER BY date DESC');
    return rows.map((r) => PurchaseOrder.fromMap(r)).toList();
  }
}
