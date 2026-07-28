import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/suppliers_dao.dart';

abstract class ISuppliersRepository {
  Stream<List<Supplier>> watchAllSuppliers();
  Future<Supplier?> getSupplierById(String id);
  Future<String> insertSupplierWithAccount(SuppliersCompanion entry);
  Future<bool> updateSupplier(Supplier entry);
  Future<int> deleteSupplier(Supplier entry);
  Future<List<Supplier>> searchSuppliers(String query);
  Future<List<SupplierTransaction>> getSupplierStatement(String supplierId);
}
