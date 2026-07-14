import 'package:flutter/material.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class CustomerPaymentResult {
  final Decimal totalAmount;
  final String? note;
  final List<({String saleId, Decimal amount})> allocations;

  CustomerPaymentResult({
    required this.totalAmount,
    this.note,
    required this.allocations,
  });
}

class CustomerPaymentDialog extends StatefulWidget {
  final Customer customer;
  final List<SaleWithBalance> outstandingInvoices;

  const CustomerPaymentDialog({
    super.key,
    required this.customer,
    required this.outstandingInvoices,
  });

  @override
  State<CustomerPaymentDialog> createState() => _CustomerPaymentDialogState();
}

class _CustomerPaymentDialogState extends State<CustomerPaymentDialog> {
  final _noteController = TextEditingController();
  final Map<String, TextEditingController> _amountControllers = {};
  final Map<String, bool> _selected = {};
  final Map<String, Decimal> _balances = {};

  @override
  void initState() {
    super.initState();
    for (final inv in widget.outstandingInvoices) {
      _selected[inv.sale.id] = true;
      _balances[inv.sale.id] = inv.balance;
      _amountControllers[inv.sale.id] = TextEditingController(
        text: inv.balance.toStringAsFixed(2),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    for (final c in _amountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Decimal get _totalAmount {
    Decimal total = Decimal.zero;
    for (final inv in widget.outstandingInvoices) {
      if (_selected[inv.sale.id] == true) {
        final val =
            Decimal.tryParse(_amountControllers[inv.sale.id]?.text ?? '');
        if (val != null && val > Decimal.zero) {
          total += val;
        }
      }
    }
    return total;
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final allocations = <({String saleId, Decimal amount})>[];
    for (final inv in widget.outstandingInvoices) {
      if (_selected[inv.sale.id] == true) {
        final val =
            Decimal.tryParse(_amountControllers[inv.sale.id]?.text ?? '');
        if (val != null && val > Decimal.zero) {
          allocations.add((saleId: inv.sale.id, amount: val));
        }
      }
    }
    if (allocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectAtLeastOneInvoice)),
      );
      return;
    }
    Navigator.pop(
      context,
      CustomerPaymentResult(
        totalAmount: _totalAmount,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
        allocations: allocations,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(l10n.payInvoicesFor(widget.customer.name)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ...widget.outstandingInvoices
                        .map((inv) => _buildInvoiceTile(inv)),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${l10n.totalAmount}: ${_totalAmount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceTile(SaleWithBalance inv) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _selected[inv.sale.id] ?? false,
                  onChanged: (v) {
                    setState(() {
                      _selected[inv.sale.id] = v ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.invoiceHash(inv.sale.id.substring(0, 8)),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.remainingLabel(inv.balance.toStringAsFixed(2)),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_selected[inv.sale.id] == true)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 48),
                child: TextField(
                  controller: _amountControllers[inv.sale.id],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.amountPaidLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
