import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/accounting/zakat_provider.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class ZakatPage extends StatefulWidget {
  const ZakatPage({super.key});

  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  String _selectedPeriod = DateTime.now().year.toString();
  String _selectedType = 'ANNUAL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ZakatProvider>().loadData(period: _selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ZakatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.zakat),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: l10n.calculateNewZakat,
            onPressed: () => _showCalculateDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCards(provider),
          _buildFilters(),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.calculations.isEmpty
                    ? Center(child: Text(l10n.noZakatCalculations))
                    : _buildCalculationsList(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ZakatProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final summary = provider.summary;
    if (summary == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: l10n.totalZakat,
              value: '${summary.totalZakat} ر.س',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SummaryCard(
              title: l10n.paidZakat,
              value: '${summary.paidZakat} ر.س',
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SummaryCard(
              title: l10n.pendingZakat,
              value: '${summary.pendingZakat} ر.س',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: InputDecoration(
                labelText: l10n.period,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: List.generate(5, (i) {
                final year = DateTime.now().year - i;
                return DropdownMenuItem(
                  value: year.toString(),
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                setState(() => _selectedPeriod = value!);
                context.read<ZakatProvider>().loadData(period: _selectedPeriod);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.calculationType,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                DropdownMenuItem(value: 'ANNUAL', child: Text(l10n.annual)),
                DropdownMenuItem(value: 'QUARTERLY', child: Text(l10n.quarterly)),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationsList(ZakatProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.calculations.length,
      itemBuilder: (context, index) {
        final calc = provider.calculations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(calc.status).withOpacity(0.1),
              child: Icon(
                _statusIcon(calc.status),
                color: _statusColor(calc.status),
                size: 20,
              ),
            ),
            title: Text(l10n.periodLabel(calc.period)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.assetsAndLiabilities(calc.totalAssets.toString(), calc.totalLiabilities.toString())),
                Text(
                  l10n.zakatAmount(calc.zakatAmount.toString()),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(l10n.statusWithValue(_statusText(calc.status, l10n))),
              ],
            ),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (action) => _handleAction(context, action, calc),
              itemBuilder: (context) => [
                if (calc.status == 'DRAFT') ...[
                  PopupMenuItem(value: 'file', child: Text(l10n.file)),
                  PopupMenuItem(value: 'pay', child: Text(l10n.pay)),
                ],
                if (calc.status == 'FILED')
                  PopupMenuItem(value: 'pay', child: Text(l10n.pay)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCalculateDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final yearController = TextEditingController(
      text: DateTime.now().year.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.calculateZakat),
        content: TextField(
          controller: yearController,
          decoration: InputDecoration(
            labelText: l10n.periodYear,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<ZakatProvider>();
              await provider.calculateZakat(
                period: yearController.text,
                calculationType: _selectedType,
              );
              if (context.mounted) {
                AppSnackBar.success(context, l10n.zakatCalculatedSuccessfully);
              }
            },
            child: Text(l10n.calculate),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, String action, ZakatCalculation calc) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<ZakatProvider>();
    switch (action) {
      case 'file':
        provider.markAsFiled(calc.id);
        AppSnackBar.success(context, l10n.zakatFiledSuccessfully);
        break;
      case 'pay':
        provider.markAsPaid(calc.id);
        AppSnackBar.success(context, l10n.zakatPaidSuccessfully);
        break;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PAID': return Colors.green;
      case 'FILED': return Colors.blue;
      default: return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'PAID': return Icons.check_circle;
      case 'FILED': return Icons.send;
      default: return Icons.edit_note;
    }
  }

  String _statusText(String status, AppLocalizations l10n) {
    switch (status) {
      case 'PAID': return l10n.paid;
      case 'FILED': return l10n.filed;
      default: return l10n.draft;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
