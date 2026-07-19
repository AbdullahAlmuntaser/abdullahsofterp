import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/utils/stock_display_adapter.dart';

class LowStockReport extends StatefulWidget {
  const LowStockReport({super.key});

  @override
  State<LowStockReport> createState() => _LowStockReportState();
}

class _LowStockReportState extends State<LowStockReport> {
  final Map<String, String> _formattedStocks = {};

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final adapter = StockDisplayAdapter(db);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.lowStockProducts,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Product>>(
              stream: db.watchLowStockProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Text(l10n.noLowStockProducts),
                  );
                }

                _prefetchFormatted(adapter, products);

                return DataTable(
                  columns: [
                    DataColumn(label: Text(l10n.productName)),
                    DataColumn(label: Text(l10n.stockLabel)),
                    DataColumn(label: Text(l10n.alertLimit), numeric: true),
                  ],
                  rows: products.map((product) {
                    return DataRow(
                      cells: [
                        DataCell(Text(product.name)),
                        DataCell(
                          Text(
                            _formattedStocks[product.id] ?? product.stock.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        DataCell(Text(product.alertLimit.toString())),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _prefetchFormatted(StockDisplayAdapter adapter, List<Product> products) {
    for (final p in products) {
      if (!_formattedStocks.containsKey(p.id)) {
        adapter.formatProductStock(p).then((v) {
          if (mounted) setState(() => _formattedStocks[p.id] = v);
        });
      }
    }
  }
}
