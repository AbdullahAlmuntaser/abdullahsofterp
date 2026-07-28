import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

Future<void> migrateV32ToV33(AppDatabase db, Migrator m) async {
  try { await m.addColumn(db.products, db.products.valuationMethod); } catch (e) { debugPrint('DB Migration v33: valuationMethod: $e'); }
  try { await m.addColumn(db.products, db.products.allowFreeQty); } catch (e) { debugPrint('DB Migration v33: allowFreeQty: $e'); }
  try { await m.addColumn(db.products, db.products.isService); } catch (e) { debugPrint('DB Migration v33: isService: $e'); }
}

Future<void> migrateV33ToV34(AppDatabase db, Migrator m) async {
  try { await m.addColumn(db.goodReceivedNotes, db.goodReceivedNotes.purchaseId); } catch (e) { debugPrint('DB Migration v34: purchaseId: $e'); }
  try { await m.addColumn(db.goodReceivedNotes, db.goodReceivedNotes.supplierId); } catch (e) { debugPrint('DB Migration v34: supplierId: $e'); }
}

Future<void> migrateV34ToV35(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.appConfigTable); } catch (e) { debugPrint('DB Migration v35: appConfigTable: $e'); }
}

Future<void> migrateV35ToV36(AppDatabase db, Migrator m) async {
  try { await m.addColumn(db.sales, db.sales.shippingCost); } catch (e) { debugPrint('DB Migration v36: shippingCost: $e'); }
  try { await m.addColumn(db.sales, db.sales.otherExpenses); } catch (e) { debugPrint('DB Migration v36: otherExpenses: $e'); }
  try { await m.addColumn(db.sales, db.sales.warehouseId); } catch (e) { debugPrint('DB Migration v36: warehouseId: $e'); }
  try { await m.addColumn(db.sales, db.sales.representativeId); } catch (e) { debugPrint('DB Migration v36: representativeId: $e'); }
}

Future<void> migrateV36ToV37(AppDatabase db, Migrator m) async {
  try { await m.createTable(db.financialTransfers); } catch (e) { debugPrint('DB Migration v37: financialTransfers: $e'); }
}

Future<void> migrateV37ToV38(AppDatabase db, Migrator m) async {
  try {
    await m.createTable(db.productionOrders);
    await m.createTable(db.productionOrderItems);
  } catch (e) { debugPrint('DB Migration v38: production tables: $e'); }
}

Future<void> migrateV38ToV39(AppDatabase db, Migrator m) async {
  // Version 39 was a placeholder or minor fix - no schema changes
}
