import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/core/services/accounting_service.dart';
import 'package:supermarket/presentation/widgets/money_form_field.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class ChecksPage extends StatefulWidget {
  const ChecksPage({super.key});

  @override
  State<ChecksPage> createState() => _ChecksPageState();
}

class _ChecksPageState extends State<ChecksPage> {
  final _formKey = GlobalKey<FormState>();
  final _checkNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDueDate;
  String _selectedType = 'RECEIVED'; // RECEIVED, ISSUED
  String? _selectedPartnerId;
  String? _selectedAccountId;
  String _selectedStatus = 'PENDING';

  @override
  void dispose() {
    _checkNumberController.dispose();
    _bankNameController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _clearForm() {
    _checkNumberController.clear();
    _bankNameController.clear();
    _amountController.clear();
    _dueDateController.clear();
    _noteController.clear();
    setState(() {
      _selectedDueDate = null;
      _selectedPartnerId = null;
      _selectedAccountId = null;
      _selectedStatus = 'PENDING';
    });
  }

  Future<void> _saveCheck() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final db = context.read<AppDatabase>();
    final amount = MoneyFormField.valueOf(_amountController);

    final check = ChecksCompanion.insert(
      id: drift.Value(const Uuid().v4()),
      checkNumber: _checkNumberController.text,
      bankName: _bankNameController.text,
      dueDate: _selectedDueDate!,
      amount: drift.Value(Decimal.parse(amount.toString())),
      type: _selectedType,
      status: drift.Value(_selectedStatus),
      partnerId: drift.Value(_selectedPartnerId),
      note: drift.Value(_noteController.text),
      paymentAccountId: drift.Value(_selectedAccountId),
    );

    await db.into(db.checks).insert(check);
    _clearForm();
    if (mounted) {
      AppSnackBar.success(context, l10n.checkStatusUpdated('SAVED'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkManagement)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.checkType,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'RECEIVED',
                          child: Text(l10n.receivedChecks),
                        ),
                        DropdownMenuItem(
                          value: 'ISSUED',
                          child: Text(l10n.issuedChecks),
                        ),
                      ],
                      onChanged: (val) => setState(() {
                        _selectedType = val!;
                        _selectedPartnerId = null;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildPartnerSelector(db, l10n),
                    const SizedBox(height: 16),
                    _buildAccountSelector(db, l10n),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _checkNumberController,
                      decoration: InputDecoration(
                        labelText: l10n.checkNumber,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bankNameController,
                      decoration: InputDecoration(
                        labelText: l10n.bankName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    MoneyFormField(
                      controller: _amountController,
                      label: l10n.amount,
                      required: true,
                      allowZero: false,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: l10n.dueDate,
                        border: const OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: _presentDatePicker,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveCheck,
                      child: Text(l10n.saveCheck),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            SizedBox(height: 400, child: _buildChecksList(db, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerSelector(AppDatabase db, AppLocalizations l10n) {
    if (_selectedType == 'RECEIVED') {
      return StreamBuilder<List<Customer>>(
        stream: db.select(db.customers).watch(),
        builder: (context, snapshot) {
          final customers = snapshot.data ?? [];
          return DropdownButtonFormField<String>(
            value: _selectedPartnerId,
            decoration: InputDecoration(
              labelText: l10n.customer,
              border: const OutlineInputBorder(),
            ),
            items: customers
                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedPartnerId = val),
            validator: (v) => v == null ? l10n.requiredField : null,
          );
        },
      );
    } else {
      return StreamBuilder<List<Supplier>>(
        stream: db.select(db.suppliers).watch(),
        builder: (context, snapshot) {
          final suppliers = snapshot.data ?? [];
          return DropdownButtonFormField<String>(
            value: _selectedPartnerId,
            decoration: InputDecoration(
              labelText: l10n.supplier,
              border: const OutlineInputBorder(),
            ),
            items: suppliers
                .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedPartnerId = val),
            validator: (v) => v == null ? l10n.requiredField : null,
          );
        },
      );
    }
  }

  Widget _buildAccountSelector(AppDatabase db, AppLocalizations l10n) {
    return StreamBuilder<List<GLAccount>>(
      stream: (db.select(db.gLAccounts)
            ..where(
              (a) =>
                  a.code.equals(AccountingService.codeCash) |
                  a.code.equals(AccountingService.codeBank),
            ))
          .watch(),
      builder: (context, snapshot) {
        final accounts = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedAccountId,
          decoration: InputDecoration(
            labelText: l10n.paymentCollectionAccount,
            border: const OutlineInputBorder(),
          ),
          items: accounts
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
              .toList(),
          onChanged: (val) => setState(() => _selectedAccountId = val),
          validator: (v) => v == null ? l10n.requiredField : null,
        );
      },
    );
  }

  Widget _buildChecksList(AppDatabase db, AppLocalizations l10n) {
    final checksStream = (db.select(
      db.checks,
    )..where((c) => c.type.equals(_selectedType)))
        .watch();

    return StreamBuilder<List<Check>>(
      stream: checksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final checks = snapshot.data ?? [];
        if (checks.isEmpty) return Center(child: Text(l10n.noChecks));

        return ListView.builder(
          itemCount: checks.length,
          itemBuilder: (context, index) {
            final check = checks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  l10n.checkInfo(check.bankName, check.checkNumber),
                ),
                subtitle: Text(
                  l10n.checkDetails(check.amount, DateFormat('yyyy-MM-dd').format(check.dueDate), check.status),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) => _updateCheckStatus(db, check, val),
                  itemBuilder: (context) => [
                    if (check.status == 'PENDING')
                      PopupMenuItem(
                        value: 'COLLECTED',
                        child: Text(l10n.collect),
                      ),
                    if (check.status == 'PENDING')
                      PopupMenuItem(value: 'BOUNCED', child: Text(l10n.reject)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateCheckStatus(
    AppDatabase db,
    Check check,
    String newStatus,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await (db.update(db.checks)..where((c) => c.id.equals(check.id))).write(
      ChecksCompanion(status: drift.Value(newStatus)),
    );

    if (newStatus == 'COLLECTED') {
      // Record check collection
      final entryId = const Uuid().v4();
      final cashAccount =
          await db.accountingDao.getAccountByCode(AccountingService.codeCash);
      final partnerAccount = check.type == 'RECEIVED'
          ? await db.accountingDao
              .getAccountByCode(AccountingService.codeAccountsReceivable)
          : await db.accountingDao
              .getAccountByCode(AccountingService.codeAccountsPayable);
      if (cashAccount != null && partnerAccount != null) {
        final lines = check.type == 'RECEIVED'
            ? [
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: cashAccount.id,
                  debit: drift.Value(Decimal.parse(check.amount.toString())),
                  credit: drift.Value(Decimal.zero),
                ),
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: partnerAccount.id,
                  debit: drift.Value(Decimal.zero),
                  credit: drift.Value(Decimal.parse(check.amount.toString())),
                ),
              ]
            : [
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: partnerAccount.id,
                  debit: drift.Value(Decimal.parse(check.amount.toString())),
                  credit: drift.Value(Decimal.zero),
                ),
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: cashAccount.id,
                  debit: drift.Value(Decimal.zero),
                  credit: drift.Value(Decimal.parse(check.amount.toString())),
                ),
              ];
        await db.accountingDao.createEntry(
          GLEntriesCompanion.insert(
            id: drift.Value(entryId),
            description: l10n.checkCollected(check.checkNumber),
            date: drift.Value(DateTime.now()),
            referenceType: const drift.Value('CHECK'),
            referenceId: drift.Value(check.id),
            status: const drift.Value('POSTED'),
            postedAt: drift.Value(DateTime.now()),
          ),
          lines,
        );
      }
    } else if (newStatus == 'BOUNCED') {
      // Record check bounce reversal
      final entryId = const Uuid().v4();
      final cashAccount =
          await db.accountingDao.getAccountByCode(AccountingService.codeCash);
      final partnerAccount = check.type == 'RECEIVED'
          ? await db.accountingDao
              .getAccountByCode(AccountingService.codeAccountsReceivable)
          : await db.accountingDao
              .getAccountByCode(AccountingService.codeAccountsPayable);
      if (cashAccount != null && partnerAccount != null) {
        final lines = check.type == 'RECEIVED'
            ? [
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: partnerAccount.id,
                  debit: drift.Value(Decimal.parse(check.amount.toString())),
                  credit: drift.Value(Decimal.zero),
                ),
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: cashAccount.id,
                  debit: drift.Value(Decimal.zero),
                  credit: drift.Value(Decimal.parse(check.amount.toString())),
                ),
              ]
            : [
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: cashAccount.id,
                  debit: drift.Value(Decimal.parse(check.amount.toString())),
                  credit: drift.Value(Decimal.zero),
                ),
                GLLinesCompanion.insert(
                  entryId: entryId,
                  accountId: partnerAccount.id,
                  debit: drift.Value(Decimal.zero),
                  credit: drift.Value(Decimal.parse(check.amount.toString())),
                ),
              ];
        await db.accountingDao.createEntry(
          GLEntriesCompanion.insert(
            id: drift.Value(entryId),
            description: l10n.checkBounced(check.checkNumber),
            date: drift.Value(DateTime.now()),
            referenceType: const drift.Value('CHECK'),
            referenceId: drift.Value(check.id),
            status: const drift.Value('POSTED'),
            postedAt: drift.Value(DateTime.now()),
          ),
          lines,
        );
      }
      // تحديث رصيد العميل/المورد عند الارتداد
      if (check.type == 'RECEIVED' && check.partnerId != null) {
        final customer = await (db.select(
          db.customers,
        )..where((c) => c.id.equals(check.partnerId!)))
            .getSingleOrNull();
        if (customer != null) {
          await (db.update(
            db.customers,
          )..where((c) => c.id.equals(customer.id)))
              .write(
            CustomersCompanion(
              balance: drift.Value(
                  customer.balance + Decimal.parse(check.amount.toString())),
            ),
          );
        }
      } else if (check.type == 'ISSUED' && check.partnerId != null) {
        final supplier = await (db.select(
          db.suppliers,
        )..where((s) => s.id.equals(check.partnerId!)))
            .getSingleOrNull();
        if (supplier != null) {
          await (db.update(
            db.suppliers,
          )..where((s) => s.id.equals(supplier.id)))
              .write(
            SuppliersCompanion(
              balance: drift.Value(
                  supplier.balance + Decimal.parse(check.amount.toString())),
            ),
          );
        }
      }
    }

    if (mounted) {
      AppSnackBar.success(context, l10n.checkStatusUpdated(newStatus));
    }
  }
}
