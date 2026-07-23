import 'package:drift/drift.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

class SupplierTransaction {
  final DateTime date;
  final String description;
  final double debit; // له (مشتريات)
  final double credit; // عليه (مدفوعات/مرتجعات)
  final String referenceId;
  final String type; // PURCHASE, PAYMENT, RETURN

  SupplierTransaction({
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.referenceId,
    required this.type,
  });
}

class SuppliersDao extends DatabaseAccessor<AppDatabase> {
  SuppliersDao(super.db);

  Stream<List<Supplier>> watchAllSuppliers() =>
      (select(db.suppliers)..where((tbl) => tbl.isActive.equals(true))).watch();

  Future<Supplier?> getSupplierById(String id) {
    return (select(db.suppliers)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  // AP Invoices
  Stream<List<APInvoice>> watchAPInvoices(String supplierId) {
    return (select(db.aPInvoices)..where((t) => t.supplierId.equals(supplierId)))
        .watch();
  }

  Stream<List<APInvoice>> watchAllAPInvoices() {
    return (select(db.aPInvoices)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<int> createAPInvoice(APInvoicesCompanion entry) {
    return into(db.aPInvoices).insert(entry);
  }

  Future<List<APInvoice>> getUnpaidAPInvoices(String supplierId) {
    return (select(db.aPInvoices)
          ..where((t) =>
              t.supplierId.equals(supplierId) &
              t.status.isIn(['POSTED', 'PARTIAL'])))
        .get();
  }

  Future<List<APInvoice>> getDueAPInvoices(DateTime endDate) {
    return (select(db.aPInvoices)
          ..where((t) =>
              t.status.isIn(['POSTED', 'PARTIAL']) &
              t.dueDate.isSmallerOrEqual(Variable(endDate))))
        .get();
  }

  /// إدراج مورد مع إنشاء حساب محاسبي له تلقائياً
  Future<String> insertSupplierWithAccount(SuppliersCompanion entry) async {
    return transaction(() async {
      // 1. البحث عن الحساب الرئيسي للموردين (مثلاً '2010')
      final parentAccount = await (select(db.gLAccounts)..where((t) => t.code.equals('2010')))
          .getSingleOrNull();

      final accountId = const Uuid().v4();
      final supplierId = const Uuid().v4();

      // 2. إنشاء حساب في دفتر الأستاذ العام
      await into(db.gLAccounts).insert(
        GLAccountsCompanion.insert(
          id: Value(accountId),
          code: '2010-${supplierId.substring(0, 5)}',
          name: 'مورد: ${entry.name.value}',
          accountType: AccountType.liability,
          parentId: Value(parentAccount?.id),
          isHeader: const Value(false),
          balance: Value(Decimal.zero),
        ),
      );

      // 3. إدراج المورد وربطه بالحساب
      final finalEntry = entry.copyWith(
        id: Value(supplierId),
        accountId: Value(accountId),
      );
      await into(db.suppliers).insert(finalEntry);

      return supplierId;
    });
  }

  Future<bool> updateSupplier(Supplier entry) {
    return update(db.suppliers).replace(entry);
  }

  Future<int> deleteSupplier(Supplier entry) {
    // تعطيل المورد بدلاً من حذفه
    return (update(db.suppliers)..where((t) => t.id.equals(entry.id))).write(
      const SuppliersCompanion(isActive: Value(false)),
    );
  }

  /// بحث متقدم عن الموردين
  Future<List<Supplier>> searchSuppliers(String query) {
    return (select(db.suppliers)
          ..where(
            (t) =>
                t.name.contains(query) |
                t.phone.contains(query) |
                t.taxNumber.contains(query),
          )
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  Future<List<SupplierTransaction>> getSupplierStatement(
    String supplierId,
  ) async {
    final List<SupplierTransaction> allTransactions = [];

    // 1. جلب المشتريات الآجلة
    final supplierPurchases = await (select(db.purchases)
          ..where(
            (p) => p.supplierId.equals(supplierId) & p.isCredit.equals(true),
          ))
        .get();

    for (var purchase in supplierPurchases) {
      allTransactions.add(
        SupplierTransaction(
          date: purchase.date,
          description:
              'فاتورة مشتريات رقم ${purchase.invoiceNumber ?? purchase.id.substring(0, 8)}',
          debit: purchase.total.toDouble(), // له
          credit: 0,
          referenceId: purchase.id,
          type: 'PURCHASE',
        ),
      );
    }

    // 2. جلب فواتير الذمم الدائنة (AP Invoices)
    final apInvoicesList = await (select(db.aPInvoices)
          ..where((t) => t.supplierId.equals(supplierId)))
        .get();
    for (var inv in apInvoicesList) {
      allTransactions.add(
        SupplierTransaction(
          date: inv.invoiceDate,
          description: 'فاتورة AP رقم ${inv.invoiceNumber}',
          debit: inv.totalAmount.toDouble(), // له
          credit: 0,
          referenceId: inv.id,
          type: 'AP_INVOICE',
        ),
      );
    }

    // 3. جلب المدفوعات للمورد (سند صرف)
    final payments = await (select(
      db.supplierPayments,
    )..where((p) => p.supplierId.equals(supplierId)))
        .get();

    for (var payment in payments) {
      allTransactions.add(
        SupplierTransaction(
          date: payment.paymentDate,
          description: 'سند صرف - ${payment.note ?? ""}',
          debit: 0,
          credit: payment.amount.toDouble(), // عليه
          referenceId: payment.id,
          type: 'PAYMENT',
        ),
      );
    }

    // 4. جلب المرتجعات للمورد
    final returnsQuery = select(db.purchaseReturns).join([
      innerJoin(
        db.purchases,
        db.purchases.id.equalsExp(db.purchaseReturns.purchaseId),
      ),
    ])
      ..where(db.purchases.supplierId.equals(supplierId));

    final returnRows = await returnsQuery.get();
    for (var row in returnRows) {
      final ret = row.readTable(db.purchaseReturns);
      allTransactions.add(
        SupplierTransaction(
          date: ret.createdAt,
          description: 'مرتجع مشتريات فاتورة ${ret.purchaseId.substring(0, 8)}',
          debit: 0,
          credit: ret.amountReturned.toDouble(), // عليه
          referenceId: ret.id,
          type: 'RETURN',
        ),
      );
    }

    // ترتيب الحركات حسب التاريخ
    allTransactions.sort((a, b) => a.date.compareTo(b.date));

    return allTransactions;
  }

  // PurchasePaymentLinks DAO methods
  Future<void> createPurchasePaymentLink(PurchasePaymentLinksCompanion entry) {
    return into(db.purchasePaymentLinks).insert(entry);
  }

  Future<List<PurchasePaymentLink>> getLinksForPayment(String paymentId) {
    return (select(db.purchasePaymentLinks)
      ..where((l) => l.paymentId.equals(paymentId))).get();
  }

  Future<List<PurchasePaymentLink>> getLinksForPurchase(String purchaseId) {
    return (select(db.purchasePaymentLinks)
      ..where((l) => l.purchaseId.equals(purchaseId))).get();
  }

  Future<int> deletePurchasePaymentLink(String id) {
    return (delete(db.purchasePaymentLinks)..where((l) => l.id.equals(id))).go();
  }
}
