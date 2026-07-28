import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV49ToV50(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.userSessions); } catch (e) { debugPrint('DB Migration v50: userSessions: $e'); }
  try { await m.createTable(db.loginAttempts); } catch (e) { debugPrint('DB Migration v50: loginAttempts: $e'); }
}

Future<void> migrateV50ToV51(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS inventory_transactions_product_warehouse_idx '
        'ON inventory_transactions (product_id, warehouse_id)');
  } catch (e) { debugPrint('DB Migration v51: inventory_transactions_product_warehouse_idx: $e'); }
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS inventory_transactions_reference_id_idx '
        'ON inventory_transactions (reference_id)');
  } catch (e) { debugPrint('DB Migration v51: inventory_transactions_reference_id_idx: $e'); }
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS account_transactions_reference_id_idx '
        'ON account_transactions (reference_id)');
  } catch (e) { debugPrint('DB Migration v51: account_transactions_reference_id_idx: $e'); }
  try {
    await db.customStatement(
        'CREATE INDEX IF NOT EXISTS account_transactions_reconciled_idx '
        'ON account_transactions (reconciled)');
  } catch (e) { debugPrint('DB Migration v51: account_transactions_reconciled_idx: $e'); }
}

Future<void> migrateV51ToV52(AppDatabase db, Migrator m) async {
  try { await db.customStatement('ALTER TABLE item_variants ADD COLUMN product_id TEXT REFERENCES products(id)'); } catch (e) { debugPrint('DB Migration v52: item_variants.product_id: $e'); }
  try { await db.customStatement('ALTER TABLE item_variants ADD COLUMN attribute_name TEXT NOT NULL DEFAULT \'\''); } catch (e) { debugPrint('DB Migration v52: item_variants.attribute_name: $e'); }
  try { await db.customStatement('ALTER TABLE item_variants ADD COLUMN attribute_value TEXT NOT NULL DEFAULT \'\''); } catch (e) { debugPrint('DB Migration v52: item_variants.attribute_value: $e'); }
  try { await db.customStatement('ALTER TABLE item_variants ADD COLUMN additional_price TEXT NOT NULL DEFAULT \'0\''); } catch (e) { debugPrint('DB Migration v52: item_variants.additional_price: $e'); }
  try { await db.customStatement('ALTER TABLE item_variants ADD COLUMN sku TEXT'); } catch (e) { debugPrint('DB Migration v52: item_variants.sku: $e'); }
  try { await db.customStatement('ALTER TABLE customer_payments ADD COLUMN payment_method TEXT NOT NULL DEFAULT \'cash\''); } catch (e) { debugPrint('DB Migration v52: customer_payments.payment_method: $e'); }
  try { await db.customStatement('ALTER TABLE customer_payments ADD COLUMN reference_number TEXT'); } catch (e) { debugPrint('DB Migration v52: customer_payments.reference_number: $e'); }
  try { await db.customStatement('ALTER TABLE customer_payments ADD COLUMN account_id TEXT REFERENCES gl_accounts(id)'); } catch (e) { debugPrint('DB Migration v52: customer_payments.account_id: $e'); }
  try { await db.customStatement('ALTER TABLE customer_payments ADD COLUMN status TEXT NOT NULL DEFAULT \'COMPLETED\''); } catch (e) { debugPrint('DB Migration v52: customer_payments.status: $e'); }
  try { await db.customStatement('ALTER TABLE supplier_payments ADD COLUMN payment_method TEXT NOT NULL DEFAULT \'cash\''); } catch (e) { debugPrint('DB Migration v52: supplier_payments.payment_method: $e'); }
  try { await db.customStatement('ALTER TABLE supplier_payments ADD COLUMN reference_number TEXT'); } catch (e) { debugPrint('DB Migration v52: supplier_payments.reference_number: $e'); }
  try { await db.customStatement('ALTER TABLE supplier_payments ADD COLUMN account_id TEXT REFERENCES gl_accounts(id)'); } catch (e) { debugPrint('DB Migration v52: supplier_payments.account_id: $e'); }
}

Future<void> migrateV52ToV53(AppDatabase db, Migrator m) async {
  const v53Tables = {
    'approval_workflows': '''
      CREATE TABLE IF NOT EXISTS approval_workflows (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        document_type TEXT NOT NULL,
        condition_type TEXT,
        condition_value REAL,
        operator TEXT,
        level_order INTEGER DEFAULT 1,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )''',
    'approval_levels': '''
      CREATE TABLE IF NOT EXISTS approval_levels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workflow_id INTEGER NOT NULL,
        level_order INTEGER NOT NULL,
        role TEXT,
        user_id INTEGER,
        min_amount REAL,
        max_amount REAL,
        requires_signature INTEGER DEFAULT 0
      )''',
    'approval_requests': '''
      CREATE TABLE IF NOT EXISTS approval_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_type TEXT NOT NULL,
        document_id INTEGER NOT NULL,
        workflow_id INTEGER NOT NULL,
        current_level INTEGER DEFAULT 1,
        status TEXT DEFAULT 'pending',
        requested_by INTEGER,
        requested_at TEXT DEFAULT CURRENT_TIMESTAMP,
        completed_at TEXT
      )''',
    'approval_history': '''
      CREATE TABLE IF NOT EXISTS approval_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        request_id INTEGER NOT NULL,
        level_order INTEGER NOT NULL,
        approver_id INTEGER,
        approver_role TEXT,
        action TEXT NOT NULL,
        comments TEXT,
        action_date TEXT DEFAULT CURRENT_TIMESTAMP
      )''',
    'quotations': '''
      CREATE TABLE IF NOT EXISTS quotations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quotation_number TEXT UNIQUE NOT NULL,
        customer_id INTEGER NOT NULL,
        branch_id INTEGER,
        warehouse_id INTEGER,
        date TEXT NOT NULL,
        expiry_date TEXT,
        status TEXT DEFAULT 'draft',
        subtotal TEXT DEFAULT '0',
        discount_total TEXT DEFAULT '0',
        tax_total TEXT DEFAULT '0',
        total_amount TEXT DEFAULT '0',
        notes TEXT,
        created_by INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )''',
    'quotation_items': '''
      CREATE TABLE IF NOT EXISTS quotation_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quotation_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity TEXT NOT NULL DEFAULT '0',
        unit_price TEXT NOT NULL DEFAULT '0',
        discount_percent TEXT DEFAULT '0',
        discount_amount TEXT DEFAULT '0',
        tax_percent TEXT DEFAULT '0',
        tax_amount TEXT DEFAULT '0',
        total_amount TEXT NOT NULL DEFAULT '0',
        notes TEXT
      )''',
  };
  for (final entry in v53Tables.entries) {
    try {
      await db.customStatement(entry.value);
      debugPrint('DB Migration v53: Created table ${entry.key}');
    } catch (e) {
      debugPrint('DB Migration v53: Failed to create ${entry.key}: $e');
    }
  }
  try { await db.customStatement('CREATE INDEX IF NOT EXISTS idx_approval_requests_status ON approval_requests(status)'); } catch (e) { debugPrint('DB Migration v53: idx_approval_requests_status: $e'); }
  try { await db.customStatement('CREATE INDEX IF NOT EXISTS idx_quotations_customer ON quotations(customer_id)'); } catch (e) { debugPrint('DB Migration v53: idx_quotations_customer: $e'); }
  try { await db.customStatement('CREATE INDEX IF NOT EXISTS idx_quotation_items_quotation ON quotation_items(quotation_id)'); } catch (e) { debugPrint('DB Migration v53: idx_quotation_items_quotation: $e'); }
}

Future<void> migrateV53ToV54(AppDatabase db, Migrator m) async {
  try { await db.customStatement('ALTER TABLE product_batches ADD COLUMN reserved_quantity TEXT NOT NULL DEFAULT \'0\''); } catch (e) { debugPrint('DB Migration v54: reserved_quantity: $e'); }
  try { await db.customStatement('ALTER TABLE product_batches ADD COLUMN stored_unit_id TEXT'); } catch (e) { debugPrint('DB Migration v54: stored_unit_id: $e'); }
  try { await db.customStatement('ALTER TABLE product_batches ADD COLUMN quantity_in_stored_unit TEXT'); } catch (e) { debugPrint('DB Migration v54: quantity_in_stored_unit: $e'); }
}

Future<void> migrateV54ToV55(AppDatabase db, Migrator m) async {
  try { await db.customStatement('ALTER TABLE audit_logs ADD COLUMN accounting_period_id TEXT REFERENCES accounting_periods(id)'); } catch (e) { debugPrint('DB Migration v55: accounting_period_id: $e'); }
  try { await db.customStatement('ALTER TABLE products ADD COLUMN display_unit_id TEXT REFERENCES product_units(id)'); } catch (e) { debugPrint('DB Migration v55: display_unit_id: $e'); }
}
