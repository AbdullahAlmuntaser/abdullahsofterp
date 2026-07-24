import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/sales_order_service.dart';
import 'package:supermarket/core/services/delivery_notes_service.dart';
import 'package:supermarket/core/services/invoice_service.dart';
import 'package:supermarket/core/services/credit_note_service.dart';
import 'package:supermarket/core/services/proforma_service.dart';
import 'package:supermarket/core/services/return_service.dart';
import 'package:supermarket/core/services/quick_customer_service.dart';
import 'package:supermarket/core/services/unified_statement_service.dart';
import 'package:supermarket/core/services/sales_commission_service.dart';
import 'package:supermarket/core/services/loyalty_service.dart';
import 'package:supermarket/core/services/pricing_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

void registerSalesModule(GetIt sl) {
  sl.registerLazySingleton<SalesOrderService>(
    () => SalesOrderService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<DeliveryNotesService>(
    () => DeliveryNotesService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<InvoiceService>(() => InvoiceService(sl<AppDatabase>()));
  sl.registerLazySingleton<CreditNoteService>(
    () => CreditNoteService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<ProformaService>(
    () => ProformaService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<ReturnService>(() => ReturnService(sl<AppDatabase>()));
  sl.registerLazySingleton<QuickCustomerService>(
    () => QuickCustomerService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<UnifiedStatementService>(
    () => UnifiedStatementService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<SalesCommissionService>(
    () => SalesCommissionService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<LoyaltyService>(
    () => LoyaltyService(sl<AppConfigService>()),
  );
  sl.registerLazySingleton<PricingService>(
    () => PricingService(sl<AppDatabase>()),
  );
}
