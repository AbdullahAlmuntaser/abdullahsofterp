import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class RecurringEntryDao extends DatabaseAccessor<AppDatabase> {
  RecurringEntryDao(super.db);

  Future<List<RecurringEntry>> getAllRecurringEntries() =>
      (select(db.recurringEntries)
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();

  Stream<List<RecurringEntry>> watchAllRecurringEntries() =>
      (select(db.recurringEntries)
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .watch();

  Future<RecurringEntry?> getRecurringEntryById(int id) =>
      (select(db.recurringEntries)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<RecurringEntry>> getActiveRecurringEntries() =>
      (select(db.recurringEntries)
            ..where((t) => t.status.equals('active'))
            ..where((t) => t.nextExecutionDate
                .isSmallerOrEqual(Variable(DateTime.now()))))
          .get();

  Future<int> createRecurringEntry(RecurringEntriesCompanion entry) =>
      into(db.recurringEntries).insert(entry);

  Future<bool> updateRecurringEntry(RecurringEntry entry) =>
      update(db.recurringEntries).replace(entry);

  Future<int> deleteRecurringEntry(int id) =>
      (delete(db.recurringEntries)..where((t) => t.id.equals(id))).go();

  Future<void> updateNextExecutionDate(int entryId, DateTime nextDate) async {
    await (update(db.recurringEntries)..where((t) => t.id.equals(entryId))).write(
      RecurringEntriesCompanion(
        nextExecutionDate: Value(nextDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> incrementExecutionCount(int entryId) async {
    final entry = await getRecurringEntryById(entryId);
    if (entry == null) return;
    final newCount = entry.totalExecutions + 1;
    await (update(db.recurringEntries)..where((t) => t.id.equals(entryId))).write(
      RecurringEntriesCompanion(
        totalExecutions: Value(newCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> pauseRecurringEntry(int entryId) async {
    await (update(db.recurringEntries)..where((t) => t.id.equals(entryId))).write(
      RecurringEntriesCompanion(
        status: const Value('paused'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> resumeRecurringEntry(int entryId) async {
    await (update(db.recurringEntries)..where((t) => t.id.equals(entryId))).write(
      RecurringEntriesCompanion(
        status: const Value('active'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> completeRecurringEntry(int entryId) async {
    await (update(db.recurringEntries)..where((t) => t.id.equals(entryId))).write(
      RecurringEntriesCompanion(
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Execution log
  Future<int> logExecution(RecurringEntryExecutionsCompanion execution) =>
      into(db.recurringEntryExecutions).insert(execution);

  Future<List<RecurringEntryExecution>> getExecutionsForEntry(
          int recurringEntryId) =>
      (select(db.recurringEntryExecutions)
            ..where((t) => t.recurringEntryId.equals(recurringEntryId))
            ..orderBy(
                [(t) => OrderingTerm(expression: t.executionDate, mode: OrderingMode.desc)]))
          .get();

  Future<List<RecurringEntryExecution>> getRecentExecutions({int limit = 50}) =>
      (select(db.recurringEntryExecutions)
            ..orderBy(
                [(t) => OrderingTerm(expression: t.executionDate, mode: OrderingMode.desc)])
            ..limit(limit))
          .get();

  Future<Map<int, List<RecurringEntryExecution>>> getExecutionStats() async {
    final all = await (select(db.recurringEntryExecutions)).get();
    final map = <int, List<RecurringEntryExecution>>{};
    for (final exec in all) {
      map.putIfAbsent(exec.recurringEntryId, () => []).add(exec);
    }
    return map;
  }
}
