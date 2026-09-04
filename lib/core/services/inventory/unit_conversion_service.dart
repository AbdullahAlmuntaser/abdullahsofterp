import 'package:supermarket/core/exceptions/app_exception.dart';
import 'package:supermarket/data/datasources/local/daos/products_dao.dart';
import 'package:supermarket/data/datasources/local/daos/product_units_dao.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';

/// Service for handling unit conversions across the system.
/// Each product has a user-defined base unit (e.g., كرتون، شدة، صندوق، حبة).
/// Additional units are defined with conversion factors relative to the base unit.
/// All quantities are stored in base units internally.
/// This service handles conversion logic and can work with DB-accessed unit data.
class UnitConversionService {
  final ProductsDao productsDao;
  final ProductUnitsDao productUnitsDao;

  UnitConversionService({
    required this.productsDao,
    required this.productUnitsDao,
  });

  /// Convert a quantity from base unit to target unit
  /// [baseQuantity] is the quantity in base units
  /// [unitName] is the name of the unit to convert TO
  Future<Decimal> convertFromBaseUnit({
    required String productId,
    required Decimal baseQuantity,
    required String unitName,
  }) async {
    if (baseQuantity == Decimal.zero) return Decimal.zero;
    final product = await productsDao.getProductById(productId);
    if (product == null) throw const BusinessException(message: 'Product not found');

    // If converting to base unit, return as-is
    if (unitName == product.unit) return baseQuantity;

    // Get units for this product
    final productUnits = await productUnitsDao.getUnitsForProduct(productId);
    final targetUnit = productUnits.firstWhere(
      (u) => u.unitName == unitName,
      orElse: () => throw BusinessException(message: 'Unit "$unitName" not found for product'),
    );

    // Convert: baseQuantity / targetUnit.unitFactor
    // If 1 كيس = 10 قطم, and we have 50 قطم (base), then in كيس it's 50/10 = 5 كيس
    return baseQuantity / targetUnit.unitFactor;
  }

  /// Convert a quantity from a unit to base unit
  /// [quantity] is the quantity in the source unit
  /// [unitName] is the name of the source unit
  Future<Decimal> convertToBaseUnit({
    required String productId,
    required Decimal quantity,
    required String unitName,
  }) async {
    if (quantity == Decimal.zero) return Decimal.zero;
    final product = await productsDao.getProductById(productId);
    if (product == null) throw const BusinessException(message: 'Product not found');

    // If already in base unit, return as-is
    if (unitName == product.unit) return quantity;

    // Get units for this product
    final productUnits = await productUnitsDao.getUnitsForProduct(productId);
    final sourceUnit = productUnits.firstWhere(
      (u) => u.unitName == unitName,
      orElse: () => throw BusinessException(message: 'Unit "$unitName" not found for product'),
    );

    // Convert: quantity * sourceUnit.unitFactor
    // If 1 كيس = 10 قطم, and we have 5 كيس, then in قطم it's 5 * 10 = 50 قطم
    return quantity * sourceUnit.unitFactor;
  }

  /// Get all available units for a product including base unit
  /// [productUnits] should be fetched from DB by the caller (already as List<ProductUnit>)
  List<ProductUnit> getProductUnits({
    required String productId,
    /// List of product units from database
    required List<ProductUnit> productUnits,
  }) {
    // Note: productId is not used here since productUnits are passed in
    // The product.unit is assumed to be the base unit

    // Build complete list including base unit
    final allUnits = <ProductUnit>[];

    // Add base unit first
    // The first unit in the list with isBaseUnit=true, or use empty defaults
    final baseUnit = productUnits.firstWhere(
      (u) => u.isBaseUnit,
      orElse: () => ProductUnit(
        id: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 1,
        version: 1,
        productId: productId,
        unitName: 'حبة', // default base unit
        barcode: '',
        unitFactor: Decimal.one,
        isBaseUnit: true,
        isDefault: false,
        buyPrice: Decimal.zero,
        sellPrice: Decimal.zero,
        wholesalePrice: Decimal.zero,
        halfWholesalePrice: Decimal.zero,
      ),
    );

    allUnits.add(baseUnit);

    // Add custom units from the provided list
    for (final pu in productUnits) {
      allUnits.add(ProductUnit(
        id: pu.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 1,
        version: 1,
        productId: pu.productId,
        unitName: pu.unitName,
        barcode: pu.barcode,
        unitFactor: pu.unitFactor,
        isBaseUnit: pu.isBaseUnit,
        isDefault: pu.isDefault,
        buyPrice: pu.buyPrice ?? Decimal.zero,
        sellPrice: pu.sellPrice ?? Decimal.zero,
        wholesalePrice: pu.wholesalePrice ?? Decimal.zero,
        halfWholesalePrice: pu.halfWholesalePrice ?? Decimal.zero,
      ));
    }

    // Sort by unitFactor descending (largest factor first)
    allUnits.sort((a, b) => b.unitFactor.compareTo(a.unitFactor));

    return allUnits;
  }

  /// Add a new custom unit to a product
  Future<void> addProductUnit({
    required String productId,
    required String unitName,
    required Decimal conversionFactor,
    String? barcode,
    Decimal? buyPrice,
    Decimal? sellPrice,
    Decimal? wholesalePrice,
    Decimal? halfWholesalePrice,
  }) async {
    final product = await productsDao.getProductById(productId);
    if (product == null) throw const BusinessException(message: 'Product not found');
    if (unitName == product.unit) {
      throw const BusinessException(message: 'Cannot add base unit as custom unit');
    }

    final existingUnits = await productUnitsDao.getUnitsForProduct(productId);
    final exists = existingUnits.any((pu) => pu.unitName == unitName);
    if (exists) throw BusinessException(message: 'Unit "$unitName" already exists');

    if (conversionFactor <= Decimal.zero) {
      throw const BusinessException(message: 'Conversion factor must be positive');
    }

    await productUnitsDao.addProductUnit(
      ProductUnitsCompanion.insert(
        productId: productId,
        unitName: unitName,
        barcode: Value(barcode),
        unitFactor: Value(conversionFactor),
        buyPrice: buyPrice != null ? Value(buyPrice) : const Value.absent(),
        sellPrice: sellPrice != null ? Value(sellPrice) : const Value.absent(),
        wholesalePrice: wholesalePrice != null ? Value(wholesalePrice) : const Value.absent(),
        halfWholesalePrice: halfWholesalePrice != null ? Value(halfWholesalePrice) : const Value.absent(),
        isDefault: const Value(false),
      ),
    );
  }

  /// Set a unit as the base unit for a product
  /// Only one base unit per product is allowed
  Future<void> setBaseUnit({
    required String productId,
    required String baseUnitName,
  }) async {
    final product = await productsDao.getProductById(productId);
    if (product == null) throw const BusinessException(message: 'Product not found');

    // Note: Setting base unit requires DB access - caller should handle this
    throw UnimplementedError(
        'setBaseUnit requires DB access. Use TransactionEngine which has DB access.');
  }

  /// Validate that adding a new unit won't create a circular reference
  Future<void> validateNoCircularReference({
    required String productId,
    required String newUnitName,
    required Decimal newUnitFactor,
  }) async {
    final productUnits = await productUnitsDao.getUnitsForProduct(productId);
    
    // Check if new unit name already exists
    final exists = productUnits.any((u) => u.unitName == newUnitName);
    if (exists) {
      throw BusinessException(message: 'الوحدة "$newUnitName" موجودة بالفعل');
    }

    // Check for circular reference: if newUnitFactor equals an existing unit's factor
    // and that unit's name matches the product's base unit, it could create confusion
    // For simplicity, we just check that the new unit name is not the same as any existing unit
    for (final unit in productUnits) {
      if (unit.unitName == newUnitName) {
        throw BusinessException(message: 'لا يمكن إنشاء مرجع دائري: الوحدة "$newUnitName" موجودة بالفعل');
      }
    }
  }

  /// Get the price for a specific unit and sale type
  Future<Decimal> getPriceForUnit({
    required String productId,
    required String unitName,
    required String saleType, // 'retail', 'wholesale', 'special'
  }) async {
    final product = await productsDao.getProductById(productId);
    if (product == null) throw const BusinessException(message: 'Product not found');

    // If using base unit, return product's default price
    if (unitName == product.unit) {
      switch (saleType) {
        case 'wholesale':
          return product.wholesalePrice;
        case 'special':
          // Special price could be a custom price, for now use sell price
          return product.sellPrice;
        case 'retail':
        default:
          return product.sellPrice;
      }
    }

    // Get unit-specific price
    final productUnits = await productUnitsDao.getUnitsForProduct(productId);
    final unit = productUnits.firstWhere(
      (u) => u.unitName == unitName,
      orElse: () => throw BusinessException(message: 'Unit "$unitName" not found'),
    );

    switch (saleType) {
      case 'wholesale':
        return unit.wholesalePrice ?? product.wholesalePrice;
      case 'special':
        return unit.sellPrice ?? product.sellPrice;
      case 'retail':
      default:
        return unit.sellPrice ?? product.sellPrice;
    }
  }

  /// Format a base quantity into human-readable format with multiple units
  /// Returns a map of unitName -> quantityForThatUnit
  /// [productUnits] should be fetched from DB by the caller
  Map<String, Decimal> formatQuantity({
    required Decimal baseQuantity,
    /// Units including base unit, from DB
    required List<ProductUnit> productUnits,
  }) {
    final result = <String, Decimal>{};
    Decimal remaining = baseQuantity;

    // Process units from largest factor to smallest (excluding base unit which has factor 1)
    final sortedUnits = productUnits
        .where((u) => u.unitFactor > Decimal.one)
        .toList()
      ..sort((a, b) => b.unitFactor.compareTo(a.unitFactor));

    for (final unit in sortedUnits) {
      if (remaining >= unit.unitFactor) {
        final count = (remaining / unit.unitFactor).toDecimal(scaleOnInfinitePrecision: 0);
        if (count > Decimal.zero) {
          result[unit.unitName] = count;
          remaining -= count * unit.unitFactor;
        }
      }
    }

    // Add remaining base unit count
    final baseUnit = productUnits.firstWhere((u) => u.isBaseUnit);
    if (remaining > Decimal.zero) {
      result[baseUnit.unitName] = remaining;
    }

    return result;
  }
}