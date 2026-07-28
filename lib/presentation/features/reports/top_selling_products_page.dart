import 'package:flutter/material.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';

class TopSellingProductsPage extends StatefulWidget {
  const TopSellingProductsPage({super.key});

  @override
  State<TopSellingProductsPage> createState() => _TopSellingProductsPageState();
}

class _TopSellingProductsPageState extends State<TopSellingProductsPage> {
  List<Map<String, dynamic>> _topProducts = [];
  bool _isLoading = true;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = di.sl<AppDatabase>();

    final rows = await db
        .customSelect(
          'SELECT si.product_id as productId, p.name as productName, '
          'SUM(CAST(si.quantity AS REAL)) as totalQty, '
          'SUM(CAST(si.quantity AS REAL) * CAST(si.price AS REAL)) as totalRevenue '
          'FROM sale_items si '
          'INNER JOIN products p ON p.id = si.product_id '
          'GROUP BY si.product_id '
          'ORDER BY totalRevenue DESC '
          'LIMIT $_limit',
        )
        .get();

    _topProducts = rows
        .map((row) => {
              'productId': row.read<String>('productId'),
              'name': row.read<String>('productName'),
              'totalQty': row.read<double>('totalQty'),
              'totalRevenue': row.read<double>('totalRevenue'),
            })
        .toList();

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxRevenue = _topProducts.isNotEmpty
        ? (_topProducts.first['totalRevenue'] as double)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.almntjatAlakthrMbyaa),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf), onPressed: _export),
          IconButton(icon: const Icon(Icons.table_chart), onPressed: _export),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _topProducts.length,
              itemBuilder: (context, index) {
                final item = _topProducts[index];
                final revenue = item['totalRevenue'] as double;
                final ratio = maxRevenue > 0 ? revenue / maxRevenue : 0.0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text('${index + 1}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(item['name'] ?? ''),
                  subtitle: Row(
                    children: [
                      Text(l10n.qtyLabel(
                          (item['totalQty'] as double).toStringAsFixed(0))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  trailing: Text('${(revenue).toStringAsFixed(2)} ${l10n.currencySar}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }

  void _export() async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'top_selling_products',
        _topProducts
            .map((item) => {
                  'name': item['name'] ?? '',
                  'quantity': (item['totalQty'] as double).toString(),
                  'revenue': (item['totalRevenue'] as double).toString(),
                })
            .toList());
  }
}
