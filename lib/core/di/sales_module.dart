import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/sales/sales_order_service.dart';
import 'package:supermarket/core/services/sales/delivery_notes_service.dart';
import 'package:supermarket/core/services/sales/invoice_service.dart';
import 'package:supermarket/core/services/sales/credit_note_service.dart';
import 'package:supermarket/core/services/sales/proforma_service.dart';
import 'package:supermarket/core/services/sales/return_service.dart';
import 'package:supermarket/core/services/sales/quick_customer_service.dart';
import 'package:supermarket/core/services/sales/unified_statement_service.dart';
import 'package:supermarket/core/services/sales/sales_commission_service.dart';
import 'package:supermarket/core/services/sales/loyalty_service.dart';
import 'package:supermarket/core/services/sales/pricing_service.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/sales_dao.dart';
import 'package:supermarket/data/repositories/i_sales_repository.dart';

void registerSalesModule(GetIt sl) {
  final db = sl<AppDatabase>();

  sl.registerLazySingleton<ISalesRepository>(() => SalesDao(db));

  sl.registerLazySingleton<SalesOrderService>(
      () => SalesOrderService(db, sl<TransactionEngine>()));
  sl.registerLazySingleton<DeliveryNotesService>(() => DeliveryNotesService(db));
  sl.registerLazySingleton<InvoiceService>(() => InvoiceService(db));
  sl.registerLazySingleton<CreditNoteService>(() => CreditNoteService(db));
  sl.registerLazySingleton<ProformaService>(() => ProformaService(db));
  sl.registerLazySingleton<ReturnService>(() => ReturnService(db));
  sl.registerLazySingleton<QuickCustomerService>(() => QuickCustomerService(db));
  sl.registerLazySingleton<UnifiedStatementService>(() => UnifiedStatementService(db));
  sl.registerLazySingleton<SalesCommissionService>(() => SalesCommissionService(db));
  sl.registerLazySingleton<LoyaltyService>(() => LoyaltyService(sl<AppConfigService>()));
  sl.registerLazySingleton<PricingService>(() => PricingService(db));
}
