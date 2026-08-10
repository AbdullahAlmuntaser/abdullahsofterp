import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/security_service.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/sales/sales_order_service.dart';
import 'package:supermarket/core/services/purchases/purchase_totals.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';

void main() {
  late AppDatabase db;
  late TransactionEngine engine;
  late SalesOrderService orderService;
  late String productId;
  late String customerId;
  late String supplierId;

  setUpAll(() {
    SecurityService.useFakeKeyForTesting = true;
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final costing = InventoryCostingService(db.stockMovementDao, db);
    final posting = PostingEngine(db);
    final packaging = PackagingEngine(db);
    engine = TransactionEngine(
      db,
      EventBusService(),
      posting,
      packaging,
      costing,
    );
    orderService = SalesOrderService(db, engine);

    productId = 'prod-1';
    customerId = 'cust-1';
    supplierId = 'supp-1';
    await db.into(db.products).insert(ProductsCompanion.insert(
          id: drift.Value(productId),
          name: 'منتج اختبار',
          sku: 'SKU-001',
          buyPrice: drift.Value(Decimal.parse('10.0')),
          sellPrice: drift.Value(Decimal.parse('100.0')),
          stock: drift.Value(Decimal.parse('100.0')),
        ));

    await db.into(db.customers).insert(CustomersCompanion.insert(
          id: drift.Value(customerId),
          name: 'عميل البحث',
          phone: const drift.Value('0500000000'),
        ));

    await db.into(db.suppliers).insert(SuppliersCompanion.insert(
          id: drift.Value(supplierId),
          name: 'مورد الاختبار',
        ));

    await db.into(db.productUnits).insert(ProductUnitsCompanion.insert(
          id: const drift.Value('unit-1'),
          productId: productId,
          unitName: 'كرتون',
          unitFactor: drift.Value(Decimal.parse('10')),
          sellPrice: drift.Value(Decimal.parse('1000')),
        ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> createOrder({
    Decimal? qty,
    Decimal? price,
    String? unitId,
    String? customer,
  }) async {
    final order = await orderService.createOrder(
      customerId: customer ?? customerId,
      items: [
        SalesOrderItemData(
          productId: productId,
          quantity: qty ?? Decimal.one,
          price: price ?? Decimal.parse('100'),
          unitId: unitId,
        ),
      ],
    );
    return order.id;
  }

  group('AUD-009: search by order number or customer name', () {
    test('orders joined with customer name', () async {
      await createOrder();
      final orders = await orderService.getAllOrdersWithCustomer();
      expect(orders, hasLength(1));
      expect(orders.first.displayName, 'عميل البحث');
      expect(orders.first.order.orderNumber, isNotNull);
    });

    test('status filter returns joined orders', () async {
      await createOrder();
      final pending = await orderService.getOrdersWithCustomerByStatus('PENDING');
      expect(pending, hasLength(1));
      final invoiced = await orderService.getOrdersWithCustomerByStatus('INVOICED');
      expect(invoiced, isEmpty);
    });
  });

  group('AUD-010: order -> purchase order conversion', () {
    test('creates PO with supplier, items, and marks order DELIVERED', () async {
      final orderId = await createOrder(qty: Decimal.parse('2'));

      final po = await orderService.convertToPurchaseOrder(
        orderId,
        supplierId: supplierId,
      );

      expect(po.supplierId, supplierId);
      expect(po.orderNumber, isNotNull);
      expect(po.status, 'PENDING');

      final items = await (db.select(db.purchaseOrderItems)
            ..where((i) => i.orderId.equals(po.id)))
          .get();
      expect(items, hasLength(1));
      expect(items.first.productId, productId);
      expect(items.first.quantity, Decimal.parse('2'));

      final order = await orderService.getOrderById(orderId);
      expect(order!.status, 'DELIVERED');
    });

    test('requires a supplier', () async {
      final orderId = await createOrder();
      expect(
        () => orderService.convertToPurchaseOrder(orderId, supplierId: 'ghost'),
        throwsA(isA<BusinessException>()),
      );
      final order = await orderService.getOrderById(orderId);
      expect(order!.status, 'PENDING');
    });

    test('cancelled order cannot be converted', () async {
      final orderId = await createOrder();
      await orderService.cancelOrder(orderId);
      expect(
        () => orderService.convertToPurchaseOrder(orderId, supplierId: supplierId),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AUD-011: unitId saved on order items', () {
    test('base unit item saves null unitId', () async {
      final orderId = await createOrder();
      final items = await orderService.getOrderItems(orderId);
      expect(items.first.unitId, isNull);
    });

    test('alternative unit item saves its unitId', () async {
      final orderId = await createOrder(unitId: 'unit-1');
      final items = await orderService.getOrderItems(orderId);
      expect(items.first.unitId, 'unit-1');
    });

    test('unitId survives update + reload', () async {
      final orderId = await createOrder();
      await orderService.updateOrder(
        orderId: orderId,
        customerId: customerId,
        items: [
          SalesOrderItemData(
            productId: productId,
            quantity: Decimal.parse('3'),
            price: Decimal.parse('100'),
            unitId: 'unit-1',
          ),
        ],
      );
      final items = await orderService.getOrderItems(orderId);
      expect(items.first.unitId, 'unit-1');
      expect(items.first.quantity, Decimal.parse('3'));
    });
  });

  group('AUD-016: unified purchase totals', () {
    test('reverse formula matches saved total', () async {
      final purchase = PurchasesCompanion.insert(
        id: const drift.Value('p-1'),
        total: Decimal.parse('130'),
        discount: drift.Value(Decimal.parse('10')),
        tax: drift.Value(Decimal.parse('15')),
        shippingCost: drift.Value(Decimal.parse('5')),
      );
      await db.into(db.purchases).insert(purchase);
      final saved = await (db.select(db.purchases)..where((p) => p.id.equals('p-1'))).getSingle();

      final totals = PurchaseTotalsCalculator.fromPurchase(saved);
      // total = subtotal - discount + shipping + tax  => 130 = subtotal - 10 + 5 + 15
      expect(totals.subtotal, Decimal.parse('120'));
      expect(totals.discount, Decimal.parse('10'));
      expect(totals.shippingCost, Decimal.parse('5'));
      expect(totals.tax, Decimal.parse('15'));
      expect(totals.total, Decimal.parse('130'));
    });
  });

  group('AUD-017: purchase items joined with products', () {
    test('join returns product names in one query', () async {
      await db.into(db.purchases).insert(PurchasesCompanion.insert(
            id: const drift.Value('p-2'),
            total: Decimal.parse('100'),
          ));
      await db.into(db.purchaseItems).insert(PurchaseItemsCompanion.insert(
            id: const drift.Value('pi-1'),
            purchaseId: 'p-2',
            productId: productId,
            quantity: Decimal.parse('2'),
            unitPrice: Decimal.parse('50'),
            price: Decimal.parse('100'),
          ));

      final rows = await (db.select(db.purchaseItems).join([
        drift.leftOuterJoin(
          db.products,
          db.products.id.equalsExp(db.purchaseItems.productId),
        ),
      ])
            ..where(db.purchaseItems.purchaseId.equals('p-2')))
          .get();

      expect(rows, hasLength(1));
      final product = rows.first.readTableOrNull(db.products);
      expect(product, isNotNull);
      expect(product!.name, 'منتج اختبار');
    });
  });
}
