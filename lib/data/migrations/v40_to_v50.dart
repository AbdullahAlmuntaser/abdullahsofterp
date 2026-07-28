import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV39ToV40(AppDatabase db, Migrator m) async {
  try {
    await m.createTable(db.currencies);
    await m.createTable(db.exchangeRates);
    await db.ensureDefaultCurrencies();
  } catch (e) {
    debugPrint('Migration to V40 failed: $e');
  }
}

Future<void> migrateV40ToV41(AppDatabase db, Migrator m) async {
  try {
    await m.createTable(db.appConfigTable);
  } catch (e) {
    debugPrint('Migration to V41 failed: $e');
  }
}

Future<void> migrateV41ToV42(AppDatabase db, Migrator m) async {
  final tablesToRecreate = <(TableInfo, String)>[
    (db.stockTakeItems, 'stock_take_items'),
    (db.goodReceivedNoteItems, 'good_received_note_items'),
    (db.deliveryNoteItems, 'delivery_note_items'),
    (db.checks, 'checks'),
    (db.purchaseOrders, 'purchase_orders'),
    (db.purchaseOrderItems, 'purchase_order_items'),
    (db.salesOrders, 'sales_orders'),
    (db.salesOrderItems, 'sales_order_items'),
    (db.customerPaymentLinks, 'customer_payment_links'),
  ];

  for (final entry in tablesToRecreate) {
    final table = entry.$1;
    final name = entry.$2;
    try {
      await m.deleteTable(name);
      await m.createTable(table);
    } catch (e) {
      debugPrint('Migration to V42: Failed to recreate $name: $e');
      try { await m.createTable(table); } catch (_) {}
    }
  }

  try {
    final accCurrenciesExists = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='acc_currencies'",
    ).getSingleOrNull();

    if (accCurrenciesExists != null) {
      await db.customStatement(
          "INSERT OR IGNORE INTO currencies (id, code, name, exchange_rate, is_base) "
          "SELECT CAST(id AS TEXT), code, name, exchange_rate, is_base FROM acc_currencies");
      await m.deleteTable('acc_currencies');
      await m.deleteTable('acc_exchange_rates');
    }
  } catch (e) {
    debugPrint('Migration to V42 (Currency Copy) failed: $e');
  }
}

Future<void> migrateV42ToV43(AppDatabase db, Migrator m) async {
  try { await m.addColumn(db.products, db.products.imagePath); } catch (e) { debugPrint('DB Migration v43: imagePath: $e'); }
}

Future<void> migrateV43ToV44(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.recurringEntries); } catch (e) { debugPrint('DB Migration v44: recurringEntries: $e'); }
  try { await m.createTable(db.recurringEntryExecutions); } catch (e) { debugPrint('DB Migration v44: recurringEntryExecutions: $e'); }
}

Future<void> migrateV44ToV45(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.leaveTypes); } catch (e) { debugPrint('DB Migration v45: leaveTypes: $e'); }
  try { await m.createTable(db.leaveRequests); } catch (e) { debugPrint('DB Migration v45: leaveRequests: $e'); }
  try { await m.createTable(db.leaveBalances); } catch (e) { debugPrint('DB Migration v45: leaveBalances: $e'); }
  try { await m.createTable(db.attendanceRecords); } catch (e) { debugPrint('DB Migration v45: attendanceRecords: $e'); }
  try { await m.createTable(db.withholdingTaxEntries); } catch (e) { debugPrint('DB Migration v45: withholdingTaxEntries: $e'); }
  try { await m.createTable(db.serialNumbers); } catch (e) { debugPrint('DB Migration v45: serialNumbers: $e'); }
  try { await m.createTable(db.creditNotes); } catch (e) { debugPrint('DB Migration v45: creditNotes: $e'); }
  try { await m.createTable(db.creditNoteItems); } catch (e) { debugPrint('DB Migration v45: creditNoteItems: $e'); }
  try { await m.createTable(db.salesTargets); } catch (e) { debugPrint('DB Migration v45: salesTargets: $e'); }
  try { await m.createTable(db.salesCommissions); } catch (e) { debugPrint('DB Migration v45: salesCommissions: $e'); }
  try { await m.createTable(db.zakatCalculations); } catch (e) { debugPrint('DB Migration v45: zakatCalculations: $e'); }
  try { await m.createTable(db.endOfServiceBenefits); } catch (e) { debugPrint('DB Migration v45: endOfServiceBenefits: $e'); }
  try { await m.createTable(db.inventoryReservations); } catch (e) { debugPrint('DB Migration v45: inventoryReservations: $e'); }
}

Future<void> migrateV45ToV46(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.proformaInvoices); } catch (e) { debugPrint('DB Migration v46: proformaInvoices: $e'); }
  try { await m.createTable(db.proformaInvoiceItems); } catch (e) { debugPrint('DB Migration v46: proformaInvoiceItems: $e'); }
}

Future<void> migrateV46ToV47(AppDatabase db, Migrator m) async {
  await db.recoverMissingTables(m);
}

Future<void> migrateV47ToV48(AppDatabase db, Migrator m) async {
  try {
    await db.customStatement('ALTER TABLE posting_profiles ADD COLUMN branch_id TEXT REFERENCES branches(id)');
  } catch (e) { debugPrint('DB Migration v48: branch_id: $e'); }
}

const List<String> migrateV48ToV49Statements = [
  'UPDATE ap_invoices SET total_amount = CAST(ROUND(total_amount * 100) AS INTEGER)',
  'UPDATE ar_invoices SET total_amount = CAST(ROUND(total_amount * 100) AS INTEGER)',
  'UPDATE hr_employees SET basic_salary = CAST(ROUND(basic_salary * 100) AS INTEGER), housing_allowance = CAST(ROUND(housing_allowance * 100) AS INTEGER), transport_allowance = CAST(ROUND(transport_allowance * 100) AS INTEGER), other_allowances = CAST(ROUND(other_allowances * 100) AS INTEGER), total_deductions = CAST(ROUND(total_deductions * 100) AS INTEGER)',
  'UPDATE hr_payroll_runs SET total_salaries = CAST(ROUND(total_salaries * 100) AS INTEGER), total_allowances = CAST(ROUND(total_allowances * 100) AS INTEGER), total_deductions = CAST(ROUND(total_deductions * 100) AS INTEGER), net_payable = CAST(ROUND(net_payable * 100) AS INTEGER)',
  'UPDATE hr_payroll_details SET basic_salary = CAST(ROUND(basic_salary * 100) AS INTEGER), housing_allowance = CAST(ROUND(housing_allowance * 100) AS INTEGER), transport_allowance = CAST(ROUND(transport_allowance * 100) AS INTEGER), other_allowances = CAST(ROUND(other_allowances * 100) AS INTEGER), gross_salary = CAST(ROUND(gross_salary * 100) AS INTEGER), deductions = CAST(ROUND(deductions * 100) AS INTEGER), net_salary = CAST(ROUND(net_salary * 100) AS INTEGER)',
  'UPDATE hr_additional_deductions SET amount = CAST(ROUND(amount * 100) AS INTEGER)',
];

Future<void> migrateV48ToV49(AppDatabase db, Migrator m) async {
  for (final stmt in migrateV48ToV49Statements) {
    try { await db.customStatement(stmt); } catch (e) { debugPrint('DB Migration v49: $e'); }
  }
}
