import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV55ToV56(AppDatabase db, Migrator m) async {
  // Sales by customer
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS sales_customer_id_idx '
        'ON sales (customer_id)');
  } catch (e) {
    debugPrint('DB Migration v56: sales_customer_id_idx: $e');
  }

  // Purchases by supplier
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS purchases_supplier_id_idx '
        'ON purchases (supplier_id)');
  } catch (e) {
    debugPrint('DB Migration v56: purchases_supplier_id_idx: $e');
  }

  // Products by category
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS products_category_id_idx '
        'ON products (category_id)');
  } catch (e) {
    debugPrint('DB Migration v56: products_category_id_idx: $e');
  }

  // Products by parent
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS products_parent_product_id_idx '
        'ON products (parent_product_id)');
  } catch (e) {
    debugPrint('DB Migration v56: products_parent_product_id_idx: $e');
  }

  // GL entries by date
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS gl_entries_date_idx '
        'ON gl_entries (date)');
  } catch (e) {
    debugPrint('DB Migration v56: gl_entries_date_idx: $e');
  }

  // GL entries by reference
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS gl_entries_reference_idx '
        'ON gl_entries (reference_type, reference_id)');
  } catch (e) {
    debugPrint('DB Migration v56: gl_entries_reference_idx: $e');
  }

  // Customer payments by customer
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS customer_payments_customer_id_idx '
        'ON customer_payments (customer_id)');
  } catch (e) {
    debugPrint('DB Migration v56: customer_payments_customer_id_idx: $e');
  }

  // Supplier payments by supplier
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS supplier_payments_supplier_id_idx '
        'ON supplier_payments (supplier_id)');
  } catch (e) {
    debugPrint('DB Migration v56: supplier_payments_supplier_id_idx: $e');
  }

  // Product batches by warehouse
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS product_batches_warehouse_id_idx '
        'ON product_batches (warehouse_id)');
  } catch (e) {
    debugPrint('DB Migration v56: product_batches_warehouse_id_idx: $e');
  }

  // Product batches by expiry
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS product_batches_expiry_date_idx '
        'ON product_batches (expiry_date)');
  } catch (e) {
    debugPrint('DB Migration v56: product_batches_expiry_date_idx: $e');
  }

  // Sale items by product
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS sale_items_product_id_idx '
        'ON sale_items (product_id)');
  } catch (e) {
    debugPrint('DB Migration v56: sale_items_product_id_idx: $e');
  }

  // Purchase items by product
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS purchase_items_product_id_idx '
        'ON purchase_items (product_id)');
  } catch (e) {
    debugPrint('DB Migration v56: purchase_items_product_id_idx: $e');
  }

  // Sales returns by sale
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS sales_returns_sale_id_idx '
        'ON sales_returns (sale_id)');
  } catch (e) {
    debugPrint('DB Migration v56: sales_returns_sale_id_idx: $e');
  }

  // Purchase returns by purchase
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS purchase_returns_purchase_id_idx '
        'ON purchase_returns (purchase_id)');
  } catch (e) {
    debugPrint('DB Migration v56: purchase_returns_purchase_id_idx: $e');
  }

  // Approval history by request
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS approval_history_request_id_idx '
        'ON approval_history (request_id)');
  } catch (e) {
    debugPrint('DB Migration v56: approval_history_request_id_idx: $e');
  }
}
