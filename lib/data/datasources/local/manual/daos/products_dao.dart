import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class ProductsDao {
  final ManualDatabase _db;
  ProductsDao(this._db);

  // ==================== CATEGORIES ====================
  Future<List<Category>> getAllCategories() async {
    final rows = _db.query('SELECT * FROM categories ORDER BY name');
    return rows.map((r) => Category.fromMap(r)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final rows = _db.query('SELECT * FROM categories WHERE id = ?', [id]);
    return rows.isEmpty ? null : Category.fromMap(rows.first);
  }

  Future<String> insertCategory(String name, {String? code}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO categories (id, name, code) VALUES (?, ?, ?)', [id, name, code]);
    return id;
  }

  Future<void> updateCategory(String id, String name, {String? code}) async {
    _db.execute('UPDATE categories SET name=?, code=? WHERE id=?', [name, code, id]);
  }

  Future<void> deleteCategory(String id) async {
    _db.execute('DELETE FROM categories WHERE id = ?', [id]);
  }

  // ==================== PRODUCTS ====================
  Future<List<Product>> getAllProducts({String? searchQuery, String? categoryId}) async {
    String sql = 'SELECT * FROM products WHERE is_active = 1';
    final params = <Object?>[];
    if (searchQuery != null && searchQuery.isNotEmpty) {
      sql += ' AND (name LIKE ? OR sku LIKE ? OR barcode LIKE ?)';
      final q = '%$searchQuery%';
      params.addAll([q, q, q]);
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      sql += ' AND category_id = ?';
      params.add(categoryId);
    }
    sql += ' ORDER BY name';
    final rows = _db.query(sql, params);
    return rows.map((r) => Product.fromMap(r)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final rows = _db.query('SELECT * FROM products WHERE id = ?', [id]);
    return rows.isEmpty ? null : Product.fromMap(rows.first);
  }

  Future<Product?> getProductBySku(String sku) async {
    final rows = _db.query('SELECT * FROM products WHERE sku = ?', [sku]);
    return rows.isEmpty ? null : Product.fromMap(rows.first);
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final rows = _db.query('SELECT * FROM products WHERE barcode = ?', [barcode]);
    return rows.isEmpty ? null : Product.fromMap(rows.first);
  }

  Future<String> insertProduct({
    required String name, required String sku,
    String? barcode, String? categoryId,
    Decimal? buyPrice, Decimal? sellPrice, Decimal? stock,
    String? supplierId, String? imagePath,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO products (id, name, sku, barcode, category_id, buy_price, sell_price, stock, supplier_id, image_path)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, name, sku, barcode, categoryId,
          buyPrice?.toString(), sellPrice?.toString(), stock?.toString(),
          supplierId, imagePath]);
    return id;
  }

  Future<void> updateProduct(Map<String, dynamic> fields, String id) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE products SET $sets, updated_at = datetime(\'now\') WHERE id = ?', values);
  }

  Future<void> deleteProduct(String id) async {
    _db.execute('UPDATE products SET is_active = 0 WHERE id = ?', [id]);
  }

  // Relationship: Product with Category (JOIN)
  Future<List<ProductWithCategory>> getProductsWithCategory({
    String? searchQuery, String? categoryId,
  }) async {
    String sql = '''
      SELECT p.*, c.id AS cat_id, c.name AS cat_name, c.code AS cat_code
      FROM products p
      LEFT JOIN categories c ON c.id = p.category_id
      WHERE p.is_active = 1
    ''';
    final params = <Object?>[];
    if (searchQuery != null && searchQuery.isNotEmpty) {
      sql += ' AND (p.name LIKE ? OR p.sku LIKE ? OR p.barcode LIKE ?)';
      final q = '%$searchQuery%';
      params.addAll([q, q, q]);
    }
    if (categoryId != null) {
      sql += ' AND p.category_id = ?';
      params.add(categoryId);
    }
    sql += ' ORDER BY p.name';
    final rows = _db.query(sql, params);
    return rows.map((r) {
      final cat = r['cat_id'] != null ? Category(
        id: r['cat_id'] as String, name: r['cat_name'] as String,
        code: r['cat_code'] as String?,
      ) : null;
      return ProductWithCategory(Product.fromMap(r), cat);
    }).toList();
  }

  Future<int> countProducts({String? searchQuery, String? categoryId}) async {
    String sql = 'SELECT COUNT(*) AS cnt FROM products WHERE is_active = 1';
    final params = <Object?>[];
    if (searchQuery != null && searchQuery.isNotEmpty) {
      sql += ' AND (name LIKE ? OR sku LIKE ? OR barcode LIKE ?)';
      final q = '%$searchQuery%';
      params.addAll([q, q, q]);
    }
    if (categoryId != null) {
      sql += ' AND category_id = ?';
      params.add(categoryId);
    }
    final rows = _db.query(sql, params);
    return (rows.first['cnt'] as int?) ?? 0;
  }

  // ==================== PRODUCT UNITS ====================
  Future<List<ProductUnit>> getProductUnits(String productId) async {
    final rows = _db.query('SELECT * FROM product_units WHERE product_id = ?', [productId]);
    return rows.map((r) => ProductUnit.fromMap(r)).toList();
  }

  Future<String> insertProductUnit(String productId, String unitName, {
    String? barcode, Decimal? unitFactor, Decimal? buyPrice,
    Decimal? sellPrice, bool isDefault = false,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO product_units (id, product_id, unit_name, barcode, unit_factor, buy_price, sell_price, is_default)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, productId, unitName, barcode, unitFactor?.toString(),
          buyPrice?.toString(), sellPrice?.toString(), isDefault ? 1 : 0]);
    return id;
  }

  // ==================== VARIANTS ====================
  Future<List<ItemVariant>> getVariants(String productId) async {
    final rows = _db.query('SELECT * FROM item_variants WHERE product_id = ?', [productId]);
    return rows.map((r) => ItemVariant.fromMap(r)).toList();
  }

  Future<String> insertVariant(String productId, String attrName, String attrValue,
      {Decimal? additionalPrice, String? sku}) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO item_variants (id, product_id, attribute_name, attribute_value, additional_price, sku)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [id, productId, attrName, attrValue, additionalPrice?.toString(), sku]);
    return id;
  }

  // ==================== LOW STOCK ====================
  Future<List<Product>> getLowStockProducts() async {
    final rows = _db.query('''
      SELECT * FROM products WHERE is_active = 1
      AND CAST(stock AS REAL) <= CAST(alert_limit AS REAL)
      ORDER BY name
    ''');
    return rows.map((r) => Product.fromMap(r)).toList();
  }

  Future<int> countLowStock() async {
    final rows = _db.query('''
      SELECT COUNT(*) AS cnt FROM products
      WHERE is_active = 1 AND CAST(stock AS REAL) <= CAST(alert_limit AS REAL)
    ''');
    return (rows.first['cnt'] as int?) ?? 0;
  }

  // ==================== PRICE HISTORY ====================
  Future<void> logPriceChange(String productId, String oldPrice, String newPrice, String type) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO price_history (id, product_id, old_price, new_price, type)
      VALUES (?, ?, ?, ?, ?)
    ''', [id, productId, oldPrice, newPrice, type]);
  }
}
