import 'package:supermarket/data/datasources/local/app_database.dart';

abstract class IPurchasesRepository {
  Stream<List<Purchase>> watchAllPurchases();
  Stream<List<PurchaseItem>> watchPurchaseItems(String purchaseId);
  Future<Purchase?> getPurchaseById(String id);
  Stream<List<PurchaseReturn>> watchAllPurchaseReturns();
  Stream<List<PurchaseReturnItem>> watchPurchaseReturnItems(String returnId);
  Future<void> createPurchase({required PurchasesCompanion purchaseCompanion, required List<PurchaseItemsCompanion> itemsCompanions, required String? userId});
  Future<void> createPurchaseReturn({required PurchaseReturnsCompanion returnCompanion, required List<PurchaseReturnItemsCompanion> itemsCompanions, required String? userId});
  Future<PurchaseItem?> getLastPurchaseItem(String productId, {String? supplierId});
  Future<Purchase?> getLastPurchase(String productId, {String? supplierId});
  Future<double?> getBestPurchasePrice(String productId);
  Stream<List<PurchaseOrder>> watchAllPurchaseOrders();
  Future<List<PurchaseOrderItem>> getPurchaseOrderItems(String orderId);
  Future<List<PurchaseOrder>> getInvoicesByDateRange({required DateTime startDate, required DateTime endDate});
  Future<void> createPurchaseOrder({required PurchaseOrdersCompanion orderCompanion, required List<PurchaseOrderItemsCompanion> itemsCompanions});
  Future<void> updatePurchaseOrderStatus(String orderId, String status);
  Future<void> deletePurchase(String purchaseId);
  Future<void> updatePurchase({required String purchaseId, required PurchasesCompanion purchaseCompanion, required List<PurchaseItemsCompanion> itemsCompanions, required String? userId});
  Future<List<PurchasePaymentLink>> getPaymentLinksForPurchase(String purchaseId);
  Future<void> linkPaymentToPurchase({required String paymentId, required String purchaseId, required Decimal amount});
  Future<void> unlinkPaymentFromPurchase(String paymentId, String purchaseId);
  Future<Decimal> getTotalPaymentsForPurchase(String purchaseId);
}
