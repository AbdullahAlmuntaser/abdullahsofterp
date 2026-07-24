import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/inventory_costing_service.dart';
import 'package:supermarket/core/services/budget_service.dart';
import 'package:supermarket/core/services/approval_workflow_service.dart';
import 'package:supermarket/core/services/serial_number_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockEventBusService extends Mock implements EventBusService {}

class MockPostingEngine extends Mock implements PostingEngine {}

class MockPackagingEngine extends Mock implements PackagingEngine {}

class MockInventoryCostingService extends Mock
    implements InventoryCostingService {}

class MockBudgetService extends Mock implements BudgetService {}

class MockApprovalWorkflowService extends Mock
    implements ApprovalWorkflowService {}

class MockSerialNumberService extends Mock implements SerialNumberService {}

void main() {
  late TransactionEngine transactionEngine;
  late MockAppDatabase mockDb;
  late MockEventBusService mockEventBus;
  late MockPostingEngine mockPostingEngine;
  late MockPackagingEngine mockPackaging;
  late MockInventoryCostingService mockCosting;

  setUpAll(() {
    registerFallbackValue(MockAppDatabase());
  });

  setUp(() {
    mockDb = MockAppDatabase();
    mockEventBus = MockEventBusService();
    mockPostingEngine = MockPostingEngine();
    mockPackaging = MockPackagingEngine();
    mockCosting = MockInventoryCostingService();

    transactionEngine = TransactionEngine(
      mockDb,
      mockEventBus,
      mockPostingEngine,
      mockPackaging,
      mockCosting,
    );
  });

  group('TransactionEngine - Construction', () {
    test('can be created with dependencies', () {
      expect(transactionEngine, isNotNull);
    });

    test('setBudgetService works', () {
      final mockBudgetService = MockBudgetService();
      expect(
        () => transactionEngine.setBudgetService(mockBudgetService),
        returnsNormally,
      );
    });

    test('setApprovalService works', () {
      final mockApprovalService = MockApprovalWorkflowService();
      expect(
        () => transactionEngine.setApprovalService(mockApprovalService),
        returnsNormally,
      );
    });

    test('setSerialNumberService works', () {
      final mockSerialService = MockSerialNumberService();
      expect(
        () => transactionEngine.setSerialNumberService(mockSerialService),
        returnsNormally,
      );
    });
  });
}
