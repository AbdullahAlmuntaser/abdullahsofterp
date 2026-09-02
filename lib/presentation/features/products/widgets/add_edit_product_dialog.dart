import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/inventory/product_image_service.dart';
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
  late TextEditingController _unitController;
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

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _unitController = TextEditingController(text: widget.product?.unit ?? '');
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

    _sellPriceController.addListener(_calculateUnitSellPrice);
    _unitsPerMainUnitController.addListener(_calculateUnitSellPrice);
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
    _unitController.dispose();
    _stockController.dispose();
    _unitsPerMainUnitController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _wholesalePriceController.dispose();
    _unitSellPriceController.dispose();
    _barcodeController.dispose();
    _remoteUrlController.dispose();
    _sellPriceController.removeListener(_calculateUnitSellPrice);
    _unitsPerMainUnitController.removeListener(_calculateUnitSellPrice);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.product == null ? l10n.addProduct : l10n.editProduct),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'الوحدة الرئيسية',
                        hintText: 'كرتون، شدة، صندوق، باكت، كيس...',
                        helperText: 'اسم الوحدة التي يُشترى ويُخزّن بها المنتج',
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
                      'الكمية بوحدة ${_unitController.text.isEmpty ? 'الوحدة الرئيسية' : _unitController.text}',
                ),
                keyboardType: TextInputType.number,
                readOnly: widget.product != null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _unitsPerMainUnitController,
                decoration: const InputDecoration(
                  labelText: 'عدد الوحدات/الحبات داخل الوحدة الرئيسية',
                  hintText: 'مثال: 20 يعني أن الوحدة الواحدة تحتوي على 20 حبة',
                  helperText: 'معامل التعبئة - يُستخدم عند التفكيك',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateUnitSellPrice(),
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        ElevatedButton(onPressed: _saveProduct, child: Text(l10n.save)),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        if (_imagePath != null && _imagePath!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(_imagePath!),
                width: 100, height: 100, fit: BoxFit.cover),
          )
        else
          Icon(Icons.image, size: 80, color: Colors.grey[400]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('المعرض')),
            TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('الكاميرا')),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await ProductImageService.pickImage(source: source);
    if (file != null) setState(() => _imagePath = file.path);
  }

  void _saveProduct() async {
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
                unit: Value(_unitController.text),
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
              unit: Value(_unitController.text),
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
