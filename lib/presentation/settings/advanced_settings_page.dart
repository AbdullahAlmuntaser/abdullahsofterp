import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  AdvancedSettingsPageState createState() => AdvancedSettingsPageState();
}

class AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  late AppConfigService _configService;

  bool _allowNegativeStock = false;
  double _taxRate = 0.15;
  String _defaultWarehouse = '';
  String _defaultBranch = '';
  int _lowStockThreshold = 10;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _configService = AppConfigService(context.read<AppDatabase>());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    _allowNegativeStock = await _configService.allowNegativeStock();
    _taxRate = await _configService.getTaxRate();
    _defaultWarehouse = await _configService.getDefaultWarehouseId();
    _defaultBranch = await _configService.getDefaultBranchId();
    _lowStockThreshold = await _configService.getLowStockThreshold();

    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _configService.setBool('allow_negative_stock', _allowNegativeStock);
      await _configService.setDouble('tax_rate', _taxRate);
      await _configService.setInt('low_stock_threshold', _lowStockThreshold);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.tmHfzAliadadatBnjah),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSavingSettings(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aliadadatAlmtqdmh),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: Text(l10n.alsmahBalmkhzwnAlslby),
              subtitle: Text(l10n.alsmahBbyaMntjatBdwnRsydKaf),
              value: _allowNegativeStock,
              onChanged: (value) {
                setState(() => _allowNegativeStock = value);
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${l10n.nsbhAldrybh} (${(_taxRate * 100).toStringAsFixed(1)}%)',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Slider(
                    value: _taxRate,
                    min: 0,
                    max: 0.25,
                    divisions: 25,
                    label: '${(_taxRate * 100).toStringAsFixed(1)}%',
                    onChanged: (value) {
                      setState(() => _taxRate = value);
                    },
                  ),
                  Text(l10n.ttrawhByn0W25,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hdAltnbyhLlmkhzwnAlmnkhfd,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Slider(
                    value: _lowStockThreshold.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _lowStockThreshold.toString(),
                    onChanged: (value) {
                      setState(() => _lowStockThreshold = value.toInt());
                    },
                  ),
                  Text(l10n.lowStockAlertThreshold(_lowStockThreshold.toString()),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.almarfatAlaftradyh,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.warehouse),
                    title: Text(l10n.almstwdaAlaftrady),
                    subtitle: Text(_defaultWarehouse),
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(l10n.alfraAlaftrady),
                    subtitle: Text(_defaultBranch),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: Text(l10n.hfzAltghyyrat),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
