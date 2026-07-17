import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/pos/bloc/pos_bloc.dart';
import 'package:supermarket/presentation/features/pos/bloc/pos_event.dart';
import 'package:supermarket/presentation/features/pos/bloc/pos_state.dart';
import 'package:supermarket/presentation/features/pos/widgets/cart_widget.dart';
import 'package:supermarket/presentation/features/pos/widgets/product_grid.dart';
import 'package:supermarket/presentation/features/pos/widgets/product_search_widget.dart';
import 'package:supermarket/presentation/features/pos/widgets/barcode_scanner_dialog.dart';
import 'package:supermarket/presentation/features/pos/widgets/category_selector.dart';
import 'package:supermarket/presentation/features/pos/widgets/pos_return_widget.dart';
import 'package:supermarket/injection_container.dart';
import 'package:supermarket/core/services/communication_service.dart';
import 'package:supermarket/core/services/quick_customer_service.dart';
import 'package:supermarket/core/utils/printer_helper.dart';
import 'package:supermarket/core/services/pricing_service.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/services/transaction_engine.dart';
import 'package:supermarket/core/services/loyalty_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:share_plus/share_plus.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final l10n = AppLocalizations.of(context)!;
        final bloc = PosBloc(
          sl<AppDatabase>(),
          sl<PricingService>(),
          sl<TransactionEngine>(),
          sl<PackagingEngine>(),
          loyaltyService: sl<LoyaltyService>(),
          t: (key, {Map<String, String>? args}) {
            final a = args;
            switch (key) {
              case 'posDiscountExceeds':
                return l10n.posDiscountExceeds(a!['max']!);
              case 'posOriginalInvoiceNotFound':
                return l10n.posOriginalInvoiceNotFound;
              case 'posErrorSearchInvoice':
                return l10n.posErrorSearchInvoice(a!['error']!);
              case 'posNoReturnItemsSelected':
                return l10n.posNoReturnItemsSelected;
              case 'posErrorProcessReturn':
                return l10n.posErrorProcessReturn(a!['error']!);
              case 'posProductNotFound':
                return l10n.posProductNotFound;
              case 'posProductOutOfStock':
                return l10n.posProductOutOfStock(a!['name']!);
              case 'posErrorAddProduct':
                return l10n.posErrorAddProduct(a!['error']!);
              case 'posQuantityExceedsStock':
                return l10n.posQuantityExceedsStock(a!['quantity']!, a['stock']!);
              case 'posMustOpenShift':
                return l10n.posMustOpenShift;
              case 'posCreditLimitExceeded':
                return l10n.posCreditLimitExceeded;
              case 'posLoyaltyReason':
                return l10n.posLoyaltyReason;
              default:
                return key;
            }
          },
        );
        return bloc..add(LoadCategories());
      },
      child: const PosView(),
    );
  }
}

class PosView extends StatefulWidget {
  const PosView({super.key});

  @override
  State<PosView> createState() => _PosViewState();
}

class _PosViewState extends State<PosView> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commService = sl<CommunicationService>();
    final quickCustomerService = sl<QuickCustomerService>();

    return BlocListener<PosBloc, PosState>(
      listener: (context, state) {
        if (state is PosCheckoutSuccess) {
          _showInvoiceOptions(
              context, state, commService, quickCustomerService);
        } else if (state is PosReturnSuccess) {
          _showReturnSuccess(context, state);
        } else if (state is PosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final bool isWholesale = state is PosLoaded && state.isWholesaleMode;

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.quickPos),
              actions: [
                IconButton(
                  icon: Icon(
                    state is PosLoaded && state.isReturnMode
                        ? Icons.keyboard_return
                        : Icons.shopping_cart,
                    color: state is PosLoaded && state.isReturnMode
                        ? Colors.orange
                        : null,
                  ),
                  tooltip: state is PosLoaded && state.isReturnMode
                      ? AppLocalizations.of(context)!.sellMode
                      : AppLocalizations.of(context)!.returnMode,
                  onPressed: () {
                    if (state is PosLoaded) {
                      context.read<PosBloc>().add(
                            ToggleReturnMode(!state.isReturnMode),
                          );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    isWholesale ? Icons.store : Icons.storefront,
                    color: isWholesale ? Colors.green : null,
                  ),
                  tooltip: isWholesale
                      ? AppLocalizations.of(context)!.retailMode
                      : AppLocalizations.of(context)!.wholesaleModeDescription,
                  onPressed: () {
                    if (state is PosLoaded) {
                      context.read<PosBloc>().add(
                            ToggleWholesaleMode(!state.isWholesaleMode),
                          );
                    }
                  },
                ),
                if (state is PosLoaded && state.cart.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.pause_circle_outline),
                    tooltip: AppLocalizations.of(context)!.holdSale,
                    onPressed: () {
                      context.read<PosBloc>().add(HoldSale());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!.saleHeld),
                            backgroundColor: Colors.orange),
                      );
                    },
                  ),
                if (state is PosLoaded && state.heldSales.isNotEmpty)
                  IconButton(
                    icon: Badge(
                      label: Text('${state.heldSales.length}'),
                      child: const Icon(Icons.play_circle_outline),
                    ),
                    tooltip: AppLocalizations.of(context)!.recallSale,
                    onPressed: () => _showHeldSalesDialog(context, state),
                  ),
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () => context.push('/sales'),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => _openScanner(context),
                ),
              ],
            ),
            body: state is PosLoading
                ? const Center(child: CircularProgressIndicator())
                : state is PosLoaded
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 800;
                          final isTablet = constraints.maxWidth > 500 &&
                              constraints.maxWidth <= 800;

                          if (isWide) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: state.isReturnMode
                                      ? const PosReturnWidget()
                                      : const CartWidget(),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: _buildProductSection(),
                                ),
                              ],
                            );
                          } else if (isTablet) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: state.isReturnMode
                                      ? const PosReturnWidget()
                                      : const CartWidget(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildProductSection(),
                                ),
                              ],
                            );
                          }
                          return DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(text: AppLocalizations.of(context)!.products),
                                    Tab(text: AppLocalizations.of(context)!.cart)
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _buildProductSection(),
                                      state.isReturnMode
                                          ? const PosReturnWidget()
                                          : const CartWidget(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(child: Text(AppLocalizations.of(context)!.quickPos)),
          );
        },
      ),
    );
  }

  Widget _buildProductSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductSearchWidget(controller: _barcodeController),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CategorySelector(),
        ),
        const Expanded(child: ProductGrid()),
      ],
    );
  }

  Future<void> _openScanner(BuildContext context) async {
    final posBloc = context.read<PosBloc>();
    final result = await showGeneralDialog<String>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) =>
          BarcodeScannerDialog(),
    );
    if (result != null && mounted) {
      posBloc.add(AddProductBySku(result));
    }
  }

  void _showHeldSalesDialog(BuildContext context, PosLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.heldSales),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.heldSales.length,
            itemBuilder: (context, index) {
              final heldCart = state.heldSales[index];
              final itemCount = heldCart.length;
              final total = heldCart.fold<Decimal>(
                  Decimal.zero, (sum, item) => sum + item.total);
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(l10n.itemsCount(itemCount)),
                subtitle: Text('${total.toStringAsFixed(2)} ${l10n.currencySar}'),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<PosBloc>().add(RecallSale(index));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showInvoiceOptions(
    BuildContext context,
    PosCheckoutSuccess state,
    CommunicationService commService,
    QuickCustomerService quickCustomerService,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.checkoutSuccess),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    String customerName = l10n.cashCustomer;
    String? customerPhone;

    if (state.sale.customerId != null) {
      final customer = await sl<AppDatabase>()
          .customersDao
          .getCustomerById(state.sale.customerId!);
      if (customer != null) {
        customerName = customer.name;
        customerPhone = customer.phone;
      }
    } else {
      final quickCustomer =
          await quickCustomerService.getOrCreateCustomerForSale(l10n.cashCustomerFallback);
      if (quickCustomer != null) {
        customerName = quickCustomer.name;
        customerPhone = quickCustomer.phone;
      }
    }

    final hasCustomerPhone = customerPhone != null && customerPhone.isNotEmpty;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('🧾 ${l10n.invoiceNo(state.sale.id.substring(0, 8))}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.totalAmountWithCurrency(state.sale.total.toStringAsFixed(2))),
            const SizedBox(height: 16),
            Text(l10n.howToSendInvoice),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.later),
          ),
          IconButton.filledTonal(
            icon: const Icon(Icons.print),
            tooltip: l10n.print,
            onPressed: () async {
              Navigator.pop(ctx);
              await PrinterHelper.printReceipt(
                state.sale,
                state.items,
                state.products,
                customerName: customerName,
              );
            },
          ),
          if (hasCustomerPhone)
            IconButton.filledTonal(
              icon: const Icon(Icons.message, color: Colors.green),
              tooltip: 'WhatsApp',
              onPressed: () async {
                Navigator.pop(ctx);
                await commService.sendInvoiceViaWhatsApp(
                  phoneNumber: customerPhone!,
                  invoiceNumber: state.sale.id.substring(0, 8),
                  total: state.sale.total.toDouble(),
                  customerName: customerName,
                );
              },
            ),
          IconButton.filledTonal(
            icon: const Icon(Icons.share),
            tooltip: l10n.share,
            onPressed: () {
              Navigator.pop(ctx);
              final String shareText =
                  '${l10n.invoiceNo(state.sale.id.substring(0, 8))}\n'
                  '${l10n.customerNameLabel(customerName)}\n'
                  '${l10n.totalAmountWithCurrency(state.sale.total.toStringAsFixed(2))}\n'
                  '${l10n.thankYouForShopping}';
              Share.share(shareText);
            },
          ),
        ],
      ),
    );

    if (context.mounted) {
      context.read<PosBloc>().add(ClearCart());
    }
  }

  void _showReturnSuccess(BuildContext context, PosReturnSuccess state) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.returnSuccessTitle} - ${l10n.returnAmount(state.totalRefund.toStringAsFixed(2))}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.returnSuccessTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.returnId(state.returnId.substring(0, 8))),
            const SizedBox(height: 8),
            Text(l10n.originalInvoice(state.originalSale.id.substring(0, 8))),
            const SizedBox(height: 8),
            Text(
              l10n.returnAmount(state.totalRefund.toStringAsFixed(2)),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PosBloc>().add(ClearReturn());
            },
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }
}
