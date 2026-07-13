import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/daos/core_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/products_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/customers_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/suppliers_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/sales_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/purchases_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/inventory_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/accounting_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/financial_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/hr_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/manufacturing_dao.dart';
import 'package:supermarket/data/datasources/local/manual/daos/other_daos.dart';

class ManualDatabaseFactory {
  static ManualDatabaseFactory? _instance;
  late final ManualDatabase _database;
  late final CoreDao coreDao;
  late final ProductsDao productsDao;
  late final CustomersDao customersDao;
  late final SuppliersDao suppliersDao;
  late final SalesDao salesDao;
  late final PurchasesDao purchasesDao;
  late final InventoryDao inventoryDao;
  late final AccountingDao accountingDao;
  late final FinancialDao financialDao;
  late final HrDao hrDao;
  late final ManufacturingDao manufacturingDao;
  late final OtherDao otherDao;
  bool _initialized = false;

  ManualDatabaseFactory._();

  static ManualDatabaseFactory get instance {
    _instance ??= ManualDatabaseFactory._();
    return _instance!;
  }

  bool get isInitialized => _initialized;

  ManualDatabase get database => _database;

  /// Call once at app startup
  Future<void> initialize({String? encryptionKey}) async {
    if (_initialized) return;

    _database = ManualDatabase.instance;
    await _database.initialize(encryptionKey: encryptionKey);

    coreDao = CoreDao(_database);
    productsDao = ProductsDao(_database);
    customersDao = CustomersDao(_database);
    suppliersDao = SuppliersDao(_database);
    salesDao = SalesDao(_database);
    purchasesDao = PurchasesDao(_database);
    inventoryDao = InventoryDao(_database);
    accountingDao = AccountingDao(_database);
    financialDao = FinancialDao(_database);
    hrDao = HrDao(_database);
    manufacturingDao = ManufacturingDao(_database);
    otherDao = OtherDao(_database);

    _initialized = true;
  }

  /// Close database connection
  void close() {
    if (_initialized) {
      _database.close();
      _initialized = false;
    }
  }
}
