import 'package:drift/drift.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';

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
      await transactionEngine.postPurchase(purchaseId);
    } catch (e, stackTrace) {
      throw BusinessException(
          message: 'خطأ في ترحيل فاتورة الشراء $purchaseId: $e\n$stackTrace');
    }
  }

  // ─── Purchase Order Flow: QUOTATION → APPROVED → RECEIVED → POSTED ───

  Future<PurchaseOrder> approveOrder(String orderId) async {
    await (db.update(db.purchaseOrders)..where((o) => o.id.equals(orderId)))
        .write(const PurchaseOrdersCompanion(status: Value('APPROVED')));
    return await (db.select(db.purchaseOrders)
          ..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  Future<PurchaseOrder> receiveOrder(String orderId, String? warehouseId) async {
    final order = await (db.select(db.purchaseOrders)
          ..where((o) => o.id.equals(orderId)))
        .getSingle();
    final items = await (db.select(db.purchaseOrderItems)
          ..where((i) => i.orderId.equals(orderId)))
        .get();

    if (items.isEmpty) throw const BusinessException(message: 'طلب الشراء لا يحتوي على أصناف');

    final purchaseId = const Uuid().v4();
    final purchaseItems = <PurchaseItemsCompanion>[];
    for (final item in items) {
      purchaseItems.add(PurchaseItemsCompanion.insert(
        purchaseId: purchaseId,
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: item.price,
        price: item.price,
      ));
    }

    await db.into(db.purchases).insert(PurchasesCompanion.insert(
          id: Value(purchaseId),
          supplierId: Value(order.supplierId),
          total: order.total,
          date: Value(DateTime.now()),
          status: const Value(DocumentStatus.draft),
          warehouseId: Value(warehouseId ?? order.warehouseId),
          referenceDocument: Value(order.orderNumber ?? orderId),
        ));

    for (final item in purchaseItems) {
      await db.into(db.purchaseItems).insert(item);
    }

    await (db.update(db.purchaseOrders)..where((o) => o.id.equals(orderId)))
        .write(const PurchaseOrdersCompanion(status: Value('RECEIVED')));

    return await (db.select(db.purchaseOrders)
          ..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  Future<PurchaseOrder> postOrder(String orderId) async {
    final order = await receiveOrder(orderId, null);
    final purchase = await (db.select(db.purchases)
          ..where((p) => p.referenceDocument.equals(order.orderNumber ?? orderId)))
        .getSingle();
    await postPurchase(purchase.id);
    await (db.update(db.purchaseOrders)..where((o) => o.id.equals(orderId)))
        .write(const PurchaseOrdersCompanion(status: Value('POSTED')));
    return await (db.select(db.purchaseOrders)
          ..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  Future<List<PurchaseOrder>> getAllOrders({String? status}) async {
    final query = db.select(db.purchaseOrders)
      ..orderBy([(o) => OrderingTerm.desc(o.date)]);
    if (status != null) query.where((o) => o.status.equals(status));
    return await query.get();
  }
}
