import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/accounting/wht_provider.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';

class WithholdingTaxPage extends StatefulWidget {
  const WithholdingTaxPage({super.key});

  @override
  State<WithholdingTaxPage> createState() => _WithholdingTaxPageState();
}

class _WithholdingTaxPageState extends State<WithholdingTaxPage> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final provider = context.read<WhtProvider>();
    provider.loadEntries(
      startDate: _startDate,
      endDate: _endDate,
      status: _statusFilter,
    );
    provider.loadSummary(_startDate, _endDate);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _loadData();
    }
  }

  String _formatAmount(Decimal amount) {
    final num = double.tryParse(amount.toString()) ?? 0.0;
    return NumberFormat('#,##0.00', 'ar_SA').format(num);
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'PENDING':
        return l10n.pending;
      case 'FILED':
        return l10n.filed;
      case 'PAID':
        return l10n.paid;
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'FILED':
        return Colors.blue;
      case 'PAID':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _whtTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'DIVIDENDS':
        return l10n.dividends;
      case 'INTEREST':
        return l10n.interest;
      case 'ROYALTIES':
        return l10n.royalties;
      case 'SERVICE_FEES':
        return l10n.serviceFees;
      case 'TECHNICAL_FEES':
        return l10n.technicalFees;
      case 'COMMISSIONS':
        return l10n.commissions;
      case 'RENT':
        return l10n.rent;
      case 'INSURANCE':
        return l10n.insurance;
      default:
        return type;
    }
  }

  Future<void> _showMarkAsFiledDialog(WithholdingTaxEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final refController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.fileTax),
        content: TextField(
          controller: refController,
          decoration: InputDecoration(
            labelText: l10n.referenceNumber,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (refController.text.trim().isEmpty) {
                AppSnackBar.warning(ctx, l10n.enterReferenceNumber);
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.confirmGeneric),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      await context.read<WhtProvider>().markAsFiled(
            entry.id,
            refController.text.trim(),
          );
      if (mounted) {
        AppSnackBar.success(context, l10n.taxFiledSuccessfully);
      }
    }
  }

  Future<void> _confirmMarkAsPaid(WithholdingTaxEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmPayment),
        content: Text(l10n.confirmPaymentMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmGeneric),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      await context.read<WhtProvider>().markAsPaid(entry.id);
      if (mounted) {
        AppSnackBar.success(context, l10n.paymentSuccess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.withholdingTax),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() {
                _statusFilter = val == 'ALL' ? null : val;
              });
              _loadData();
            },
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'ALL', child: Text(l10n.all)),
              PopupMenuItem(value: 'PENDING', child: Text(l10n.pending)),
              PopupMenuItem(value: 'FILED', child: Text(l10n.filed)),
              PopupMenuItem(value: 'PAID', child: Text(l10n.paid)),
            ],
          ),
        ],
      ),
      body: Consumer<WhtProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.entries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDateFilters(),
                const SizedBox(height: 12),
                _buildSummaryCard(provider),
                const SizedBox(height: 16),
                _buildRatesReference(),
                const SizedBox(height: 16),
                _buildEntriesHeader(provider),
                const SizedBox(height: 8),
                ...provider.entries.map(_buildEntryCard),
                if (provider.entries.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        l10n.noTaxEntriesInPeriod,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateFilters() {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat('yyyy-MM-dd');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(isStart: true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.fromDate,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  child: Text(fmt.format(_startDate)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(isStart: false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.toDate,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  child: Text(fmt.format(_endDate)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(WhtProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final summary = provider.summary;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.withholdingTaxSummary,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryItem(
                  l10n.entryCount,
                  summary != null ? '${summary.entryCount}' : '0',
                ),
                _summaryItem(
                  l10n.totalAmount,
                  summary != null ? _formatAmount(summary.totalGrossAmount) : '0.00',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryItem(
                  l10n.withholdingTax,
                  summary != null ? _formatAmount(summary.totalTaxAmount) : '0.00',
                ),
                _summaryItem(
                  l10n.netAmount,
                  summary != null ? _formatAmount(summary.totalNetAmount) : '0.00',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRatesReference() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Text(
                  l10n.withholdingTaxRates,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const Divider(),
            _rateRow(l10n.dividendsInterest, '5%'),
            _rateRow(l10n.royaltiesServices, '15%'),
            _rateRow(l10n.technicalFeesCommissionsRent, '15%'),
            _rateRow(l10n.insurance, '5%'),
          ],
        ),
      ),
    );
  }

  Widget _rateRow(String label, String rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            rate,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesHeader(WhtProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.entriesCount(provider.entries.length.toString()),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (_statusFilter != null)
          Chip(
            label: Text(_statusLabel(_statusFilter!, l10n)),
            backgroundColor: _statusColor(_statusFilter!),
            labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
            onDeleted: () {
              setState(() => _statusFilter = null);
              _loadData();
            },
          ),
      ],
    );
  }

  Widget _buildEntryCard(WithholdingTaxEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.paymentLabel(entry.paymentId),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'FILED') {
                      _showMarkAsFiledDialog(entry);
                    } else if (val == 'PAID') {
                      _confirmMarkAsPaid(entry);
                    }
                  },
                  itemBuilder: (context) => [
                    if (entry.status == 'PENDING' || entry.status == 'FILED')
                      PopupMenuItem(
                        value: 'FILED',
                        child: Text(l10n.fileTax),
                      ),
                    if (entry.status == 'FILED')
                      PopupMenuItem(
                        value: 'PAID',
                        child: Text(l10n.recordPayment),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoChip(l10n.supplier, entry.supplierId),
                const SizedBox(width: 8),
                _infoChip(l10n.typeLabel, _whtTypeLabel(entry.paymentType, l10n)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountColumn(l10n.grossAmount, _formatAmount(entry.grossAmount)),
                _amountColumn(
                  l10n.taxWithRate(entry.taxRate.toString()),
                  _formatAmount(entry.taxAmount),
                ),
                _amountColumn(l10n.net, _formatAmount(entry.netAmount)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(entry.taxDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(entry.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusLabel(entry.status, l10n),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountColumn(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
