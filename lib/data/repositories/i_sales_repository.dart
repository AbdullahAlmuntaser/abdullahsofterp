import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/sales_dao.dart';

abstract class ISalesRepository {
  Stream<List<Sale>> watchAllSales();
  Stream<List<SaleItem>> watchSaleItems(String saleId);
  Stream<Decimal> watchTotalRevenueToday();
  Stream<double> watchTotalSalesToday();
  Stream<Decimal> watchTotalProfitToday();
  Future<List<Sale>> getSalesForCustomer(String customerId);
  Future<List<Sale>> getInvoicesByDateRange(DateTime startDate, DateTime endDate);
  Future<List<SaleItem>> getInvoiceItems(String saleId);
  Future<Sale?> getSaleById(String id);
  Future<void> createSale({required SalesCompanion saleCompanion, required List<SaleItemsCompanion> itemsCompanions, required String? userId});
  Future<void> createSaleReturn({required SalesReturnsCompanion returnCompanion, required List<SalesReturnItemsCompanion> itemsCompanions, required String? userId});
  Future<List<Product>> getMostSoldProducts({int limit = 10});
  Future<List<TopProduct>> getTopSellingProducts({int limit = 5});
  Future<List<ProductProfitability>> getProductProfitability({DateTime? startDate, DateTime? endDate});
  Future<List<SalesOrder>> getAllSalesOrders();
  Future<SalesOrder?> getSalesOrderById(String orderId);
  Future<List<SalesOrderItem>> getSalesOrderItems(String orderId);
  Future<void> createSalesOrder({required SalesOrdersCompanion orderCompanion, required List<SalesOrderItemsCompanion> itemsCompanions, required String? userId});
  Future<void> updateSalesOrderStatus(String orderId, String newStatus);
  Future<void> deleteSalesOrder(String orderId);
  Future<void> deleteSale(String saleId);
  Future<void> updateSale({required String saleId, required SalesCompanion saleCompanion, required List<SaleItemsCompanion> itemsCompanions, required String? userId});
  Future<List<SalesOrder>> getSalesOrdersByCustomer(String customerId);
  Future<List<SalesOrder>> getSalesOrdersByStatus(String status);
  Future<List<CustomerPaymentLink>> getPaymentLinksForSale(String saleId);
  Future<void> linkPaymentToSale({required String paymentId, required String saleId, required Decimal amount});
  Future<void> unlinkPaymentFromSale(String paymentId, String saleId);
  Future<Decimal> getTotalPaymentsForSale(String saleId);
}
