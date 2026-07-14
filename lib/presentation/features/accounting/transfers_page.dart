import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/transfer_service.dart';
import 'package:supermarket/presentation/widgets/shared/account_selector_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';
import 'package:supermarket/presentation/widgets/money_form_field.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class TransfersPage extends StatefulWidget {
  const TransfersPage({super.key});

  @override
  State<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _commissionController = TextEditingController();
  final _companyController = TextEditingController();
  final _noteController = TextEditingController();

  String? _senderAccountId;
  String? _receiverAccountId;
  String _transferType = 'CASH';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = Provider.of<AppDatabase>(context);
    final transferService = Provider.of<TransferService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transfers)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AccountSelectorWidget(
                          label: l10n.fromAccount,
                          selectedAccountId: _senderAccountId,
                          onSelected: (acc) =>
                              setState(() => _senderAccountId = acc?.id),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AccountSelectorWidget(
                          label: l10n.toAccount,
                          selectedAccountId: _receiverAccountId,
                          onSelected: (acc) =>
                              setState(() => _receiverAccountId = acc?.id),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MoneyFormField(
                          controller: _amountController,
                          label: l10n.amount,
                          required: true,
                          allowZero: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MoneyFormField(
                          controller: _commissionController,
                          label: l10n.commission,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _transferType,
                          decoration: InputDecoration(
                              labelText: l10n.transferType,
                              border: const OutlineInputBorder()),
                          items: [
                            DropdownMenuItem(
                                value: 'CASH', child: Text(l10n.cash)),
                            DropdownMenuItem(
                                value: 'BANK', child: Text(l10n.bankTransfer)),
                            DropdownMenuItem(
                                value: 'CHECK', child: Text(l10n.check)),
                          ],
                          onChanged: (v) => setState(() => _transferType = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _companyController,
                          decoration: InputDecoration(
                              labelText: l10n.transferCompany,
                              border: const OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                        labelText: l10n.notes, border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_senderAccountId == null ||
                            _receiverAccountId == null) {
                          AppSnackBar.warning(context, l10n.selectAccountsError);
                          return;
                        }
                        try {
                          await transferService.createTransfer(
                            senderAccountId: _senderAccountId!,
                            receiverAccountId: _receiverAccountId!,
                            amount: MoneyFormField.valueOf(_amountController),
                            commission:
                                MoneyFormField.valueOf(_commissionController),
                            company: _companyController.text,
                            transferType: _transferType,
                            note: _noteController.text,
                          );
                          if (!context.mounted) return;
                          AppSnackBar.success(context, l10n.transferSuccess);
                          _formKey.currentState!.reset();
                          setState(() {
                            _senderAccountId = null;
                            _receiverAccountId = null;
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          AppSnackBar.error(context, l10n.errorWithMessage(e.toString()));
                        }
                      }
                    },
                    child: Text(l10n.recordTransfer),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<FinancialTransfer>>(
              stream: db.transfersDao.watchAllTransfers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final transfers = snapshot.data!;
                return ListView.builder(
                  itemCount: transfers.length,
                  itemBuilder: (context, index) {
                    final t = transfers[index];
                    return ListTile(
                      title: Text(l10n.transferItem(t.amount.toString())),
                      subtitle: Text(
                          '${intl.DateFormat('yyyy-MM-dd').format(t.date)} - ${t.note ?? ""}'),
                      trailing: Text(t.status),
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
}

class ApiResponseSnackBar extends SnackBar {
  ApiResponseSnackBar(
      {super.key, required String message, bool isError = false})
      : super(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        );
}
