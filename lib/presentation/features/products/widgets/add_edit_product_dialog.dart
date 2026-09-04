import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/inventory/barcode_generation_service.dart';
import 'package:supermarket/core/services/inventory/unit_conversion_service.dart';
import 'package:supermarket/injection_container.dart';
import 'package:decimal/decimal.dart';
import 'package:uuid/uuid.dart';

class AddEditProductDialog extends StatefulWidget {
  final Product? product;

  const AddEditProductDialog({super.key, this.product});

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _skuController;
  late TextEditingController _nameController;
  late TextEditingController _baseUnitController;
  late TextEditingController _stockController;
  late TextEditingController _unitsPerMainUnitController;
  late TextEditingController _buyPriceController;
  late TextEditingController _sellPriceController;
  late TextEditingController _wholesalePriceController;
  late TextEditingController _unitSellPriceController;
  late TextEditingController _barcodeController;
  late TextEditingController _remoteUrlController;
  String? _imagePath;
  String? _selectedCategoryId;
  List<Category> _categories = [];

  // Unit hierarchy fields
  late TextEditingController _parentUnitController;
  late TextEditingController _conversionFactorController;
  late TextEditingController _unitNameController;
  late TextEditingController _unitBarcodeController;
  late TextEditingController _unitBuyPriceController;
  late TextEditingController _unitSellPriceFieldController;
  late TextEditingController _unitWholesalePriceController;
  bool _isBaseUnit = false;
  List<ProductUnit> _unitsList = [];
  bool _isAddingUnit = false;
  bool _isLoadingUnits = false;

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _baseUnitController =
        TextEditingController(text: widget.product?.unit ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '0.0');
    _unitsPerMainUnitController = TextEditingController(
        text: widget.product?.unitsPerMainUnit.toString() ?? '1');
    _buyPriceController = TextEditingController(
        text: widget.product?.buyPrice.toString() ?? '0.0');
    _sellPriceController = TextEditingController(
        text: widget.product?.sellPrice.toString() ?? '0.0');
    _wholesalePriceController = TextEditingController(
        text: widget.product?.wholesalePrice.toString() ?? '0.0');
    _unitSellPriceController = TextEditingController(
        text: widget.product?.unitSellPrice.toString() ?? '0.0');
    _barcodeController =
        TextEditingController(text: widget.product?.barcode ?? '');
    _remoteUrlController =
        TextEditingController(text: widget.product?.remoteUrl ?? '');
    _imagePath = widget.product?.imagePath;
    _selectedCategoryId = widget.product?.categoryId;
    _loadCategories();

    // Initialize unit fields
    _parentUnitController = TextEditingController();
    _conversionFactorController = TextEditingController();
    _unitNameController = TextEditingController();
    _unitBarcodeController = TextEditingController();
    _unitBuyPriceController = TextEditingController();
    _unitSellPriceFieldController = TextEditingController();
    _unitWholesalePriceController = TextEditingController();
    _isBaseUnit = false;

    // Load existing units for this product
    _loadExistingUnits();

    _sellPriceController.addListener(_calculateUnitSellPrice);
    _unitsPerMainUnitController.addListener(_calculateUnitSellPrice);
  }

  Future<void> _loadExistingUnits() async {
    if (widget.product == null) {
      setState(() => _unitsList = []);
      return;
    }
    setState(() => _isLoadingUnits = true);
    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final units = await (db.select(db.productUnits)
            ..where((u) => u.productId.equals(widget.product!.id)))
          .get();
      if (mounted) {
        setState(() {
          _unitsList = units;
          _isLoadingUnits = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingUnits = false);
      }
    }
  }

  Future<void> _loadCategories() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final list = await db.select(db.categories).get();
    if (mounted) {
      setState(() {
        _categories = list;
      });
    }
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _baseUnitController.dispose();
    _stockController.dispose();
    _unitsPerMainUnitController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _wholesalePriceController.dispose();
    _unitSellPriceController.dispose();
    _barcodeController.dispose();
    _remoteUrlController.dispose();
    _parentUnitController.dispose();
    _conversionFactorController.dispose();
    _unitNameController.dispose();
    _unitBarcodeController.dispose();
    _unitBuyPriceController.dispose();
    _unitSellPriceFieldController.dispose();
    _unitWholesalePriceController.dispose();
    _sellPriceController.removeListener(_calculateUnitSellPrice);
    _unitsPerMainUnitController.removeListener(_calculateUnitSellPrice);
    super.dispose();
  }

  Widget _buildImageSection() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _imagePath == null
          ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
          : Image.network(_imagePath!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.product == null ? l10n.addProduct : l10n.editProduct),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildImageSection(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.productName),
                validator: (value) =>
                    value!.isEmpty ? l10n.enterProductName : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _baseUnitController,
                      decoration: const InputDecoration(
                        labelText: 'الوحدة الرئيسية',
                        hintText: 'كرتون، شدة، صندوق، باكت، كيس...',
                        helperText: 'اسم الوحدة الأساسية للمنتج',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال الوحدة الرئيسية' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'التصنيف'),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategoryId = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(labelText: l10n.sku),
                validator: (value) =>
                    value!.isEmpty ? l10n.enterSku : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'باركود الوحدة الرئيسية',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () => _barcodeController.text =
                        BarcodeGenerationService.autoGenerateBarcode(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'العدد (كمية المخزون)',
                  helperText:
                      'الكمية بوحدة ${_baseUnitController.text.isEmpty ? 'الوحدة الرئيسية' : _baseUnitController.text}',
                ),
                keyboardType: TextInputType.number,
                readOnly: widget.product != null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitsPerMainUnitController,
                      decoration: const InputDecoration(
                        labelText: 'عدد الحبات/الوحدات داخل الوحدة الرئيسية',
                        hintText: 'مثال: 20 يعني أن الوحدة الواحدة تحتوي على 20 حبة',
                        helperText: 'معامل التعبئة - يُستخدم عند التفكيك',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitSellPriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر الوحدة المفردة',
                        helperText: 'سعر التجزئة ÷ عدد الوحدات داخل الوحدة',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buyPriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر الشراء للوحدة الرئيسية',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر البيع بالتجزئة للوحدة الرئيسية',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateUnitSellPrice(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _wholesalePriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر البيع بالجملة للوحدة الرئيسية',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitSellPriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر الوحدة المفردة (محسوب تلقائيًا)',
                        helperText: 'سعر التجزئة ÷ عدد الوحدات داخل الوحدة',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Unit hierarchy section
              ListTile(
                title: const Text('وحدة الأم (Parent Unit)'),
                subtitle: _parentUnitController.text.isNotEmpty
                    ? Text('${_parentUnitController.text} × ${_conversionFactorController.text}')
                    : const Text('لا يوجد'),
                trailing: const Icon(Icons.arrow_right),
                onTap: _selectParentUnit,
              ),
              const Divider(),
              TextFormField(
                controller: _conversionFactorController,
                decoration: const InputDecoration(
                  labelText: 'معامل التحويل',
                  hintText: 'مثلاً: 10 يعني أن وحدة الأم تساوي 10 من هذه الوحدة',
                  helperText: '1 كيس = 10 قطم (القيم يجب أن تكون أكبر من 0)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'required';
                  final factor = double.tryParse(value);
                  if (factor == null || factor <= 0) {
                    return 'يجب أن يكون أكبر من 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitNameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الوحدة الجديدة',
                        hintText: 'قطمة، حبة، علبة...',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال اسم الوحدة' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitBarcodeController,
                      decoration: const InputDecoration(
                        labelText: 'باركود الوحدة',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitBuyPriceController,
                      decoration: const InputDecoration(
                        labelText: 'سعر شراء الوحدة',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitSellPriceFieldController,
                      decoration: const InputDecoration(
                        labelText: 'سعر بيع تجزئة الوحدة',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _unitWholesalePriceController,
                decoration: const InputDecoration(
                  labelText: 'سعر بيع جملة الوحدة',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _isBaseUnit,
                    onChanged: (val) => setState(() => _isBaseUnit = val ?? false),
                  ),
                  const Text('جعل هذه الوحدة هي الوحدة الأساسية'),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _isAddingUnit ? null : _addUnit,
                icon: _isAddingUnit
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add),
                label: Text(_isAddingUnit ? 'جاري الإضافة...' : 'إضافة وحدة'),
              ),
              const SizedBox(height: 8),
              // Display existing units
              ..._buildUnitsListItems(),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel)),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUnitsListItems() {
    if (_isLoadingUnits) {
      return [const Center(child: CircularProgressIndicator())];
    }
    if (_unitsList.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('لا توجد وحدات فرعية معرفة'),
        )
      ];
    }
    return _unitsList.asMap().entries.map((entry) {
      final index = entry.key;
      final unit = entry.value;
      return Dismissible(
        key: Key('unit_${unit.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _removeUnit(unit),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
          title: Text('${unit.unitName} (${unit.unitFactor})'),
          subtitle: Text(
              'Barcode: ${unit.barcode ?? 'لا يوجد'} | baseUnit: ${unit.isBaseUnit ? 'نعم' : 'لا'}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editUnit(unit);
              } else if (value == 'delete') {
                _removeUnit(unit);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('تعديل'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('حذف'),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _addUnit() async {
    if (_unitNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال اسم الوحدة')));
      return;
    }

    // Validate conversion factor
    final factorStr = _conversionFactorController.text;
    if (factorStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال معامل التحويل')));
      return;
    }
    final conversionFactor = Decimal.tryParse(factorStr);
    if (conversionFactor == null || conversionFactor <= Decimal.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('معامل التحويل يجب أن يكون أكبر من صفر')));
      return;
    }

    // Check for circular reference
    if (widget.product != null) {
      final existingUnits = await (db.select(db.productUnits)
            ..where((u) => u.productId.equals(widget.product!.id)))
          .get();
      
      // Check if this unit name already exists
      final exists = existingUnits.any((u) => u.unitName == _unitNameController.text);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('الوحدة "${_unitNameController.text}" موجودة بالفعل')));
        return;
      }

      // Check for circular reference: if this unit is already a parent of another unit
      for (final unit in existingUnits) {
        if (unit.unitName == _unitNameController.text && unit.unitFactor != Decimal.one) {
          // This would create a circular reference
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لا يمكن إنشاء مرجع دائري للوحدات')));
          return;
        }
      }
    }

    setState(() => _isAddingUnit = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final unitConversionService = sl<UnitConversionService>();
      
      await unitConversionService.addProductUnit(
        productId: widget.product?.id ?? '',
        unitName: _unitNameController.text,
        conversionFactor: conversionFactor,
        barcode: _unitBarcodeController.text.isEmpty ? null : _unitBarcodeController.text,
        buyPrice: _unitBuyPriceController.text.isEmpty ? null : Decimal.tryParse(_unitBuyPriceController.text),
        sellPrice: _unitSellPriceFieldController.text.isEmpty ? null : Decimal.tryParse(_unitSellPriceFieldController.text),
        wholesalePrice: _unitWholesalePriceController.text.isEmpty ? null : Decimal.tryParse(_unitWholesalePriceController.text),
      );

      // Clear fields
      _unitNameController.clear();
      _conversionFactorController.clear();
      _unitBarcodeController.clear();
      _unitBuyPriceController.clear();
      _unitSellPriceFieldController.clear();
      _unitWholesalePriceController.clear();
      _isBaseUnit = false;

      // Reload units
      await _loadExistingUnits();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الوحدة بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل إضافة الوحدة: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingUnit = false);
      }
    }
  }

  Future<void> _removeUnit(ProductUnit unit) async {
    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      await (db.delete(db.productUnits)..where((u) => u.id.equals(unit.id))).go();
      await _loadExistingUnits();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف الوحدة')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل حذف الوحدة: $e')));
      }
    }
  }

  void _editUnit(ProductUnit unit) {
    // Show edit dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تعديل الوحدة: ${unit.unitName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: unit.unitFactor.toString(),
              decoration: const InputDecoration(labelText: 'معامل التحويل'),
              keyboardType: TextInputType.number,
              onChanged: (val) async {
                final factor = Decimal.tryParse(val);
                if (factor != null && factor > Decimal.zero) {
                  final db = Provider.of<AppDatabase>(context, listen: false);
                  await (db.update(db.productUnits)..where((u) => u.id.equals(unit.id)))
                      .write(ProductUnitsCompanion(unitFactor: Value(factor)));
                  await _loadExistingUnits();
                  if (mounted) Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ],
      ),
    );
  }

  void _selectParentUnit() {
    // For now, just show a message - this would need a more complex UI
    // to select from existing units
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر وحدة من القائمة أدناه')));
  }

  void _calculateUnitSellPrice() {
    final sellPrice = Decimal.tryParse(_sellPriceController.text) ?? Decimal.zero;
    final unitsPerMain = Decimal.tryParse(_unitsPerMainUnitController.text) ?? Decimal.one;
    if (unitsPerMain > Decimal.zero && sellPrice > Decimal.zero) {
      final unitPrice = sellPrice / unitsPerMain;
      _unitSellPriceController.text = unitPrice.toStringAsFixed(2);
    } else {
      _unitSellPriceController.text = '0';
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final buyPrice = Decimal.tryParse(_buyPriceController.text) ?? Decimal.zero;
      final sellPrice = Decimal.tryParse(_sellPriceController.text) ?? Decimal.zero;
      final wholesalePrice = Decimal.tryParse(_wholesalePriceController.text) ?? Decimal.zero;
      final unitSellPrice = Decimal.tryParse(_unitSellPriceController.text) ?? Decimal.zero;
      final stock = Decimal.tryParse(_stockController.text) ?? Decimal.zero;
      final unitsPerMainUnit = Decimal.tryParse(_unitsPerMainUnitController.text) ?? Decimal.one;

      try {
        if (widget.product == null) {
          // Create new product
          final productId = const Uuid().v4();
          await db.into(db.products).insert(ProductsCompanion.insert(
                id: Value(productId),
                name: _nameController.text,
                sku: _skuController.text,
                unit: Value(_baseUnitController.text),
                stock: Value(stock),
                buyPrice: Value(buyPrice),
                sellPrice: Value(sellPrice),
                wholesalePrice: Value(wholesalePrice),
                unitSellPrice: Value(unitSellPrice),
                unitsPerMainUnit: Value(unitsPerMainUnit),
                barcode: Value(_barcodeController.text.isNotEmpty
                    ? _barcodeController.text
                    : null),
                categoryId: Value(_selectedCategoryId),
                imagePath: Value(_imagePath),
              ));

          // Set the base unit as the product's main unit
          await db.into(db.productUnits).insert(ProductUnitsCompanion.insert(
                productId: productId,
                unitName: _baseUnitController.text,
                unitFactor: const Value(Decimal.one),
                isBaseUnit: const Value(true),
                isDefault: const Value(true),
              ));

          // Add any units that were added in the dialog
          for (final unit in _unitsList) {
            await db.into(db.productUnits).insert(ProductUnitsCompanion.insert(
                  productId: productId,
                  unitName: unit.unitName,
                  unitFactor: Value(unit.unitFactor),
                  barcode: Value(unit.barcode),
                  buyPrice: Value(unit.buyPrice ?? Decimal.zero),
                  sellPrice: Value(unit.sellPrice ?? Decimal.zero),
                  wholesalePrice: Value(unit.wholesalePrice ?? Decimal.zero),
                  isDefault: const Value(false),
                ));
          }
        } else {
          // Update existing product
          await (db.update(db.products)
                ..where((p) => p.id.equals(widget.product!.id)))
              .write(
            ProductsCompanion(
              name: Value(_nameController.text),
              sku: Value(_skuController.text),
              unit: Value(_baseUnitController.text),
              buyPrice: Value(buyPrice),
              sellPrice: Value(sellPrice),
              wholesalePrice: Value(wholesalePrice),
              unitSellPrice: Value(unitSellPrice),
              unitsPerMainUnit: Value(unitsPerMainUnit),
              barcode: Value(_barcodeController.text.isNotEmpty
                  ? _barcodeController.text
                  : null),
              categoryId: Value(_selectedCategoryId),
              imagePath: Value(_imagePath),
            ),
          );

          // Update base unit if changed
          final existingUnits = await (db.select(db.productUnits)
                ..where((u) => u.productId.equals(widget.product!.id)))
              .get();
          final baseUnit = existingUnits.firstWhere(
            (u) => u.isBaseUnit,
            orElse: () => existingUnits.first,
          );
          
          if (baseUnit.unitName != _baseUnitController.text) {
            await (db.update(db.productUnits)..where((u) => u.id.equals(baseUnit.id)))
                .write(ProductUnitsCompanion(unitName: Value(_baseUnitController.text)));
          }
        }

        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل الحفظ: $e')));
      }
    }
  }
}�