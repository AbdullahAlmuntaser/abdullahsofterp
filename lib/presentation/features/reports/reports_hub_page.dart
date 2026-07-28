import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class ReportsHubPage extends StatelessWidget {
  const ReportsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reports = [
      _ReportLink(l10n.tqaryrAlmbyaat, Icons.receipt_long, '/reports/sales'),
      _ReportLink(l10n.rbhyhAlmntjat, Icons.trending_up, '/reports/profitability'),
      _ReportLink(l10n.ijmalyAlrbh, Icons.analytics, '/reports/gross-profit'),
      _ReportLink(l10n.alarbahAlmtqdm, Icons.stacked_bar_chart, '/reports/advanced-profit'),
      _ReportLink(l10n.almntjatAlakthrMbyaa, Icons.leaderboard, '/reports/top-selling'),
      _ReportLink(l10n.almntjatAlrakdh, Icons.hourglass_bottom, '/reports/slow-moving'),
      _ReportLink(l10n.tqryrAliyradatWalmsrwfat, Icons.account_balance_wallet, '/reports/income-expense'),
      _ReportLink(l10n.tqaryrAlmshtryat, Icons.shopping_cart, '/reports/purchases'),
      _ReportLink(l10n.tqryrAlsnadyq, Icons.payments, '/reports/cashbox'),
      _ReportLink(l10n.tqryrAlamlaa, Icons.people, '/reports/customers'),
      _ReportLink(l10n.tqryrAlmwrdyn, Icons.business, '/reports/suppliers'),
      _ReportLink(l10n.tqryrHrkhAlmkhzwn, Icons.move_up, '/reports/stock-movement'),
      _ReportLink(l10n.tqaryrAlmkhzwn, Icons.inventory_2, '/reports/inventory'),
      _ReportLink(l10n.tdqyqAlmkhzwn, Icons.fact_check, '/reports/inventory-audit'),
      _ReportLink(l10n.hrkhSnf, Icons.swap_horiz, '/reports/item-movement'),
      _ReportLink(l10n.almsrwfatHsbAlmrkz, Icons.account_tree, '/reports/expenses-by-center'),
      _ReportLink(l10n.drybhAlqymhAlmdafh, Icons.percent, '/reports/vat'),
      _ReportLink(l10n.aamarAldywn, Icons.schedule, '/reports/aging'),
      _ReportLink(l10n.twqaAltdfqAlnqdy, Icons.waterfall_chart, '/reports/cash-flow'),
      _ReportLink(l10n.sjlAltdqyq, Icons.history, '/reports/audit'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mrkzAltqaryr)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.35,
        ),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go(report.route),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(report.icon,
                        size: 42, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      report.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReportLink {
  const _ReportLink(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}
