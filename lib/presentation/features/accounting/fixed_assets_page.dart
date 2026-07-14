import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/presentation/features/accounting/asset_provider.dart';
import 'package:supermarket/presentation/features/accounting/widgets/add_edit_asset_dialog.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class FixedAssetsPage extends StatefulWidget {
  const FixedAssetsPage({super.key});

  @override
  State<FixedAssetsPage> createState() => _FixedAssetsPageState();
}

class _FixedAssetsPageState extends State<FixedAssetsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetProvider>().loadAssets(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<AssetProvider>();
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'ar_SA',
      symbol: 'ر.س',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fixedAssetsManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.confirmGeneric),
                  content: Text(l10n.confirmDepreciation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.run),
                    ),
                  ],
                ),
              );
              if (confirmed ?? false) {
                if (context.mounted) {
                  await provider.runDepreciation(context);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.depreciationCompleted),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            tooltip: l10n.calculateMonthlyDepreciation,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.assets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_center_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noFixedAssets,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.startAddingAsset,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.assets.length,
                  itemBuilder: (context, index) {
                    final asset = provider.assets[index];
                    final bookValue =
                        asset.cost - asset.accumulatedDepreciation;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              label: l10n.purchaseDate,
                              value: DateFormat(
                                'yyyy-MM-dd',
                              ).format(asset.purchaseDate),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.monetization_on,
                              label: l10n.originalCost,
                              value: currencyFormat.format(asset.cost),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.hourglass_bottom,
                              label: l10n.usefulLife,
                              value: l10n.years(asset.usefulLifeYears),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.recycling,
                              label: l10n.salvageValue,
                              value: currencyFormat.format(asset.salvageValue),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.trending_down,
                              label: l10n.accumulatedDepreciation,
                              value: currencyFormat.format(
                                asset.accumulatedDepreciation,
                              ),
                              color: Colors.orange.shade700,
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.book,
                              label: l10n.netBookValue,
                              value: currencyFormat.format(bookValue),
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => AddEditAssetDialog(assetProvider: provider),
        ),
        label: Text(l10n.addAsset),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
    bool isTotal = false,
  }) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: color,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          fontSize: isTotal ? 18 : 16,
        );
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 8),
        Text('$label:', style: style?.copyWith(color: Colors.grey.shade700)),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
