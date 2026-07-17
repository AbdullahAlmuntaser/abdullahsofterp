import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

class AccountingPeriodService {
  final AppDatabase db;

  AccountingPeriodService(this.db);

  /// إنشاء فترة محاسبية سنوية لسنة معينة
  Future<int> bulkCreatePeriods({
    required int year,
    required String type, // فقط yearly مدعوم
  }) async {
    // الفترات السنوية فقط - لا فترات شهرية أو ربعية
    if (type != 'yearly') {
      throw Exception('يتم دعم الفترات السنوية فقط. النوع المطلوب: $type غير مدعوم.');
    }

    // التحقق من وجود فترة مفتوحة لهذه السنة مسبقاً
    final existingOpen = await (db.select(db.accountingPeriods)
          ..where((p) =>
              p.fiscalYear.equals(year) &
              p.status.equals('OPEN')))
        .getSingleOrNull();

    if (existingOpen != null) {
      return 1; // الفترة موجودة مسبقاً
    }

    const uuid = Uuid();
    await db.into(db.accountingPeriods).insert(
      AccountingPeriodsCompanion.insert(
        id: Value(uuid.v4()),
        name: 'السنة $year',
        fiscalYear: year,
        startDate: DateTime(year, 1, 1),
        endDate: DateTime(year, 12, 31),
        status: const Value('OPEN'),
        syncStatus: const Value(1),
      ),
      onConflict: DoNothing(
        target: [db.accountingPeriods.fiscalYear, db.accountingPeriods.status],
      ),
    );

    return 1;
  }

  /// Closes the current accounting period and prevents further transactions in it.
  Future<void> closePeriod(String periodId, String closedBy) async {
    final period = await (db.select(db.accountingPeriods)
          ..where((p) => p.id.equals(periodId)))
        .getSingle();

    if (period.isClosed) {
      throw Exception('هذه الفترة مغلقة بالفعل.');
    }

    await db.transaction(() async {
      // 1. تحديث حالة الفترة
      await (db.update(db.accountingPeriods)
            ..where((p) => p.id.equals(periodId)))
          .write(AccountingPeriodsCompanion(
        isClosed: const Value(true),
        closedAt: Value(DateTime.now()),
        closedBy: Value(closedBy),
        status: const Value('CLOSED'),
      ));
    });
  }

  /// Ensures there's an open yearly accounting period for the current year
  Future<void> ensureOpenPeriod() async {
    final now = DateTime.now();
    final existingOpen = await (db.select(db.accountingPeriods)
          ..where((p) =>
              p.fiscalYear.equals(now.year) &
              p.status.equals('OPEN')))
        .getSingleOrNull();

    if (existingOpen == null) {
      const uuid = Uuid();
      await db.into(db.accountingPeriods).insert(
            AccountingPeriodsCompanion.insert(
              id: Value(uuid.v4()),
              name: 'السنة ${now.year}',
              fiscalYear: now.year,
              startDate: DateTime(now.year, 1, 1),
              endDate: DateTime(now.year, 12, 31),
              status: const Value('OPEN'),
            ),
            onConflict: DoNothing(
              target: [db.accountingPeriods.fiscalYear, db.accountingPeriods.status],
            ),
          );
    }
  }

  /// Checks if a transaction date is allowed (must not be in a closed period)
  Future<bool> isDateAllowed(DateTime date) async {
    final closedPeriods = await (db.select(db.accountingPeriods)
          ..where((p) =>
              p.isClosed.equals(true) &
              p.startDate.isSmallerOrEqual(Variable(date)) &
              p.endDate.isBiggerOrEqual(Variable(date))))
        .get();

    return closedPeriods.isEmpty;
  }
}
