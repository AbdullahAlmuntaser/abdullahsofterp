import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/accounting/accounting_provider.dart';

class CloseFinancialYearDialog extends StatefulWidget {
  const CloseFinancialYearDialog({super.key});

  @override
  State<CloseFinancialYearDialog> createState() =>
      _CloseFinancialYearDialogState();
}

class _CloseFinancialYearDialogState extends State<CloseFinancialYearDialog> {
  DateTime _selectedDate = DateTime.now();
  bool _isClosing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.closeFinancialYear),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.closeYearDescription,
            style: const TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              l10n.closeDate(_selectedDate.toLocal().toString().split(' ')[0]),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isClosing ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _isClosing
              ? null
              : () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  final provider = context.read<AccountingProvider>();

                  setState(() => _isClosing = true);
                  try {
                    await provider.closeYear(_selectedDate);
                    if (mounted) {
                      navigator.pop();
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.yearClosedSuccessfully),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(l10n.closeFailed(e.toString()))),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _isClosing = false);
                  }
                },
          child: _isClosing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.confirmClose),
        ),
      ],
    );
  }
}
