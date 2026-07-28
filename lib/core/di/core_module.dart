import 'package:get_it/get_it.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/products_dao.dart';
import 'package:supermarket/data/datasources/local/daos/product_units_dao.dart';
import 'package:supermarket/data/datasources/local/daos/stock_movement_dao.dart';
import 'package:supermarket/data/datasources/local/daos/audit_dao.dart';
import 'package:supermarket/data/datasources/local/daos/customers_dao.dart';
import 'package:supermarket/data/datasources/local/daos/suppliers_dao.dart';
import 'package:supermarket/data/datasources/local/daos/accounting_dao.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/services/app_settings_service.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/security_service.dart';
import 'package:supermarket/core/services/permission_service.dart';
import 'package:supermarket/core/services/approval_workflow_service.dart';
import 'package:supermarket/core/services/reconciliation_service.dart';
import 'package:supermarket/core/services/report_engine_service.dart';
import 'package:supermarket/core/services/dashboard_service.dart';
import 'package:supermarket/core/services/analytics_service.dart';
import 'package:supermarket/core/services/notification_service.dart';
import 'package:supermarket/core/services/thermal_printer_service.dart';
import 'package:supermarket/core/services/backup/backup_service.dart';
import 'package:supermarket/core/services/cash_management_service.dart';
import 'package:supermarket/core/services/transfer_service.dart';
import 'package:supermarket/core/services/tax_service.dart';
import 'package:supermarket/core/services/accounting/withholding_tax_service.dart';
import 'package:supermarket/core/services/bom_service.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/pdf_service.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/accounting/budget_service.dart';
import 'package:supermarket/data/repositories/i_products_repository.dart';
import 'package:supermarket/data/repositories/i_accounting_repository.dart';
import 'package:supermarket/data/repositories/i_customers_repository.dart';
import 'package:supermarket/data/repositories/i_suppliers_repository.dart';

void registerCoreModule(GetIt sl) {
  final db = sl<AppDatabase>();

  // DAOs
  sl.registerLazySingleton<ProductsDao>(() => ProductsDao(db));
  sl.registerLazySingleton<ProductUnitsDao>(() => ProductUnitsDao(db));
  sl.registerLazySingleton<StockMovementDao>(() => StockMovementDao(db));
  sl.registerLazySingleton<AuditDao>(() => AuditDao(db));

  // Repositories (interfaces → concrete DAOs)
  sl.registerLazySingleton<IProductsRepository>(() => sl<ProductsDao>());
  sl.registerLazySingleton<IAccountingRepository>(() => AccountingDao(db));
  sl.registerLazySingleton<ICustomersRepository>(() => CustomersDao(db));
  sl.registerLazySingleton<ISuppliersRepository>(() => SuppliersDao(db));

  // Core services
  sl.registerLazySingleton<EventBusService>(() => EventBusService());
  sl.registerLazySingleton<AuditService>(() => AuditService(db));
  sl.registerLazySingleton<AppConfigService>(() => AppConfigService(db));
  sl.registerLazySingleton<AppSettingsService>(() => AppSettingsService(db));
  sl.registerLazySingleton<SecurityService>(() => SecurityService(db));
  sl.registerLazySingleton<PermissionService>(
    () => PermissionService(db, auditLogService: sl<AuditService>()),
  );
  sl.registerLazySingleton<ApprovalWorkflowService>(
    () => ApprovalWorkflowService(db, auditLogService: sl<AuditService>()),
  );
  sl.registerLazySingleton<ReconciliationService>(
    () => ReconciliationService(db),
  );
  sl.registerLazySingleton<ReportEngineService>(
    () => ReportEngineService(db),
  );
  sl.registerLazySingleton<DashboardService>(() => DashboardService(db));
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService(db));
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<PdfInvoiceService>(() => PdfInvoiceService());
  sl.registerLazySingleton<ThermalPrinterService>(
    () => ThermalPrinterService(),
  );
  sl.registerLazySingleton<BackupService>(() => BackupService(db));
  sl.registerLazySingleton<CashManagementService>(
    () => CashManagementService(db, sl<PostingEngine>()),
  );
  sl.registerLazySingleton<TransferService>(() => TransferService(db));
  sl.registerLazySingleton<TaxService>(() => TaxService(sl<AppSettingsService>()));
  sl.registerLazySingleton<WithholdingTaxService>(
    () => WithholdingTaxService(db),
  );
  sl.registerLazySingleton<BomService>(() => BomService(db));
  sl.registerLazySingleton<PackagingEngine>(() => PackagingEngine(db));

  // Engines
  sl.registerLazySingleton<InventoryCostingService>(
    () => InventoryCostingService(sl<StockMovementDao>(), db),
  );
  sl.registerLazySingleton<PostingEngine>(
    () => PostingEngine(db, costingService: sl<InventoryCostingService>()),
  );
  sl.registerLazySingleton<TransactionEngine>(() {
    final eventBus = sl<EventBusService>();
    final postingEngine = sl<PostingEngine>();
    final packagingEngine = sl<PackagingEngine>();
    final costingService = sl<InventoryCostingService>();
    final engine = TransactionEngine(
      db,
      eventBus,
      postingEngine,
      packagingEngine,
      costingService,
    );
    engine.setBudgetService(sl<BudgetService>());
    engine.setApprovalService(sl<ApprovalWorkflowService>());
    return engine;
  });
}

