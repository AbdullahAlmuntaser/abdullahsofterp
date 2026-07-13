import 'package:drift/drift.dart';
import 'package:supermarket/core/services/inventory_costing_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

class PurchaseService {
  final AppDatabase db;
  final TransactionEngine transactionEngine;
  final InventoryCostingService inventoryCostingService;
  final AppConfigService configService;

  PurchaseService(this.db, this.transactionEngine,
      this.inventoryCostingService, this.configService);

  Future<Purchase> createPurchase({
    required String supplierId,
    required List<PurchaseItemsCompanion> items,
    required double total,
    String? warehouseId,
  }) async {
    final purchaseId = const Uuid().v4();
    final purchase = PurchasesCompanion.insert(
      id: Value(purchaseId),
      supplierId: Value(supplierId),
      date: Value(DateTime.now()),
      total: Decimal.parse(total.toString()),
      status: const Value(DocumentStatus.draft),
      warehouseId: Value(warehouseId),
    );

    await db.into(db.purchases).insert(purchase);

    for (var item in items) {
      await db
          .into(db.purchaseItems)
          .insert(item.copyWith(purchaseId: Value(purchaseId)));
    }

    return await (db.select(
      db.purchases,
    )..where((p) => p.id.equals(purchaseId)))
        .getSingle();
  }

  Future<void> postPurchase(String purchaseId) async {
    try {
      // Delegate to TransactionEngine - single source of truth for all posting
      await transactionEngine.postPurchase(purchaseId);
    } catch (e, stackTrace) {
      throw Exception(
          'خطأ في ترحيل فاتورة الشراء $purchaseId: $e\n$stackTrace');
    }
  }
}
