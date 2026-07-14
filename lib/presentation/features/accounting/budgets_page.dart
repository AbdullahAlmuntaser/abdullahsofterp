import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/budget_service.dart';
import 'package:supermarket/injection_container.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedPeriod = DateTime.now().year.toString();
  int? _selectedCostCenterId;
  int? _selectedAccountId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = context.read<AppDatabase>();
    final budgetService = sl<BudgetService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.list), text: l10n.budgetList),
            Tab(icon: const Icon(Icons.add_circle), text: l10n.createBudget),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBudgetsList(db),
          _buildCreateBudgetForm(db, budgetService),
        ],
      ),
    );
  }

  Widget _buildBudgetsList(AppDatabase db) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<AccBudget>>(
      stream: (db.select(db.accBudgets)
            ..orderBy([(b) => drift.OrderingTerm.desc(b.createdAt)]))
          .watch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final budgets = snapshot.data ?? [];

        if (budgets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined,
                    size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(l10n.noBudgetsFound,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                const SizedBox(height: 8),
                Text(l10n.createBudgetHint),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];
            final progress = budget.budgetedAmount > Decimal.zero
                ? (budget.actualAmount / budget.budgetedAmount).toDecimal()
                : Decimal.zero;
            final variance = budget.budgetedAmount - budget.actualAmount;
            final isOverBudget = variance < Decimal.zero;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            budget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: budget.status == 'active'
                                ? Colors.green.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            budget.status == 'active' ? l10n.statusActive : l10n.closed,
                            style: TextStyle(
                              color: budget.status == 'active'
                                  ? Colors.green.shade700
                                  : Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.periodLabel(budget.period),
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBudgetInfo(
                          l10n.budgeted,
                          NumberFormat.currency(symbol: '')
                              .format(budget.budgetedAmount),
                          Colors.blue,
                        ),
                        _buildBudgetInfo(
                          l10n.actual,
                          NumberFormat.currency(symbol: '')
                              .format(budget.actualAmount),
                          Colors.orange,
                        ),
                        _buildBudgetInfo(
                          l10n.variance,
                          NumberFormat.currency(symbol: '').format(variance),
                          isOverBudget ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress.toDouble().clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          progress > Decimal.one ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.consumedPercent((progress.toDouble() * 100).toStringAsFixed(1)),
                      style: TextStyle(
                        color: progress > Decimal.one
                            ? Colors.red
                            : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateBudgetForm(AppDatabase db, BudgetService budgetService) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.budgetName,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterBudgetNameError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: InputDecoration(
                labelText: l10n.period,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              items: _buildPeriodItems(),
              onChanged: (value) => setState(() => _selectedPeriod = value!),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<CostCenter>>(
              future: (db.select(db.costCenters)
                    ..where((c) => c.isActive.equals(true)))
                  .get(),
              builder: (context, snapshot) {
                final costCenters = snapshot.data ?? [];
                return DropdownButtonFormField<int?>(
                  value: _selectedCostCenterId,
                  decoration: InputDecoration(
                    labelText: l10n.costCenterOptional,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.business),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                        value: null, child: Text(l10n.general)),
                    ...costCenters.map((c) => DropdownMenuItem(
                          value: int.tryParse(c.id),
                          child: Text(c.name),
                        )),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedCostCenterId = value),
                );
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<GLAccount>>(
              future: (db.select(db.gLAccounts)).get(),
              builder: (context, snapshot) {
                final accounts = snapshot.data ?? [];
                return DropdownButtonFormField<int?>(
                  value: _selectedAccountId,
                  decoration: InputDecoration(
                    labelText: l10n.accountOptional,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.account_balance),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                        value: null, child: Text(l10n.general)),
                    ...accounts.where((a) => a.type == 'EXPENSE').map(
                          (a) => DropdownMenuItem(
                              value: int.tryParse(a.id), child: Text(a.name)),
                        ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedAccountId = value),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.budgetedAmount,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: l10n.currencySymbol,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterAmountPrompt;
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return l10n.enterAmountError;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () => _createBudget(db),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? l10n.creating : l10n.createBudget),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildPeriodItems() {
    final l10n = AppLocalizations.of(context)!;
    final currentYear = DateTime.now().year;
    return [
      DropdownMenuItem(
          value: currentYear.toString(), child: Text('$currentYear')),
      DropdownMenuItem(
          value: '${currentYear - 1}', child: Text('${currentYear - 1}')),
      DropdownMenuItem(
          value: '${currentYear - 2}', child: Text('${currentYear - 2}')),
      DropdownMenuItem(
          value: '$currentYear-Q1', child: Text('$currentYear - ${l10n.q1}')),
      DropdownMenuItem(
          value: '$currentYear-Q2', child: Text('$currentYear - ${l10n.q2}')),
      DropdownMenuItem(
          value: '$currentYear-Q3', child: Text('$currentYear - ${l10n.q3}')),
      DropdownMenuItem(
          value: '$currentYear-Q4', child: Text('$currentYear - ${l10n.q4}')),
    ];
  }

  Future<void> _createBudget(AppDatabase db) async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);

    try {
      await db.into(db.accBudgets).insert(
            AccBudgetsCompanion.insert(
              name: _nameController.text,
              period: _selectedPeriod,
              costCenterId: drift.Value(_selectedCostCenterId?.toString()),
              accountId: drift.Value(_selectedAccountId?.toString()),
              budgetedAmount: Decimal.parse(_amountController.text),
              variance: Decimal.parse(_amountController.text),
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.budgetCreated),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
        _amountController.clear();
        setState(() {
          _selectedCostCenterId = null;
          _selectedAccountId = null;
        });
        _tabController.animateTo(0);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
