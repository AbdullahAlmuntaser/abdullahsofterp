import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class TransfersDao extends DatabaseAccessor<AppDatabase> {
  TransfersDao(super.db);

  Stream<List<FinancialTransfer>> watchAllTransfers() => (select(db.financialTransfers)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .watch();

  Future<int> insertTransfer(FinancialTransfersCompanion companion) =>
      into(db.financialTransfers).insert(companion);

  Future<FinancialTransfer?> getTransferById(String id) =>
      (select(db.financialTransfers)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<bool> updateTransfer(FinancialTransfer transfer) =>
      update(db.financialTransfers).replace(transfer);
}
