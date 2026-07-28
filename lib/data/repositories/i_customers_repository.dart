import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/customers_dao.dart';

abstract class ICustomersRepository {
  Stream<List<Customer>> watchAllCustomers();
  Stream<int> watchTotalCustomers();
  Future<Customer?> getCustomerById(String id);
  Future<String> insertCustomerWithAccount(CustomersCompanion entry);
  Future<bool> updateCustomer(Customer entry);
  Future<int> deleteCustomer(Customer entry);
  Future<List<Customer>> searchCustomers(String query);
  Future<List<CustomerSearchResult>> smartSearchCustomers(String query);
  Future<Customer?> findByNormalizedName(String name);
  Future<String> createQuickCustomer(String name, {String? phone});
  Future<List<Customer>> getQuickCustomers();
  Stream<List<Customer>> watchRegularCustomers();
  Future<List<CustomerTransaction>> getCustomerStatement(String customerId);
  Future<List<CustomerPayment>> getPaymentsForCustomer(String customerId);
}
