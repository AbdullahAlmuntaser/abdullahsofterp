import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/bank_reconciliation_service.dart';
import 'package:supermarket/core/services/accounting_service.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class BankReconciliationPage extends StatefulWidget {
  const BankReconciliationPage({super.key});

  @override
  State<BankReconciliationPage> createState() => _BankReconciliationPageState();
}

class _BankReconciliationPageState extends State<BankReconciliationPage> {
  String? _selectedAccountId;
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  List<UnmatchedTransaction> _transactions = [];
  final Set<String> _selectedTxIds = {};
  bool _isLoading = false;
  bool _selectAll = false;
  final _actualBalanceController = TextEditingController();
  final _toleranceController = TextEditingController(text: '0.01');
  final _noteController = TextEditingController();
  double _bookBalance = 0.0;

  late BankReconciliationService _reconciliationService;
  late AppDatabase _db;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = context.read<AppDatabase>();
    _reconciliationService = BankReconciliationService(_db);
  }

  @override
  void dispose() {
    _actualBalanceController.dispose();
    _toleranceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bankReconciliation),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterRow(),
            const SizedBox(height: 16),
            if (_selectedAccountId != null) ...[
              _buildBalanceSummary(),
              const SizedBox(height: 16),
              _buildTransactionList(),
            ] else
              Expanded(
                child: Center(
                  child: Text(
                    l10n.selectBankAccountPrompt,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: StreamBuilder<List<GLAccount>>(
                    stream: (_db.select(_db.gLAccounts)
                          ..where((t) =>
                              t.code.equals(AccountingService.codeBank) |
                              t.code.like('112%'))
                          ..orderBy(
                              [(t) => drift.OrderingTerm(expression: t.code)]))
                        .watch(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final accounts = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedAccountId,
                        decoration: InputDecoration(
                          labelText: l10n.bankAccount,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: accounts
                            .map((a) => DropdownMenuItem(
                                  value: a.id,
                                  child: Text('${a.code} - ${a.name}'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedAccountId = val;
                            _selectedTxIds.clear();
                            _selectAll = false;
                          });
                          _loadTransactions();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDateField(
                    label: l10n.fromDate,
                    date: _fromDate,
                    onChanged: (d) => setState(() => _fromDate = d),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDateField(
                    label: l10n.toDate,
                    date: _toDate,
                    onChanged: (d) => setState(() => _toDate = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _actualBalanceController,
                    decoration: InputDecoration(
                      labelText: l10n.actualBalance,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _toleranceController,
                    decoration: InputDecoration(
                      labelText: l10n.tolerance,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _loadTransactions,
                    icon: const Icon(Icons.search, size: 18),
                    label: Text(l10n.search),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required Function(DateTime) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(DateFormat('yyyy-MM-dd').format(date)),
      ),
    );
  }

  Widget _buildBalanceSummary() {
    final l10n = AppLocalizations.of(context)!;
    final actual = double.tryParse(_actualBalanceController.text) ?? 0.0;
    final diff = actual - _bookBalance;

    return Card(
      color: Colors.blueGrey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _summaryItem(l10n.bookBalance, _bookBalance, Colors.blue),
            const SizedBox(width: 24),
            _summaryItem(l10n.actualBalance, actual, Colors.green),
            const SizedBox(width: 24),
            _summaryItem(
              l10n.difference,
              diff,
              diff == 0
                  ? Colors.green
                  : diff > 0
                      ? Colors.orange
                      : Colors.red,
            ),
            const SizedBox(width: 24),
            _summaryItem(
              l10n.selectedTransactions,
              _selectedTxIds.length.toDouble(),
              Colors.purple,
              isCount: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, double value, Color color,
      {bool isCount = false}) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          isCount ? '${value.toInt()}' : '${value.toStringAsFixed(2)} ${l10n.currencySymbol}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: Card(
        child: Column(
          children: [
            _buildListHeader(),
            const Divider(height: 1),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_transactions.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    l10n.noUnmatchedTransactions,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    final isSelected = _selectedTxIds.contains(tx.glLineId);
                    return _buildTransactionRow(tx, isSelected);
                  },
                ),
              ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: _selectAll,
              onChanged: (val) {
                setState(() {
                  _selectAll = val ?? false;
                  if (_selectAll) {
                    _selectedTxIds.addAll(_transactions.map((t) => t.glLineId));
                  } else {
                    _selectedTxIds.clear();
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(l10n.description,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.reference,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.amount,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(UnmatchedTransaction tx, bool isSelected) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTxIds.remove(tx.glLineId);
          } else {
            _selectedTxIds.add(tx.glLineId);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : null,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Checkbox(
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedTxIds.add(tx.glLineId);
                    } else {
                      _selectedTxIds.remove(tx.glLineId);
                    }
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('yyyy-MM-dd').format(tx.date),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                tx.description,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                tx.reference,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${tx.amount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: tx.amount >= Decimal.zero ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: l10n.reconciliationNotesHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _selectedTxIds.isEmpty ? null : _reconcileSelected,
            icon: const Icon(Icons.check_circle, size: 18),
            label: Text(l10n.reconcileSelected),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _autoReconcile,
            icon: const Icon(Icons.auto_fix_high, size: 18),
            label: Text(l10n.autoReconcile),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _reconcileAll,
            icon: const Icon(Icons.done_all, size: 18),
            label: Text(l10n.reconcileAll),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTransactions() async {
    if (_selectedAccountId == null) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _selectedTxIds.clear();
      _selectAll = false;
    });

    try {
      final transactions =
          await _reconciliationService.getUnmatchedTransactions(
        accountId: _selectedAccountId!,
        fromDate: _fromDate,
        toDate: _toDate,
      );

      final balance =
          await _db.accountingDao.getAccountBalance(_selectedAccountId!);

      if (mounted) {
        setState(() {
          _transactions = transactions;
          _bookBalance = balance.toDouble();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingTransactions(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reconcileSelected() async {
    if (_selectedAccountId == null || _selectedTxIds.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      for (final txId in _selectedTxIds) {
        final tx = _transactions.firstWhere((t) => t.glLineId == txId);
        await _reconciliationService.reconcileTransaction(
          accountId: _selectedAccountId!,
          glLineId: tx.glLineId,
          entryId: tx.entryId,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reconcileSuccessCount(_selectedTxIds.length)),
            backgroundColor: Colors.green,
          ),
        );
      }

      _loadTransactions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reconciliationError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _autoReconcile() async {
    if (_selectedAccountId == null) return;
    final l10n = AppLocalizations.of(context)!;

    final tolerance =
        Decimal.tryParse(_toleranceController.text) ?? Decimal.zero;

    try {
      final bankLines = _transactions.map((tx) => BankStatementLine(
        date: tx.date,
        description: tx.description,
        amount: tx.amount,
        reference: tx.reference,
      )).toList();

      final matched = await _reconciliationService.autoReconcile(
        accountId: _selectedAccountId!,
        bankLines: bankLines,
        tolerance: tolerance,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.autoReconcileCount(matched)),
            backgroundColor: Colors.blue,
          ),
        );
      }

      _loadTransactions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.autoReconcileError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reconcileAll() async {
    if (_selectedAccountId == null || _transactions.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.reconcileAll),
          content: Text(dialogL10n.reconcileAllConfirm(_transactions.length)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.confirmGeneric),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      for (final tx in _transactions) {
        await _reconciliationService.reconcileTransaction(
          accountId: _selectedAccountId!,
          glLineId: tx.glLineId,
          entryId: tx.entryId,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reconcileAllSuccess(_transactions.length)),
            backgroundColor: Colors.green,
          ),
        );
      }

      _loadTransactions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reconciliationError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
