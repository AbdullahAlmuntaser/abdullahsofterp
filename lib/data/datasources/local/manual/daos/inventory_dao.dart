import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class InventoryDao {
  final ManualDatabase _db;
  InventoryDao(this._db);

  // ==================== WAREHOUSES ====================
  Future<List<Warehouse>> getAllWarehouses() async {
    final rows = _db.query('SELECT * FROM warehouses ORDER BY name');
    return rows.map((r) => Warehouse.fromMap(r)).toList();
  }

  Future<Warehouse?> getWarehouseById(String id) async {
    final rows = _db.query('SELECT * FROM warehouses WHERE id = ?', [id]);
    return rows.isEmpty ? null : Warehouse.fromMap(rows.first);
  }

  Future<String> insertWarehouse(String name, {String? location, String? accountId, bool isDefault = false}) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO warehouses (id, name, location, account_id, is_default)
      VALUES (?, ?, ?, ?, ?)
    ''', [id, name, location, accountId, isDefault ? 1 : 0]);
    return id;
  }

  Future<void> updateWarehouse(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE warehouses SET $sets WHERE id = ?', values);
  }

  Future<void> setDefaultWarehouse(String id) async {
    _db.transaction(() {
      _db.execute('UPDATE warehouses SET is_default = 0');
      _db.execute('UPDATE warehouses SET is_default = 1 WHERE id = ?', [id]);
    });
  }

  // ==================== PRODUCT BATCHES ====================
  Future<List<ProductBatch>> getBatches(String productId, String warehouseId) async {
    final rows = _db.query('''
      SELECT * FROM product_batches
      WHERE product_id = ? AND warehouse_id = ? AND CAST(quantity AS REAL) > 0
      ORDER BY expiry_date ASC
    ''', [productId, warehouseId]);
    return rows.map((r) => ProductBatch.fromMap(r)).toList();
  }

  Future<List<ProductBatch>> getBatchesByFefo(String productId, String warehouseId) async {
    final rows = _db.query('''
      SELECT * FROM product_batches
      WHERE product_id = ? AND warehouse_id = ? AND CAST(quantity AS REAL) > 0
      ORDER BY expiry_date ASC
    ''', [productId, warehouseId]);
    return rows.map((r) => ProductBatch.fromMap(r)).toList();
  }

  Future<String> insertBatch({
    required String productId, required String warehouseId,
    required String batchNumber, DateTime? expiryDate,
    Decimal? quantity, Decimal? costPrice,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO product_batches (id, product_id, warehouse_id, batch_number, expiry_date, quantity, initial_quantity, cost_price)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, productId, warehouseId, batchNumber,
          expiryDate?.toIso8601String(), quantity?.toString() ?? '0',
          quantity?.toString() ?? '0', costPrice?.toString() ?? '0']);
    return id;
  }

  Future<void> updateBatchQuantity(String batchId, Decimal newQty) async {
    _db.execute('UPDATE product_batches SET quantity = ? WHERE id = ?', [newQty.toString(), batchId]);
  }

  // ==================== STOCK MOVEMENTS ====================
  Future<List<StockMovement>> getStockMovements(String productId) async {
    final rows = _db.query('''
      SELECT * FROM stock_movements WHERE product_id = ? ORDER BY movement_date DESC
    ''', [productId]);
    return rows.map((r) => StockMovement.fromMap(r)).toList();
  }

  Future<String> insertStockMovement({
    required String productId, required Decimal quantity,
    required String type, String? fromWarehouseId, String? toWarehouseId,
    String? batchId, String? referenceId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO stock_movements (id, product_id, from_warehouse_id, to_warehouse_id, quantity, batch_id, type, reference_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, productId, fromWarehouseId, toWarehouseId, quantity.toString(), batchId, type, referenceId]);
    return id;
  }

  // ==================== STOCK TAKES ====================
  Future<List<StockTake>> getAllStockTakes() async {
    final rows = _db.query('SELECT * FROM stock_takes ORDER BY date DESC');
    return rows.map((r) => StockTake.fromMap(r)).toList();
  }

  Future<String> insertStockTake(String warehouseId, {String? note}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO stock_takes (id, warehouse_id, note) VALUES (?, ?, ?)', [id, warehouseId, note]);
    return id;
  }

  Future<void> insertStockTakeItem(String stockTakeId, String productId,
      {Decimal? expectedQty, Decimal? actualQty}) async {
    final id = const Uuid().v4();
    final variance = (actualQty ?? Decimal.zero) - (expectedQty ?? Decimal.zero);
    _db.execute('''
      INSERT INTO stock_take_items (id, stock_take_id, product_id, expected_qty, actual_qty, variance)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [id, stockTakeId, productId, expectedQty?.toString(), actualQty?.toString(), variance.toString()]);
  }

  // ==================== STOCK TRANSFERS ====================
  Future<void> transferStock({
    required String fromWarehouseId, required String toWarehouseId,
    required List<Map<String, dynamic>> items, String? note,
  }) async {
    _db.transaction(() {
      final transferId = const Uuid().v4();
      _db.execute('''
        INSERT INTO stock_transfers (id, from_warehouse_id, to_warehouse_id, note)
        VALUES (?, ?, ?, ?)
      ''', [transferId, fromWarehouseId, toWarehouseId, note]);

      for (final item in items) {
        final itemId = const Uuid().v4();
        _db.execute('''
          INSERT INTO stock_transfer_items (id, transfer_id, product_id, batch_id, quantity)
          VALUES (?, ?, ?, ?, ?)
        ''', [itemId, transferId, item['product_id'], item['batch_id'], item['quantity'].toString()]);

        // Decrease source batch
        _db.execute('''
          UPDATE product_batches SET quantity = CAST(quantity AS REAL) - ?
          WHERE id = ? AND CAST(quantity AS REAL) >= ?
        ''', [item['quantity'].toString(), item['batch_id'], item['quantity'].toString()]);

        // Increase or create target batch
        final target = _db.query('''
          SELECT id FROM product_batches
          WHERE product_id = ? AND warehouse_id = ? AND batch_number = ?
        ''', [item['product_id'], toWarehouseId, item['batch_number'] ?? '']);

        if (target.isNotEmpty) {
          _db.execute('''
            UPDATE product_batches SET quantity = CAST(quantity AS REAL) + ? WHERE id = ?
          ''', [item['quantity'].toString(), target.first['id']]);
        } else {
          final newBatchId = const Uuid().v4();
          _db.execute('''
            INSERT INTO product_batches (id, product_id, warehouse_id, batch_number, quantity, initial_quantity, cost_price)
            VALUES (?, ?, ?, ?, ?, ?, ?)
          ''', [newBatchId, item['product_id'], toWarehouseId,
                item['batch_number'] ?? '', item['quantity'].toString(),
                item['quantity'].toString(), item['cost_price']?.toString() ?? '0']);
        }
      }
    });
  }

  // ==================== EXPIRING BATCHES ====================
  Future<List<ProductBatch>> getExpiringBatches({int daysThreshold = 30}) async {
    final rows = _db.query('''
      SELECT * FROM product_batches
      WHERE expiry_date IS NOT NULL
      AND CAST(julianday(expiry_date) - julianday('now') AS INTEGER) <= ?
      AND CAST(julianday(expiry_date) - julianday('now') AS INTEGER) >= 0
      AND CAST(quantity AS REAL) > 0
      ORDER BY expiry_date ASC
    ''', [daysThreshold]);
    return rows.map((r) => ProductBatch.fromMap(r)).toList();
  }

  Future<Decimal> getWarehouseStock(String productId, String warehouseId) async {
    final rows = _db.query('''
      SELECT COALESCE(SUM(CAST(quantity AS REAL)), 0) AS total
      FROM product_batches WHERE product_id = ? AND warehouse_id = ? AND CAST(quantity AS REAL) > 0
    ''', [productId, warehouseId]);
    return Decimal.parse(rows.first['total'].toString());
  }

  Future<bool> hasStock(String warehouseId) async {
    final rows = _db.query('''
      SELECT 1 FROM product_batches WHERE warehouse_id = ? AND CAST(quantity AS REAL) > 0 LIMIT 1
    ''', [warehouseId]);
    return rows.isNotEmpty;
  }
}

class StockTake {
  final String id; final String warehouseId;
  final DateTime date; final String status; final String? note;
  StockTake.fromMap(Map<String, dynamic> m) :
    id = m['id'], warehouseId = m['warehouse_id'],
    date = DateTime.parse(m['date']), status = m['status'] ?? 'DRAFT',
    note = m['note'];
}
