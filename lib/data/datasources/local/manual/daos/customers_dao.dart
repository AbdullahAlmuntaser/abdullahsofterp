import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class CustomersDao {
  final ManualDatabase _db;
  CustomersDao(this._db);

  // ==================== CUSTOMERS ====================
  Future<List<Customer>> getAllCustomers({bool activeOnly = true}) async {
    String sql = 'SELECT * FROM customers';
    if (activeOnly) sql += ' WHERE is_active = 1';
    sql += ' ORDER BY name';
    final rows = _db.query(sql);
    return rows.map((r) => Customer.fromMap(r)).toList();
  }

  Future<Customer?> getCustomerById(String id) async {
    final rows = _db.query('SELECT * FROM customers WHERE id = ?', [id]);
    return rows.isEmpty ? null : Customer.fromMap(rows.first);
  }

  Future<String> insertCustomer({
    required String name, String? phone, String? taxNumber,
    String? address, String? email, String? customerType,
    Decimal? creditLimit, String? accountId,
    bool isQuickCustomer = false,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO customers (id, name, phone, tax_number, address, email, customer_type,
        credit_limit, balance, account_id, is_quick_customer)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, name, phone, taxNumber, address, email, customerType ?? 'RETAIL',
          creditLimit?.toString() ?? '0', '0', accountId, isQuickCustomer ? 1 : 0]);
    return id;
  }

  Future<void> updateCustomer(Map<String, dynamic> fields, String id) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE customers SET $sets, updated_at = datetime(\'now\') WHERE id = ?', values);
  }

  Future<void> softDeleteCustomer(String id) async {
    _db.execute('UPDATE customers SET is_active = 0 WHERE id = ?', [id]);
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final q = '%$query%';
    final rows = _db.query('''
      SELECT * FROM customers WHERE is_active = 1
      AND (name LIKE ? OR phone LIKE ? OR tax_number LIKE ?)
      ORDER BY name
    ''', [q, q, q]);
    return rows.map((r) => Customer.fromMap(r)).toList();
  }

  // ==================== CUSTOMER PAYMENTS ====================
  Future<List<CustomerPayment>> getPaymentsForCustomer(String customerId) async {
    final rows = _db.query('''
      SELECT * FROM customer_payments WHERE customer_id = ? ORDER BY payment_date DESC
    ''', [customerId]);
    return rows.map((r) => CustomerPayment.fromMap(r)).toList();
  }

  Future<String> insertCustomerPayment({
    required String customerId, required Decimal amount,
    String? note, String? paymentMethod, String? referenceNumber,
    String? accountId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO customer_payments (id, customer_id, amount, note, payment_method, reference_number, account_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, customerId, amount.toString(), note, paymentMethod ?? 'cash',
          referenceNumber, accountId]);
    return id;
  }

  // ==================== CUSTOMER STATEMENT (JOIN) ====================
  Future<List<Map<String, dynamic>>> getCustomerStatement(String customerId) async {
    final sales = _db.query('''
      SELECT id, created_at AS date, total AS amount, 'SALE' AS type, 'فاتورة مبيعات' AS description
      FROM sales WHERE customer_id = ? AND is_credit = 1
    ''', [customerId]);

    final ar = _db.query('''
      SELECT id, invoice_date AS date, total_amount AS amount, 'AR_INVOICE' AS type, 'فاتورة AR' AS description
      FROM ar_invoices WHERE customer_id = ?
    ''', [customerId]);

    final payments = _db.query('''
      SELECT id, payment_date AS date, amount, 'PAYMENT' AS type, 'سند قبض' AS description
      FROM customer_payments WHERE customer_id = ?
    ''', [customerId]);

    final all = [...sales, ...ar, ...payments];
    all.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    return all;
  }

  // ==================== AR INVOICES ====================
  Future<List<ARInvoice>> getARInvoicesForCustomer(String customerId) async {
    final rows = _db.query('''
      SELECT * FROM ar_invoices WHERE customer_id = ? ORDER BY invoice_date DESC
    ''', [customerId]);
    return rows.map((r) => ARInvoice.fromMap(r)).toList();
  }
}

class ARInvoice {
  final String id; final String customerId; final String invoiceNumber;
  final DateTime invoiceDate; final DateTime? dueDate;
  final int totalAmount; final Decimal taxAmount;
  final Decimal paidAmount; final String status;
  final String? notes; final String? accountId;
  ARInvoice.fromMap(Map<String, dynamic> m) :
    id = m['id'], customerId = m['customer_id'],
    invoiceNumber = m['invoice_number'],
    invoiceDate = DateTime.parse(m['invoice_date']),
    dueDate = m['due_date'] != null ? DateTime.parse(m['due_date']) : null,
    totalAmount = m['total_amount'] as int,
    taxAmount = _parseDecimal(m['tax_amount']),
    paidAmount = _parseDecimal(m['paid_amount']),
    status = m['status'] ?? 'DRAFT', notes = m['notes'],
    accountId = m['account_id'];

  static Decimal _parseDecimal(dynamic v) {
    if (v == null) return Decimal.zero;
    if (v is Decimal) return v;
    return Decimal.tryParse(v.toString()) ?? Decimal.zero;
  }
}
