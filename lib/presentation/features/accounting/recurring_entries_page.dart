// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/recurring_entry_service.dart';
import 'package:supermarket/injection_container.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class RecurringEntriesPage extends StatefulWidget {
  const RecurringEntriesPage({super.key});

  @override
  State<RecurringEntriesPage> createState() => _RecurringEntriesPageState();
}

class _RecurringEntriesPageState extends State<RecurringEntriesPage> {
  late final RecurringEntryService _service;

  @override
  void initState() {
    super.initState();
    _service = RecurringEntryService(sl<AppDatabase>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recurringEntries),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: l10n.executeDueEntries,
            onPressed: _executeDueEntries,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addRecurringEntry,
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<RecurringEntry>>(
        stream: _service.watchAllEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noRecurringEntries,
                      style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(l10n.tapToAddRecurringEntry,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (context, index) =>
                _buildEntryCard(context, entries[index]),
          );
        },
      ),
    );
  }

  Widget _buildEntryCard(BuildContext context, RecurringEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    final frequencyMap = {
      'DAILY': l10n.dailyFreq,
      'WEEKLY': l10n.weeklyFreq,
      'BIWEEKLY': l10n.biweeklyFreq,
      'MONTHLY': l10n.monthlyFreq,
      'QUARTERLY': l10n.quarterlyFreq,
      'YEARLY': l10n.yearlyFreq,
    };
    final statusMap = {
      'active': (l10n.statusActive, Colors.green),
      'paused': (l10n.statusPaused, Colors.orange),
      'completed': (l10n.statusCompleted, Colors.blue),
    };

    final statusInfo = statusMap[entry.status] ?? (l10n.statusUnknown, Colors.grey);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusInfo.$2.withOpacity(0.2),
          child: Icon(
            entry.status == 'active' ? Icons.replay : Icons.pause,
            color: statusInfo.$2,
          ),
        ),
        title: Text(entry.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${frequencyMap[entry.frequency] ?? entry.frequency} | ${entry.amount}'),
            Text(
              l10n.fromToAccounts(entry.creditAccountCode, entry.debitAccountCode),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              l10n.nextExecutionDate(entry.nextExecutionDate.toString().substring(0, 10)),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              entry.maxExecutions != null
                  ? l10n.executedCount(entry.totalExecutions, entry.maxExecutions!)
                  : l10n.executedCountNoLimit(entry.totalExecutions),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value, entry),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
            PopupMenuItem(
              value: entry.status == 'active' ? 'pause' : 'resume',
              child: Text(entry.status == 'active' ? l10n.pause : l10n.resume),
            ),
            PopupMenuItem(value: 'execute', child: Text(l10n.executeNow)),
            PopupMenuItem(value: 'history', child: Text(l10n.executionHistory)),
            PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _handleMenuAction(
      BuildContext context, String action, RecurringEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    switch (action) {
      case 'edit':
        _showEditDialog(context, entry);
        break;
      case 'pause':
        await _service.pauseEntry(entry.id);
        break;
      case 'resume':
        await _service.resumeEntry(entry.id);
        break;
      case 'execute':
        try {
          await _service.executeEntryNow(entry.id);
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.entryExecutedSuccessfully)),
          );
        } catch (e) {
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.errorWithMessage(e.toString()))),
          );
        }
        break;
      case 'history':
        _showExecutionHistory(context, entry);
        break;
      case 'delete':
        _confirmDelete(context, entry);
        break;
    }
  }

  Future<void> _executeDueEntries() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _service.executeDueEntries();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.executionResult(result.failCount, result.successCount),
          ),
        ),
      );
    }
  }

  void _showAddDialog(BuildContext context) {
    _showEntryForm(context, null);
  }

  void _showEditDialog(BuildContext context, RecurringEntry entry) {
    _showEntryForm(context, entry);
  }

  void _showEntryForm(BuildContext context, RecurringEntry? existing) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final amountCtrl =
        TextEditingController(text: existing?.amount.toString() ?? '');
    final debitCtrl =
        TextEditingController(text: existing?.debitAccountCode ?? '');
    final creditCtrl =
        TextEditingController(text: existing?.creditAccountCode ?? '');
    String frequency = existing?.frequency ?? 'MONTHLY';
    String referenceType = existing?.referenceType ?? 'EXPENSE';
    DateTime startDate = existing?.startDate ?? DateTime.now();
    DateTime? endDate = existing?.endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? l10n.addRecurringEntry : l10n.edit),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.entryName, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.amount, border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: debitCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.debitAccountCode, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: creditCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.creditAccountCode, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: InputDecoration(
                      labelText: l10n.frequency, border: const OutlineInputBorder()),
                  items: [
                    DropdownMenuItem(value: 'DAILY', child: Text(l10n.dailyFreq)),
                    DropdownMenuItem(value: 'WEEKLY', child: Text(l10n.weeklyFreq)),
                    DropdownMenuItem(value: 'MONTHLY', child: Text(l10n.monthlyFreq)),
                    DropdownMenuItem(value: 'QUARTERLY', child: Text(l10n.quarterlyFreq)),
                    DropdownMenuItem(value: 'YEARLY', child: Text(l10n.yearlyFreq)),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => frequency = v);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: referenceType,
                  decoration: InputDecoration(
                      labelText: l10n.referenceType, border: const OutlineInputBorder()),
                  items: [
                    DropdownMenuItem(value: 'EXPENSE', child: Text(l10n.expenseType)),
                    DropdownMenuItem(value: 'REVENUE', child: Text(l10n.revenueType)),
                    DropdownMenuItem(value: 'CUSTOM', child: Text(l10n.customType)),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => referenceType = v);
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(l10n.startDate),
                  subtitle: Text(startDate.toString().substring(0, 10)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setDialogState(() => startDate = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || amountCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pleaseFillRequiredFields)),
                  );
                  return;
                }
                try {
                  if (existing == null) {
                    await _service.createEntry(
                      name: nameCtrl.text,
                      frequency: frequency,
                      referenceType: referenceType,
                      debitAccountCode: debitCtrl.text,
                      creditAccountCode: creditCtrl.text,
                      amount: Decimal.parse(amountCtrl.text),
                      startDate: startDate,
                      endDate: endDate,
                    );
                  } else {
                    await _service.updateEntry(existing.copyWith(
                      name: nameCtrl.text,
                      frequency: frequency,
                      referenceType: referenceType,
                      debitAccountCode: debitCtrl.text,
                      creditAccountCode: creditCtrl.text,
                      amount: Decimal.parse(amountCtrl.text),
                      startDate: startDate,
                      endDate: drift.Value(endDate),
                    ));
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.errorWithMessage(e.toString()))),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showExecutionHistory(BuildContext context, RecurringEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final history = await _service.getExecutionHistory(entry.id);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.executionHistoryFor(entry.name)),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? Text(l10n.noExecutionHistory)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final exec = history[index];
                    return ListTile(
                      leading: Icon(
                        exec.status == 'posted'
                            ? Icons.check_circle
                            : Icons.error,
                        color: exec.status == 'posted'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(exec.executionDate.toString().substring(0, 16)),
                      subtitle: Text(exec.status),
                      trailing: exec.errorMessage != null
                          ? const Icon(Icons.info, color: Colors.orange)
                          : null,
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, RecurringEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteRecurringEntry(entry.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await _service.deleteEntry(entry.id);
              if (!mounted) return;
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
