import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/security_service.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/sales/sales_order_service.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';
import 'package:supermarket/core/utils/split_payment_validator.dart';
import 'package:supermarket/core/services/accounting/journal_service.dart';
import 'package:supermarket/core/services/accounting/financial_closing_service.dart';
import 'package:supermarket/core/services/accounting/financial_report_service.dart';

void main() {
  late AppDatabase db;
  late TransactionEngine engine;
  late SalesOrderService orderService;
  late String productId;
  late String customerId;
  late String warehouseId;

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
          name: 'عميل اختبار',
          phone: const drift.Value('0500000000'),
        ));

    final warehouse = await (db.select(db.warehouses)
          ..where((w) => w.isDefault.equals(true)))
        .getSingle();
    warehouseId = warehouse.id;

    await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
          id: const drift.Value('batch-1'),
          productId: productId,
          warehouseId: warehouseId,
          batchNumber: 'B1',
          quantity: drift.Value(Decimal.parse('100.0')),
          initialQuantity: drift.Value(Decimal.parse('100.0')),
          costPrice: drift.Value(Decimal.parse('10.0')),
        ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> createOrder(Decimal qty, Decimal price) async {
    final order = await orderService.createOrder(
      customerId: customerId,
      items: [
        SalesOrderItemData(
          productId: productId,
          quantity: qty,
          price: price,
        ),
      ],
    );
    return order.id;
  }

  Future<String> createDraftSale({
    required Decimal total,
    Decimal? tax,
    bool isCredit = false,
    PaymentMethod method = PaymentMethod.cash,
    Decimal? paidAmount,
    Decimal? qty,
    Decimal? price,
  }) async {
    final saleId = const Uuid().v4();
    await db.salesDao.createSale(
      saleCompanion: SalesCompanion.insert(
        id: drift.Value(saleId),
        customerId: drift.Value(customerId),
        total: total,
        tax: drift.Value(tax ?? Decimal.parse('0')),
        paymentMethod: method,
        isCredit: drift.Value(isCredit),
        status: const drift.Value(DocumentStatus.draft),
        paidAmount: drift.Value(paidAmount ?? Decimal.parse('0')),
      ),
      itemsCompanions: [
        SaleItemsCompanion.insert(
          id: drift.Value(const Uuid().v4()),
          saleId: saleId,
          productId: productId,
          quantity: qty ?? Decimal.parse('1'),
          price: price ?? Decimal.parse('100'),
        ),
      ],
      userId: null,
    );
    return saleId;
  }

  Future<Decimal> getProductStock() async {
    final product = await (db.select(db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingle();
    return product.stock;
  }

  Future<Decimal> getCustomerBalance() async {
    final customer = await (db.select(db.customers)
          ..where((c) => c.id.equals(customerId)))
        .getSingle();
    return customer.balance;
  }

  Future<List<GLEntry>> getEntriesFor(String referenceId) async {
    return (db.select(db.gLEntries)
          ..where((e) => e.referenceId.equals(referenceId)))
        .get();
  }

  Future<Map<String, String>> getAccountIds() async {
    final accounts = await (db.select(db.gLAccounts).get());
    return {for (final a in accounts) a.code: a.id};
  }

  group('AUD-001: Order -> Invoice conversion', () {
    test('full chain: posted invoice, stock movement, GL entry, order INVOICED',
        () async {
      final orderId = await createOrder(Decimal.one, Decimal.parse('100'));

      final sale = await orderService.convertToSale(orderId);

      final saved = await (db.select(db.sales)
            ..where((s) => s.id.equals(sale.id)))
          .getSingle();
      expect(saved.status, DocumentStatus.posted);
      expect(saved.total, Decimal.parse('100'));

      // Stock deducted
      expect(await getProductStock(), Decimal.parse('99'));

      // Inventory transaction created
      final tx = await (db.select(db.inventoryTransactions)
            ..where((t) =>
                t.referenceId.equals(sale.id) & t.type.equals('SALE')))
            .get();
      expect(tx, hasLength(1));
      expect(tx.first.quantity, Decimal.parse('-1'));

      // Journal entry exists and is balanced
      final entries = await getEntriesFor(sale.id);
      expect(entries, isNotEmpty);
      final saleEntry = entries.firstWhere((e) => e.referenceType == 'SALE');
      final lines = await (db.select(db.gLLines)
            ..where((l) => l.entryId.equals(saleEntry.id)))
            .get();
      final debitSum = lines.fold<Decimal>(
          Decimal.zero, (sum, l) => sum + l.debit);
      final creditSum = lines.fold<Decimal>(
          Decimal.zero, (sum, l) => sum + l.credit);
      expect(debitSum, creditSum);

      // Order status updated
      final order = await orderService.getOrderById(orderId);
      expect(order!.status, 'INVOICED');
    });

    test('cash sale: customer balance unchanged', () async {
      final orderId = await createOrder(Decimal.one, Decimal.parse('100'));
      await orderService.convertToSale(orderId);
      expect(await getCustomerBalance(), Decimal.zero);
    });

    test('already converted order is rejected', () async {
      final orderId = await createOrder(Decimal.one, Decimal.parse('100'));
      await orderService.convertToSale(orderId);
      expect(
        () => orderService.convertToSale(orderId),
        throwsA(isA<BusinessException>()),
      );
    });

    test('cancelled order is rejected', () async {
      final orderId = await createOrder(Decimal.one, Decimal.parse('100'));
      await orderService.cancelOrder(orderId);
      expect(
        () => orderService.convertToSale(orderId),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AUD-002: Split payment posting', () {
    test('credit sale: customer balance increases by total', () async {
      final saleId = await createDraftSale(
        total: Decimal.parse('100'),
        isCredit: true,
      );
      await engine.postSale(saleId);
      expect(await getCustomerBalance(), Decimal.parse('100'));

      final accountIds = await getAccountIds();
      final entries = await getEntriesFor(saleId);
      final saleEntry = entries.firstWhere((e) => e.referenceType == 'SALE');
      final lines = await (db.select(db.gLLines)
            ..where((l) => l.entryId.equals(saleEntry.id)))
            .get();
      final receivableLines = lines
          .where((l) => l.accountId == accountIds['1030'])
          .toList();
      expect(receivableLines.fold<Decimal>(Decimal.zero, (s, l) => s + l.debit),
          Decimal.parse('100'));
    });

    test('split sale: balance increases by credit portion only', () async {
      final saleId = await createDraftSale(
        total: Decimal.parse('100'),
        isCredit: true,
        method: PaymentMethod.split,
        paidAmount: Decimal.parse('40'),
      );
      await engine.postSale(saleId);
      expect(await getCustomerBalance(), Decimal.parse('60'));

      final accountIds = await getAccountIds();
      final entries = await getEntriesFor(saleId);
      final saleEntry = entries.firstWhere((e) => e.referenceType == 'SALE');
      final lines = await (db.select(db.gLLines)
            ..where((l) => l.entryId.equals(saleEntry.id)))
            .get();
      final debitSum =
          lines.fold<Decimal>(Decimal.zero, (sum, l) => sum + l.debit);
      final creditSum =
          lines.fold<Decimal>(Decimal.zero, (sum, l) => sum + l.credit);
      expect(debitSum, creditSum);
      expect(debitSum, Decimal.parse('100'));

      final cashDebit = lines
          .where((l) =>
              l.accountId == accountIds['1010'] && l.debit > Decimal.zero)
          .fold<Decimal>(Decimal.zero, (s, l) => s + l.debit);
      final receivableDebit = lines
          .where((l) =>
              l.accountId == accountIds['1030'] && l.debit > Decimal.zero)
          .fold<Decimal>(Decimal.zero, (s, l) => s + l.debit);
      expect(cashDebit, Decimal.parse('40'));
      expect(receivableDebit, Decimal.parse('60'));
    });

    test('split sale with tax: revenue = total - tax', () async {
      final saleId = await createDraftSale(
        total: Decimal.parse('115'),
        tax: Decimal.parse('15'),
        isCredit: true,
        method: PaymentMethod.split,
        paidAmount: Decimal.parse('50'),
      );
      await engine.postSale(saleId);

      final accountIds = await getAccountIds();
      final entries = await getEntriesFor(saleId);
      final saleEntry = entries.firstWhere((e) => e.referenceType == 'SALE');
      final lines = await (db.select(db.gLLines)
            ..where((l) => l.entryId.equals(saleEntry.id)))
            .get();
      final debitSum =
          lines.fold<Decimal>(Decimal.zero, (sum, l) => sum + l.debit);
      final creditSum =
          lines.fold<Decimal>(Decimal.zero, (sum, l) => sum + l.credit);
      expect(debitSum, creditSum);
      final revenueCredit = lines
          .where((l) =>
              l.accountId == accountIds['4010'] && l.credit > Decimal.zero)
          .fold<Decimal>(Decimal.zero, (s, l) => s + l.credit);
      expect(revenueCredit, Decimal.parse('100'));
    });

    test('cancel split sale: stock restored and balance reversed', () async {
      final saleId = await createDraftSale(
        total: Decimal.parse('100'),
        isCredit: true,
        method: PaymentMethod.split,
        paidAmount: Decimal.parse('40'),
      );
      await engine.postSale(saleId);
      expect(await getCustomerBalance(), Decimal.parse('60'));
      expect(await getProductStock(), Decimal.parse('99'));

      await engine.cancelSale(saleId);

      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
            .getSingle();
      expect(sale.status, DocumentStatus.cancelled);
      expect(await getCustomerBalance(), Decimal.zero);
      expect(await getProductStock(), Decimal.parse('100'));

      // Reversal entries are posted, originals cancelled
      final entries = await getEntriesFor(saleId);
      final cancellationEntries =
          entries.where((e) => e.referenceType == 'SALE_CANCELLATION');
      expect(cancellationEntries, isNotEmpty);
    });
  });

  group('AUD-006: Reverse entries (cancellation)', () {
    test('cancel cash sale: originals stay POSTED, reversal posted, net zero',
        () async {
      final saleId = await createDraftSale(total: Decimal.parse('100'));
      await engine.postSale(saleId);

      final accountIds = await getAccountIds();
      expect(await db.accountingDao.getAccountBalance(accountIds['1010']!),
          Decimal.parse('100'));
      expect(await db.accountingDao.getAccountBalance(accountIds['4010']!),
          Decimal.parse('100'));

      await engine.cancelSale(saleId);

      // Original entries are NOT deleted nor cancelled (audit trail preserved)
      final entries = await getEntriesFor(saleId);
      final originals = entries
          .where((e) =>
              e.referenceType == 'SALE' || e.referenceType == 'COGS')
          .toList();
      expect(originals, isNotEmpty);
      for (final entry in originals) {
        expect(entry.status, 'POSTED');
      }

      // Reversal entries are posted, balanced, with swapped lines
      final reversals = entries
          .where((e) =>
              e.referenceType == 'SALE_CANCELLATION' ||
              e.referenceType == 'COGS_CANCELLATION')
          .toList();
      expect(reversals, hasLength(2));
      for (final reversal in reversals) {
        expect(reversal.status, 'POSTED');
        final lines = await (db.select(db.gLLines)
              ..where((l) => l.entryId.equals(reversal.id)))
            .get();
        final debitSum =
            lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.debit);
        final creditSum =
            lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.credit);
        expect(debitSum, creditSum);
      }

      // Reversal lines are recorded in accountTransactions (entry-id linked)
      final reversalTx = await (db.select(db.accountTransactions)
            ..where((t) => t.referenceId.equals(reversals.first.id)))
            .get();
      expect(reversalTx, isNotEmpty);

      // Net effect on financial reports is zero
      expect(await db.accountingDao.getAccountBalance(accountIds['1010']!),
          Decimal.zero);
      expect(await db.accountingDao.getAccountBalance(accountIds['4010']!),
          Decimal.zero);
      expect(await db.accountingDao.getAccountBalance(accountIds['5010']!),
          Decimal.zero);
      expect(await db.accountingDao.getAccountBalance(accountIds['1040']!),
          Decimal.zero);
    });

    test('cancel split sale: customer balance and GL balances net zero',
        () async {
      final saleId = await createDraftSale(
        total: Decimal.parse('100'),
        isCredit: true,
        method: PaymentMethod.split,
        paidAmount: Decimal.parse('40'),
      );
      await engine.postSale(saleId);
      expect(await getCustomerBalance(), Decimal.parse('60'));

      await engine.cancelSale(saleId);

      final accountIds = await getAccountIds();
      expect(await getCustomerBalance(), Decimal.zero);
      expect(await db.accountingDao.getAccountBalance(accountIds['1030']!),
          Decimal.zero);
      expect(await db.accountingDao.getAccountBalance(accountIds['1010']!),
          Decimal.zero);
    });

    test('cancel purchase: originals stay POSTED, reversal posted, net zero',
        () async {
      await db.into(db.suppliers).insert(SuppliersCompanion.insert(
            id: const drift.Value('supp-1'),
            name: 'مورد اختبار',
          ));

      final purchaseId = const Uuid().v4();
      await db.into(db.purchases).insert(PurchasesCompanion.insert(
            id: drift.Value(purchaseId),
            supplierId: const drift.Value('supp-1'),
            total: Decimal.parse('100'),
            status: const drift.Value(DocumentStatus.draft),
            warehouseId: drift.Value(warehouseId),
          ));
      await db.into(db.purchaseItems).insert(PurchaseItemsCompanion.insert(
            id: drift.Value(const Uuid().v4()),
            purchaseId: purchaseId,
            productId: productId,
            quantity: Decimal.one,
            unitPrice: Decimal.parse('100'),
            price: Decimal.parse('100'),
            warehouseId: drift.Value(warehouseId),
          ));
      await db.into(db.goodReceivedNotes).insert(
            GoodReceivedNotesCompanion.insert(
              id: drift.Value(const Uuid().v4()),
              purchaseId: drift.Value(purchaseId),
              supplierId: const drift.Value('supp-1'),
              warehouseId: warehouseId,
              grnNumber: 'GRN-1',
              status: const drift.Value('POSTED'),
            ),
          );

      await engine.postPurchase(purchaseId);

      final accountIds = await getAccountIds();
      expect(await db.accountingDao.getAccountBalance(accountIds['1040']!),
          Decimal.parse('100'));

      await engine.cancelPurchase(purchaseId);

      final entries = await (db.select(db.gLEntries)
            ..where((e) => e.referenceId.equals(purchaseId)))
            .get();
      final originals = entries.where((e) => e.referenceType == 'PURCHASE');
      expect(originals, isNotEmpty);
      for (final entry in originals) {
        expect(entry.status, 'POSTED');
      }

      final reversals =
          entries.where((e) => e.referenceType == 'PURCHASE_CANCELLATION');
      expect(reversals, isNotEmpty);
      for (final reversal in reversals) {
        expect(reversal.status, 'POSTED');
        final lines = await (db.select(db.gLLines)
              ..where((l) => l.entryId.equals(reversal.id)))
            .get();
        final debitSum =
            lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.debit);
        final creditSum =
            lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.credit);
        expect(debitSum, creditSum);
      }

      expect(await db.accountingDao.getAccountBalance(accountIds['1040']!),
          Decimal.zero);
    });
  });

  group('AUD-007: Period closing blocks postings', () {
    test('closed period blocks sales/payments/journal; admin reopen restores',
        () async {
      final period = await (db.select(db.accountingPeriods)).getSingle();
      final accountIds = await getAccountIds();
      final journalService = JournalService(db);
      final closingService =
          FinancialClosingService(db, FinancialReportService(db));

      // Posting works while the period is open
      final saleId = await createDraftSale(total: Decimal.parse('100'));
      await engine.postSale(saleId);

      // Close the period
      await (db.update(db.accountingPeriods)
            ..where((p) => p.id.equals(period.id)))
          .write(const AccountingPeriodsCompanion(isClosed: drift.Value(true)));

      // Sales posting blocked
      final blockedSale = await createDraftSale(total: Decimal.parse('50'));
      await expectLater(
        engine.postSale(blockedSale),
        throwsA(isA<BusinessException>()),
      );

      // Cancellation blocked
      await expectLater(
        engine.cancelSale(saleId),
        throwsA(isA<BusinessException>()),
      );

      // Customer payment blocked
      await expectLater(
        engine.postCustomerPayment(
          customerId: customerId,
          amount: Decimal.one,
          paymentMethod: 'cash',
        ),
        throwsA(isA<BusinessException>()),
      );

      // Manual journal (expense) blocked
      await expectLater(
        journalService.recordExpense(
          description: 'اختبار',
          amount: Decimal.one,
          date: DateTime.now(),
          expenseAccountId: accountIds['6000']!,
          paymentAccountId: accountIds['1010']!,
        ),
        throwsA(isA<BusinessException>()),
      );

      // Reopening requires admin permission
      final nonAdmin = await closingService.reopenPeriod(
        period.id,
        'user-1',
        'admin-1',
      );
      expect(nonAdmin.success, false);

      final admin = await closingService.reopenPeriod(
        period.id,
        'admin-1',
        'admin-1',
      );
      expect(admin.success, true);

      // Posting works again after reopen
      await engine.postSale(blockedSale);
      final posted = await (db.select(db.sales)
            ..where((s) => s.id.equals(blockedSale)))
            .getSingle();
      expect(posted.status, DocumentStatus.posted);
    });
  });

  group('AUD-008: Currency / exchange rate / cost center', () {
    test('foreign currency sale posts with balanced entry', () async {
      final saleId = await createDraftSale(total: Decimal.parse('100'));
      await (db.update(db.sales)..where((s) => s.id.equals(saleId)))
          .write(SalesCompanion(
            currencyId: const drift.Value('USD'),
            exchangeRate: drift.Value(Decimal.parse('3.75')),
          ));
      await engine.postSale(saleId);

      final entries = await getEntriesFor(saleId);
      final saleEntry = entries.firstWhere((e) => e.referenceType == 'SALE');
      final lines = await (db.select(db.gLLines)
            ..where((l) => l.entryId.equals(saleEntry.id)))
            .get();
      final debitSum =
          lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.debit);
      final creditSum =
          lines.fold<Decimal>(Decimal.zero, (s, l) => s + l.credit);
      expect(debitSum, creditSum);
      expect(debitSum, Decimal.parse('100'));
    });

    test('cost center is persisted on journal lines', () async {
      const costCenterId = 'cc-1';
      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
            id: const drift.Value('cc-1'),
            code: 'CC1',
            name: 'فرع الرياض',
          ));

      final accountIds = await getAccountIds();
      await JournalService(db).recordExpense(
        description: 'مصروف اختبار',
        amount: Decimal.parse('50'),
        date: DateTime.now(),
        expenseAccountId: accountIds['6000']!,
        paymentAccountId: accountIds['1010']!,
        costCenterId: costCenterId,
      );

      final lines = await (db.select(db.gLLines)
            ..where((l) => l.costCenterId.equals(costCenterId)))
            .get();
      expect(lines, isNotEmpty);
      for (final line in lines) {
        expect(line.costCenterId, costCenterId);
      }
    });
  });

  group('AUD-002: SplitPaymentValidator', () {
    test('valid split passes', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.parse('40'),
          credit: Decimal.parse('60'),
          total: Decimal.parse('100'),
        ),
        isNull,
      );
    });

    test('cash full (credit = 0) passes', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.parse('100'),
          credit: Decimal.zero,
          total: Decimal.parse('100'),
        ),
        isNull,
      );
    });

    test('credit full (cash = 0) passes', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.zero,
          credit: Decimal.parse('100'),
          total: Decimal.parse('100'),
        ),
        isNull,
      );
    });

    test('split larger than total is rejected', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.parse('60'),
          credit: Decimal.parse('60'),
          total: Decimal.parse('100'),
        ),
        isNotNull,
      );
    });

    test('split smaller than total is rejected', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.parse('30'),
          credit: Decimal.parse('30'),
          total: Decimal.parse('100'),
        ),
        isNotNull,
      );
    });

    test('zero amount split is rejected', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.zero,
          credit: Decimal.zero,
          total: Decimal.parse('100'),
        ),
        isNotNull,
      );
    });

    test('negative amounts are rejected', () {
      expect(
        SplitPaymentValidator.validate(
          cash: Decimal.parse('-10'),
          credit: Decimal.parse('110'),
          total: Decimal.parse('100'),
        ),
        isNotNull,
      );
    });
  });
}
