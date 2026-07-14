import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/core/services/financial_closing_service.dart';
import 'package:supermarket/core/auth/auth_provider.dart';
import 'package:supermarket/core/services/accounting_period_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class AccountingPeriodsPage extends StatefulWidget {
  const AccountingPeriodsPage({super.key});

  @override
  State<AccountingPeriodsPage> createState() => _AccountingPeriodsPageState();
}

class _AccountingPeriodsPageState extends State<AccountingPeriodsPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  int _selectedYear = DateTime.now().year;
  String _periodType = 'monthly';
  bool _isBulkCreate = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = context.read<AppDatabase>();
    final periodService = context.read<AccountingPeriodService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountingPeriods),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: l10n.createAutoPeriods,
            onPressed: () => _showBulkCreateDialog(db, periodService),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.addManualPeriod,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _isBulkCreate = !_isBulkCreate;
                          });
                        },
                        icon: Icon(
                            _isBulkCreate ? Icons.close : Icons.auto_awesome),
                        label: Text(_isBulkCreate
                            ? l10n.cancelAutoGeneration
                            : l10n.autoGenerate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.periodName,
                      border: const OutlineInputBorder(),
                      hintText: l10n.examplePeriodName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectStartDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.startDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                  : l10n.selectDate,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectEndDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.endDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                  : l10n.selectDate,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _startDate != null && _endDate != null
                        ? () => _addPeriod(db)
                        : null,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addManualPeriod),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.existingPeriods,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AccountingPeriod>>(
              stream: db.select(db.accountingPeriods).watch(),
              builder: (context, snapshot) {
                final periods = snapshot.data ?? [];
                if (periods.isEmpty) {
                  return Center(child: Text(l10n.noAccountingPeriods));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: periods.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final period = periods[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          period.isClosed
                              ? Icons.lock_outline
                              : Icons.lock_open,
                          color: period.isClosed ? Colors.red : Colors.green,
                        ),
                        title: Text(period.name),
                        subtitle: Text(
                          '${DateFormat('yyyy-MM-dd').format(period.startDate)} - ${DateFormat('yyyy-MM-dd').format(period.endDate)}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            if (!period.isClosed)
                              TextButton.icon(
                                onPressed: () =>
                                    _confirmClosePeriod(db, period),
                                icon: const Icon(Icons.lock, size: 18),
                                label: Text(l10n.closePeriod),
                              ),
                            if (period.isClosed)
                              TextButton.icon(
                                onPressed: () => _reopenPeriod(db, period),
                                icon: const Icon(Icons.lock_open, size: 18),
                                label: Text(l10n.openPeriod),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePeriod(db, period),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => _startDate = date);
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => _endDate = date);
  }

  Future<void> _addPeriod(AppDatabase db) async {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseFillAllFields)));
      return;
    }

    await db.into(db.accountingPeriods).insert(
          AccountingPeriodsCompanion.insert(
            id: drift.Value(const Uuid().v4()),
            name: _nameController.text,
            fiscalYear: _startDate!.year,
            startDate: _startDate!,
            endDate: _endDate!,
            status: const drift.Value('OPEN'),
          ),
        );

    _nameController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.periodAddedSuccessfully)));
    }
  }

  Future<void> _confirmClosePeriod(
    AppDatabase db,
    AccountingPeriod period,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClosePeriod),
        content: Text(
          '${l10n.closePeriodMessage}\n'
          '${l10n.closePeriodMessage}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmGeneric),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _closePeriod(db, period);
    }
  }

  Future<void> _closePeriod(AppDatabase db, AccountingPeriod period) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final authProvider = context.read<AuthProvider>();
      final closingService = context.read<FinancialClosingService>();

      final result = await closingService.closeMonthlyPeriod(
        periodId: period.id,
        userId: authProvider.currentUser?.id ?? '',
      );

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result.message), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result.error ?? l10n.failedToClosePeriod),
                backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${l10n.failedToClosePeriod}: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _reopenPeriod(AppDatabase db, AccountingPeriod period) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final authProvider = context.read<AuthProvider>();
      final closingService = context.read<FinancialClosingService>();

      final result = await closingService.reopenPeriod(
        period.id,
        authProvider.currentUser?.id ?? '',
        authProvider.currentUser?.id ?? '',
      );

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result.message), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result.error ?? l10n.failedToReopenPeriod),
                backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${l10n.failedToReopenPeriod}: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deletePeriod(AppDatabase db, AccountingPeriod period) async {
    final l10n = AppLocalizations.of(context)!;
    if (period.isClosed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cannotDeleteClosedPeriod)));
      return;
    }

    final entryCount = await (db.select(db.gLEntries)
          ..where(
              (e) => e.date.isBiggerOrEqual(drift.Variable(period.startDate)))
          ..where(
              (e) => e.date.isSmallerOrEqual(drift.Variable(period.endDate))))
        .get();

    if (!mounted) return;

    if (entryCount.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotDeletePeriodWithEntries),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await (db.delete(
      db.accountingPeriods,
    )..where((p) => p.id.equals(period.id)))
        .go();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.periodDeleted)));
    }
  }

  Future<void> _showBulkCreateDialog(
    AppDatabase db,
    AccountingPeriodService periodService,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    int year = _selectedYear;
    String type = _periodType;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.createAutoPeriods),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: year,
                decoration: InputDecoration(
                  labelText: l10n.year,
                  border: const OutlineInputBorder(),
                ),
                items: List.generate(10, (i) => DateTime.now().year - 5 + i)
                    .map((y) => DropdownMenuItem(
                          value: y,
                          child: Text(y.toString()),
                        ))
                    .toList(),
                onChanged: (v) => setDialogState(() => year = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                decoration: InputDecoration(
                  labelText: l10n.periodType,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                      value: 'monthly', child: Text(l10n.monthly)),
                  DropdownMenuItem(
                      value: 'quarterly', child: Text(l10n.quarterly)),
                  DropdownMenuItem(
                      value: 'yearly', child: Text(l10n.yearly)),
                ],
                onChanged: (v) => setDialogState(() => type = v!),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.autoPeriodInfo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _bulkCreatePeriods(db, periodService, year, type);
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.autoGenerate),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bulkCreatePeriods(
    AppDatabase db,
    AccountingPeriodService periodService,
    int year,
    String type,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final count =
          await periodService.bulkCreatePeriods(year: year, type: type);

      if (mounted) {
        setState(() {
          _selectedYear = year;
          _periodType = type;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.periodsCreated(count.toString())),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToCreatePeriods(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
