import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/accounting_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class ReconciliationPage extends StatefulWidget {
  const ReconciliationPage({super.key});

  @override
  State<ReconciliationPage> createState() => _ReconciliationPageState();
}

class _ReconciliationPageState extends State<ReconciliationPage> {
  String? _selectedAccountId;
  final _actualBalanceController = TextEditingController();
  final _noteController = TextEditingController();
  double _bookBalance = 0.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reconciliation)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAccountSelector(db),
            const SizedBox(height: 20),
            if (_selectedAccountId != null) ...[
              _buildBalanceComparison(),
              const SizedBox(height: 20),
              TextField(
                controller: _actualBalanceController,
                decoration: InputDecoration(
                  labelText: l10n.actualBalance,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.reconciliationNotes,
                  border: const OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              _buildSubmitButton(db),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSelector(AppDatabase db) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<GLAccount>>(
      stream: (db.select(db.gLAccounts)
            ..where(
              (t) =>
                  t.code.equals(AccountingService.codeCash) |
                  t.code.equals(AccountingService.codeBank),
            ))
          .watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return DropdownButtonFormField<String>(
          value: _selectedAccountId,
          decoration: InputDecoration(
            labelText: l10n.selectAccount,
          ),
          items: snapshot.data!
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
              .toList(),
          onChanged: (val) async {
            if (val != null) {
              final balance = await db.accountingDao.getAccountBalance(val);
              setState(() {
                _selectedAccountId = val;
                _bookBalance = balance.toDouble();
              });
            }
          },
        );
      },
    );
  }

  Widget _buildBalanceComparison() {
    final l10n = AppLocalizations.of(context)!;
    final actual = double.tryParse(_actualBalanceController.text) ?? 0.0;
    final diff = actual - _bookBalance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _row('${l10n.bookBalance}:', _bookBalance.toStringAsFixed(2)),
          const Divider(),
          _row(
            '${l10n.difference}:',
            diff.toStringAsFixed(2),
            color: diff < 0 ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppDatabase db) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          final actual = double.tryParse(_actualBalanceController.text) ?? 0.0;
          final diff = actual - _bookBalance;

          if (diff == 0) {
            await db.into(db.reconciliations).insert(
                  ReconciliationsCompanion.insert(
                    accountId: _selectedAccountId!,
                    bookBalance:
                        drift.Value(Decimal.parse(_bookBalance.toString())),
                    actualBalance:
                        drift.Value(Decimal.parse(actual.toString())),
                    difference: drift.Value(Decimal.parse(diff.toString())),
                    note: drift.Value(_noteController.text),
                  ),
                );
          } else {
            final cashAccount = await db.accountingDao.getAccountByCode(
              AccountingService.codeCash,
            );
            final cashOverShort = await db.accountingDao.getAccountByCode(
              AccountingService.codeCashOverShort,
            );

            if (cashAccount == null || cashOverShort == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.cashOverShortNotFound),
                  ),
                );
              }
              return;
            }

            final entryId = const Uuid().v4();
            final absDiff = diff.abs();

            final entry = GLEntriesCompanion.insert(
              id: drift.Value(entryId),
              description: l10n.reconciliationDescription(
                _noteController.text.isEmpty ? l10n.reconciliationDifference : _noteController.text,
              ),
              date: drift.Value(DateTime.now()),
              referenceType: const drift.Value('RECONCILIATION'),
              referenceId: drift.Value(entryId),
              status: const drift.Value('POSTED'),
              postedAt: drift.Value(DateTime.now()),
            );

            final lines = diff > 0
                ? [
                    GLLinesCompanion.insert(
                      entryId: entryId,
                      accountId: cashAccount.id,
                      debit: drift.Value(Decimal.parse(absDiff.toString())),
                      credit: drift.Value(Decimal.zero),
                    ),
                    GLLinesCompanion.insert(
                      entryId: entryId,
                      accountId: cashOverShort.id,
                      debit: drift.Value(Decimal.zero),
                      credit: drift.Value(Decimal.parse(absDiff.toString())),
                    ),
                  ]
                : [
                    GLLinesCompanion.insert(
                      entryId: entryId,
                      accountId: cashOverShort.id,
                      debit: drift.Value(Decimal.parse(absDiff.toString())),
                      credit: drift.Value(Decimal.zero),
                    ),
                    GLLinesCompanion.insert(
                      entryId: entryId,
                      accountId: cashAccount.id,
                      debit: drift.Value(Decimal.zero),
                      credit: drift.Value(Decimal.parse(absDiff.toString())),
                    ),
                  ];

            await db.accountingDao.createEntry(entry, lines);

            await db.into(db.reconciliations).insert(
                  ReconciliationsCompanion.insert(
                    accountId: _selectedAccountId!,
                    bookBalance:
                        drift.Value(Decimal.parse(_bookBalance.toString())),
                    actualBalance:
                        drift.Value(Decimal.parse(actual.toString())),
                    difference: drift.Value(Decimal.parse(diff.toString())),
                    note: drift.Value(_noteController.text),
                  ),
                );
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.reconciliationSuccess)),
            );
            _actualBalanceController.clear();
            _noteController.clear();
            setState(() => _bookBalance = 0.0);
          }
        },
        child: Text(l10n.confirmAndRecordReconciliation),
      ),
    );
  }
}
