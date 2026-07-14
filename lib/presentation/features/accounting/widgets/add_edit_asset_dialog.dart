import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/accounting/asset_provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class AddEditAssetDialog extends StatefulWidget {
  final AssetProvider assetProvider;
  final FixedAsset? asset; // Pass asset for editing

  const AddEditAssetDialog({
    super.key,
    required this.assetProvider,
    this.asset,
  });

  @override
  State<AddEditAssetDialog> createState() => _AddEditAssetDialogState();
}

class _AddEditAssetDialogState extends State<AddEditAssetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _lifeController;
  late TextEditingController _salvageController;
  late DateTime _purchaseDate;

  bool get _isEditing => widget.asset != null;

  @override
  void initState() {
    super.initState();
    final asset = widget.asset;
    _nameController = TextEditingController(text: asset?.name ?? '');
    _costController = TextEditingController(text: asset?.cost.toString() ?? '');
    _lifeController = TextEditingController(
      text: asset?.usefulLifeYears.toString() ?? '',
    );
    _salvageController = TextEditingController(
      text: asset?.salvageValue.toString() ?? '',
    );
    _purchaseDate = asset?.purchaseDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _lifeController.dispose();
    _salvageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _purchaseDate) {
      setState(() {
        _purchaseDate = pickedDate;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final companion = FixedAssetsCompanion(
        id: _isEditing ? Value(widget.asset!.id) : const Value.absent(),
        name: Value(_nameController.text),
        cost: Value(Decimal.tryParse(_costController.text) ?? Decimal.zero),
        usefulLifeYears: Value(int.tryParse(_lifeController.text) ?? 5),
        salvageValue:
            Value(Decimal.tryParse(_salvageController.text) ?? Decimal.zero),
        purchaseDate: Value(_purchaseDate),
        accumulatedDepreciation:
            _isEditing ? const Value.absent() : Value(Decimal.zero),
      );

      if (_isEditing) {
        // widget.assetProvider.updateAsset(context, companion);
      } else {
        widget.assetProvider.addAsset(context, companion);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(_isEditing ? l10n.editAsset : l10n.newAsset),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.assetName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? l10n.thisFieldRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: l10n.cost,
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.thisFieldRequired;
                  if (double.tryParse(value) == null) {
                    return l10n.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lifeController,
                decoration: InputDecoration(
                  labelText: l10n.usefulLifeYears,
                  prefixIcon: const Icon(Icons.hourglass_bottom),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.thisFieldRequired;
                  if (int.tryParse(value) == null) {
                    return l10n.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salvageController,
                decoration: InputDecoration(
                  labelText: l10n.salvageValue,
                  prefixIcon: const Icon(Icons.recycling),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.thisFieldRequired;
                  if (double.tryParse(value) == null) {
                    return l10n.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    l10n.purchaseDateLabel(DateFormat('yyyy-MM-dd').format(_purchaseDate)),
                  ),
                  const Spacer(),
                  TextButton(onPressed: _pickDate, child: Text(l10n.change)),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(_isEditing ? l10n.saveChanges : l10n.add),
        ),
      ],
    );
  }
}
