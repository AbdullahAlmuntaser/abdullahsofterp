import 'package:supermarket/core/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/presentation/features/accounting/accounting_provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class ManualJournalEntryPage extends StatefulWidget {
  const ManualJournalEntryPage({super.key});

  @override
  State<ManualJournalEntryPage> createState() => _ManualJournalEntryPageState();
}

class _ManualJournalEntryPageState extends State<ManualJournalEntryPage> {
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<ManualLine> _lines = [ManualLine(), ManualLine()];

  Decimal get _totalDebit =>
      _lines.fold(Decimal.zero, (sum, l) => sum + l.debit);
  Decimal get _totalCredit =>
      _lines.fold(Decimal.zero, (sum, l) => sum + l.credit);
  bool get _isBalanced =>
      (_totalDebit - _totalCredit).abs() < Decimal.parse('0.001') &&
      _totalDebit > Decimal.zero;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<AccountingProvider>();
    final db = context.watch<AppDatabase>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manualJournalEntry), elevation: 0),
      body: StreamBuilder<List<GLAccount>>(
        stream: provider.watchAccounts(),
        builder: (context, accSnapshot) {
          return StreamBuilder<List<CostCenter>>(
            stream: db.select(db.costCenters).watch(),
            builder: (context, ccSnapshot) {
              final accounts =
                  (accSnapshot.data ?? []).where((a) => !a.isHeader).toList();
              final costCenters = ccSnapshot.data ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildHeader(colorScheme, l10n),
                    const SizedBox(height: 16),
                    ..._lines.asMap().entries.map(
                          (entry) => _buildLineCard(entry.key, entry.value,
                              accounts, costCenters, colorScheme, l10n),
                        ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _lines.add(ManualLine())),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addAccountToEntry),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomSheet: _buildPersistentFooter(provider, l10n),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.entryDescription,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.entryDate,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineCard(
    int index,
    ManualLine line,
    List<GLAccount> accounts,
    List<CostCenter> costCenters,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: line.accountId,
                    decoration: InputDecoration(
                        labelText: l10n.account, isDense: true),
                    items: accounts
                        .map((a) => DropdownMenuItem(
                            value: a.id, child: Text('${a.code} - ${a.name}')))
                        .toList(),
                    onChanged: (val) => setState(() => line.accountId = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: line.costCenterId,
                    decoration: InputDecoration(
                        labelText: l10n.costCenter, isDense: true),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(l10n.noCostCenter)),
                      ...costCenters.map((cc) =>
                          DropdownMenuItem(value: cc.id, child: Text(cc.name))),
                    ],
                    onChanged: (val) => setState(() => line.costCenterId = val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => setState(() => _lines.removeAt(index)),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.debit),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() =>
                        line.debit = Decimal.tryParse(val) ?? Decimal.zero),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.credit),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() =>
                        line.credit = Decimal.tryParse(val) ?? Decimal.zero),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentFooter(AccountingProvider provider, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${l10n.debit}: $_totalDebit'),
              Text('${l10n.credit}: $_totalCredit'),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isBalanced ? () => _saveEntry(provider) : null,
              child: Text(_isBalanced ? l10n.saveAndPost : l10n.entryNotBalanced),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEntry(AccountingProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    if (_descriptionController.text.trim().isEmpty) {
      AppSnackBar.warning(context, l10n.pleaseEnterDescription);
      return;
    }

    final db = context.read<AppDatabase>();
    final inClosedPeriod =
        await db.accountingDao.isDateInClosedPeriod(_selectedDate);
    if (!mounted) return;
    if (inClosedPeriod) {
      AppSnackBar.error(context, l10n.cannotPostToClosedPeriod);
      return;
    }

    for (var i = 0; i < _lines.length; i++) {
      final line = _lines[i];
      if (line.accountId == null &&
          (line.debit > Decimal.zero || line.credit > Decimal.zero)) {
        AppSnackBar.warning(context, l10n.pleaseSelectAccountForLine(i + 1));
        return;
      }
      if (line.debit > Decimal.zero && line.credit > Decimal.zero) {
        AppSnackBar.warning(
          context,
          l10n.lineCannotHaveDebitAndCredit(i + 1),
        );
        return;
      }
      if (line.accountId != null &&
          line.debit == Decimal.zero &&
          line.credit == Decimal.zero) {
        AppSnackBar.warning(
          context,
          l10n.lineHasAccountWithoutAmount(i + 1),
        );
        return;
      }
    }

    final userId =
        Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
    final lines = _lines
        .where((l) => l.accountId != null)
        .map((l) => GLLinesCompanion.insert(
              entryId: '',
              accountId: l.accountId!,
              costCenterId: drift.Value(l.costCenterId),
              debit: drift.Value(l.debit),
              credit: drift.Value(l.credit),
            ))
        .toList();

    try {
      await provider.createManualEntry(
        context: context,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        lines: lines,
        userId: userId,
      );
      if (!mounted) return;
      AppSnackBar.success(context, l10n.entrySavedAndPosted);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, l10n.failedToSaveEntry(e.toString()));
    }
  }
}

class ManualLine {
  String? accountId;
  String? costCenterId;
  Decimal debit = Decimal.zero;
  Decimal credit = Decimal.zero;
}
