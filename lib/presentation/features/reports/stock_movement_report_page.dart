import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';

class StockMovementReportPage extends StatefulWidget {
  const StockMovementReportPage({super.key});

  @override
  State<StockMovementReportPage> createState() =>
      _StockMovementReportPageState();
}

class _StockMovementReportPageState extends State<StockMovementReportPage> {
  List<StockMovement> _movements = [];
  bool _isLoading = true;
  String? _selectedProductId;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = di.sl<AppDatabase>();
    var query = db.select(db.stockMovements)
      ..orderBy([(m) => OrderingTerm.desc(m.movementDate)]);
    if (_selectedProductId != null) {
      query = query..where((m) => m.productId.equals(_selectedProductId!));
    }
    if (_selectedType != null) {
      query = query..where((m) => m.type.equals(_selectedType!));
    }
    _movements = await query.get();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrHrkhAlmkhzwn),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf), onPressed: _export),
          IconButton(icon: const Icon(Icons.table_chart), onPressed: _export),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(l10n),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _movements.length,
                    itemBuilder: (context, index) {
                      final m = _movements[index];
                      return ListTile(
                        leading: Icon(
                          _getMovementIcon(m.type),
                          color: _getMovementColor(m.type),
                        ),
                        title: Text(l10n.productIdLabel(m.productId.substring(0, 8))),
                        subtitle: Text('${m.type} - ${m.movementDate}'),
                        trailing: Text(
                          '${m.quantity > Decimal.zero ? '+' : ''}${m.quantity}',
                          style: TextStyle(
                            color: m.quantity > Decimal.zero
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  hintText: l10n.alnwa),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                DropdownMenuItem(value: 'purchase', child: Text(l10n.buyAction)),
                DropdownMenuItem(value: 'sale', child: Text(l10n.sell)),
                DropdownMenuItem(value: 'adjustment', child: Text(l10n.edit)),
                DropdownMenuItem(
                    value: 'transferIn', child: Text(l10n.thwylWard)),
                DropdownMenuItem(
                    value: 'transferOut', child: Text(l10n.thwylSadr)),
              ],
              onChanged: (val) => setState(() {
                _selectedType = val;
                _loadData();
              }),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMovementIcon(String type) {
    switch (type) {
      case 'purchase':
        return Icons.add_shopping_cart;
      case 'sale':
        return Icons.shopping_cart;
      case 'adjustment':
        return Icons.tune;
      case 'transferIn':
        return Icons.arrow_downward;
      case 'transferOut':
        return Icons.arrow_upward;
      default:
        return Icons.inventory;
    }
  }

  Color _getMovementColor(String type) {
    switch (type) {
      case 'purchase':
        return Colors.green;
      case 'sale':
        return Colors.red;
      case 'adjustment':
        return Colors.orange;
      case 'transferIn':
        return Colors.blue;
      case 'transferOut':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _export() async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'stock_movements',
        _movements
            .map((m) => {
                  'productId': m.productId,
                  'type': m.type,
                  'quantity': m.quantity.toString(),
                  'date': m.movementDate.toString(),
                })
            .toList());
  }
}
