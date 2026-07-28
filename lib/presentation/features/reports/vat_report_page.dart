import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/core/models/accounting/vat_report_data.dart';
import 'package:supermarket/core/services/accounting/accounting_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/presentation/widgets/main_drawer.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class VatReportPage extends StatefulWidget {
  const VatReportPage({super.key});

  @override
  State<VatReportPage> createState() => _VatReportPageState();
}

class _VatReportPageState extends State<VatReportPage> {
  DateTimeRange _range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrDrybhAlqymhAlmdafh),
        actions: [
          IconButton(
            tooltip: l10n.tghyyrAlftrh,
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder<VatReportData>(
        future: _fetchVatReport(db),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('${l10n.errorLoadingData}: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: Text(l10n.noDataAvailable));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildRangeCard(l10n),
              const SizedBox(height: 16),
              _buildSectionTitle(l10n.almbyaatWalmkhrjat),
              _buildCard(
                  l10n.ijmalyAlmbyaatAlkhadahLldrybh, data.totalTaxableSales),
              _buildCard(l10n.ijmalyDrybhAlmkhrjat, data.totalOutputVat),
              const SizedBox(height: 16),
              _buildSectionTitle(l10n.almshtryatWalmdkhlat),
              _buildCard(l10n.ijmalyAlmshtryatAlkhadahLldrybh,
                  data.totalTaxablePurchases),
              _buildCard(l10n.ijmalyDrybhAlmdkhlat, data.totalInputVat),
              const SizedBox(height: 16),
              const Divider(thickness: 2),
              _buildCard(
                  l10n.safyAldrybhAlmsthqhLldfallastrdad, data.netVatPayable,
                  isHighlight: true),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: l10n.akhtrFtrhTqryrAldrybh,
      cancelText: l10n.cancel,
      confirmText: l10n.ttbyq,
    );
    if (picked != null && mounted) {
      setState(() => _range = picked);
    }
  }

  Widget _buildRangeCard(AppLocalizations l10n) {
    final formatter = DateFormat('yyyy-MM-dd');
    return Card(
      child: ListTile(
        leading: const Icon(Icons.date_range),
        title: Text(l10n.ftrhAltqryr),
        subtitle: Text(
          '${formatter.format(_range.start)} ${l10n.ila} ${formatter.format(_range.end)}',
        ),
        trailing: TextButton.icon(
          onPressed: _pickDateRange,
          icon: const Icon(Icons.edit_calendar),
          label: Text(l10n.change),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Future<VatReportData> _fetchVatReport(AppDatabase db) async {
    final service = AccountingService(
        db, Provider.of<EventBusService>(context, listen: false));
    return await service.getVatReport(
      startDate: _range.start,
      endDate: _range.end,
    );
  }

  Widget _buildCard(String title, Decimal amount, {bool isHighlight = false}) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          amount.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isHighlight
                ? (amount >= Decimal.zero ? Colors.red : Colors.green)
                : null,
          ),
        ),
      ),
    );
  }
}
