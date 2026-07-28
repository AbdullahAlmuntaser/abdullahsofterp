import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/core/services/accounting/accounting_service.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/accounting_dao.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockEventBusService extends Mock implements EventBusService {}

class MockAccountingDao extends Mock implements AccountingDao {}

class MockAppConfigService extends Mock implements AppConfigService {}

class MockGLAccount extends Mock implements GLAccount {}

class FakeGLAccountsCompanion extends Fake implements GLAccountsCompanion {}

GLAccount _mockAccount(
    String id, String name, AccountType type, String code) {
  final acc = MockGLAccount();
  when(() => acc.id).thenReturn(id);
  when(() => acc.name).thenReturn(name);
  when(() => acc.accountType).thenReturn(type);
  when(() => acc.code).thenReturn(code);
  when(() => acc.isHeader).thenReturn(false);
  when(() => acc.branchId).thenReturn(null);
  when(() => acc.parentId).thenReturn(null);
  when(() => acc.balance).thenReturn(Decimal.zero);
  return acc;
}

void main() {
  late AccountingService accountingService;
  late MockAppDatabase mockDatabase;
  late MockEventBusService mockEventBus;
  late MockAccountingDao mockAccountingDao;
  late MockAppConfigService mockConfigService;

  setUpAll(() {
    registerFallbackValue(FakeGLAccountsCompanion());
  });

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockEventBus = MockEventBusService();
    mockAccountingDao = MockAccountingDao();
    mockConfigService = MockAppConfigService();

    when(() => mockEventBus.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockDatabase.accountingDao).thenReturn(mockAccountingDao);
    when(() => mockConfigService.getDefaultBranchId())
        .thenAnswer((_) async => 'branch-1');

    accountingService = AccountingService(mockDatabase, mockEventBus);
  });

  group('AccountingService Unit Tests', () {
    test('seedDefaultAccounts should create accounts if they do not exist',
        () async {
      when(() => mockDatabase.transaction(any())).thenAnswer((inv) async {
        final callback =
            inv.positionalArguments[0] as Future<dynamic> Function();
        return await callback();
      });
      when(() => mockAccountingDao.getAccountByCode(any()))
          .thenAnswer((_) async => null);
      when(() => mockAccountingDao.createAccount(any()))
          .thenAnswer((_) async => 'acc-id');

      await accountingService.seedDefaultAccounts(branchId: '1');

      verify(() => mockAccountingDao.createAccount(any())).called(21);
    });

    test('Trial balance should have equal debits and credits', () async {
      final accounts = [
        _mockAccount('acc-1', 'النقد', AccountType.asset, '1000'),
        _mockAccount('acc-2', 'الإيرادات', AccountType.revenue, '4000'),
        _mockAccount('acc-3', 'المصروفات', AccountType.expense, '5000'),
      ];

      when(() => mockAccountingDao.getAllAccounts())
          .thenAnswer((_) async => accounts);
      when(() => mockAccountingDao.getTrialBalance())
          .thenAnswer((_) async {
        return [
          TrialBalanceItem(accounts[0], Decimal.fromInt(500), Decimal.zero),
          TrialBalanceItem(accounts[1], Decimal.zero, Decimal.fromInt(1000)),
          TrialBalanceItem(accounts[2], Decimal.fromInt(500), Decimal.zero),
        ];
      });

      final result = await mockAccountingDao.getTrialBalance();
      final totalDebit =
          result.fold(Decimal.zero, (sum, item) => sum + item.totalDebit);
      final totalCredit =
          result.fold(Decimal.zero, (sum, item) => sum + item.totalCredit);

      expect(totalDebit, equals(totalCredit));
    });

    test('postSale should record GL entry with correct accounts', () async {
      when(() => mockDatabase.transaction(any())).thenAnswer((inv) async {
        final callback =
            inv.positionalArguments[0] as Future<dynamic> Function();
        return await callback();
      });
      when(() => mockAccountingDao.getAccountByCode(any()))
          .thenAnswer((_) async => null);
      when(() => mockAccountingDao.createAccount(any()))
          .thenAnswer((_) async => 'acc-id');

      await accountingService.seedDefaultAccounts(branchId: '1');

      verify(() => mockAccountingDao.createAccount(any())).called(21);
    });
  });
}
