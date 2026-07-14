import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class AccountingDao {
  final ManualDatabase _db;
  AccountingDao(this._db);

  // ==================== GL ACCOUNTS ====================
  Future<List<GLAccount>> getAllAccounts() async {
    final rows = _db.query('SELECT * FROM gl_accounts ORDER BY code');
    return rows.map((r) => GLAccount.fromMap(r)).toList();
  }

  Future<GLAccount?> getAccountById(String id) async {
    final rows = _db.query('SELECT * FROM gl_accounts WHERE id = ?', [id]);
    return rows.isEmpty ? null : GLAccount.fromMap(rows.first);
  }

  Future<GLAccount?> getAccountByCode(String code) async {
    final rows = _db.query('SELECT * FROM gl_accounts WHERE code = ?', [code]);
    return rows.isEmpty ? null : GLAccount.fromMap(rows.first);
  }

  Future<String> insertAccount({
    required String code, required String name, required int accountType,
    String? parentId, bool isHeader = false, String? analyticType,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO gl_accounts (id, code, name, account_type, parent_id, is_header, analytic_type)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, code, name, accountType, parentId, isHeader ? 1 : 0, analyticType]);
    return id;
  }

  Future<void> updateAccount(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE gl_accounts SET $sets WHERE id = ?', values);
  }

  // ==================== GL ACCOUNT TREE (JOIN - self-referential) ====================
  Future<List<GLAccountWithParent>> getAccountTree() async {
    final rows = _db.query('''
      SELECT a.*, p.id AS p_id, p.code AS p_code, p.name AS p_name
      FROM gl_accounts a
      LEFT JOIN gl_accounts p ON p.id = a.parent_id
      ORDER BY a.code
    ''');
    return rows.map((r) {
      final parent = r['p_id'] != null ? GLAccount.fromMap({
        'id': r['p_id'], 'code': r['p_code'], 'name': r['p_name'],
        'account_type': 0, 'is_header': 0,
      }) : null;
      return GLAccountWithParent(GLAccount.fromMap(r), parent);
    }).toList();
  }

  // ==================== COST CENTERS ====================
  Future<List<CostCenter>> getAllCostCenters() async {
    final rows = _db.query('SELECT * FROM cost_centers WHERE is_active = 1 ORDER BY code');
    return rows.map((r) => CostCenter.fromMap(r)).toList();
  }

  Future<String> insertCostCenter(String code, String name,
      {String? parentId, String type = 'department'}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO cost_centers (id, code, name, parent_id, type) VALUES (?, ?, ?, ?, ?)',
        [id, code, name, parentId, type]);
    return id;
  }

  // ==================== GL ENTRIES ====================
  Future<GLEntry?> getGLEntryById(String id) async {
    final rows = _db.query('SELECT * FROM gl_entries WHERE id = ?', [id]);
    return rows.isEmpty ? null : GLEntry.fromMap(rows.first);
  }

  Future<List<GLEntry>> getGLEntriesByDateRange(DateTime start, DateTime end) async {
    final rows = _db.query('''
      SELECT * FROM gl_entries WHERE date >= ? AND date <= ? ORDER BY date DESC
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return rows.map((r) => GLEntry.fromMap(r)).toList();
  }

  Future<String> insertGLEntry({
    required String description, DateTime? date,
    String? referenceType, String? referenceId,
    String? currencyId, Decimal? exchangeRate,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO gl_entries (id, description, date, reference_type, reference_id, currency_id, exchange_rate)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, description, date?.toIso8601String() ?? DateTime.now().toIso8601String(),
          referenceType, referenceId, currencyId, exchangeRate?.toString() ?? '1']);
    return id;
  }

  Future<void> postGLEntry(String id, String postedBy) async {
    _db.execute('''
      UPDATE gl_entries SET status = 'POSTED', posted_at = datetime('now'), posted_by = ? WHERE id = ?
    ''', [postedBy, id]);
  }

  // ==================== GL LINES ====================
  Future<List<GLLine>> getGLLines(String entryId) async {
    final rows = _db.query('SELECT * FROM gl_lines WHERE entry_id = ?', [entryId]);
    return rows.map((r) => GLLine.fromMap(r)).toList();
  }

  Future<String> insertGLLine({
    required String entryId, required String accountId,
    Decimal? debit, Decimal? credit,
    String? costCenterId, String? memo,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO gl_lines (id, entry_id, account_id, debit, credit, cost_center_id, memo)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, entryId, accountId, debit?.toString() ?? '0',
          credit?.toString() ?? '0', costCenterId, memo]);
    return id;
  }

  // ==================== TRIAL BALANCE (JOIN) ====================
  Future<List<Map<String, dynamic>>> getTrialBalance(DateTime start, DateTime end) async {
    final rows = _db.query('''
      SELECT a.id AS account_id, a.code, a.name, a.account_type,
        gl.debit AS raw_debit, gl.credit AS raw_credit
      FROM gl_accounts a
      LEFT JOIN gl_lines gl ON gl.account_id = a.id
      LEFT JOIN gl_entries e ON e.id = gl.entry_id AND e.status = 'POSTED'
        AND e.date >= ? AND e.date <= ?
      ORDER BY a.code
    ''', [start.toIso8601String(), end.toIso8601String()]);

    final Map<String, Map<String, dynamic>> grouped = {};
    for (final row in rows) {
      final id = row['account_id'] as String;
      grouped.putIfAbsent(id, () => {
        'account_id': id, 'code': row['code'], 'name': row['name'],
        'account_type': row['account_type'], 'total_debit': Decimal.zero, 'total_credit': Decimal.zero,
      });
      grouped[id]!['total_debit'] = (grouped[id]!['total_debit'] as Decimal) +
          _pd(row['raw_debit']);
      grouped[id]!['total_credit'] = (grouped[id]!['total_credit'] as Decimal) +
          _pd(row['raw_credit']);
    }
    return grouped.values.toList();
  }

  // ==================== INCOME STATEMENT (JOIN) ====================
  Future<Map<String, dynamic>> getIncomeStatement(DateTime start, DateTime end) async {
    final rows = _db.query('''
      SELECT a.account_type, gl.debit AS raw_debit, gl.credit AS raw_credit
      FROM gl_lines gl
      JOIN gl_accounts a ON a.id = gl.account_id
      JOIN gl_entries e ON e.id = gl.entry_id AND e.status = 'POSTED'
      WHERE a.account_type IN (3, 4) AND e.date >= ? AND e.date <= ?
    ''', [start.toIso8601String(), end.toIso8601String()]);

    Decimal revenue = Decimal.zero;
    Decimal expenses = Decimal.zero;
    for (final row in rows) {
      final type = row['account_type'] as int;
      if (type == 3) {
        revenue += _pd(row['raw_credit']) - _pd(row['raw_debit']);
      } else if (type == 4) {
        expenses += _pd(row['raw_debit']) - _pd(row['raw_credit']);
      }
    }
    return {
      'total_revenue': revenue,
      'total_expenses': expenses,
      'net_income': revenue - expenses,
    };
  }

  // ==================== BALANCE SHEET (JOIN) ====================
  Future<Map<String, dynamic>> getBalanceSheet() async {
    final rows = _db.query('''
      SELECT account_type, balance FROM gl_accounts WHERE account_type IN (0, 1, 2)
    ''');

    Decimal assets = Decimal.zero;
    Decimal liabilities = Decimal.zero;
    Decimal equity = Decimal.zero;
    for (final row in rows) {
      final value = _pd(row['balance']);
      switch (row['account_type'] as int) {
        case 0: assets += value;
        case 1: liabilities += value;
        case 2: equity += value;
      }
    }
    return {
      'total_assets': assets,
      'total_liabilities': liabilities,
      'total_equity': equity,
    };
  }

  // ==================== ACCOUNTING PERIODS ====================
  Future<List<AccountingPeriod>> getAllPeriods() async {
    final rows = _db.query('SELECT * FROM accounting_periods ORDER BY start_date DESC');
    return rows.map((r) => AccountingPeriod.fromMap(r)).toList();
  }

  Future<String> insertPeriod(String name, int fiscalYear, DateTime start, DateTime end) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO accounting_periods (id, name, fiscal_year, start_date, end_date)
      VALUES (?, ?, ?, ?, ?)
    ''', [id, name, fiscalYear, start.toIso8601String(), end.toIso8601String()]);
    return id;
  }

  Future<void> closePeriod(String id, String closedBy) async {
    _db.execute('''
      UPDATE accounting_periods SET is_closed = 1, status = 'CLOSED', closed_at = datetime('now'), closed_by = ? WHERE id = ?
    ''', [closedBy, id]);
  }

  // ==================== ACCOUNT TRANSACTIONS ====================
  Future<List<AccountTransaction>> getAccountTransactions(String accountId) async {
    final rows = _db.query('''
      SELECT * FROM account_transactions WHERE account_id = ? ORDER BY date DESC
    ''', [accountId]);
    return rows.map((r) => AccountTransaction.fromMap(r)).toList();
  }

  // ==================== POSTING PROFILES ====================
  Future<List<PostingProfile>> getPostingProfiles(String operationType) async {
    final rows = _db.query('''
      SELECT * FROM posting_profiles WHERE operation_type = ? AND is_active = 1 ORDER BY sequence
    ''', [operationType]);
    return rows.map((r) => PostingProfile.fromMap(r)).toList();
  }
}

class AccountingPeriod {
  final String id; final String name; final int fiscalYear;
  final DateTime startDate; final DateTime endDate;
  final bool isClosed; final DateTime? closedAt; final String? closedBy;
  final String? closingType; final String status;
  AccountingPeriod.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], fiscalYear = m['fiscal_year'] as int,
    startDate = DateTime.parse(m['start_date']),
    endDate = DateTime.parse(m['end_date']),
    isClosed = m['is_closed'] == 1,
    closedAt = m['closed_at'] != null ? DateTime.parse(m['closed_at']) : null,
    closedBy = m['closed_by'], closingType = m['closing_type'],
    status = m['status'] ?? 'OPEN';
}

Decimal _pd(dynamic v) {
  if (v == null) return Decimal.zero;
  if (v is Decimal) return v;
  return Decimal.tryParse(v.toString()) ?? Decimal.zero;
}

class AccountTransaction {
  final String id; final String accountId; final DateTime date;
  final String type; final String? referenceId;
  final Decimal debit; final Decimal credit; final bool reconciled;
  AccountTransaction.fromMap(Map<String, dynamic> m) :
    id = m['id'], accountId = m['account_id'],
    date = DateTime.parse(m['date']), type = m['type'],
    referenceId = m['reference_id'], debit = _pd(m['debit']),
    credit = _pd(m['credit']), reconciled = m['reconciled'] == 1;
}

class PostingProfile {
  final String id; final String operationType; final String accountType;
  final String? accountId; final String? description; final String? accountCode;
  final bool isActive; final int sequence; final String side;
  PostingProfile.fromMap(Map<String, dynamic> m) :
    id = m['id'], operationType = m['operation_type'],
    accountType = m['account_type'], accountId = m['account_id'],
    description = m['description'], accountCode = m['account_code'],
    isActive = m['is_active'] == 1, sequence = m['sequence'] as int? ?? 0,
    side = m['side'];
}
