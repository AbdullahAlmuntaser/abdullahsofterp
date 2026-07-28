import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV1ToV32(AppDatabase db, Migrator m) async {
  await m.createIndex(Index('products_sku_idx',
      'CREATE INDEX products_sku_idx ON products (sku)'));
  await m.createIndex(Index('products_barcode_idx',
      'CREATE INDEX products_barcode_idx ON products (barcode)'));
  await m.createIndex(Index('sale_items_sale_id_idx',
      'CREATE INDEX sale_items_sale_id_idx ON sale_items (sale_id)'));
  await m.createIndex(Index('purchase_items_purchase_id_idx',
      'CREATE INDEX purchase_items_purchase_id_idx ON purchase_items (purchase_id)'));
  await m.createIndex(Index('gl_lines_entry_id_idx',
      'CREATE INDEX gl_lines_entry_id_idx ON gl_lines (entry_id)'));
  await m.createIndex(Index('gl_lines_account_id_idx',
      'CREATE INDEX gl_lines_account_id_idx ON gl_lines (account_id)'));
  await m.createIndex(Index('stock_movements_product_id_idx',
      'CREATE INDEX stock_movements_product_id_idx ON stock_movements (product_id)'));
}
