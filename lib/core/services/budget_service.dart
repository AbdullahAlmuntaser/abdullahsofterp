import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/notification_service.dart';

class BudgetService {
  final AppDatabase db;
  final NotificationService notificationService;

  BudgetService(this.db, this.notificationService);

  /// التحقق من توافر الميزانية قبل تسجيل المصروف
  Future<void> validateExpenseAgainstBudget({
    required String costCenterId,
    required Decimal expenseAmount,
    required String period,
  }) async {
    final budgets = await (db.select(db.accBudgets)
          ..where((b) => b.costCenterId.equals(costCenterId))
          ..where((b) => b.period.equals(period)))
        .get();

    for (var budget in budgets) {
      final budgetedDecimal = Decimal.parse(budget.budgetedAmount.toString());
      final actualDecimal = Decimal.parse(budget.actualAmount.toString());
      final remaining = budgetedDecimal - actualDecimal;

      if (expenseAmount > remaining) {
        throw Exception(
          'تنبيه: المبلغ المطلوب يتجاوز الميزانية المتبقية لمركز التكلفة ${budget.name}. المتبقي: ${remaining.toStringAsFixed(2)}',
        );
      }

      final consumption = (actualDecimal + expenseAmount) / budgetedDecimal;
      if (consumption >= Decimal.fromInt(9) / Decimal.fromInt(10)) {
        await notificationService.showNotification(
          costCenterId.hashCode,
          'تنبيه ميزانية',
          'مركز التكلفة ${budget.name} استهلك ${(consumption.toDouble() * 100).toStringAsFixed(0)}% من الميزانية المخصصة.',
        );
      }
    }
  }

  /// تحديث الميزانية عند تسجيل مصروف فعلي
  Future<void> updateActualBudget({
    required String costCenterId,
    required Decimal expenseAmount,
    required String period,
  }) async {
    final budgets = await (db.select(db.accBudgets)
          ..where((b) => b.costCenterId.equals(costCenterId))
          ..where((b) => b.period.equals(period)))
        .get();

    for (var budget in budgets) {
      final newActual =
          Decimal.parse(budget.actualAmount.toString()) + expenseAmount;
      await (db.update(db.accBudgets)..where((b) => b.id.equals(budget.id)))
          .write(AccBudgetsCompanion(
        actualAmount: Value(newActual),
        variance:
            Value(Decimal.parse(budget.budgetedAmount.toString()) - newActual),
      ));
    }
  }

  /// فحص جميع الميزانيات النشطة وإصدار تنبيهات للميزانيات التي تجاوزت الحد المحدد
  Future<List<AccBudget>> checkAllBudgets({double threshold = 0.9}) async {
    final budgets = await (db.select(db.accBudgets)
          ..where((b) => b.status.equals('active')))
        .get();

    final exceeded = <AccBudget>[];

    for (final budget in budgets) {
      final budgeted = Decimal.parse(budget.budgetedAmount.toString());
      if (budgeted == Decimal.zero) continue;

      final actual = Decimal.parse(budget.actualAmount.toString());
      final consumption = actual / budgeted;

      final thresholdDecimal = Decimal.parse(threshold.toStringAsFixed(2));
      if (consumption.toDouble() >= thresholdDecimal.toDouble()) {
        exceeded.add(budget);
        await notificationService.showNotification(
          budget.id,
          'تنبيه ميزانية: ${budget.name}',
          'الميزانية "${budget.name}" استهلكت ${(consumption.toDouble() * 100).toStringAsFixed(1)}% من إجمالي الميزانية للفترة ${budget.period}.',
        );
      }
    }

    return exceeded;
  }
}
