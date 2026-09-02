import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';

class DecompositionPage extends StatefulWidget {
  const DecompositionPage({super.key});

  @override
  State<DecompositionPage> createState() => _DecompositionPageState();
}

class _DecompositionPageState extends State<DecompositionPage> {
  Product? _selectedProduct;
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.sku.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _loadProducts() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final products = await (db.select(db.products)
          ..where((p) =>
              p.unitsPerMainUnit.isBiggerThan(Variable(Decimal.one.toString())) &
              p.isActive.equals(true)))
        .get();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  Future<void> _performDecomposition() async {
    if (_selectedProduct == null) {
      AppSnackBar.warning(context, 'يرجى اختيار منتج');
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      AppSnackBar.warning(context, 'يرجى إدخال كمية صحيحة');
      return;
    }

    final unitsPerMain = _selectedProduct!.unitsPerMainUnit.toDouble();
    if (unitsPerMain <= 0) {
      AppSnackBar.warning(context, 'عدد الوحدات داخل الوحدة الرئيسية غير صحيح');
      return;
    }

    if (_selectedProduct!.stock < Decimal.fromInt(quantity)) {
      AppSnackBar.warning(
          context, 'الكمية المطلوبة ($quantity) أكبر من المخزون (${_selectedProduct!.stock})');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final int totalDecomposed = quantity;
      final int unitsProduced = (totalDecomposed * unitsPerMain).toInt();

      await db.transaction(() async {
        // 1. Find a batch with main unit stock
        final batches = await (db.select(db.productBatches)
              ..where((b) =>
                  b.productId.equals(_selectedProduct!.id) &
                  b.storedUnitId.equals(_selectedProduct!.unit) &
                  b.quantity.isBiggerThan(Variable(Decimal.zero.toString())))
              ..orderBy([(b) => OrderingTerm(
                    expression: b.createdAt,
                    mode: OrderingMode.asc,
                  )]))
            .get();

        Decimal remainingToDeduct = Decimal.fromInt(quantity);
        String? sourceBatchId;

        for (final batch in batches) {
          if (remainingToDeduct <= Decimal.zero) break;
          final available = batch.quantity - batch.reservedQuantity;
          final deduct = available >= remainingToDeduct ? remainingToDeduct : available;

          await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id)))
              .write(ProductBatchesCompanion(
            quantity: Value(batch.quantity - deduct),
          ));

          sourceBatchId = batch.id;
          remainingToDeduct -= deduct;
        }

        // If no batches found with main unit, try any batch
        if (sourceBatchId == null || remainingToDeduct > Decimal.zero) {
          final anyBatches = await (db.select(db.productBatches)
                ..where((b) =>
                    b.productId.equals(_selectedProduct!.id) &
                    b.quantity.isBiggerThan(Variable(Decimal.zero.toString())))
                ..orderBy([(b) => OrderingTerm(
                      expression: b.createdAt,
                      mode: OrderingMode.asc,
                    )]))
              .get();

          for (final batch in anyBatches) {
            if (remainingToDeduct <= Decimal.zero) break;
            final available = batch.quantity - batch.reservedQuantity;
            final deduct = available >= remainingToDeduct ? remainingToDeduct : available;

            await (db.update(db.productBatches)
                  ..where((b) => b.id.equals(batch.id)))
                .write(ProductBatchesCompanion(
              quantity: Value(batch.quantity - deduct),
            ));

            sourceBatchId = batch.id;
            remainingToDeduct -= deduct;
          }
        }

        // 2. Calculate individual units produced
        // (uses unitsProduced from outer scope)

        // 3. Create or update batch for individual units
        final existingIndividualBatch = await (db.select(db.productBatches)
              ..where((b) =>
                  b.productId.equals(_selectedProduct!.id) &
                  b.storedUnitId.isNull() &
                  b.batchNumber.like('IND-%'))
              ..limit(1))
            .getSingleOrNull();

        if (existingIndividualBatch != null) {
          await (db.update(db.productBatches)
                ..where((b) => b.id.equals(existingIndividualBatch.id)))
              .write(ProductBatchesCompanion(
            quantity: Value(
                existingIndividualBatch.quantity + Decimal.fromInt(unitsProduced)),
          ));
        } else {
          await db.into(db.productBatches).insert(
                ProductBatchesCompanion.insert(
                  productId: _selectedProduct!.id,
                  warehouseId: '',
                  batchNumber: 'IND-${const Uuid().v4().substring(0, 8)}',
                  quantity: Value(Decimal.fromInt(unitsProduced)),
                  initialQuantity: Value(Decimal.fromInt(unitsProduced)),
                  costPrice: Value(_selectedProduct!.buyPrice),
                  storedUnitId: const Value(null),
                  quantityInStoredUnit: Value(Decimal.fromInt(unitsProduced)),
                ),
              );
        }

        // 4. Log inventory transactions
        if (sourceBatchId != null) {
          await db.into(db.inventoryTransactions).insert(
                InventoryTransactionsCompanion.insert(
                  productId: _selectedProduct!.id,
                  warehouseId: '',
                  batchId: Value(sourceBatchId),
                  quantity: Value(Decimal.fromInt(-totalDecomposed)),
                  type: 'DISASSEMBLY',
                  referenceId: sourceBatchId,
                ),
              );

          await db.into(db.inventoryTransactions).insert(
                InventoryTransactionsCompanion.insert(
                  productId: _selectedProduct!.id,
                  warehouseId: '',
                  quantity: Value(Decimal.fromInt(unitsProduced)),
                  type: 'DISASSEMBLY',
                  referenceId: sourceBatchId,
                ),
              );
        }
      });

      if (!mounted) return;
      AppSnackBar.success(
        context,
        'تم التفكيك بنجاح: $quantity ${_selectedProduct!.unit} → $unitsProduced حبة',
      );

      setState(() {
        _selectedProduct = null;
        _quantityController.clear();
      });
      _loadProducts();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, 'خطأ في التفكيك: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفكيك الوحدات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'بحث عن منتج',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Product selection
            if (_filteredProducts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    final isSelected = _selectedProduct?.id == product.id;
                    return Card(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          '${product.unit} | المخزون: ${product.stock} | '
                          'محتوى الوحدة: ${product.unitsPerMainUnit} حبة',
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() => _selectedProduct = product);
                          _quantityController.text = '1';
                        },
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text('لا توجد منتجات تحتوي على وحدات قابلة للتفكيك'),
                ),
              ),

            const SizedBox(height: 16),

            // Decomposition form
            if (_selectedProduct != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المنتج: ${_selectedProduct!.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الوحدة الرئيسية: ${_selectedProduct!.unit}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'محتوى الوحدة: ${_selectedProduct!.unitsPerMainUnit} حبة/وحدة',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'المخزون الحالي: ${_selectedProduct!.stock} ${_selectedProduct!.unit}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'كم ${_selectedProduct!.unit} تريد تفكيكها؟',
                          border: const OutlineInputBorder(),
                          suffixText: _selectedProduct!.unit,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_quantityController.text.isNotEmpty) ...[
                        Text(
                          'النتيجة: '
                          '${_quantityController.text} ${_selectedProduct!.unit} '
                          '→ '
                          '${((int.tryParse(_quantityController.text) ?? 0) * _selectedProduct!.unitsPerMainUnit.toDouble()).toInt()} حبة',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isProcessing ? null : _performDecomposition,
                          icon: _isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.inventory_2),
                          label: const Text('تنفيذ التفكيك'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
