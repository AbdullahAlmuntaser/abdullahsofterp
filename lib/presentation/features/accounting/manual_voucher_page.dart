import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/injection_container.dart';
import 'package:supermarket/presentation/features/accounting/widgets/bill_allocation_widget.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';
import 'package:supermarket/presentation/widgets/money_form_field.dart';
import 'package:supermarket/l10n/app_localizations.dart';

/// صفحة سند القبض/الصرف اليدوي
class ManualVoucherPage extends StatefulWidget {
  final bool isReceipt; // true = سند قبض, false = سند صرف
  const ManualVoucherPage({super.key, this.isReceipt = true});

  @override
  State<ManualVoucherPage> createState() => _ManualVoucherPageState();
}

class _ManualVoucherPageState extends State<ManualVoucherPage> {
  Customer? _selectedCustomer;
  Supplier? _selectedSupplier;
  String _paymentMethod = 'cash';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _checkNumberController = TextEditingController();
  DateTime _checkDueDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _checkNumberController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.isReceipt ? l10n.receiptVoucher : l10n.paymentVoucher)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // نوع الطرف
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isReceipt ? l10n.receiveFrom : l10n.payTo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'customer', label: Text(l10n.customer)),
                        ButtonSegment(value: 'supplier', label: Text(l10n.supplier)),
                      ],
                      selected: {
                        _selectedCustomer != null ? 'customer' : 'supplier',
                      },
                      onSelectionChanged: (selection) {
                        setState(() {
                          if (selection.contains('customer')) {
                            _selectedSupplier = null;
                          } else {
                            _selectedCustomer = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // اختيار العميل
            if (_selectedCustomer == null || _selectedSupplier == null)
              _selectedCustomer == null
                  ? _buildCustomerSelector(db)
                  : _buildSupplierSelector(db),

            const SizedBox(height: 16),

            // المبلغ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MoneyFormField(
                      controller: _amountController,
                      label: l10n.amount,
                      required: true,
                      allowZero: false,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.payments),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // طريقة الدفع
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.paymentMethod,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'cash', child: Text(l10n.cash)),
                        DropdownMenuItem(value: 'bank', child: Text(l10n.bankTransfer)),
                        DropdownMenuItem(value: 'check', child: Text(l10n.check)),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentMethod = val);
                      },
                    ),
                    if (_paymentMethod == 'check') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _checkNumberController,
                        decoration: InputDecoration(
                          labelText: l10n.checkNumber,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text(l10n.checkDueDate(_formatDate(_checkDueDate))),
                        leading: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _checkDueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() => _checkDueDate = date);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // تخصيص الفواتير (فقط في سند القبض للعملاء)
            if (widget.isReceipt && _selectedCustomer != null) ...[
              BillAllocationWidget(
                customerId: _selectedCustomer!.id,
                totalPaymentAmount: MoneyFormField.valueOf(_amountController),
                onAllocationChanged: (allocs) {},
              ),
              const SizedBox(height: 16),
            ],

            // التاريخ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                            _dateController.text = _formatDate(date);
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(_formatDate(_selectedDate)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ملاحظات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notes,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: l10n.additionalNotes,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // زر الحفظ
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isReceipt
                                ? Icons.receipt_long
                                : Icons.money_off,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isReceipt
                                ? l10n.saveReceiptVoucher
                                : l10n.savePaymentVoucher,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSelector(AppDatabase db) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Customer>>(
          stream: db.select(db.customers).watch(),
          builder: (context, snapshot) {
            final customers = snapshot.data ?? [];
            return DropdownButtonFormField<Customer>(
              value: _selectedCustomer,
              decoration: InputDecoration(
                labelText: l10n.selectCustomer,
                border: const OutlineInputBorder(),
              ),
              items: customers
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCustomer = value;
                  _selectedSupplier = null;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSupplierSelector(AppDatabase db) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Supplier>>(
          stream: db.select(db.suppliers).watch(),
          builder: (context, snapshot) {
            final suppliers = snapshot.data ?? [];
            return DropdownButtonFormField<Supplier>(
              value: _selectedSupplier,
              decoration: InputDecoration(
                labelText: l10n.selectSupplier,
                border: const OutlineInputBorder(),
              ),
              items: suppliers
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSupplier = value;
                  _selectedCustomer = null;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveVoucher() async {
    final l10n = AppLocalizations.of(context)!;
    final amount = MoneyFormField.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppSnackBar.warning(context, l10n.enterAmountError);
      return;
    }

    if (_selectedCustomer == null && _selectedSupplier == null) {
      AppSnackBar.warning(context, l10n.selectCustomerOrSupplier);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final engine = sl<TransactionEngine>();

      if (_selectedCustomer != null) {
        await engine.postCustomerPayment(
          customerId: _selectedCustomer!.id,
          amount: Decimal.parse(amount.toString()),
          paymentMethod: _paymentMethod,
          note: _noteController.text.isEmpty ? null : _noteController.text,
        );
      } else if (_selectedSupplier != null) {
        await engine.postSupplierPayment(
          supplierId: _selectedSupplier!.id,
          amount: Decimal.parse(amount.toString()),
          paymentMethod: _paymentMethod,
          note: _noteController.text.isEmpty ? null : _noteController.text,
        );
      }
      if (mounted) {
        context.pop();
        AppSnackBar.success(
          context,
          widget.isReceipt
              ? l10n.receiptVoucherSaved
              : l10n.paymentVoucherSaved,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, l10n.saveFailed(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
