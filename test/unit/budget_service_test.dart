import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/budget_service.dart';
import 'package:supermarket/core/services/notification_service.dart';

AppDatabase _createDb() => AppDatabase(NativeDatabase.memory());

void main() {
  group('BudgetService - validateExpenseAgainstBudget', () {
    late AppDatabase db;
    late BudgetService budgetService;
    late NotificationService notificationService;

    setUp(() async {
      db = _createDb();
      notificationService = NotificationService();
      budgetService = BudgetService(db, notificationService);

      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
        id: const Value('cc1'),
        name: 'قسم التطوير',
        code: 'DEV',
        isActive: const Value(true),
      ));

      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
        id: const Value('cc2'),
        name: 'قسم التسويق',
        code: 'MKT',
        isActive: const Value(true),
      ));
    });

    tearDown(() async {
      await db.close();
    });

    test('allows expense within budget', () async {
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التطوير',
        period: '2024-Q1',
        costCenterId: const Value('cc1'),
        budgetedAmount: Decimal.parse('10000'),
        variance: Decimal.parse('10000'),
      ));

      await expectLater(
        budgetService.validateExpenseAgainstBudget(
          costCenterId: 'cc1',
          expenseAmount: Decimal.parse('5000'),
          period: '2024-Q1',
        ),
        completes,
      );
    });

    test('throws when expense exceeds remaining budget', () async {
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التطوير',
        period: '2024-Q1',
        costCenterId: const Value('cc1'),
        budgetedAmount: Decimal.parse('10000'),
        actualAmount: Value(Decimal.parse('8000')),
        variance: Decimal.parse('2000'),
      ));

      await expectLater(
        budgetService.validateExpenseAgainstBudget(
          costCenterId: 'cc1',
          expenseAmount: Decimal.parse('3000'),
          period: '2024-Q1',
        ),
        throwsException,
      );
    });

    test('sends notification when consumption exceeds 90%', () async {
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التسويق',
        period: '2024',
        costCenterId: const Value('cc2'),
        budgetedAmount: Decimal.parse('10000'),
        actualAmount: Value(Decimal.parse('8500')),
        variance: Decimal.parse('1500'),
      ));

      expect(notificationService.notifications, isEmpty);

      await budgetService.validateExpenseAgainstBudget(
        costCenterId: 'cc2',
        expenseAmount: Decimal.parse('1000'),
        period: '2024',
      );

      expect(notificationService.notifications.length, equals(1));
      expect(
        notificationService.notifications.first.category,
        equals('system'),
      );
      expect(
        notificationService.notifications.first.severity,
        equals('warning'),
      );
    });

    test('allows expense exactly equal to remaining budget', () async {
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التطوير',
        period: '2024-Q1',
        costCenterId: const Value('cc1'),
        budgetedAmount: Decimal.parse('10000'),
        actualAmount: Value(Decimal.parse('7000')),
        variance: Decimal.parse('3000'),
      ));

      await expectLater(
        budgetService.validateExpenseAgainstBudget(
          costCenterId: 'cc1',
          expenseAmount: Decimal.parse('3000'),
          period: '2024-Q1',
        ),
        completes,
      );
    });

    test('completes when no budget exists for the period', () async {
      await expectLater(
        budgetService.validateExpenseAgainstBudget(
          costCenterId: 'cc1',
          expenseAmount: Decimal.parse('100'),
          period: '2025',
        ),
        completes,
      );
    });
  });

  group('BudgetService - updateActualBudget', () {
    late AppDatabase db;
    late BudgetService budgetService;
    late NotificationService notificationService;

    setUp(() async {
      db = _createDb();
      notificationService = NotificationService();
      budgetService = BudgetService(db, notificationService);

      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
        id: const Value('cc1'),
        name: 'قسم التطوير',
        code: 'DEV',
        isActive: const Value(true),
      ));

      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التطوير',
        period: '2024',
        costCenterId: const Value('cc1'),
        budgetedAmount: Decimal.parse('50000'),
        variance: Decimal.parse('40000'),
      ));
    });

    tearDown(() async {
      await db.close();
    });

    test('updates actual amount and variance correctly', () async {
      await budgetService.updateActualBudget(
        costCenterId: 'cc1',
        expenseAmount: Decimal.parse('5000'),
        period: '2024',
      );

      final budgets = await (db.select(db.accBudgets)).get();
      expect(budgets.length, equals(1));
      expect(budgets.first.actualAmount, equals(Decimal.parse('5000')));
      expect(budgets.first.variance, equals(Decimal.parse('45000')));
    });

    test('handles multiple expenses', () async {
      await budgetService.updateActualBudget(
        costCenterId: 'cc1',
        expenseAmount: Decimal.parse('5000'),
        period: '2024',
      );
      await budgetService.updateActualBudget(
        costCenterId: 'cc1',
        expenseAmount: Decimal.parse('3000'),
        period: '2024',
      );

      final budgets = await (db.select(db.accBudgets)).get();
      expect(budgets.first.actualAmount, equals(Decimal.parse('8000')));
      expect(budgets.first.variance, equals(Decimal.parse('42000')));
    });

    test('does nothing when no matching budget', () async {
      await budgetService.updateActualBudget(
        costCenterId: 'cc1',
        expenseAmount: Decimal.parse('5000'),
        period: '2025',
      );

      final budgets = await (db.select(db.accBudgets)).get();
      expect(budgets.length, equals(1));
      expect(budgets.first.actualAmount, equals(Decimal.parse('0')));
    });
  });

  group('BudgetService - checkAllBudgets', () {
    late AppDatabase db;
    late BudgetService budgetService;
    late NotificationService notificationService;

    setUp(() async {
      db = _createDb();
      notificationService = NotificationService();
      budgetService = BudgetService(db, notificationService);

      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
        id: const Value('cc1'),
        name: 'قسم التطوير',
        code: 'DEV',
        isActive: const Value(true),
      ));
      await db.into(db.costCenters).insert(CostCentersCompanion.insert(
        id: const Value('cc2'),
        name: 'قسم التسويق',
        code: 'MKT',
        isActive: const Value(true),
      ));

      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التطوير',
        period: '2024',
        costCenterId: const Value('cc1'),
        budgetedAmount: Decimal.parse('50000'),
        variance: Decimal.parse('40000'),
      ));
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية التسويق',
        period: '2024',
        costCenterId: const Value('cc2'),
        budgetedAmount: Decimal.parse('30000'),
        actualAmount: Value(Decimal.parse('28000')),
        variance: Decimal.parse('2000'),
      ));
      await db.into(db.accBudgets).insert(AccBudgetsCompanion.insert(
        name: 'ميزانية الأبحاث',
        period: '2024',
        budgetedAmount: Decimal.parse('20000'),
        actualAmount: Value(Decimal.parse('19000')),
        variance: Decimal.parse('1000'),
      ));
    });

    tearDown(() async {
      await db.close();
    });

    test('returns budgets exceeding threshold', () async {
      final result = await budgetService.checkAllBudgets(threshold: 0.8);

      expect(result.length, equals(2));
      expect(result.any((b) => b.name == 'ميزانية التسويق'), isTrue);
      expect(result.any((b) => b.name == 'ميزانية الأبحاث'), isTrue);
      expect(result.any((b) => b.name == 'ميزانية التطوير'), isFalse);
    });

    test('returns empty when all budgets are within threshold', () async {
      final result = await budgetService.checkAllBudgets(threshold: 0.96);
      expect(result, isEmpty);
    });

    test('sends notification for each exceeded budget', () async {
      await budgetService.checkAllBudgets(threshold: 0.7);

      expect(notificationService.notifications.length, equals(2));
    });
  });
}
