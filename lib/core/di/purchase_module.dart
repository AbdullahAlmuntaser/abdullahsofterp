import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/purchases/purchase_service.dart';
import 'package:supermarket/core/services/purchases/purchase_converter.dart';
import 'package:supermarket/core/services/purchases/grn_service.dart';
import 'package:supermarket/core/services/purchases/supplier_analytics_service.dart';
import 'package:supermarket/core/services/purchases/aging_service.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/purchases_dao.dart';
import 'package:supermarket/data/repositories/i_purchases_repository.dart';

void registerPurchaseModule(GetIt sl) {
  final db = sl<AppDatabase>();

  sl.registerLazySingleton<IPurchasesRepository>(() => PurchasesDao(db));

  sl.registerLazySingleton<PurchaseService>(
    () => PurchaseService(db, sl<TransactionEngine>(),
        sl<InventoryCostingService>(), sl<AppConfigService>()),
  );
  sl.registerLazySingleton<PurchaseConverter>(() => PurchaseConverter(db));
  sl.registerLazySingleton<GrnService>(() => GrnService(db));
  sl.registerLazySingleton<SupplierAnalyticsService>(() => SupplierAnalyticsService(db));
  sl.registerLazySingleton<AgingService>(() => AgingService(db));
}
