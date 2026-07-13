import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class SuppliersDao {
  final ManualDatabase _db;
  SuppliersDao(this._db);

  Future<List<Supplier>> getAllSuppliers({bool activeOnly = true}) async {
    String sql = 'SELECT * FROM suppliers';
    if (activeOnly) sql += ' WHERE is_active = 1';
    sql += ' ORDER BY name';
    final rows = _db.query(sql);
    return rows.map((r) => Supplier.fromMap(r)).toList();
  }

  Future<Supplier?> getSupplierById(String id) async {
    final rows = _db.query('SELECT * FROM suppliers WHERE id = ?', [id]);
    return rows.isEmpty ? null : Supplier.fromMap(rows.first);
  }

  Future<String> insertSupplier({
    required String name, String? phone, String? contactPerson,
    String? taxNumber, String? address, String? email,
    Decimal? creditLimit, String? accountId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO suppliers (id, name, phone, contact_person, tax_number, address, email,
        credit_limit, balance, account_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, name, phone, contactPerson, taxNumber, address, email,
          creditLimit?.toString() ?? '0', '0', accountId]);
    return id;
  }

  Future<void> updateSupplier(Map<String, dynamic> fields, String id) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE suppliers SET $sets, updated_at = datetime(\'now\') WHERE id = ?', values);
  }

  Future<void> softDeleteSupplier(String id) async {
    _db.execute('UPDATE suppliers SET is_active = 0 WHERE id = ?', [id]);
  }

  Future<List<Supplier>> searchSuppliers(String query) async {
    final q = '%$query%';
    final rows = _db.query('''
      SELECT * FROM suppliers WHERE is_active = 1
      AND (name LIKE ? OR phone LIKE ? OR tax_number LIKE ?)
      ORDER BY name
    ''', [q, q, q]);
    return rows.map((r) => Supplier.fromMap(r)).toList();
  }

  Future<List<Map<String, dynamic>>> getSupplierStatement(String supplierId) async {
    final purchases = _db.query('''
      SELECT id, date, total AS amount, 'PURCHASE' AS type, 'فاتورة مشتريات' AS description
      FROM purchases WHERE supplier_id = ? AND is_credit = 1
    ''', [supplierId]);

    final ap = _db.query('''
      SELECT id, invoice_date AS date, total_amount AS amount, 'AP_INVOICE' AS type, 'فاتورة AP' AS description
      FROM ap_invoices WHERE supplier_id = ?
    ''', [supplierId]);

    final payments = _db.query('''
      SELECT id, payment_date AS date, amount, 'PAYMENT' AS type, 'سند صرف' AS description
      FROM supplier_payments WHERE supplier_id = ?
    ''', [supplierId]);

    final all = [...purchases, ...ap, ...payments];
    all.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    return all;
  }
}
