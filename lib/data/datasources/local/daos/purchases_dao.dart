import 'package:drift/drift.dart';
import '../app_database.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

class PurchasesDao extends DatabaseAccessor<AppDatabase> with SyncLogMixin {
  PurchasesDao(super.db);

  Stream<List<Purchase>> watchAllPurchases() => select(db.purchases).watch();

  Stream<List<PurchaseItem>> watchPurchaseItems(String purchaseId) {
    return (select(db.purchaseItems)..where((pi) => pi.purchaseId.equals(purchaseId)))
        .watch();
  }

  Future<Purchase?> getPurchaseById(String id) {
    return (select(db.purchases)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Stream<List<PurchaseReturn>> watchAllPurchaseReturns() {
    return (select(db.purchaseReturns)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<PurchaseReturnItem>> watchPurchaseReturnItems(String returnId) {
    return (select(db.purchaseReturnItems)..where((pi) => pi.purchaseReturnId.equals(returnId)))
        .watch();
  }

  Future<void> createPurchase({
    required PurchasesCompanion purchaseCompanion,
    required List<PurchaseItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    if (itemsCompanions.isEmpty) {
      throw Exception('لا يمكن إنشاء فاتورة مشتريات بدون أصناف.');
    }

    return transaction(() async {
      // 1. Insert Purchase
      final purchaseId = purchaseCompanion.id.value;
      await into(db.purchases).insert(purchaseCompanion);

      // 2. Insert Items
      for (var item in itemsCompanions) {
        await into(db.purchaseItems).insert(item);
      }

      // 3. Sync Queue
      await logSyncOperation(
        table: 'purchases',
        entityId: purchaseId,
        operation: 'CREATE',
      );

      // 4. Audit Log
      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'CREATE',
          targetEntity: 'PURCHASES',
          entityId: purchaseId,
          details: Value('Created purchase record: $purchaseId'),
        ),
      );
    });
  }

  Future<void> createPurchaseReturn({
    required PurchaseReturnsCompanion returnCompanion,
    required List<PurchaseReturnItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    return transaction(() async {
      // 1. Insert Purchase Return
      final returnId = returnCompanion.id.value;
      await into(db.purchaseReturns).insert(returnCompanion);

      // 2. Insert Items
      for (var item in itemsCompanions) {
        await into(db.purchaseReturnItems).insert(item);
      }

      // 3. Sync Queue
      await logSyncOperation(
        table: 'purchase_returns',
        entityId: returnId,
        operation: 'CREATE',
      );

      // 4. Audit Log
      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'CREATE',
          targetEntity: 'PURCHASE_RETURNS',
          entityId: returnId,
          details: Value(
            'Created purchase return record: $returnId for purchase: ${returnCompanion.purchaseId.value}',
          ),
        ),
      );
    });
  }

  Future<PurchaseItem?> getLastPurchaseItem(
    String productId, {
    String? supplierId,
  }) async {
    final query = select(db.purchaseItems).join([
      innerJoin(db.purchases, db.purchases.id.equalsExp(db.purchaseItems.purchaseId)),
    ])
      ..where(db.purchaseItems.productId.equals(productId));

    if (supplierId != null) {
      query.where(db.purchases.supplierId.equals(supplierId));
    }

    query.orderBy([OrderingTerm.desc(db.purchases.date)]);

    final results = await query.get();
    if (results.isEmpty) return null;
    final row = results.first;
    return row.readTable(db.purchaseItems);
  }

  Future<Purchase?> getLastPurchase(
    String productId, {
    String? supplierId,
  }) async {
    final query = select(db.purchases).join([
      innerJoin(
        db.purchaseItems,
        db.purchaseItems.purchaseId.equalsExp(db.purchases.id),
      ),
    ])
      ..where(db.purchaseItems.productId.equals(productId));

    if (supplierId != null) {
      query.where(db.purchases.supplierId.equals(supplierId));
    }

    query.orderBy([OrderingTerm.desc(db.purchases.date)]);

    final results = await query.get();
    if (results.isEmpty) return null;
    final row = results.first;
    return row.readTable(db.purchases);
  }

  Future<double?> getBestPurchasePrice(String productId) async {
    final minPriceExpr =
        CustomExpression<double>('MIN(${db.purchaseItems.unitPrice.name})');
    final query = selectOnly(db.purchaseItems)
      ..addColumns([minPriceExpr])
      ..where(db.purchaseItems.productId.equals(productId));

    final row = await query.getSingle();
    return row.read(minPriceExpr)?.toDouble();
  }

  // --- Purchase Orders ---
  Stream<List<PurchaseOrder>> watchAllPurchaseOrders() {
    return (select(db.purchaseOrders)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<List<PurchaseOrderItem>> getPurchaseOrderItems(String orderId) {
    return (select(db.purchaseOrderItems)..where((pi) => pi.orderId.equals(orderId)))
        .get();
  }

  Future<List<PurchaseOrder>> getInvoicesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return (select(db.purchaseOrders)
          ..where((p) =>
              p.date.isBiggerOrEqualValue(startDate) &
              p.date.isSmallerOrEqualValue(endDate))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Future<void> createPurchaseOrder({
    required PurchaseOrdersCompanion orderCompanion,
    required List<PurchaseOrderItemsCompanion> itemsCompanions,
  }) async {
    return transaction(() async {
      await into(db.purchaseOrders).insert(orderCompanion);
      for (var item in itemsCompanions) {
        await into(db.purchaseOrderItems).insert(item);
      }
    });
  }

  Future<void> updatePurchaseOrderStatus(String orderId, String status) async {
    await (update(db.purchaseOrders)..where((t) => t.id.equals(orderId))).write(
      PurchaseOrdersCompanion(status: Value(status)),
    );
  }

  Future<void> deletePurchase(String purchaseId) async {
    return transaction(() async {
      final existing = await (select(db.purchases)
            ..where((p) => p.id.equals(purchaseId)))
          .getSingleOrNull();
      if (existing == null) {
        throw Exception('فاتورة المشتريات غير موجودة.');
      }
      if (existing.status != DocumentStatus.draft) {
        throw Exception(
          'لا يمكن حذف فاتورة مشتريات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من الحذف المباشر.',
        );
      }

      await (delete(db.purchaseItems)
            ..where((i) => i.purchaseId.equals(purchaseId)))
          .go();
      await (delete(db.purchases)..where((p) => p.id.equals(purchaseId))).go();

      await logSyncOperation(
        table: 'purchases',
        entityId: purchaseId,
        operation: 'DELETE',
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          action: 'DELETE',
          targetEntity: 'PURCHASES',
          entityId: purchaseId,
          details: Value('Deleted purchase record: $purchaseId'),
        ),
      );
    });
  }

  Future<void> updatePurchase({
    required String purchaseId,
    required PurchasesCompanion purchaseCompanion,
    required List<PurchaseItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    if (itemsCompanions.isEmpty) {
      throw Exception('لا يمكن تحديث فاتورة مشتريات بدون أصناف.');
    }

    return transaction(() async {
      final existing = await (select(db.purchases)
            ..where((p) => p.id.equals(purchaseId)))
          .getSingleOrNull();
      if (existing == null) {
        throw Exception('فاتورة المشتريات غير موجودة.');
      }
      if (existing.status != DocumentStatus.draft) {
        throw Exception(
          'لا يمكن تعديل فاتورة مشتريات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من التعديل المباشر.',
        );
      }

      await (update(db.purchases)..where((p) => p.id.equals(purchaseId)))
          .write(purchaseCompanion);

      await (delete(db.purchaseItems)
            ..where((i) => i.purchaseId.equals(purchaseId)))
          .go();
      for (var item in itemsCompanions) {
        await into(db.purchaseItems).insert(item);
      }

      await logSyncOperation(
        table: 'purchases',
        entityId: purchaseId,
        operation: 'UPDATE',
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'UPDATE',
          targetEntity: 'PURCHASES',
          entityId: purchaseId,
          details: Value('Updated purchase record: $purchaseId'),
        ),
      );
    });
  }

  // ==================== Purchase Payment Links ====================

  Future<List<PurchasePaymentLink>> getPaymentLinksForPurchase(String purchaseId) {
    return (db.select(db.purchasePaymentLinks)
          ..where((l) => l.purchaseId.equals(purchaseId)))
        .get();
  }

  Future<void> linkPaymentToPurchase({
    required String paymentId,
    required String purchaseId,
    required Decimal amount,
  }) async {
    final linkId = const Uuid().v4();
    await db.into(db.purchasePaymentLinks).insert(PurchasePaymentLinksCompanion(
      id: Value(linkId),
      paymentId: Value(paymentId),
      purchaseId: Value(purchaseId),
      amount: Value(amount),
    ));
  }

  Future<void> unlinkPaymentFromPurchase(String paymentId, String purchaseId) async {
    await (db.delete(db.purchasePaymentLinks)
          ..where((l) => l.paymentId.equals(paymentId))
          ..where((l) => l.purchaseId.equals(purchaseId)))
        .go();
  }

  Future<Decimal> getTotalPaymentsForPurchase(String purchaseId) async {
    final links = await getPaymentLinksForPurchase(purchaseId);
    return links.fold<Decimal>(
      Decimal.zero,
      (sum, link) => sum + link.amount,
    );
  }
}
