import 'package:drift/drift.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

class SalesDao extends DatabaseAccessor<AppDatabase> {
  SalesDao(super.db);

  Stream<List<Sale>> watchAllSales() => select(db.sales).watch();

  Stream<List<SaleItem>> watchSaleItems(String saleId) {
    return (select(db.saleItems)..where((si) => si.saleId.equals(saleId))).watch();
  }

  Stream<Decimal> watchTotalRevenueToday() {
    final query = select(db.sales)
      ..where(
        (s) => s.createdAt.isBiggerOrEqualValue(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
    return query.watch().map(
          (rows) => rows.fold<Decimal>(
            Decimal.zero,
            (sum, sale) => sum + sale.total,
          ),
        );
  }

  Stream<double> watchTotalSalesToday() {
    final query = select(db.sales)
      ..where(
        (s) => s.createdAt.isBiggerOrEqualValue(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
    return query.watch().map((rows) => rows.length.toDouble());
  }

  /// حساب أرباح اليوم
  Stream<Decimal> watchTotalProfitToday() {
    final startOfDay = DateTime.now().subtract(const Duration(days: 1));
    final query = select(db.saleItems).join([
      innerJoin(db.sales, db.sales.id.equalsExp(db.saleItems.saleId)),
      innerJoin(db.products, db.products.id.equalsExp(db.saleItems.productId)),
    ])
      ..where(db.sales.createdAt.isBiggerOrEqual(Variable(startOfDay)));

    return query.watch().map((rows) {
      Decimal profit = Decimal.zero;
      for (var row in rows) {
        final item = row.readTable(db.saleItems);
        final product = row.readTable(db.products);
        profit += (item.price - product.buyPrice) * item.quantity;
      }
      return profit;
    });
  }

  Future<List<Sale>> getSalesForCustomer(String customerId) {
    return (select(db.sales)..where((s) => s.customerId.equals(customerId))).get();
  }

  Future<List<Sale>> getInvoicesByDateRange(
      DateTime startDate, DateTime endDate) {
    return (select(db.sales)
          ..where((s) =>
              s.createdAt.isBiggerOrEqualValue(startDate) &
              s.createdAt.isSmallerOrEqualValue(endDate))
          ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
        .get();
  }

  Future<List<SaleItem>> getInvoiceItems(String saleId) {
    return (select(db.saleItems)..where((si) => si.saleId.equals(saleId))).get();
  }

  Future<Sale?> getSaleById(String id) {
    return (select(db.sales)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  Future<void> createSale({
    required SalesCompanion saleCompanion,
    required List<SaleItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    if (itemsCompanions.isEmpty) {
      throw Exception('لا يمكن إنشاء فاتورة بدون أصناف.');
    }

    return transaction(() async {
      // 1. Insert Sale
      final saleId = saleCompanion.id.value;
      await into(db.sales).insert(saleCompanion);

      // 2. Insert Items
      for (var item in itemsCompanions) {
        await into(db.saleItems).insert(item);
      }

      // 3. Sync Queue
      await logSyncOperation(
        table: 'sales',
        entityId: saleId,
        operation: 'CREATE',
      );

      // 4. Audit Log
      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'CREATE',
          targetEntity: 'SALES',
          entityId: saleId,
          details: Value('Created sale record: $saleId'),
        ),
      );
    });
  }

  Future<void> createSaleReturn({
    required SalesReturnsCompanion returnCompanion,
    required List<SalesReturnItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    return transaction(() async {
      final returnId = returnCompanion.id.value;
      await into(db.salesReturns).insert(returnCompanion);

      for (var item in itemsCompanions) {
        await into(db.salesReturnItems).insert(item);
      }

      await logSyncOperation(
        table: 'sales_returns',
        entityId: returnId,
        operation: 'CREATE',
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'CREATE',
          targetEntity: 'SALES_RETURNS',
          entityId: returnId,
          details: Value(
            'Created sales return record: $returnId for sale: ${returnCompanion.saleId.value}',
          ),
        ),
      );
    });
  }

  Future<List<Product>> getMostSoldProducts({int limit = 10}) async {
    final quantitySum =
        CustomExpression<double>('SUM(${db.saleItems.quantity.name})');
    final query = selectOnly(db.saleItems)
      ..addColumns([db.saleItems.productId, quantitySum])
      ..groupBy([db.saleItems.productId])
      ..orderBy([OrderingTerm.desc(quantitySum)])
      ..limit(limit);

    final rows = await query.get();
    final productIds =
        rows.map((row) => row.read(db.saleItems.productId)!).toList();

    if (productIds.isEmpty) return [];

    return (select(db.products)..where((p) => p.id.isIn(productIds))).get();
  }

  Future<List<TopProduct>> getTopSellingProducts({int limit = 5}) async {
    final quantitySum =
        CustomExpression<double>('SUM(${db.saleItems.quantity.name})');
    final query = select(db.saleItems).join([
      innerJoin(db.products, db.products.id.equalsExp(db.saleItems.productId)),
    ])
      ..addColumns([quantitySum])
      ..groupBy([db.saleItems.productId])
      ..orderBy([OrderingTerm.desc(quantitySum)])
      ..limit(limit);

    final rows = await query.get();
    return rows.map((row) {
      return TopProduct(
        product: row.readTable(db.products),
        totalQuantity: (row.read(quantitySum) ?? 0).toDouble(),
      );
    }).toList();
  }

  Future<List<ProductProfitability>> getProductProfitability({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final reportStartDate = startDate ?? DateTime(2000);
    final reportEndDate = endDate ?? DateTime.now();

    final revenueSum = CustomExpression<double>(
        'SUM(${db.saleItems.quantity.name} * ${db.saleItems.price.name})');
    final costSum = CustomExpression<double>(
        'SUM(${db.saleItems.quantity.name} * ${db.products.buyPrice.name})');
    final quantitySum =
        CustomExpression<double>('SUM(${db.saleItems.quantity.name})');

    final query = select(db.saleItems).join([
      innerJoin(db.sales, db.sales.id.equalsExp(db.saleItems.saleId)),
      innerJoin(db.products, db.products.id.equalsExp(db.saleItems.productId)),
    ])
      ..addColumns([revenueSum, costSum, quantitySum])
      ..where(db.sales.createdAt
          .isBetween(Variable(reportStartDate), Variable(reportEndDate)))
      ..groupBy([db.saleItems.productId]);

    final rows = await query.get();

    return rows.map((row) {
      final product = row.readTable(db.products);
      final revenue = (row.read(revenueSum) ?? 0).toDouble();
      final cost = (row.read(costSum) ?? 0).toDouble();

      return ProductProfitability(
        productId: product.id,
        productName: product.name,
        totalQuantity: (row.read(quantitySum) ?? 0).toDouble(),
        totalRevenue: revenue,
        totalCost: cost,
      );
    }).toList()
      ..sort((a, b) => b.netProfit.compareTo(a.netProfit));
  }

  // ==================== Sales Orders Management ====================
  // إدارة طلبات المبيعات (Sales Orders)

  Future<List<SalesOrder>> getAllSalesOrders() async {
    return (select(db.salesOrders)).get();
  }

  Future<SalesOrder?> getSalesOrderById(String orderId) async {
    return (select(db.salesOrders)..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
  }

  Future<List<SalesOrderItem>> getSalesOrderItems(String orderId) async {
    return (select(db.salesOrderItems)..where((i) => i.orderId.equals(orderId)))
        .get();
  }

  Future<void> createSalesOrder({
    required SalesOrdersCompanion orderCompanion,
    required List<SalesOrderItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    if (itemsCompanions.isEmpty) {
      throw Exception('لا يمكن إنشاء طلب بيع بدون أصناف.');
    }

    return transaction(() async {
      final orderId = orderCompanion.id.value;
      await into(db.salesOrders).insert(orderCompanion);

      for (var item in itemsCompanions) {
        await into(db.salesOrderItems).insert(item);
      }

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'CREATE',
          targetEntity: 'SALES_ORDER',
          entityId: orderId,
          details: Value('Created sales order: $orderId'),
        ),
      );
    });
  }

  Future<void> updateSalesOrderStatus(String orderId, String newStatus) async {
    return transaction(() async {
      await (update(db.salesOrders)..where((o) => o.id.equals(orderId))).write(
        SalesOrdersCompanion(status: Value(newStatus)),
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          action: 'UPDATE',
          targetEntity: 'SALES_ORDER',
          entityId: orderId,
          details: Value('Updated status to: $newStatus'),
        ),
      );
    });
  }

  Future<void> deleteSalesOrder(String orderId) async {
    return transaction(() async {
      await (delete(db.salesOrderItems)..where((i) => i.orderId.equals(orderId)))
          .go();
      await (delete(db.salesOrders)..where((o) => o.id.equals(orderId))).go();

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          action: 'DELETE',
          targetEntity: 'SALES_ORDER',
          entityId: orderId,
          details: const Value('Deleted sales order'),
        ),
      );
    });
  }

  Future<void> deleteSale(String saleId) async {
    return transaction(() async {
      final existing = await (select(db.sales)..where((s) => s.id.equals(saleId)))
          .getSingleOrNull();
      if (existing == null) {
        throw Exception('فاتورة المبيعات غير موجودة.');
      }
      if (existing.status != DocumentStatus.draft) {
        throw Exception(
          'لا يمكن حذف فاتورة مبيعات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من الحذف المباشر.',
        );
      }

      await (delete(db.saleItems)..where((i) => i.saleId.equals(saleId))).go();
      await (delete(db.sales)..where((s) => s.id.equals(saleId))).go();

      await logSyncOperation(
        table: 'sales',
        entityId: saleId,
        operation: 'DELETE',
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          action: 'DELETE',
          targetEntity: 'SALES_INVOICE',
          entityId: saleId,
          details: Value('Deleted sales invoice: $saleId'),
        ),
      );
    });
  }

  Future<void> updateSale({
    required String saleId,
    required SalesCompanion saleCompanion,
    required List<SaleItemsCompanion> itemsCompanions,
    required String? userId,
  }) async {
    if (itemsCompanions.isEmpty) {
      throw Exception('لا يمكن تحديث فاتورة مبيعات بدون أصناف.');
    }

    return transaction(() async {
      final existing = await (select(db.sales)..where((s) => s.id.equals(saleId)))
          .getSingleOrNull();
      if (existing == null) {
        throw Exception('فاتورة المبيعات غير موجودة.');
      }
      if (existing.status != DocumentStatus.draft) {
        throw Exception(
          'لا يمكن تعديل فاتورة مبيعات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من التعديل المباشر.',
        );
      }

      await (update(db.sales)..where((s) => s.id.equals(saleId)))
          .write(saleCompanion);

      await (delete(db.saleItems)..where((i) => i.saleId.equals(saleId))).go();
      for (var item in itemsCompanions) {
        await into(db.saleItems).insert(item);
      }

      await logSyncOperation(
        table: 'sales',
        entityId: saleId,
        operation: 'UPDATE',
      );

      await into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: Value(userId),
          action: 'UPDATE',
          targetEntity: 'SALES_INVOICE',
          entityId: saleId,
          details: Value('Updated sales invoice: $saleId'),
        ),
      );
    });
  }

  Future<List<SalesOrder>> getSalesOrdersByCustomer(String customerId) async {
    return (select(db.salesOrders)..where((o) => o.customerId.equals(customerId)))
        .get();
  }

  Future<List<SalesOrder>> getSalesOrdersByStatus(String status) async {
    return (select(db.salesOrders)..where((o) => o.status.equals(status))).get();
  }

  // ==================== Customer Payment Links ====================

  Future<List<CustomerPaymentLink>> getPaymentLinksForSale(String saleId) {
    return (db.select(db.customerPaymentLinks)
          ..where((l) => l.saleId.equals(saleId)))
        .get();
  }

  Future<void> linkPaymentToSale({
    required String paymentId,
    required String saleId,
    required Decimal amount,
  }) async {
    final linkId = const Uuid().v4();
    await db.into(db.customerPaymentLinks).insert(CustomerPaymentLinksCompanion(
      id: Value(linkId),
      paymentId: Value(paymentId),
      saleId: Value(saleId),
      amount: Value(amount),
    ));
  }

  Future<void> unlinkPaymentFromSale(String paymentId, String saleId) async {
    await (db.delete(db.customerPaymentLinks)
          ..where((l) => l.paymentId.equals(paymentId))
          ..where((l) => l.saleId.equals(saleId)))
        .go();
  }

  Future<Decimal> getTotalPaymentsForSale(String saleId) async {
    final links = await getPaymentLinksForSale(saleId);
    return links.fold<Decimal>(
      Decimal.zero,
      (sum, link) => sum + link.amount,
    );
  }
}

class ProductProfitability {
  final String productId;
  final String productName;
  final double totalQuantity;
  final double totalRevenue;
  final double totalCost;

  double get netProfit => totalRevenue - totalCost;
  double get profitMargin =>
      totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;

  ProductProfitability({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.totalCost,
  });
}

class TopProduct {
  final Product product;
  final double totalQuantity;

  TopProduct({required this.product, required this.totalQuantity});
}
