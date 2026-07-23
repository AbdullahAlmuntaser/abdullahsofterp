import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/concurrency_exception.dart';

class ProductWithCategory {
  final Product product;
  final Category? category;

  ProductWithCategory({required this.product, this.category});
}

class TransferItemData {
  final String productId;
  final String batchId;
  final double quantity;

  TransferItemData({
    required this.productId,
    required this.batchId,
    required this.quantity,
  });
}

class ProductsDao extends DatabaseAccessor<AppDatabase> {
  ProductsDao(super.db);

  Stream<List<Product>> watchAllProducts() {
    return select(db.products).watch();
  }

  Future<List<Product>> getAllProducts() {
    return select(db.products).get();
  }

  // ========== Warehouse & Batch Management ==========
  Stream<List<Warehouse>> watchWarehouses() {
    return select(db.warehouses).watch();
  }

  Future<int> addWarehouse(WarehousesCompanion entry) {
    return into(db.warehouses).insert(entry);
  }

  Future<List<ProductBatch>> getProductBatches(
    String productId,
    String warehouseId,
  ) {
    return (select(db.productBatches)
          ..where(
            (b) =>
                b.productId.equals(productId) &
                b.warehouseId.equals(warehouseId) &
                b.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
          ))
        .get();
  }

  Future<List<ProductBatch>> getBatchesByFefo(
    String productId,
    String warehouseId,
  ) {
    return (select(db.productBatches)
          ..where(
            (b) =>
                b.productId.equals(productId) &
                b.warehouseId.equals(warehouseId) &
                b.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
          )
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.expiryDate,
                  mode: OrderingMode.asc,
                ),
          ]))
        .get();
  }

  /// تنفيذ عملية تحويل مخزني بين مستودعين
  Future<void> transferStock({
    required String fromWarehouseId,
    required String toWarehouseId,
    required List<TransferItemData> items,
    String? note,
  }) async {
    await transaction(() async {
      final transfer = await into(db.stockTransfers).insertReturning(
        StockTransfersCompanion.insert(
          fromWarehouseId: fromWarehouseId,
          toWarehouseId: toWarehouseId,
          note: Value(note),
          transferDate: Value(DateTime.now()),
        ),
      );

      final transferId = transfer.id;

      for (var item in items) {
        final sourceBatch = await (select(db.productBatches)..where((b) => b.id.equals(item.batchId)))
            .getSingle();

        final itemQuantityDecimal = Decimal.parse(item.quantity.toString());
        if (sourceBatch.quantity < itemQuantityDecimal) {
          throw Exception('الكمية المطلوبة غير متوفرة في الدفعة المحددة');
        }

        final changes = await (update(db.productBatches)..where((b) => b.id.equals(item.batchId) & b.version.equals(sourceBatch.version)))
            .write(
          ProductBatchesCompanion(
            quantity: Value(sourceBatch.quantity - itemQuantityDecimal),
          ).copyWith(version: Value(sourceBatch.version + 1)),
        );
        if (changes == 0) {
          throw ConcurrencyException('ProductBatch ${item.batchId} was modified by another transaction');
        }

        final targetBatch = await (select(db.productBatches)
              ..where(
                (b) =>
                    b.productId.equals(item.productId) &
                    b.warehouseId.equals(toWarehouseId) &
                    b.batchNumber.equals(sourceBatch.batchNumber),
              ))
            .getSingleOrNull();

        if (targetBatch != null) {
          final changes = await (update(db.productBatches)..where((b) => b.id.equals(targetBatch.id) & b.version.equals(targetBatch.version)))
              .write(
            ProductBatchesCompanion(
              quantity: Value(targetBatch.quantity + itemQuantityDecimal),
            ).copyWith(version: Value(targetBatch.version + 1)),
          );
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch ${targetBatch.id} was modified by another transaction');
          }
        } else {
          await into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              productId: item.productId,
              warehouseId: toWarehouseId,
              batchNumber: sourceBatch.batchNumber,
              expiryDate: Value(sourceBatch.expiryDate),
              quantity: Value(itemQuantityDecimal),
              initialQuantity: Value(itemQuantityDecimal),
              costPrice: Value(sourceBatch.costPrice),
            ),
          );
        }

        await into(db.stockTransferItems).insert(
          StockTransferItemsCompanion.insert(
            transferId: transferId,
            productId: item.productId,
            batchId: item.batchId,
            quantity: Value(Decimal.parse(item.quantity.toString())),
          ),
        );
      }
    });
  }

  Future<int> countProducts({String? searchQuery, String? categoryId}) async {
    final query = selectOnly(db.products);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
        db.products.name.like('%$searchQuery%') |
            db.products.sku.like('%$searchQuery%') |
            db.products.barcode.like('%$searchQuery%'),
      );
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      query.where(db.products.categoryId.equals(categoryId));
    }
    final countExp = db.products.id.count();
    query.addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  // ========== Products (Items) Operations ==========
  Stream<List<ProductWithCategory>> watchProducts({
    String? searchQuery,
    String? categoryId,
    int? limit,
    int? offset,
  }) {
    final query = select(db.products).join([
      leftOuterJoin(db.categories, db.categories.id.equalsExp(db.products.categoryId)),
    ]);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
        db.products.name.like('%$searchQuery%') |
            db.products.sku.like('%$searchQuery%') |
            db.products.barcode.like('%$searchQuery%'),
      );
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      query.where(db.products.categoryId.equals(categoryId));
    }

    query.orderBy([OrderingTerm.asc(db.products.name)]);

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return query.watch().map((rows) {
      return rows.map((row) {
        return ProductWithCategory(
          product: row.readTable(db.products),
          category: row.readTableOrNull(db.categories),
        );
      }).toList();
    });
  }

  Stream<List<Product>> watchLowStockProducts() {
    return (select(db.products)..where((p) => p.stock.isSmallerOrEqual(p.alertLimit)))
        .watch();
  }

  Stream<int> watchLowStockCount() {
    final query = select(db.products)
      ..where((p) => p.stock.isSmallerOrEqual(p.alertLimit));
    return query.watch().map((list) => list.length);
  }

  Future<Product?> getProductById(String id) {
    return (select(db.products)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<Product?> getProductBySku(String sku) {
    return (select(db.products)..where((p) => p.sku.equals(sku)))
        .getSingleOrNull();
  }

  Future<Product?> getProductByBarcode(String barcode) {
    return (select(db.products)..where((p) => p.barcode.equals(barcode)))
        .get()
        .then((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<int> addProduct(ProductsCompanion entry) {
    return into(db.products).insert(entry);
  }

  Future<bool> updateProduct(Product entry) {
    return update(db.products).replace(entry);
  }

  Future<int> deleteProduct(Product entry) {
    return delete(db.products).delete(entry);
  }

  // ========== Variant Operations ==========
  /// Get all variants for a specific product (parent)
  Future<List<Product>> getVariantsForProduct(String productId) {
    return (select(db.products)..where((p) => p.parentProductId.equals(productId)))
        .get();
  }

  /// Stream variants for a product
  Stream<List<Product>> watchVariantsForProduct(String productId) {
    return (select(db.products)..where((p) => p.parentProductId.equals(productId)))
        .watch();
  }

  /// Get a product with its variants (returns the parent)
  Future<ProductWithVariants?> getProductWithVariants(String productId) async {
    final product = await getProductById(productId);
    if (product == null) return null;
    final variants = await getVariantsForProduct(productId);
    return ProductWithVariants(product: product, variants: variants);
  }

  // ========== Categories ==========
  Stream<List<Category>> watchCategories() {
    return select(db.categories).watch();
  }

  Future<int> addCategory(CategoriesCompanion entry) {
    return into(db.categories).insert(entry);
  }

  Future<bool> updateCategory(Category entry) {
    return update(db.categories).replace(entry);
  }

  Future<int> deleteCategory(Category entry) {
    return delete(db.categories).delete(entry);
  }

  // ========== Expiring Batches ==========
  Stream<List<ProductBatch>> watchExpiringBatches({int daysThreshold = 30}) {
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
    return (select(db.productBatches)
          ..where(
            (b) =>
                b.expiryDate.isSmallerOrEqual(Variable(thresholdDate)) &
                b.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.expiryDate, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Future<List<ProductBatch>> getExpiringBatches({
    int daysThreshold = 30,
  }) async {
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
    return (select(db.productBatches)
          ..where(
            (b) =>
                b.expiryDate.isSmallerOrEqual(Variable(thresholdDate)) &
                b.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.expiryDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<List<ProductBatch>> getExpiredBatches({
    required String warehouseId,
  }) async {
    final now = DateTime.now();
    return (select(db.productBatches)
          ..where(
            (b) =>
                b.warehouseId.equals(warehouseId) &
                b.expiryDate.isSmallerOrEqual(Variable(now)) &
                b.quantity.isBiggerThan(Variable(Decimal.zero.toString())),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.expiryDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<Decimal> getWarehouseStock(String productId, String warehouseId) async {
    final batches = await (select(db.productBatches)
          ..where((b) =>
              b.productId.equals(productId) &
              b.warehouseId.equals(warehouseId) &
              b.quantity.isBiggerThan(Variable(Decimal.zero.toString()))))
        .get();
    return batches.fold<Decimal>(
      Decimal.zero,
      (sum, b) => sum + (b.quantity - b.reservedQuantity),
    );
  }
}

/// Helper class to return a product with its variants
class ProductWithVariants {
  final Product product;
  final List<Product> variants;

  ProductWithVariants({required this.product, required this.variants});
}
