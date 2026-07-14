import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class SalesDao {
  final ManualDatabase _db;
  SalesDao(this._db);

  // ==================== SALES ====================
  Future<List<Sale>> getAllSales() async {
    final rows = _db.query('SELECT * FROM sales ORDER BY created_at DESC');
    return rows.map((r) => Sale.fromMap(r)).toList();
  }

  Future<Sale?> getSaleById(String id) async {
    final rows = _db.query('SELECT * FROM sales WHERE id = ?', [id]);
    return rows.isEmpty ? null : Sale.fromMap(rows.first);
  }

  Future<String> insertSale(Map<String, dynamic> fields) async {
    final id = fields['id'] as String? ?? const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO sales ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  Future<void> updateSale(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    fields['updated_at'] = "datetime('now')";
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE sales SET $sets WHERE id = ?', values);
  }

  Future<void> deleteSale(String id) async {
    _db.transaction(() {
      _db.execute('DELETE FROM sale_items WHERE sale_id = ?', [id]);
      _db.execute('DELETE FROM sales WHERE id = ?', [id]);
    });
  }

  // ==================== SALE ITEMS ====================
  Future<List<SaleItem>> getSaleItems(String saleId) async {
    final rows = _db.query('SELECT * FROM sale_items WHERE sale_id = ?', [saleId]);
    return rows.map((r) => SaleItem.fromMap(r)).toList();
  }

  Future<void> insertSaleItems(String saleId, List<Map<String, dynamic>> items) async {
    for (final item in items) {
      item['id'] = const Uuid().v4();
      item['sale_id'] = saleId;
      final cols = item.keys.join(', ');
      final placeholders = item.keys.map((_) => '?').join(', ');
      _db.execute('INSERT INTO sale_items ($cols) VALUES ($placeholders)', item.values.toList());
    }
  }

  // ==================== TOP SELLING (JOIN) ====================
  Future<List<Map<String, dynamic>>> getTopSellingProducts({int limit = 10}) async {
    return _db.query('''
      SELECT si.product_id, p.name AS product_name, p.sku,
        ROUND(SUM(CAST(si.quantity AS REAL)), 6) AS total_qty,
        ROUND(SUM(CAST(si.quantity AS REAL) * CAST(si.price AS REAL)), 6) AS total_revenue
      FROM sale_items si
      JOIN products p ON p.id = si.product_id
      GROUP BY si.product_id
      ORDER BY total_qty DESC
      LIMIT ?
    ''', [limit]);
  }

  // ==================== SALES WITH CUSTOMER (JOIN) ====================
  Future<List<SaleWithCustomer>> getSalesWithCustomer({
    DateTime? startDate, DateTime? endDate,
  }) async {
    String sql = '''
      SELECT s.*, c.id AS c_id, c.name AS c_name, c.phone AS c_phone, c.tax_number AS c_tax
      FROM sales s
      LEFT JOIN customers c ON c.id = s.customer_id
      WHERE 1=1
    ''';
    final params = <Object?>[];
    if (startDate != null) { sql += ' AND s.created_at >= ?'; params.add(startDate.toIso8601String()); }
    if (endDate != null) { sql += ' AND s.created_at <= ?'; params.add(endDate.toIso8601String()); }
    sql += ' ORDER BY s.created_at DESC';
    final rows = _db.query(sql, params);
    return rows.map((r) {
      final customer = r['c_id'] != null ? Customer.fromMap({
        'id': r['c_id'], 'name': r['c_name'], 'phone': r['c_phone'],
        'tax_number': r['c_tax'], 'is_active': 1,
      }) : null;
      return SaleWithCustomer(Sale.fromMap(r), customer);
    }).toList();
  }

  // ==================== TODAY'S STATS ====================
  Future<Decimal> getTotalRevenueToday() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final rows = _db.query('''
      SELECT COALESCE(SUM(CAST(total AS REAL)), 0) AS total
      FROM sales WHERE created_at LIKE ?
    ''', ['$today%']);
    return Decimal.parse(rows.first['total'].toString());
  }

  // ==================== SALES ORDERS ====================
  Future<List<SalesOrder>> getAllSalesOrders() async {
    final rows = _db.query('SELECT * FROM sales_orders ORDER BY date DESC');
    return rows.map((r) => SalesOrder.fromMap(r)).toList();
  }

  Future<SalesOrder?> getSalesOrderById(String id) async {
    final rows = _db.query('SELECT * FROM sales_orders WHERE id = ?', [id]);
    return rows.isEmpty ? null : SalesOrder.fromMap(rows.first);
  }

  Future<String> insertSalesOrder(Map<String, dynamic> fields) async {
    final id = fields['id'] as String? ?? const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO sales_orders ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  Future<void> updateSalesOrderStatus(String id, String status) async {
    _db.execute('UPDATE sales_orders SET status = ? WHERE id = ?', [status, id]);
  }
}
