import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class PurchaseReportPage extends StatefulWidget {
  const PurchaseReportPage({super.key});

  @override
  State<PurchaseReportPage> createState() => _PurchaseReportPageState();
}

class _PurchaseReportPageState extends State<PurchaseReportPage> {
  List<Purchase> _purchases = [];
  bool _isLoading = true;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = di.sl<AppDatabase>();
    _purchases = await (db.select(db.purchases)
          ..where((p) =>
              p.date.isBiggerOrEqualValue(_startDate) &
              p.date.isSmallerOrEqualValue(_endDate))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalAmount =
        _purchases.fold<double>(0, (sum, p) => sum + p.total.toDouble());
    final totalTax =
        _purchases.fold<double>(0, (sum, p) => sum + p.tax.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrAlmshtryat),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf), onPressed: _exportToPdf),
          IconButton(
              icon: const Icon(Icons.table_chart), onPressed: _exportToExcel),
        ],
      ),
      body: Column(
        children: [
          _buildDateFilter(l10n),
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(l10n.addAlfwatyr, '${_purchases.length}'),
                _statItem(l10n.total, '${totalAmount.toStringAsFixed(2)} ${l10n.currencySar}'),
                _statItem(l10n.tax, '${totalTax.toStringAsFixed(2)} ${l10n.currencySar}'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _purchases.length,
                    itemBuilder: (context, index) {
                      final purchase = _purchases[index];
                      return ListTile(
                        title: Text(l10n.invoiceHash(purchase.invoiceNumber ?? purchase.id.substring(0, 8))),
                        subtitle: Text(
                            DateFormat('yyyy-MM-dd').format(purchase.date)),
                        trailing: Text('${purchase.total} ${l10n.currencySar}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now());
                if (date != null) {
                  setState(() {
                    _startDate = date;
                    _loadData();
                  });
                }
              },
              child: Text('${l10n.mn}: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now());
                if (date != null) {
                  setState(() {
                    _endDate = date;
                    _loadData();
                  });
                }
              },
              child: Text('${l10n.ila}: ${DateFormat('yyyy-MM-dd').format(_endDate)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  void _exportToPdf() async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToPdf(
        'purchases',
        _purchases
            .map((p) => {
                  'invoice': p.invoiceNumber ?? p.id.substring(0, 8),
                  'date': DateFormat('yyyy-MM-dd').format(p.date),
                  'total': p.total.toString(),
                  'tax': p.tax.toString(),
                })
            .toList());
  }

  void _exportToExcel() async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'purchases',
        _purchases
            .map((p) => {
                  'invoice': p.invoiceNumber ?? p.id.substring(0, 8),
                  'date': DateFormat('yyyy-MM-dd').format(p.date),
                  'total': p.total.toString(),
                  'tax': p.tax.toString(),
                })
            .toList());
  }
}
