import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class UnifiedStatementService {
  final AppDatabase db;

  UnifiedStatementService(this.db);

  Future<List<UnifiedStatementEntry>> getUnifiedStatement({
    required String accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final account = await db.accountingDao.getAccountById(accountId);

    final rows = await (db.select(db.gLLines).join([
      innerJoin(db.gLEntries, db.gLEntries.id.equalsExp(db.gLLines.entryId)),
    ])
          ..where(db.gLLines.accountId.equals(accountId))
          ..where(db.gLEntries.date.isBetweenValues(startDate, endDate))
          ..orderBy([
            OrderingTerm(expression: db.gLEntries.date),
            OrderingTerm(expression: db.gLLines.id),
          ]))
        .get();

    double runningBalance = (await db.accountingDao.getAccountBalanceAsOfDate(
      accountId,
      startDate.subtract(const Duration(milliseconds: 1)),
    ))
        .toDouble();

    List<UnifiedStatementEntry> entries = [];

    entries.add(UnifiedStatementEntry(
      date: startDate,
      description: 'رصيد افتتاحى / Opening Balance',
      debit: 0,
      credit: 0,
      balance: runningBalance,
      referenceId: '',
      type: 'OPENING',
    ));

    for (final row in rows) {
      final line = row.readTable(db.gLLines);
      final entry = row.readTable(db.gLEntries);

      if (account?.type == 'ASSET' || account?.type == 'EXPENSE') {
        runningBalance += (line.debit - line.credit).toDouble();
      } else {
        runningBalance += (line.credit - line.debit).toDouble();
      }
      entries.add(UnifiedStatementEntry(
        date: entry.date,
        description: _getTransactionDescription(entry),
        debit: line.debit.toDouble(),
        credit: line.credit.toDouble(),
        balance: runningBalance,
        referenceId: entry.referenceId ?? '',
        type: entry.referenceType ?? '',
      ));
    }

    return entries;
  }

  String _getTransactionDescription(GLEntry entry) {
    final type = entry.referenceType ?? '';
    final refId = entry.referenceId ?? '';
    if (type == 'INVOICE' || type == 'Sale') {
      return 'فاتورة رقم: $refId';
    } else if (type == 'PAYMENT' || type == 'Purchase') {
      return 'سند صرف رقم: $refId';
    } else if (type == 'RECEIPT') {
      return 'سند قبض رقم: $refId';
    } else if (type == 'RETURN' || type == 'SaleReturn' || type == 'PurchaseReturn') {
      return 'مردودات رقم: $refId';
    } else if (type == 'TRANSFER') {
      return 'تحويل مالي رقم: $refId';
    } else if (type == 'HR_ADVANCE') {
      return 'سلفة موظف رقم: $refId';
    }
      return '${entry.description} ($type)';
  }
}

class UnifiedStatementEntry {
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final double balance;
  final String referenceId;
  final String type;

  UnifiedStatementEntry({
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.referenceId,
    required this.type,
  });
}
