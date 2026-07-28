import 'package:drift/drift.dart';
import 'package:supermarket/core/constants/account_codes.dart';
import 'package:supermarket/core/models/accounting/vat_report_data.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';

class VatService {
  final AppDatabase db;

  VatService(this.db);

  Future<VatReportData> getVatReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dao = db.accountingDao;
    final reportStartDate = startDate ?? DateTime(2000);
    final reportEndDate = endDate ?? DateTime.now();
    final outputVatAccount = await dao.getAccountByCode(AccountCodes.outputVAT);
    final inputVatAccount = await dao.getAccountByCode(AccountCodes.inputVAT);
    final deferredOutputVatAccount =
        await dao.getAccountByCode(AccountCodes.deferredOutputVAT);
    final deferredInputVatAccount =
        await dao.getAccountByCode(AccountCodes.deferredInputVAT);

    if (outputVatAccount == null || inputVatAccount == null) {
      throw const BusinessException(message: 'Output VAT or Input VAT accounts not found.');
    }

    Future<Decimal> getVatBalance(String accountId,
        {required bool isDebitPositive}) async {
      final lines = await (db.select(db.gLLines).join([
        innerJoin(db.gLEntries, db.gLEntries.id.equalsExp(db.gLLines.entryId)),
      ])
        ..where(
          db.gLLines.accountId.equals(accountId) &
              db.gLEntries.date.isBetweenValues(
                reportStartDate,
                reportEndDate,
              ),
        ))
          .get();

      Decimal balance = Decimal.zero;
      for (final line in lines) {
        final debit =
            (line.read(db.gLLines.debit) as Decimal?) ?? Decimal.zero;
        final credit =
            (line.read(db.gLLines.credit) as Decimal?) ?? Decimal.zero;
        balance += isDebitPositive ? debit - credit : credit - debit;
      }
      return balance;
    }

    final totalOutputVat =
        await getVatBalance(outputVatAccount.id, isDebitPositive: false);
    final totalInputVat =
        await getVatBalance(inputVatAccount.id, isDebitPositive: true);

    // Include deferred VAT balances in the report (Cash basis)
    Decimal deferredOutputVat = Decimal.zero;
    if (deferredOutputVatAccount != null) {
      deferredOutputVat = await getVatBalance(deferredOutputVatAccount.id,
          isDebitPositive: false);
    }
    Decimal deferredInputVat = Decimal.zero;
    if (deferredInputVatAccount != null) {
      deferredInputVat = await getVatBalance(deferredInputVatAccount.id,
          isDebitPositive: true);
    }

    final taxableSales = await (db.select(db.sales)
      ..where((s) =>
          s.tax.isBiggerThan(Constant(Decimal.zero.toString())) &
          s.updatedAt.isBetweenValues(reportStartDate, reportEndDate)))
        .get();
    Decimal totalTaxableSales =
        taxableSales.fold(Decimal.zero, (sum, s) => sum + (s.total - s.tax));

    final taxablePurchases = await (db.select(db.purchases)
      ..where((p) =>
          p.tax.isBiggerThan(Constant(Decimal.zero.toString())) &
          p.updatedAt.isBetweenValues(reportStartDate, reportEndDate)))
        .get();
    Decimal totalTaxablePurchases =
        taxablePurchases.fold(Decimal.zero, (sum, p) => sum + (p.total - p.tax));

    return VatReportData(
      totalTaxableSales: totalTaxableSales,
      totalOutputVat: totalOutputVat + deferredOutputVat,
      totalTaxablePurchases: totalTaxablePurchases,
      totalInputVat: totalInputVat + deferredInputVat,
      netVatPayable: (totalOutputVat + deferredOutputVat) -
          (totalInputVat + deferredInputVat),
      startDate: reportStartDate,
      endDate: reportEndDate,
    );
  }
}
