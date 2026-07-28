import 'package:flutter/material.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class CustomerReportPage extends StatefulWidget {
  const CustomerReportPage({super.key});

  @override
  State<CustomerReportPage> createState() => _CustomerReportPageState();
}

class _CustomerReportPageState extends State<CustomerReportPage> {
  List<Customer> _customers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = di.sl<AppDatabase>();
    _customers = await (db.select(db.customers)
          ..where((c) => c.isActive.equals(true)))
        .get();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _customers
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.phone?.contains(_searchQuery) ?? false))
        .toList();

    final totalBalance =
        filtered.fold<double>(0, (sum, c) => sum + c.balance.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrAlamlaa),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(filtered),
            tooltip: l10n.tsdyrPDF,
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: () => _exportToExcel(filtered),
            tooltip: l10n.tsdyrExcel,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.bhthBalasmAwAlhatf,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(l10n.totalCustomers, '${filtered.length}'),
                _statItem(l10n.alrsydAlijmaly,
                    '${totalBalance.toStringAsFixed(2)} ${l10n.currencySar}'),
                _statItem(l10n.dhmmMdynh,
                    '${filtered.where((c) => c.balance > Decimal.zero).length}'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final customer = filtered[index];
                      return ListTile(
                        title: Text(customer.name),
                        subtitle: Text(customer.phone ?? ''),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${customer.balance} ${l10n.currencySar}',
                              style: TextStyle(
                                color: customer.balance > Decimal.zero
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${l10n.creditLimitLabel}: ${customer.creditLimit}',
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      );
                    },
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _exportToPdf(List<Customer> data) async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToPdf(
        'customers',
        data
            .map((c) => {
                  'name': c.name,
                  'phone': c.phone ?? '',
                  'balance': c.balance.toString(),
                  'creditLimit': c.creditLimit.toString(),
                })
            .toList());
  }

  void _exportToExcel(List<Customer> data) async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'customers',
        data
            .map((c) => {
                  'name': c.name,
                  'phone': c.phone ?? '',
                  'balance': c.balance.toString(),
                  'creditLimit': c.creditLimit.toString(),
                })
            .toList());
  }
}
