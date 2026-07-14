import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/accounting_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class RevaluationDialog extends StatelessWidget {
  final dynamic invoice; // الفاتورة المرحلة

  const RevaluationDialog({super.key, required this.invoice});

  Future<void> _performRevaluation(BuildContext context, String reason) async {
    final accountingService = GetIt.I<AccountingService>();
    // استدعاء المنطق: يولد قيد تسوية جديد ويسجل في AuditTrail
    await accountingService.createRevaluationEntry(invoice, reason);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.invoiceAlreadyApproved),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.invoiceApprovedMessage),
          const SizedBox(height: 16),
          ListTile(
            title: Text(l10n.createRevaluationEntry),
            leading: const Icon(Icons.calculate),
            onTap: () => _performRevaluation(context, l10n.revaluationReason),
          ),
          ListTile(
            title: Text(l10n.createReturn),
            leading: const Icon(Icons.undo),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
