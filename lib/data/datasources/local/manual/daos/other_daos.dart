import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class OtherDao {
  final ManualDatabase _db;
  OtherDao(this._db);

  // ==================== CURRENCIES ====================
  Future<List<Currency>> getAllCurrencies() async {
    final rows = _db.query('SELECT * FROM currencies ORDER BY code');
    return rows.map((r) => Currency.fromMap(r)).toList();
  }

  Future<Currency?> getBaseCurrency() async {
    final rows = _db.query('SELECT * FROM currencies WHERE is_base = 1');
    return rows.isEmpty ? null : Currency.fromMap(rows.first);
  }

  Future<Currency?> getCurrencyByCode(String code) async {
    final rows = _db.query('SELECT * FROM currencies WHERE code = ?', [code]);
    return rows.isEmpty ? null : Currency.fromMap(rows.first);
  }

  Future<String> insertCurrency(String code, String name,
      {Decimal? exchangeRate, bool isBase = false, int decimalPlaces = 2}) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO currencies (id, code, name, exchange_rate, is_base, decimal_places)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [id, code, name, exchangeRate?.toString() ?? '1', isBase ? 1 : 0, decimalPlaces]);
    return id;
  }

  Future<void> updateExchangeRate(String currencyId, Decimal rate) async {
    _db.execute('UPDATE currencies SET exchange_rate = ? WHERE id = ?', [rate.toString(), currencyId]);
  }

  // ==================== PROMOTIONS ====================
  Future<List<Promotion>> getAllActivePromotions() async {
    final rows = _db.query('''
      SELECT * FROM promotions WHERE is_active = 1
      AND datetime('now') BETWEEN start_date AND end_date
      ORDER BY name
    ''');
    return rows.map((r) => Promotion.fromMap(r)).toList();
  }

  Future<String> insertPromotion(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO promotions ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== SERIAL NUMBERS ====================
  Future<SerialNumber?> getSerialByNumber(String serial) async {
    final rows = _db.query('SELECT * FROM serial_numbers WHERE serial_number = ?', [serial]);
    return rows.isEmpty ? null : SerialNumber.fromMap(rows.first);
  }

  Future<String> registerSerial({
    required String productId, required String serialNumber,
    String? batchId, String? warehouseId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO serial_numbers (id, product_id, serial_number, batch_id, warehouse_id)
      VALUES (?, ?, ?, ?, ?)
    ''', [id, productId, serialNumber, batchId, warehouseId]);
    return id;
  }

  Future<void> markSerialSold(String serialId, String saleId) async {
    _db.execute('UPDATE serial_numbers SET status = \'SOLD\', sale_id = ? WHERE id = ?', [saleId, serialId]);
  }

  // ==================== FIXED ASSETS ====================
  Future<List<FixedAsset>> getAllFixedAssets({String? status}) async {
    String sql = 'SELECT * FROM fixed_assets';
    final params = <Object?>[];
    if (status != null) { sql += ' WHERE status = ?'; params.add(status); }
    sql += ' ORDER BY name';
    final rows = _db.query(sql, params);
    return rows.map((r) => FixedAsset.fromMap(r)).toList();
  }

  Future<String> insertFixedAsset(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO fixed_assets ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== PROFORMA INVOICES ====================
  Future<List<ProformaInvoice>> getAllProformaInvoices() async {
    final rows = _db.query('SELECT * FROM proforma_invoices ORDER BY created_at DESC');
    return rows.map((r) => ProformaInvoice.fromMap(r)).toList();
  }

  Future<String> insertProformaInvoice(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO proforma_invoices ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== ZAKAT & EOSB ====================
  Future<List<Map<String, dynamic>>> getZakatCalculations(int year) async {
    return _db.query('SELECT * FROM zakat_calculations WHERE year = ?', [year]);
  }

  Future<List<Map<String, dynamic>>> getEosbByEmployee(String employeeId) async {
    return _db.query('''
      SELECT * FROM end_of_service_benefits WHERE employee_id = ? ORDER BY calculation_date DESC
    ''', [employeeId]);
  }

  // ==================== WITHHOLDING TAX ====================
  Future<List<Map<String, dynamic>>> getWithholdingTaxEntries({
    String? partnerId, String? status,
  }) async {
    String sql = 'SELECT * FROM withholding_tax_entries';
    final params = <Object?>[];
    final conditions = <String>[];
    if (partnerId != null) { conditions.add('partner_id = ?'); params.add(partnerId); }
    if (status != null) { conditions.add('status = ?'); params.add(status); }
    if (conditions.isNotEmpty) sql += ' WHERE ${conditions.join(' AND ')}';
    sql += ' ORDER BY date DESC';
    return _db.query(sql, params);
  }

  // ==================== GLOBAL UNITS ====================
  Future<List<GlobalUnit>> getAllGlobalUnits() async {
    final rows = _db.query('SELECT * FROM global_units ORDER BY name');
    return rows.map((r) => GlobalUnit.fromMap(r)).toList();
  }

  Future<String> insertGlobalUnit(String name, {String? symbol}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO global_units (id, name, symbol) VALUES (?, ?, ?)', [id, name, symbol]);
    return id;
  }

  // ==================== BRANCH MANAGEMENT ====================
  Future<List<Branch>> getAllBranches() async {
    final rows = _db.query('SELECT * FROM branches WHERE is_active = 1 ORDER BY name');
    return rows.map((r) => Branch.fromMap(r)).toList();
  }
}

class GlobalUnit {
  final String id; final String name; final String? symbol; final bool isCustom;
  GlobalUnit.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], symbol = m['symbol'],
    isCustom = m['is_custom'] == 1;
}
