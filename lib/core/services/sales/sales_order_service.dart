import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';
import 'package:supermarket/core/services/transaction_engine.dart';

class SalesOrderService {
  final AppDatabase db;
  final TransactionEngine _transactionEngine;

  SalesOrderService(this.db, this._transactionEngine);

  Future<List<SalesOrder>> getAllOrders() async {
    return (db.select(db.salesOrders)
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<List<SalesOrderWithCustomer>> getAllOrdersWithCustomer() async {
    final query = db.select(db.salesOrders).join([
      leftOuterJoin(
        db.customers,
        db.customers.id.equalsExp(db.salesOrders.customerId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(db.salesOrders.createdAt)]);

    final rows = await query.get();
    return rows.map((row) {
      return SalesOrderWithCustomer(
        order: row.readTable(db.salesOrders),
        customer: row.readTableOrNull(db.customers),
      );
    }).toList();
  }

  Future<List<SalesOrderWithCustomer>> getOrdersWithCustomerByStatus(
      String status) async {
    final query = db.select(db.salesOrders).join([
      leftOuterJoin(
        db.customers,
        db.customers.id.equalsExp(db.salesOrders.customerId),
      ),
    ])
      ..where(db.salesOrders.status.equals(status))
      ..orderBy([OrderingTerm.desc(db.salesOrders.createdAt)]);

    final rows = await query.get();
    return rows.map((row) {
      return SalesOrderWithCustomer(
        order: row.readTable(db.salesOrders),
        customer: row.readTableOrNull(db.customers),
      );
    }).toList();
  }

  Stream<List<SalesOrder>> watchAllOrders() {
    return (db.select(db.salesOrders)
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch();
  }

  Future<SalesOrder?> getOrderById(String orderId) async {
    return (db.select(db.salesOrders)..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
  }

  Future<List<SalesOrderItem>> getOrderItems(String orderId) async {
    return (db.select(db.salesOrderItems)
          ..where((i) => i.orderId.equals(orderId)))
        .get();
  }

  Stream<List<SalesOrderItem>> watchOrderItems(String orderId) {
    return (db.select(db.salesOrderItems)
          ..where((i) => i.orderId.equals(orderId)))
        .watch();
  }

  Future<List<SalesOrder>> getOrdersByStatus(String status) async {
    return (db.select(db.salesOrders)
          ..where((o) => o.status.equals(status))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Stream<List<SalesOrder>> watchOrdersByStatus(String status) {
    return (db.select(db.salesOrders)
          ..where((o) => o.status.equals(status))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch();
  }

  Future<List<SalesOrder>> getOrdersByCustomer(String customerId) async {
    return (db.select(db.salesOrders)
          ..where((o) => o.customerId.equals(customerId))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<String> _generateOrderNumber() async {
    final now = DateTime.now();
    final prefix =
        'SO${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final count = await db.customSelect(
      "SELECT COUNT(*) as cnt FROM sales_orders WHERE order_number LIKE ?",
      variables: [Variable.withString('$prefix%')],
    ).getSingle();
    final seq = (count.data['cnt'] as int) + 1;
    return '$prefix${seq.toString().padLeft(4, '0')}';
  }

  Future<SalesOrder> createOrder({
    required String? customerId,
    required List<SalesOrderItemData> items,
    String? notes,
    String? userId,
  }) async {
    if (items.isEmpty) {
      throw const BusinessException(message: 'لا يمكن إنشاء طلبية بدون أصناف.');
    }

    Decimal total = Decimal.zero;
    for (final item in items) {
      total += item.price * item.quantity;
    }

    final orderId = const Uuid().v4();
    final orderNumber = await _generateOrderNumber();

    return db.transaction(() async {
      await db.into(db.salesOrders).insert(
            SalesOrdersCompanion.insert(
              id: Value(orderId),
              customerId: Value(customerId),
              total: Value(total),
              orderNumber: Value(orderNumber),
              status: const Value('PENDING'),
              notes: Value(notes),
            ),
          );

      for (final item in items) {
        await db.into(db.salesOrderItems).insert(
              SalesOrderItemsCompanion.insert(
                id: Value(const Uuid().v4()),
                orderId: orderId,
                productId: item.productId,
                quantity: Value(item.quantity),
                price: Value(item.price),
                unitId: Value(item.unitId),
              ),
            );
      }

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'CREATE',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: Value('Created sales order: $orderNumber'),
            ),
          );

      return (db.select(db.salesOrders)..where((o) => o.id.equals(orderId)))
          .getSingle();
    });
  }

  Future<void> updateOrder({
    required String orderId,
    String? customerId,
    required List<SalesOrderItemData> items,
    String? notes,
    String? userId,
  }) async {
    if (items.isEmpty) {
      throw const BusinessException(message: 'لا يمكن تحديث طلبية بدون أصناف.');
    }

    Decimal total = Decimal.zero;
    for (final item in items) {
      total += item.price * item.quantity;
    }

    await db.transaction(() async {
      await (db.update(db.salesOrders)..where((o) => o.id.equals(orderId)))
          .write(
        SalesOrdersCompanion(
          customerId: Value(customerId),
          total: Value(total),
          notes: Value(notes),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await (db.delete(db.salesOrderItems)
            ..where((i) => i.orderId.equals(orderId)))
          .go();

      for (final item in items) {
        await db.into(db.salesOrderItems).insert(
              SalesOrderItemsCompanion.insert(
                id: Value(const Uuid().v4()),
                orderId: orderId,
                productId: item.productId,
                quantity: Value(item.quantity),
                price: Value(item.price),
                unitId: Value(item.unitId),
              ),
            );
      }

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'UPDATE',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: Value('Updated sales order: $orderId'),
            ),
          );
    });
  }

  Future<void> updateStatus(String orderId, String newStatus,
      {String? userId}) async {
    await db.transaction(() async {
      await (db.update(db.salesOrders)..where((o) => o.id.equals(orderId)))
          .write(
        SalesOrdersCompanion(
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'UPDATE',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: Value('Updated order status to: $newStatus'),
            ),
          );
    });
  }

  Future<void> deleteOrder(String orderId, {String? userId}) async {
    await db.transaction(() async {
      await (db.delete(db.salesOrderItems)
            ..where((i) => i.orderId.equals(orderId)))
          .go();
      await (db.delete(db.salesOrders)..where((o) => o.id.equals(orderId)))
          .go();

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'DELETE',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: const Value('Deleted sales order'),
            ),
          );
    });
  }

  Future<Sale> convertToSale(String orderId, {String? userId}) async {
    final order = await getOrderById(orderId);
    if (order == null) throw const BusinessException(message: 'الطلبية غير موجودة.');
    if (order.status == 'CANCELLED') {
      throw const BusinessException(message: 'لا يمكن تحويل طلبية ملغاة.');
    }
    if (order.status == 'INVOICED') {
      throw const BusinessException(message: 'تم تحويل هذه الطلبية بالفعل.');
    }

    final items = await getOrderItems(orderId);
    if (items.isEmpty) throw const BusinessException(message: 'الطلبية لا تحتوي على أصناف.');

    final saleId = const Uuid().v4();

    await db.transaction(() async {
      // 1) Create the invoice through the official creation path
      //    (same as the sales invoice page: UI -> Service -> DAO -> DB)
      final itemsCompanions = <SaleItemsCompanion>[
        for (final item in items)
          SaleItemsCompanion.insert(
            id: Value(const Uuid().v4()),
            saleId: saleId,
            productId: item.productId,
            quantity: item.quantity,
            price: item.price,
            unitId: Value(item.unitId),
          ),
      ];

      final saleCompanion = SalesCompanion.insert(
        id: Value(saleId),
        customerId: Value(order.customerId),
        total: order.total,
        paymentMethod: PaymentMethod.cash,
        status: const Value(DocumentStatus.draft),
        saleType: const Value('ORDER'),
        referenceNumber: Value(order.orderNumber),
        notes: Value(order.notes),
      );

      await db.salesDao.createSale(
        saleCompanion: saleCompanion,
        itemsCompanions: itemsCompanions,
        userId: userId,
      );

      // 2) Post through the official accounting engine:
      //    inventory movement + customer balance + journal entry
      await _transactionEngine.postSale(saleId, userId: userId);

      // 3) Update order status only after the full chain succeeded
      await updateStatus(orderId, 'INVOICED', userId: userId);

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'CONVERT',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: Value('Converted order to posted sale: $saleId'),
            ),
          );
    });

    return (db.select(db.sales)..where((s) => s.id.equals(saleId))).getSingle();
  }

  Future<PurchaseOrder> convertToPurchaseOrder(
    String orderId, {
    required String supplierId,
    String? warehouseId,
    String? userId,
  }) async {
    final order = await getOrderById(orderId);
    if (order == null) throw const BusinessException(message: 'الطلبية غير موجودة.');
    if (order.status == 'CANCELLED') {
      throw const BusinessException(message: 'لا يمكن تحويل طلبية ملغاة.');
    }
    if (order.status == 'INVOICED') {
      throw const BusinessException(message: 'تم تحويل هذه الطلبية بالفعل.');
    }

    final items = await getOrderItems(orderId);
    if (items.isEmpty) throw const BusinessException(message: 'الطلبية لا تحتوي على أصناف.');

    final supplier = await (db.select(db.suppliers)
          ..where((s) => s.id.equals(supplierId)))
        .getSingleOrNull();
    if (supplier == null) {
      throw const BusinessException(message: 'المورد المحدد غير موجود.');
    }

    final poId = const Uuid().v4();
    final poNumber = await _generatePurchaseOrderNumber();

    await db.transaction(() async {
      // 1) Create the purchase order through the official DAO path
      await db.purchasesDao.createPurchaseOrder(
        orderCompanion: PurchaseOrdersCompanion.insert(
          id: Value(poId),
          supplierId: Value(supplierId),
          warehouseId: Value(warehouseId),
          total: Value(order.total),
          orderNumber: Value(poNumber),
          status: const Value('PENDING'),
          notes: Value(
            'محول من طلبية مبيعات: ${order.orderNumber ?? order.id.substring(0, 8)}',
          ),
        ),
        itemsCompanions: [
          for (final item in items)
            PurchaseOrderItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              orderId: poId,
              productId: item.productId,
              quantity: Value(item.quantity),
              price: Value(item.price),
              unitId: Value(item.unitId),
            ),
        ],
      );

      // 2) Update the sales order status only after the full chain succeeded
      await updateStatus(orderId, 'DELIVERED', userId: userId);

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              userId: Value(userId),
              action: 'CONVERT',
              targetEntity: 'SALES_ORDER',
              entityId: orderId,
              details: Value('Converted order to purchase order: $poId'),
            ),
          );
    });

    return (db.select(db.purchaseOrders)..where((o) => o.id.equals(poId)))
        .getSingle();
  }

  Future<String> _generatePurchaseOrderNumber() async {
    final now = DateTime.now();
    final prefix =
        'PO${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final count = await db.customSelect(
      "SELECT COUNT(*) as cnt FROM purchase_orders WHERE order_number LIKE ?",
      variables: [Variable.withString('$prefix%')],
    ).getSingle();
    final seq = (count.data['cnt'] as int) + 1;
    return '$prefix${seq.toString().padLeft(4, '0')}';
  }

  Future<void> cancelOrder(String orderId, {String? userId}) async {
    final order = await getOrderById(orderId);
    if (order == null) throw const BusinessException(message: 'الطلبية غير موجودة.');
    if (order.status == 'INVOICED') {
      throw const BusinessException(message: 'لا يمكن إلغاء طلبية محولة لفاتورة.');
    }
    await updateStatus(orderId, 'CANCELLED', userId: userId);
  }

  Future<int> getOrdersCountByStatus(String status) async {
    final result = await db.customSelect(
      "SELECT COUNT(*) as cnt FROM sales_orders WHERE status = ?",
      variables: [Variable.withString(status)],
    ).getSingle();
    return result.data['cnt'] as int;
  }
}

class SalesOrderItemData {
  final String productId;
  final Decimal quantity;
  final Decimal price;
  final String? unitId;

  SalesOrderItemData({
    required this.productId,
    required this.quantity,
    required this.price,
    this.unitId,
  });
}

class SalesOrderWithCustomer {
  final SalesOrder order;
  final Customer? customer;

  SalesOrderWithCustomer({required this.order, this.customer});

  String get displayName => customer?.name ?? '';
}
