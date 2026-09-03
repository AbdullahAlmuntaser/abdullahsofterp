import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/inventory/barcode_generation_service.dart';

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
  bool _isBaseUnit = false;
  List<Map<String, dynamic>> _unitsList = [];
  bool _isAddingUnit = false;

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

    // Initialize unit fields from existing product
    _parentUnitController = TextEditingController();
    _conversionFactorController = TextEditingController();
    _unitNameController = TextEditingController();
    _unitBarcodeController = TextEditingController();
    
    // Product doesn't have isBaseUnit directly on it in the schema usually, 
    // it's part of the Unit hierarchy.
    _isBaseUnit = false; 

    // Load existing units for this product
    _loadExistingUnits();

    _sellPriceController.addListener(_calculateUnitSellPrice);
    _unitsPerMainUnitController.addListener(_calculateUnitSellPrice);
  }

  void _loadExistingUnits() {
    // In a real implementation, this would load from the database
    // For now, we'll initialize with empty list
    _unitsList = [];
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
          : Image.network(_imagePath!), // Assuming remote URL or handle local file
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
                          labelText: 'باركود الوحدة الرئيسية'),
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
                        helperText:
                            'معامل التعبئة - يُستخدم عند التفكيك',
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
                        helperText:
                            'سعر التجزئة ÷ عدد الوحدات داخل الوحدة',
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
                        helperText:
                            'سعر التجزئة ÷ عدد الوحدات داخل الوحدة',
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
                  helperText:
                      '1 كيس = 10 قطم (القيم يجب أن تكون أكبر من 0)',
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
        key: Key('unit_$index'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _removeUnit(index),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
          title: Text('${unit['unitName']} (${unit['unitFactor']})'),
          subtitle: Text(
              'Barcode: ${unit['barcode'] ?? 'لا يوجد'} | baseUnit: ${unit['isBaseUnit'] ? 'نعم' : 'لا'}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editUnit(index);
              } else if (value == 'delete') {
                _removeUnit(index);
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

  void _addUnit() {
    if (_unitNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال اسم الوحدة'))
      );
      return;
    }

    setState(() => _isAddingUnit = true);

    // Add the unit to the list
    _unitsList.add({
      'unitName': _unitNameController.text,
      'unitFactor': double.tryParse(_conversionFactorController.text) ?? 1.0,
      'barcode': _unitBarcodeController.text,
      'isBaseUnit': _isBaseUnit,
    });

    // Clear fields
    _unitNameController.clear();
    _conversionFactorController.clear();
    _unitBarcodeController.clear();
    _isBaseUnit = false;
    setState(() => _isAddingUnit = false);
  }

  void _removeUnit(int index) {
    setState(() {
      _unitsList.removeAt(index);
    });
  }

  void _editUnit(int index) {
    // In a real implementation, show a dialog to edit the unit
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تحرير الوحدة - سيتم تطويره لاحقاً')));
  }

  void _selectParentUnit() {
    // Show a dialog to select parent unit from product's units
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختيار وحدة الآب - سيتم تطويره لاحقاً')));
  }

  void _calculateUnitSellPrice() {
    final sellPrice = double.tryParse(_sellPriceController.text) ?? 0;
    final unitsPerMain = double.tryParse(_unitsPerMainUnitController.text) ?? 1;
    if (unitsPerMain > 0 && sellPrice > 0) {
      final unitPrice = sellPrice / unitsPerMain;
      _unitSellPriceController.text = unitPrice.toStringAsFixed(2);
    } else {
      _unitSellPriceController.text = '0';
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final buyPrice =
          Decimal.tryParse(_buyPriceController.text) ?? Decimal.zero;
      final sellPrice =
          Decimal.tryParse(_sellPriceController.text) ?? Decimal.zero;
      final wholesalePrice =
          Decimal.tryParse(_wholesalePriceController.text) ?? Decimal.zero;
      final unitSellPrice =
          Decimal.tryParse(_unitSellPriceController.text) ?? Decimal.zero;
      final stock = Decimal.tryParse(_stockController.text) ?? Decimal.zero;
      final unitsPerMainUnit =
          Decimal.tryParse(_unitsPerMainUnitController.text) ?? Decimal.one;

      try {
        if (widget.product == null) {
          await db.into(db.products).insert(ProductsCompanion.insert(
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
        } else {
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
              barcode: Value(_barcodeController.text),
              categoryId: Value(_selectedCategoryId),
              imagePath: Value(_imagePath),
            ),
          );
        }
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل الحفظ: $e')));
      }
    }
  }
}