import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/accounting/accounting_service.dart';
import 'package:supermarket/core/services/accounting/accounting_period_service.dart';
import 'package:supermarket/core/services/accounting/budget_service.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/notification_service.dart';
import 'package:supermarket/core/services/accounting/currency_conversion_service.dart';
import 'package:supermarket/core/services/accounting/chart_of_accounts_service.dart';
import 'package:supermarket/core/services/accounting/depreciation_service.dart';
import 'package:supermarket/core/services/accounting/financial_closing_service.dart';
import 'package:supermarket/core/services/accounting/financial_control_service.dart';
import 'package:supermarket/core/services/accounting/financial_report_service.dart';
import 'package:supermarket/core/services/accounting/journal_service.dart';
import 'package:supermarket/core/services/accounting/vat_service.dart';
import 'package:supermarket/core/services/accounting/fixed_assets_service.dart';
import 'package:supermarket/core/services/accounting/zakat_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

void registerAccountingModule(GetIt sl) {
  final db = sl<AppDatabase>();

  sl.registerLazySingleton<AccountingPeriodService>(
    () => AccountingPeriodService(db),
  );
  sl.registerLazySingleton<BudgetService>(() => BudgetService(db, sl<NotificationService>()));
  sl.registerLazySingleton<CurrencyConversionService>(
    () => CurrencyConversionService(db),
  );
  sl.registerLazySingleton<AccountingService>(
    () => AccountingService(db),
  );
  sl.registerLazySingleton<ChartOfAccountsService>(
    () => ChartOfAccountsService(db),
  );
  sl.registerLazySingleton<FinancialReportService>(
    () => FinancialReportService(db),
  );
  sl.registerLazySingleton<VatService>(() => VatService(db));
  sl.registerLazySingleton<DepreciationService>(() => DepreciationService(db));
  sl.registerLazySingleton<JournalService>(() => JournalService(db));
  sl.registerLazySingleton<FinancialClosingService>(
    () => FinancialClosingService(db, sl<FinancialReportService>()),
  );
  sl.registerLazySingleton<FinancialControlService>(
    () => FinancialControlService(
      db,
      costingService: sl<InventoryCostingService>(),
    ),
  );
  sl.registerLazySingleton<FixedAssetsService>(
    () => FixedAssetsService(db),
  );
  sl.registerLazySingleton<ZakatService>(() => ZakatService(db));
}
