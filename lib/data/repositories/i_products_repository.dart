import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/products_dao.dart';

abstract class IProductsRepository {
  Stream<List<Product>> watchAllProducts();
  Future<List<Product>> getAllProducts();
  Stream<List<ProductWithCategory>> watchProducts({String? searchQuery, String? categoryId, int? limit, int? offset});
  Stream<List<Product>> watchLowStockProducts();
  Stream<int> watchLowStockCount();
  Future<Product?> getProductById(String id);
  Future<Product?> getProductBySku(String sku);
  Future<Product?> getProductByBarcode(String barcode);
  Future<int> addProduct(ProductsCompanion entry);
  Future<bool> updateProduct(Product entry);
  Future<int> deleteProduct(Product entry);
  Future<int> countProducts({String? searchQuery, String? categoryId});
  Future<List<ProductBatch>> getProductBatches(String productId, String warehouseId);
  Future<List<ProductBatch>> getBatchesByFefo(String productId, String warehouseId);
  Future<void> transferStock({required String fromWarehouseId, required String toWarehouseId, required List<TransferItemData> items, String? note});
  Future<List<Product>> getVariantsForProduct(String productId);
  Stream<List<Product>> watchVariantsForProduct(String productId);
  Future<ProductWithVariants?> getProductWithVariants(String productId);
  Stream<List<Warehouse>> watchWarehouses();
  Future<int> addWarehouse(WarehousesCompanion entry);
  Stream<List<Category>> watchCategories();
  Future<int> addCategory(CategoriesCompanion entry);
  Future<bool> updateCategory(Category entry);
  Future<int> deleteCategory(Category entry);
  Stream<List<ProductBatch>> watchExpiringBatches({int daysThreshold = 30});
  Future<List<ProductBatch>> getExpiringBatches({int daysThreshold = 30});
  Future<List<ProductBatch>> getExpiredBatches({required String warehouseId});
  Future<Decimal> getWarehouseStock(String productId, String warehouseId);
}
