import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

class UnitConversionPage extends StatefulWidget {
  final String productId;
  final String productName;

  const UnitConversionPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<UnitConversionPage> createState() => _UnitConversionPageState();
}

class _UnitConversionPageState extends State<UnitConversionPage> {
  final _formKey = GlobalKey<FormState>();
  final _unitNameController = TextEditingController();
  final _factorController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _unitNameController.dispose();
    _factorController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addConversion() async {
    if (_formKey.currentState!.validate()) {
      final db = context.read<AppDatabase>();
      await db.into(db.productUnits).insert(
            ProductUnitsCompanion.insert(
              productId: widget.productId,
              unitName: _unitNameController.text,
              unitFactor: drift.Value(Decimal.parse(_factorController.text)),
              barcode: drift.Value(
                _barcodeController.text.isEmpty
                    ? null
                    : _barcodeController.text,
              ),
              sellPrice: drift.Value(
                _priceController.text.isEmpty
                    ? null
                    : Decimal.parse(_priceController.text),
              ),
            ),
          );

      _unitNameController.clear();
      _factorController.clear();
      _barcodeController.clear();
      _priceController.clear();

      if (mounted) {
        Navigator.pop(context);
        setState(() {}); // Refresh list
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: Text('وحدات: ${widget.productName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ProductUnit>>(
              stream: (db.select(
                db.productUnits,
              )..where((t) => t.productId.equals(widget.productId)))
                  .watch(),
              builder: (context, unitSnapshot) {
                return FutureBuilder<Product?>(
                  future: (db.select(db.products)
                        ..where((p) => p.id.equals(widget.productId)))
                      .getSingleOrNull(),
                  builder: (context, productSnapshot) {
                    final product = productSnapshot.data;
                    final conversions = unitSnapshot.data ?? [];

                    return Column(
                      children: [
                        if (product != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'الوحدة الرئيسية:',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  product.unit,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'محتوى الوحدة: ${product.unitsPerMainUnit} حبة/وحدة',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'المخزون: ${product.stock} ${product.unit}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        if (unitSnapshot.connectionState ==
                            ConnectionState.waiting)
                          const Expanded(
                              child: Center(child: CircularProgressIndicator()))
                        else if (conversions.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                  'لا توجد وحدات إضافية مضافة بعد.\nيمكنك إضافة وحدات للبيع بالقطعة.'),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              itemCount: conversions.length,
                              itemBuilder: (context, index) {
                                final conv = conversions[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${conv.unitName}',
                                    ),
                                    subtitle: Text(
                                      product != null
                                          ? '1 ${conv.unitName} = ${conv.unitFactor} ${product.unit}'
                                          : '1 ${conv.unitName} = ${conv.unitFactor} وحدة',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        await (db.delete(
                                          db.productUnits,
                                        )..where((t) => t.id.equals(conv.id)))
                                            .go();
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        label: const Text('إضافة وحدة'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة وحدة جديدة'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _unitNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الوحدة',
                    hintText: 'مثال: كرتون، باكت، كيس...',
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                TextFormField(
                  controller: _factorController,
                  decoration: const InputDecoration(
                    labelText: 'عدد الحبات داخل الوحدة',
                    helperText: 'كم حبة في هذه الوحدة؟ مثال: 20 حبة في الكرتون → أدخل 20',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final parsed = double.tryParse(v ?? '');
                    if (parsed == null) return 'أدخل رقماً صحيحاً';
                    if (parsed <= 0) return 'العدد يجب أن يكون أكبر من صفر';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'باركود الوحدة (اختياري)',
                  ),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'سعر البيع لهذه الوحدة (اختياري)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(onPressed: _addConversion, child: const Text('حفظ')),
        ],
      ),
    );
  }
}
