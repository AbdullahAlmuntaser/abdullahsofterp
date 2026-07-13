import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class FinancialDao {
  final ManualDatabase _db;
  FinancialDao(this._db);

  // ==================== CASHBOX ====================
  Future<List<CashboxTransaction>> getAllCashboxTransactions() async {
    final rows = _db.query('SELECT * FROM cashbox_transactions ORDER BY created_at DESC');
    return rows.map((r) => CashboxTransaction.fromMap(r)).toList();
  }

  Future<String> insertCashboxTransaction({
    required Decimal amount, required String type,
    required String category, required String userId,
    String? referenceId, String? note,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO cashbox_transactions (id, amount, type, category, reference_id, note, user_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, amount.toString(), type, category, referenceId, note, userId]);
    return id;
  }

  Future<Decimal> getCashboxBalance({String? userId}) async {
    String sql = '''
      SELECT COALESCE(SUM(CASE WHEN type = 'IN' THEN CAST(amount AS REAL) ELSE -CAST(amount AS REAL) END), 0) AS balance
      FROM cashbox_transactions
    ''';
    final params = <Object?>[];
    if (userId != null) {
      sql += ' WHERE user_id = ?';
      params.add(userId);
    }
    final rows = _db.query(sql, params);
    return Decimal.parse(rows.first['balance'].toString());
  }

  // ==================== FINANCIAL TRANSFERS ====================
  Future<List<FinancialTransfer>> getAllTransfers() async {
    final rows = _db.query('SELECT * FROM financial_transfers ORDER BY date DESC');
    return rows.map((r) => FinancialTransfer.fromMap(r)).toList();
  }

  Future<String> insertTransfer(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO financial_transfers ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== CHECKS ====================
  Future<List<Check>> getAllChecks({String? status}) async {
    String sql = 'SELECT * FROM checks';
    final params = <Object?>[];
    if (status != null) { sql += ' WHERE status = ?'; params.add(status); }
    sql += ' ORDER BY due_date DESC';
    final rows = _db.query(sql, params);
    return rows.map((r) => Check.fromMap(r)).toList();
  }

  Future<String> insertCheck(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO checks ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  Future<void> updateCheckStatus(String id, String status) async {
    _db.execute('UPDATE checks SET status = ? WHERE id = ?', [status, id]);
  }

  // ==================== RECONCILIATIONS ====================
  Future<List<Reconciliation>> getAllReconciliations() async {
    final rows = _db.query('SELECT * FROM reconciliations ORDER BY date DESC');
    return rows.map((r) => Reconciliation.fromMap(r)).toList();
  }

  Future<String> insertReconciliation(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO reconciliations ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== SHIFTS ====================
  Future<List<Shift>> getShiftsByUser(String userId) async {
    final rows = _db.query('SELECT * FROM shifts WHERE user_id = ? ORDER BY start_time DESC', [userId]);
    return rows.map((r) => Shift.fromMap(r)).toList();
  }

  Future<String> openShift(String userId, Decimal openingCash, {String? note}) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO shifts (id, user_id, opening_cash, note) VALUES (?, ?, ?, ?)
    ''', [id, userId, openingCash.toString(), note]);
    return id;
  }

  Future<void> closeShift(String id, Decimal closingCash, Decimal expectedCash) async {
    _db.execute('''
      UPDATE shifts SET end_time = datetime('now'), closing_cash = ?, expected_cash = ?, is_open = 0 WHERE id = ?
    ''', [closingCash.toString(), expectedCash.toString(), id]);
  }
}

class FinancialTransfer {
  final String id; final String senderAccountId; final String receiverAccountId;
  final Decimal amount; final Decimal commission; final String? company;
  final String transferType; final String? checkId;
  final DateTime date; final String? note; final String status;
  FinancialTransfer.fromMap(Map<String, dynamic> m) :
    id = m['id'], senderAccountId = m['sender_account_id'],
    receiverAccountId = m['receiver_account_id'],
    amount = _fd(m['amount']), commission = _fd(m['commission']),
    company = m['company'], transferType = m['transfer_type'],
    checkId = m['check_id'], date = DateTime.parse(m['date']),
    note = m['note'], status = m['status'] ?? 'POSTED';
}

class Reconciliation {
  final String id; final String accountId; final DateTime date;
  final Decimal bookBalance; final Decimal actualBalance;
  final Decimal difference; final String? note;
  Reconciliation.fromMap(Map<String, dynamic> m) :
    id = m['id'], accountId = m['account_id'],
    date = DateTime.parse(m['date']),
    bookBalance = _fd(m['book_balance']),
    actualBalance = _fd(m['actual_balance']),
    difference = _fd(m['difference']), note = m['note'];
}

class Shift {
  final String id; final String userId; final DateTime startTime;
  final DateTime? endTime; final Decimal openingCash;
  final Decimal? closingCash; final Decimal? expectedCash;
  final String? note; final bool isOpen;
  Shift.fromMap(Map<String, dynamic> m) :
    id = m['id'], userId = m['user_id'],
    startTime = DateTime.parse(m['start_time']),
    endTime = m['end_time'] != null ? DateTime.parse(m['end_time']) : null,
    openingCash = _fd(m['opening_cash']),
    closingCash = _fd(m['closing_cash']),
    expectedCash = _fd(m['expected_cash']),
    note = m['note'], isOpen = m['is_open'] == 1;
}

Decimal _fd(dynamic v) {
  if (v == null) return Decimal.zero;
  if (v is Decimal) return v;
  return Decimal.tryParse(v.toString()) ?? Decimal.zero;
}
