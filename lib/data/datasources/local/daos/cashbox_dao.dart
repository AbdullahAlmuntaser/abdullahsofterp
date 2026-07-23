import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class CashboxDao extends DatabaseAccessor<AppDatabase> {
  CashboxDao(super.db);

  Stream<List<CashboxTransaction>> watchAllTransactions() =>
      (select(db.cashboxTransactions)
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
            ]))
          .watch();

  Future<int> insertTransaction(CashboxTransactionsCompanion companion) =>
      into(db.cashboxTransactions).insert(companion);

  Future<List<CashboxTransaction>> getTransactionsByReference(
          String referenceId) =>
      (select(db.cashboxTransactions)
            ..where((t) => t.referenceId.equals(referenceId)))
          .get();

  Future<Decimal> getCashboxBalance({String? userId}) async {
    final query = selectOnly(db.cashboxTransactions)
      ..addColumns([db.cashboxTransactions.amount, db.cashboxTransactions.type]);
    if (userId != null) {
      query.where(db.cashboxTransactions.userId.equals(userId));
    }

    final rows = await query.get();
    Decimal balance = Decimal.zero;
    for (final row in rows) {
      final amount =
          (row.read(db.cashboxTransactions.amount) as Decimal?) ?? Decimal.zero;
      final type = row.read(db.cashboxTransactions.type);
      if (type == 'IN') {
        balance += amount;
      } else if (type == 'OUT') {
        balance -= amount;
      }
    }
    return balance;
  }
}
