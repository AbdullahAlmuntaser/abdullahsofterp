import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/core/constants/app_colors.dart';
import 'package:supermarket/core/constants/app_dimensions.dart';
import 'package:supermarket/core/auth/auth_provider.dart';
import 'package:supermarket/core/auth/user_role.dart';
import 'package:supermarket/core/auth/access_guard.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/home/providers/command_center_provider.dart';

class OperationCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<OperationAction> actions;

  const OperationCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.actions,
  });
}

class OperationAction {
  final String title;
  final String route;
  final IconData icon;

  const OperationAction(
      {required this.title, required this.route, required this.icon});
}

class NewOperationSheet extends StatelessWidget {
  const NewOperationSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXxl)),
      ),
      builder: (_) => const NewOperationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final role = UserRole.fromString(auth.currentUser?.role ?? 'cashier');
    final provider = context.read<CommandCenterProvider>();

    final l10n = AppLocalizations.of(context)!;
    final categories = _buildCategories(role, l10n);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXxl)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline,
                        color: AppColors.primary),
                    const SizedBox(width: AppDimensions.sm),
                    Text(AppLocalizations.of(context)!.newOperation,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return _buildCategorySection(context, cat, provider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(BuildContext context, OperationCategory cat,
      CommandCenterProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(cat.icon, size: 18, color: cat.color),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(cat.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cat.color)),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: cat.actions.map((action) {
              return ActionChip(
                avatar: Icon(action.icon, size: 16, color: cat.color),
                label: Text(action.title, style: const TextStyle(fontSize: 12)),
                backgroundColor: cat.color.withOpacity(0.05),
                side: BorderSide(color: cat.color.withOpacity(0.2)),
                onPressed: () {
                  Navigator.pop(context);
                  provider.addRecentOperation(RecentOperation(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: action.title,
                    subtitle: cat.title,
                    icon: action.icon,
                    color: cat.color,
                    timestamp: DateTime.now(),
                    route: action.route,
                  ));
                  context.push(action.route);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<OperationCategory> _buildCategories(UserRole role, AppLocalizations l10n) {
    final cats = <OperationCategory>[];

    if (AccessGuard.canAccess('/pos', role)) {
      cats.add(OperationCategory(
        title: l10n.sales,
        icon: Icons.point_of_sale,
        color: AppColors.opSales,
        actions: [
          OperationAction(
              title: l10n.saleInvoice,
              route: '/pos',
              icon: Icons.add_shopping_cart),
          OperationAction(
              title: l10n.salesReturns,
              route: '/sales/returns',
              icon: Icons.assignment_return),
          OperationAction(
              title: l10n.priceQuote,
              route: '/sales/invoice',
              icon: Icons.request_quote),
          OperationAction(
              title: l10n.customerOrder,
              route: '/sales/orders',
              icon: Icons.shopping_cart_checkout),
        ],
      ));
    }

    if (AccessGuard.canAccess('/purchases/new', role)) {
      cats.add(OperationCategory(
        title: l10n.purchases,
        icon: Icons.shopping_bag,
        color: AppColors.opPurchases,
        actions: [
          OperationAction(
              title: l10n.purchaseInvoice,
              route: '/purchases/new',
              icon: Icons.shopping_bag),
          OperationAction(
              title: l10n.purchaseReturns,
              route: '/purchases/returns',
              icon: Icons.assignment_return),
          OperationAction(
              title: l10n.purchaseOrder,
              route: '/purchases/orders',
              icon: Icons.receipt),
        ],
      ));
    }

    if (AccessGuard.canAccess('/customers', role)) {
      cats.add(OperationCategory(
        title: l10n.customers,
        icon: Icons.people,
        color: AppColors.opCustomers,
        actions: [
          OperationAction(
              title: l10n.addCustomer, route: '/customers', icon: Icons.person_add),
          OperationAction(
              title: l10n.customerStatement,
              route: '/accounting/customer-ledger',
              icon: Icons.person_search),
          OperationAction(
              title: l10n.receiptVoucher,
              route: '/accounting/manual-voucher?receipt=true',
              icon: Icons.receipt),
        ],
      ));
    }

    if (AccessGuard.canAccess('/suppliers', role)) {
      cats.add(OperationCategory(
        title: l10n.suppliers,
        icon: Icons.local_shipping,
        color: AppColors.opSuppliers,
        actions: [
          OperationAction(
              title: l10n.addSupplier,
              route: '/suppliers',
              icon: Icons.add_business),
          OperationAction(
              title: l10n.supplierStatement,
              route: '/accounting/supplier-ledger',
              icon: Icons.receipt_long),
          OperationAction(
              title: l10n.paymentVoucher,
              route: '/accounting/manual-voucher?receipt=false',
              icon: Icons.payment),
        ],
      ));
    }

    if (AccessGuard.canAccess('/products', role)) {
      cats.add(OperationCategory(
        title: l10n.inventory,
        icon: Icons.inventory_2,
        color: AppColors.opInventory,
        actions: [
          OperationAction(
              title: l10n.addProduct, route: '/products', icon: Icons.add_box),
          OperationAction(
              title: l10n.stockTake,
              route: '/inventory/stock-take',
              icon: Icons.fact_check),
          OperationAction(
              title: l10n.inventoryTransfer,
              route: '/inventory/transfer',
              icon: Icons.swap_horiz),
          OperationAction(
              title: l10n.printBarcode,
              route: '/barcode-printing',
              icon: Icons.qr_code),
        ],
      ));
    }

    if (AccessGuard.canAccess('/accounting/cashbox', role)) {
      cats.add(OperationCategory(
        title: l10n.cashboxes,
        icon: Icons.account_balance_wallet,
        color: AppColors.opCashbox,
        actions: [
          OperationAction(
              title: l10n.deposit,
              route: '/accounting/cashbox',
              icon: Icons.savings),
          OperationAction(
              title: l10n.withdraw,
              route: '/accounting/cashbox',
              icon: Icons.money_off),
          OperationAction(
              title: l10n.transfer,
              route: '/accounting/transfers',
              icon: Icons.swap_horiz),
        ],
      ));
    }

    if (AccessGuard.canAccess('/reports/sales', role)) {
      cats.add(OperationCategory(
        title: l10n.reports,
        icon: Icons.assessment,
        color: AppColors.opReports,
        actions: [
          OperationAction(
              title: l10n.salesReport,
              route: '/reports/sales',
              icon: Icons.bar_chart),
          OperationAction(
              title: l10n.purchasesReport,
              route: '/reports/purchases',
              icon: Icons.pie_chart),
          OperationAction(
              title: l10n.profitReport,
              route: '/reports/profitability',
              icon: Icons.show_chart),
          OperationAction(
              title: l10n.inventoryReport,
              route: '/reports/inventory',
              icon: Icons.inventory),
        ],
      ));
    }

    return cats;
  }
}
