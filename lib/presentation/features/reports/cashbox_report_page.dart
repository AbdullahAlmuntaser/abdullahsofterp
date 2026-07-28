import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class CashboxReportPage extends StatefulWidget {
  const CashboxReportPage({super.key});

  @override
  State<CashboxReportPage> createState() => _CashboxReportPageState();
}

class _CashboxReportPageState extends State<CashboxReportPage> {
  List<CashboxTransaction> _transactions = [];
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
    _transactions = await (db.select(db.cashboxTransactions)
          ..where((t) =>
              t.createdAt.isBiggerOrEqual(Variable(_startDate)) &
              t.createdAt.isSmallerOrEqual(Variable(_endDate)))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalIn = _transactions
        .where((t) => t.type == 'IN')
        .fold<double>(0, (sum, t) => sum + t.amount.toDouble());
    final totalOut = _transactions
        .where((t) => t.type == 'OUT')
        .fold<double>(0, (sum, t) => sum + t.amount.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrAlsnadyq),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf), onPressed: _export),
          IconButton(icon: const Icon(Icons.table_chart), onPressed: _export),
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
                _statItem(
                    l10n.ijmalyAlward, totalIn.toStringAsFixed(2), Colors.green),
                _statItem(
                    l10n.ijmalyAlsadr, totalOut.toStringAsFixed(2), Colors.red),
                _statItem(l10n.alsafy, (totalIn - totalOut).toStringAsFixed(2),
                    Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final t = _transactions[index];
                      return ListTile(
                        leading: Icon(
                          t.type == 'IN'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.type == 'IN' ? Colors.green : Colors.red,
                        ),
                        title: Text(t.note ?? t.category),
                        subtitle: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(t.createdAt)),
                        trailing: Text(
                          '${t.type == 'IN' ? '+' : '-'}${t.amount} ${l10n.currencySar}',
                          style: TextStyle(
                            color: t.type == 'IN' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
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

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  void _export() async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'cashbox',
        _transactions
            .map((t) => {
                  'type': t.type,
                  'amount': t.amount.toString(),
                  'note': t.note ?? '',
                  'date': t.createdAt.toIso8601String(),
                })
            .toList());
  }
}
