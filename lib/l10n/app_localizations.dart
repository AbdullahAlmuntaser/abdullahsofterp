import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounting App'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @pos.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get pos;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @returns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get returns;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get sales;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @backupDb.
  ///
  /// In en, this message translates to:
  /// **'Backup DB'**
  String get backupDb;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @accountingSystem.
  ///
  /// In en, this message translates to:
  /// **'Accounting System'**
  String get accountingSystem;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @loginHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered user credentials'**
  String get loginHint;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @seedProducts.
  ///
  /// In en, this message translates to:
  /// **'Seed Products'**
  String get seedProducts;

  /// No description provided for @viewSales.
  ///
  /// In en, this message translates to:
  /// **'View Sales'**
  String get viewSales;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @todaySales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaySales;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @pendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending Sync'**
  String get pendingSync;

  /// No description provided for @seedDataAdded.
  ///
  /// In en, this message translates to:
  /// **'Seed data added!'**
  String get seedDataAdded;

  /// No description provided for @wholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get wholesale;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'PROCEED TO CHECKOUT'**
  String get proceedToCheckout;

  /// No description provided for @completePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer (Optional)'**
  String get selectCustomer;

  /// No description provided for @cashPayment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cashPayment;

  /// No description provided for @creditSale.
  ///
  /// In en, this message translates to:
  /// **'Credit Sale'**
  String get creditSale;

  /// No description provided for @selectCustomerError.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer for credit sale'**
  String get selectCustomerError;

  /// No description provided for @customerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search or add new customer'**
  String get customerNameHint;

  /// No description provided for @addCustomerForCredit.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer for Credit Sale'**
  String get addCustomerForCredit;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @skuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get skuLabel;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockLabel;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAdded;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdated;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers...'**
  String get searchCustomers;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get noPhone;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Bal: {balance}'**
  String balanceLabel(Object balance);

  /// No description provided for @limitLabel.
  ///
  /// In en, this message translates to:
  /// **'Limit: {limit}'**
  String limitLabel(Object limit);

  /// No description provided for @customerAdded.
  ///
  /// In en, this message translates to:
  /// **'Customer added successfully'**
  String get customerAdded;

  /// No description provided for @customerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated successfully'**
  String get customerUpdated;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterNameError;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @creditLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get creditLimitLabel;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get totalCustomers;

  /// No description provided for @searchSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Search suppliers...'**
  String get searchSuppliers;

  /// No description provided for @noSuppliersFound.
  ///
  /// In en, this message translates to:
  /// **'No suppliers found'**
  String get noSuppliersFound;

  /// No description provided for @noContactPerson.
  ///
  /// In en, this message translates to:
  /// **'No contact person'**
  String get noContactPerson;

  /// No description provided for @supplierAdded.
  ///
  /// In en, this message translates to:
  /// **'Supplier added successfully'**
  String get supplierAdded;

  /// No description provided for @supplierUpdated.
  ///
  /// In en, this message translates to:
  /// **'Supplier updated successfully'**
  String get supplierUpdated;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get addSupplier;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editSupplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @purchasesHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchases History'**
  String get purchasesHistory;

  /// No description provided for @noPurchases.
  ///
  /// In en, this message translates to:
  /// **'No purchases recorded yet.'**
  String get noPurchases;

  /// No description provided for @invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice: {invoice}'**
  String invoiceLabel(Object invoice);

  /// No description provided for @supplierLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier: {supplier}'**
  String supplierLabel(Object supplier);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(Object date);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @newPurchase.
  ///
  /// In en, this message translates to:
  /// **'New Purchase'**
  String get newPurchase;

  /// No description provided for @purchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get purchaseDetails;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @newPurchaseInvoice.
  ///
  /// In en, this message translates to:
  /// **'New Purchase Invoice'**
  String get newPurchaseInvoice;

  /// No description provided for @selectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Select Supplier'**
  String get selectSupplier;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumberLabel;

  /// No description provided for @noProductsAdded.
  ///
  /// In en, this message translates to:
  /// **'No products added yet.'**
  String get noProductsAdded;

  /// No description provided for @qtyAtPrice.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} @ {price}'**
  String qtyAtPrice(Object price, Object qty);

  /// No description provided for @savePurchase.
  ///
  /// In en, this message translates to:
  /// **'SAVE PURCHASE'**
  String get savePurchase;

  /// No description provided for @purchaseSaved.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved successfully!'**
  String get purchaseSaved;

  /// No description provided for @addProductToPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Product to Purchase'**
  String get addProductToPurchase;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @buyPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy Price'**
  String get buyPriceLabel;

  /// No description provided for @noSalesFound.
  ///
  /// In en, this message translates to:
  /// **'No sales found'**
  String get noSalesFound;

  /// No description provided for @saleIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale #{id}'**
  String saleIdLabel(Object id);

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @saleDetails.
  ///
  /// In en, this message translates to:
  /// **'Sale Details'**
  String get saleDetails;

  /// No description provided for @newSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSale;

  /// No description provided for @returnsManagement.
  ///
  /// In en, this message translates to:
  /// **'Returns Management'**
  String get returnsManagement;

  /// No description provided for @salesReturns.
  ///
  /// In en, this message translates to:
  /// **'Sales Returns'**
  String get salesReturns;

  /// No description provided for @purchaseReturns.
  ///
  /// In en, this message translates to:
  /// **'Purchase Returns'**
  String get purchaseReturns;

  /// No description provided for @newReturn.
  ///
  /// In en, this message translates to:
  /// **'New Return'**
  String get newReturn;

  /// No description provided for @noReturnsFound.
  ///
  /// In en, this message translates to:
  /// **'No returns found.'**
  String get noReturnsFound;

  /// No description provided for @returnIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Return ID: {id}'**
  String returnIdLabel(Object id);

  /// No description provided for @amountReturnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String amountReturnedLabel(Object amount);

  /// No description provided for @createReturn.
  ///
  /// In en, this message translates to:
  /// **'Create Return'**
  String get createReturn;

  /// No description provided for @fromSale.
  ///
  /// In en, this message translates to:
  /// **'From a Sale'**
  String get fromSale;

  /// No description provided for @fromPurchase.
  ///
  /// In en, this message translates to:
  /// **'From a Purchase'**
  String get fromPurchase;

  /// No description provided for @txLabel.
  ///
  /// In en, this message translates to:
  /// **'Tx: {id}'**
  String txLabel(Object id);

  /// No description provided for @financialReports.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get financialReports;

  /// No description provided for @totalProfitLoss.
  ///
  /// In en, this message translates to:
  /// **'Total Profit/Loss'**
  String get totalProfitLoss;

  /// No description provided for @totalSalesRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Sales (Revenue)'**
  String get totalSalesRevenue;

  /// No description provided for @totalPurchasesExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Purchases (Expenses)'**
  String get totalPurchasesExpenses;

  /// No description provided for @grossProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross Profit'**
  String get grossProfit;

  /// No description provided for @outstandingBalances.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balances'**
  String get outstandingBalances;

  /// No description provided for @customerDebts.
  ///
  /// In en, this message translates to:
  /// **'Customer Debts'**
  String get customerDebts;

  /// No description provided for @supplierDebts.
  ///
  /// In en, this message translates to:
  /// **'Supplier Debts'**
  String get supplierDebts;

  /// No description provided for @inventoryValue.
  ///
  /// In en, this message translates to:
  /// **'Inventory Value'**
  String get inventoryValue;

  /// No description provided for @totalStockValue.
  ///
  /// In en, this message translates to:
  /// **'Total Stock Value (at Buy Price)'**
  String get totalStockValue;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productNameLabel;

  /// No description provided for @skuBarcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU/Barcode'**
  String get skuBarcodeLabel;

  /// No description provided for @enterSkuError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an SKU'**
  String get enterSkuError;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @sellPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sell Price'**
  String get sellPriceLabel;

  /// No description provided for @initialStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial Stock'**
  String get initialStockLabel;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay Amount'**
  String get payAmount;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmount;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully'**
  String get paymentSuccess;

  /// No description provided for @enterAmountError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get enterAmountError;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @inventoryReports.
  ///
  /// In en, this message translates to:
  /// **'Inventory Reports'**
  String get inventoryReports;

  /// No description provided for @lowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Products'**
  String get lowStockProducts;

  /// No description provided for @noLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'No products with low stock.'**
  String get noLowStockProducts;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @alertLimit.
  ///
  /// In en, this message translates to:
  /// **'Alert Limit'**
  String get alertLimit;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @lowStockItems.
  ///
  /// In en, this message translates to:
  /// **'items with low stock'**
  String get lowStockItems;

  /// No description provided for @noLowStockItems.
  ///
  /// In en, this message translates to:
  /// **'No low stock items'**
  String get noLowStockItems;

  /// No description provided for @stockLevel.
  ///
  /// In en, this message translates to:
  /// **'Stock Level'**
  String get stockLevel;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @searchByInvoiceId.
  ///
  /// In en, this message translates to:
  /// **'Search by Invoice ID'**
  String get searchByInvoiceId;

  /// No description provided for @invoiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invoice not found'**
  String get invoiceNotFound;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @categoryCode.
  ///
  /// In en, this message translates to:
  /// **'Category Code'**
  String get categoryCode;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAdded;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdated;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @enterSku.
  ///
  /// In en, this message translates to:
  /// **'Enter SKU'**
  String get enterSku;

  /// No description provided for @buyPrice.
  ///
  /// In en, this message translates to:
  /// **'Buy Price'**
  String get buyPrice;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell Price'**
  String get sellPrice;

  /// No description provided for @wholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Wholesale Price'**
  String get wholesalePrice;

  /// No description provided for @costCenters.
  ///
  /// In en, this message translates to:
  /// **'Cost Centers'**
  String get costCenters;

  /// No description provided for @addCostCenter.
  ///
  /// In en, this message translates to:
  /// **'Add Cost Center'**
  String get addCostCenter;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @noCostCentersFound.
  ///
  /// In en, this message translates to:
  /// **'No cost centers found'**
  String get noCostCentersFound;

  /// No description provided for @accounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get accounting;

  /// No description provided for @chartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'Chart of Accounts'**
  String get chartOfAccounts;

  /// No description provided for @generalLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get generalLedger;

  /// No description provided for @trialBalance.
  ///
  /// In en, this message translates to:
  /// **'Trial Balance'**
  String get trialBalance;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accountCode.
  ///
  /// In en, this message translates to:
  /// **'Account Code'**
  String get accountCode;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @asset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get asset;

  /// No description provided for @liability.
  ///
  /// In en, this message translates to:
  /// **'Liability'**
  String get liability;

  /// No description provided for @equity.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get equity;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @isHeader.
  ///
  /// In en, this message translates to:
  /// **'Is Header?'**
  String get isHeader;

  /// No description provided for @parentAccount.
  ///
  /// In en, this message translates to:
  /// **'Parent Account'**
  String get parentAccount;

  /// No description provided for @balanceSheet.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet'**
  String get balanceSheet;

  /// No description provided for @incomeStatement.
  ///
  /// In en, this message translates to:
  /// **'Income Statement'**
  String get incomeStatement;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @inventoryAudit.
  ///
  /// In en, this message translates to:
  /// **'Inventory Audit'**
  String get inventoryAudit;

  /// No description provided for @userRoles.
  ///
  /// In en, this message translates to:
  /// **'User Roles'**
  String get userRoles;

  /// No description provided for @thermalPrinting.
  ///
  /// In en, this message translates to:
  /// **'Thermal Printing'**
  String get thermalPrinting;

  /// No description provided for @printReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get printReceipt;

  /// No description provided for @fixedAssets.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets'**
  String get fixedAssets;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @totalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get totalAssets;

  /// No description provided for @totalLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Total Liabilities'**
  String get totalLiabilities;

  /// No description provided for @totalEquity.
  ///
  /// In en, this message translates to:
  /// **'Total Equity'**
  String get totalEquity;

  /// No description provided for @netIncome.
  ///
  /// In en, this message translates to:
  /// **'Net Income'**
  String get netIncome;

  /// No description provided for @operatingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Operating Expenses'**
  String get operatingExpenses;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saveSuccess;

  /// No description provided for @shiftManagement.
  ///
  /// In en, this message translates to:
  /// **'Shift Management'**
  String get shiftManagement;

  /// No description provided for @openShift.
  ///
  /// In en, this message translates to:
  /// **'Open Shift'**
  String get openShift;

  /// No description provided for @closeShift.
  ///
  /// In en, this message translates to:
  /// **'Close Shift'**
  String get closeShift;

  /// No description provided for @openingCash.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash'**
  String get openingCash;

  /// No description provided for @closingCash.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash'**
  String get closingCash;

  /// No description provided for @expectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get expectedCash;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @shiftOpened.
  ///
  /// In en, this message translates to:
  /// **'Shift opened successfully'**
  String get shiftOpened;

  /// No description provided for @shiftClosed.
  ///
  /// In en, this message translates to:
  /// **'Shift closed successfully'**
  String get shiftClosed;

  /// No description provided for @noOpenShift.
  ///
  /// In en, this message translates to:
  /// **'No open shift found'**
  String get noOpenShift;

  /// No description provided for @currentShift.
  ///
  /// In en, this message translates to:
  /// **'Current Shift'**
  String get currentShift;

  /// No description provided for @manualJournalEntries.
  ///
  /// In en, this message translates to:
  /// **'Manual Journal Entries'**
  String get manualJournalEntries;

  /// No description provided for @financialYearClosing.
  ///
  /// In en, this message translates to:
  /// **'Financial Year Closing'**
  String get financialYearClosing;

  /// No description provided for @reconciliation.
  ///
  /// In en, this message translates to:
  /// **'Bank/Cash Reconciliation'**
  String get reconciliation;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get auditLog;

  /// No description provided for @vatReturn.
  ///
  /// In en, this message translates to:
  /// **'VAT Return Report'**
  String get vatReturn;

  /// No description provided for @cashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Statement'**
  String get cashFlow;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get selectAccount;

  /// No description provided for @actualBalance.
  ///
  /// In en, this message translates to:
  /// **'Actual Balance'**
  String get actualBalance;

  /// No description provided for @bookBalance.
  ///
  /// In en, this message translates to:
  /// **'Book Balance'**
  String get bookBalance;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @reconciliationAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation adjustment'**
  String get reconciliationAdjustment;

  /// No description provided for @cashOverShortAccount.
  ///
  /// In en, this message translates to:
  /// **'Cash Over/Short Account'**
  String get cashOverShortAccount;

  /// No description provided for @selectAccountError.
  ///
  /// In en, this message translates to:
  /// **'Please select an account'**
  String get selectAccountError;

  /// No description provided for @enterActualBalanceError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the actual balance'**
  String get enterActualBalanceError;

  /// No description provided for @reconciliationDifference.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation Difference'**
  String get reconciliationDifference;

  /// No description provided for @vatOnSales.
  ///
  /// In en, this message translates to:
  /// **'VAT on Sales (Output VAT)'**
  String get vatOnSales;

  /// No description provided for @vatOnPurchases.
  ///
  /// In en, this message translates to:
  /// **'VAT on Purchases (Input VAT)'**
  String get vatOnPurchases;

  /// No description provided for @netVatPayable.
  ///
  /// In en, this message translates to:
  /// **'Net VAT Payable'**
  String get netVatPayable;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available for the selected period'**
  String get noDataAvailable;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @welcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome Admin'**
  String get welcomeAdmin;

  /// No description provided for @adminDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your supermarket operations with ease.'**
  String get adminDashboardDescription;

  /// No description provided for @manageStaff.
  ///
  /// In en, this message translates to:
  /// **'Manage Staff'**
  String get manageStaff;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @asOf.
  ///
  /// In en, this message translates to:
  /// **'As of'**
  String get asOf;

  /// No description provided for @balanceSheetBalanced.
  ///
  /// In en, this message translates to:
  /// **'Assets = Liabilities + Equity'**
  String get balanceSheetBalanced;

  /// No description provided for @balanceSheetNotBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet is not balanced!'**
  String get balanceSheetNotBalanced;

  /// No description provided for @operatingActivities.
  ///
  /// In en, this message translates to:
  /// **'Operating Activities'**
  String get operatingActivities;

  /// No description provided for @netCashFromOperating.
  ///
  /// In en, this message translates to:
  /// **'Net Cash From Operating Activities'**
  String get netCashFromOperating;

  /// No description provided for @investingActivities.
  ///
  /// In en, this message translates to:
  /// **'Investing Activities'**
  String get investingActivities;

  /// No description provided for @netCashFromInvesting.
  ///
  /// In en, this message translates to:
  /// **'Net Cash From Investing Activities'**
  String get netCashFromInvesting;

  /// No description provided for @financingActivities.
  ///
  /// In en, this message translates to:
  /// **'Financing Activities'**
  String get financingActivities;

  /// No description provided for @netCashFromFinancing.
  ///
  /// In en, this message translates to:
  /// **'Net Cash From Financing Activities'**
  String get netCashFromFinancing;

  /// No description provided for @netChangeInCash.
  ///
  /// In en, this message translates to:
  /// **'Net Change In Cash'**
  String get netChangeInCash;

  /// No description provided for @beginningCashBalance.
  ///
  /// In en, this message translates to:
  /// **'Beginning Cash Balance'**
  String get beginningCashBalance;

  /// No description provided for @endingCashBalance.
  ///
  /// In en, this message translates to:
  /// **'Ending Cash Balance'**
  String get endingCashBalance;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @liabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get liabilities;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No Purchases Found'**
  String get noPurchasesFound;

  /// No description provided for @walkInSupplier.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Supplier'**
  String get walkInSupplier;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySymbol;

  /// No description provided for @backupAndSync.
  ///
  /// In en, this message translates to:
  /// **'Backup and Sync'**
  String get backupAndSync;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @localBackup.
  ///
  /// In en, this message translates to:
  /// **'Local Backup'**
  String get localBackup;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @restoreFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud'**
  String get restoreFromCloud;

  /// No description provided for @noCloudBackups.
  ///
  /// In en, this message translates to:
  /// **'No Cloud Backups'**
  String get noCloudBackups;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreFromLocalFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from Local File'**
  String get restoreFromLocalFile;

  /// No description provided for @pickBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Pick Backup File'**
  String get pickBackupFile;

  /// No description provided for @confirmRestore.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get confirmRestore;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Restoring will overwrite current data. Are you sure?'**
  String get restoreWarning;

  /// No description provided for @simplifiedTaxInvoice.
  ///
  /// In en, this message translates to:
  /// **'Simplified Tax Invoice'**
  String get simplifiedTaxInvoice;

  /// No description provided for @vatNumber.
  ///
  /// In en, this message translates to:
  /// **'VAT Number: {vatNumber}'**
  String vatNumber(Object vatNumber);

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice No: {invoiceNumber}'**
  String invoiceNumber(Object invoiceNumber);

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @purchaseId.
  ///
  /// In en, this message translates to:
  /// **'Purchase ID'**
  String get purchaseId;

  /// No description provided for @totalReturnAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Return Amount'**
  String get totalReturnAmount;

  /// No description provided for @purchaseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Purchase not found'**
  String get purchaseNotFound;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business!'**
  String get thankYou;

  /// No description provided for @closeFinancialYear.
  ///
  /// In en, this message translates to:
  /// **'Close Financial Year'**
  String get closeFinancialYear;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @staffManagement.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get staffManagement;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @confirmDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete user {name}?'**
  String confirmDeleteUser(Object name);

  /// No description provided for @leaveEmptyToKeep.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep current password'**
  String get leaveEmptyToKeep;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role/Permission'**
  String get role;

  /// No description provided for @customerStatement.
  ///
  /// In en, this message translates to:
  /// **'Customer Statement'**
  String get customerStatement;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @allChangesSynced.
  ///
  /// In en, this message translates to:
  /// **'All changes synced'**
  String get allChangesSynced;

  /// No description provided for @unsyncedChanges.
  ///
  /// In en, this message translates to:
  /// **'{count} unsynced changes'**
  String unsyncedChanges(Object count);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync: {time}'**
  String lastSync(Object time);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @batchNumber.
  ///
  /// In en, this message translates to:
  /// **'Batch Number'**
  String get batchNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @ordered.
  ///
  /// In en, this message translates to:
  /// **'Ordered'**
  String get ordered;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @selectWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Select Warehouse'**
  String get selectWarehouse;

  /// No description provided for @noWarehousesFound.
  ///
  /// In en, this message translates to:
  /// **'No warehouses found'**
  String get noWarehousesFound;

  /// No description provided for @addWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Add Warehouse'**
  String get addWarehouse;

  /// No description provided for @warehouseName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Name'**
  String get warehouseName;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @whatWouldYouLikeToDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// No description provided for @downloadPdfInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Invoice'**
  String get downloadPdfInvoice;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @vatReport.
  ///
  /// In en, this message translates to:
  /// **'VAT Report'**
  String get vatReport;

  /// No description provided for @vatSummary.
  ///
  /// In en, this message translates to:
  /// **'VAT Summary'**
  String get vatSummary;

  /// No description provided for @totalOutputVat.
  ///
  /// In en, this message translates to:
  /// **'Total Output VAT'**
  String get totalOutputVat;

  /// No description provided for @totalInputVat.
  ///
  /// In en, this message translates to:
  /// **'Total Input VAT'**
  String get totalInputVat;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get unknownProduct;

  /// No description provided for @viewInvoice.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get viewInvoice;

  /// No description provided for @confirmDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category? This will prevent access to associated products.'**
  String get confirmDeleteCategory;

  /// No description provided for @categoryHasProductsError.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete category because it is associated with existing products.'**
  String get categoryHasProductsError;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @customerStatementTooltip.
  ///
  /// In en, this message translates to:
  /// **'Account Statement'**
  String get customerStatementTooltip;

  /// No description provided for @newPurchaseReturn.
  ///
  /// In en, this message translates to:
  /// **'New Purchase Return'**
  String get newPurchaseReturn;

  /// No description provided for @selectPurchase.
  ///
  /// In en, this message translates to:
  /// **'Select Purchase'**
  String get selectPurchase;

  /// No description provided for @selectAPurchaseToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select a purchase to continue'**
  String get selectAPurchaseToContinue;

  /// No description provided for @processReturn.
  ///
  /// In en, this message translates to:
  /// **'Process Return'**
  String get processReturn;

  /// No description provided for @returnProcessedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Return processed successfully'**
  String get returnProcessedSuccessfully;

  /// No description provided for @noReturnsYet.
  ///
  /// In en, this message translates to:
  /// **'No returns yet'**
  String get noReturnsYet;

  /// No description provided for @newSalesReturn.
  ///
  /// In en, this message translates to:
  /// **'New Sales Return'**
  String get newSalesReturn;

  /// No description provided for @selectSale.
  ///
  /// In en, this message translates to:
  /// **'Select Sale'**
  String get selectSale;

  /// No description provided for @failedToSaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to save product'**
  String get failedToSaveProduct;

  /// No description provided for @failedToSaveCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to save category'**
  String get failedToSaveCategory;

  /// No description provided for @failedToDeleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product'**
  String get failedToDeleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {productName}?'**
  String deleteProductConfirmation(Object productName);

  /// No description provided for @failedToSavePurchase.
  ///
  /// In en, this message translates to:
  /// **'Failed to save purchase'**
  String get failedToSavePurchase;

  /// No description provided for @selectASaleToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select a sale to continue'**
  String get selectASaleToContinue;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @cartonUnit.
  ///
  /// In en, this message translates to:
  /// **'Carton Unit'**
  String get cartonUnit;

  /// No description provided for @piecesPerCarton.
  ///
  /// In en, this message translates to:
  /// **'Pieces per Carton'**
  String get piecesPerCarton;

  /// No description provided for @baseUnit.
  ///
  /// In en, this message translates to:
  /// **'Base Unit'**
  String get baseUnit;

  /// No description provided for @isCarton.
  ///
  /// In en, this message translates to:
  /// **'Is Carton?'**
  String get isCarton;

  /// No description provided for @accountsPayable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable'**
  String get accountsPayable;

  /// No description provided for @apInvoices.
  ///
  /// In en, this message translates to:
  /// **'AP Invoices'**
  String get apInvoices;

  /// No description provided for @supplierLedger.
  ///
  /// In en, this message translates to:
  /// **'Supplier Ledger'**
  String get supplierLedger;

  /// No description provided for @newAPInvoice.
  ///
  /// In en, this message translates to:
  /// **'New AP Invoice'**
  String get newAPInvoice;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoiceDate;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @taxAmount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get taxAmount;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paidAmount;

  /// No description provided for @apInvoiceAdded.
  ///
  /// In en, this message translates to:
  /// **'AP Invoice added successfully'**
  String get apInvoiceAdded;

  /// No description provided for @accountsReceivable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable'**
  String get accountsReceivable;

  /// No description provided for @arInvoices.
  ///
  /// In en, this message translates to:
  /// **'AR Invoices'**
  String get arInvoices;

  /// No description provided for @customerLedger.
  ///
  /// In en, this message translates to:
  /// **'Customer Ledger'**
  String get customerLedger;

  /// No description provided for @newARInvoice.
  ///
  /// In en, this message translates to:
  /// **'New AR Invoice'**
  String get newARInvoice;

  /// No description provided for @arInvoiceAdded.
  ///
  /// In en, this message translates to:
  /// **'AR Invoice added successfully'**
  String get arInvoiceAdded;

  /// No description provided for @agingReport.
  ///
  /// In en, this message translates to:
  /// **'Aging Report'**
  String get agingReport;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @days30.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get days30;

  /// No description provided for @days60.
  ///
  /// In en, this message translates to:
  /// **'60 Days'**
  String get days60;

  /// No description provided for @days90Plus.
  ///
  /// In en, this message translates to:
  /// **'90+ Days'**
  String get days90Plus;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Due'**
  String get totalDue;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @cashFlowForecast.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Forecast'**
  String get cashFlowForecast;

  /// No description provided for @inflow.
  ///
  /// In en, this message translates to:
  /// **'Cash Inflow (AR)'**
  String get inflow;

  /// No description provided for @outflow.
  ///
  /// In en, this message translates to:
  /// **'Cash Outflow (AP)'**
  String get outflow;

  /// No description provided for @netCash.
  ///
  /// In en, this message translates to:
  /// **'Net Cash'**
  String get netCash;

  /// No description provided for @next30Days.
  ///
  /// In en, this message translates to:
  /// **'Next 30 Days'**
  String get next30Days;

  /// No description provided for @next60Days.
  ///
  /// In en, this message translates to:
  /// **'Next 60 Days'**
  String get next60Days;

  /// No description provided for @next90Days.
  ///
  /// In en, this message translates to:
  /// **'Next 90 Days'**
  String get next90Days;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @noItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'No items selected'**
  String get noItemsSelected;

  /// No description provided for @deleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get deleteCustomer;

  /// No description provided for @deleteSupplier.
  ///
  /// In en, this message translates to:
  /// **'Delete Supplier'**
  String get deleteSupplier;

  /// No description provided for @confirmDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {customerName}?'**
  String confirmDeleteCustomer(Object customerName);

  /// No description provided for @confirmDeleteSupplier.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {supplierName}?'**
  String confirmDeleteSupplier(Object supplierName);

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted'**
  String get customerDeleted;

  /// No description provided for @supplierDeleted.
  ///
  /// In en, this message translates to:
  /// **'Supplier deleted'**
  String get supplierDeleted;

  /// No description provided for @failedToDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete customer'**
  String get failedToDeleteCustomer;

  /// No description provided for @failedToDeleteSupplier.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete supplier'**
  String get failedToDeleteSupplier;

  /// No description provided for @manufacturing.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing'**
  String get manufacturing;

  /// No description provided for @productionOrders.
  ///
  /// In en, this message translates to:
  /// **'Production Orders'**
  String get productionOrders;

  /// No description provided for @bomManagement.
  ///
  /// In en, this message translates to:
  /// **'BOM Management'**
  String get bomManagement;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// No description provided for @plannedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Planned Quantity'**
  String get plannedQuantity;

  /// No description provided for @productionOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Production order created successfully'**
  String get productionOrderCreated;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @bom.
  ///
  /// In en, this message translates to:
  /// **'Bill of Materials'**
  String get bom;

  /// No description provided for @executeAssembly.
  ///
  /// In en, this message translates to:
  /// **'Execute Assembly'**
  String get executeAssembly;

  /// No description provided for @assemblySuccess.
  ///
  /// In en, this message translates to:
  /// **'Assembly executed successfully'**
  String get assemblySuccess;

  /// No description provided for @finishedProduct.
  ///
  /// In en, this message translates to:
  /// **'Finished Product'**
  String get finishedProduct;

  /// No description provided for @rawMaterials.
  ///
  /// In en, this message translates to:
  /// **'Raw Materials'**
  String get rawMaterials;

  /// No description provided for @bankReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Bank Reconciliation'**
  String get bankReconciliation;

  /// No description provided for @autoBreakService.
  ///
  /// In en, this message translates to:
  /// **'Auto-Break Service'**
  String get autoBreakService;

  /// No description provided for @unitHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Unit Hierarchy'**
  String get unitHierarchy;

  /// No description provided for @addUnit.
  ///
  /// In en, this message translates to:
  /// **'Add Unit'**
  String get addUnit;

  /// No description provided for @removeUnit.
  ///
  /// In en, this message translates to:
  /// **'Remove Unit'**
  String get removeUnit;

  /// No description provided for @unitName.
  ///
  /// In en, this message translates to:
  /// **'Unit Name'**
  String get unitName;

  /// No description provided for @unitFactor.
  ///
  /// In en, this message translates to:
  /// **'Unit Factor'**
  String get unitFactor;

  /// No description provided for @returnMode.
  ///
  /// In en, this message translates to:
  /// **'Return Mode'**
  String get returnMode;

  /// No description provided for @returnFromSale.
  ///
  /// In en, this message translates to:
  /// **'Return from Sale'**
  String get returnFromSale;

  /// No description provided for @originalSaleReference.
  ///
  /// In en, this message translates to:
  /// **'Original Sale Reference'**
  String get originalSaleReference;

  /// No description provided for @searchSale.
  ///
  /// In en, this message translates to:
  /// **'Search Sale'**
  String get searchSale;

  /// No description provided for @returnItem.
  ///
  /// In en, this message translates to:
  /// **'Return Item'**
  String get returnItem;

  /// No description provided for @returnQuantity.
  ///
  /// In en, this message translates to:
  /// **'Return Quantity'**
  String get returnQuantity;

  /// No description provided for @returnReason.
  ///
  /// In en, this message translates to:
  /// **'Return Reason'**
  String get returnReason;

  /// No description provided for @returnSuccess.
  ///
  /// In en, this message translates to:
  /// **'Return processed successfully'**
  String get returnSuccess;

  /// No description provided for @totalRefund.
  ///
  /// In en, this message translates to:
  /// **'Total Refund'**
  String get totalRefund;

  /// No description provided for @cancelReturn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Return'**
  String get cancelReturn;

  /// No description provided for @unmatchedTransactions.
  ///
  /// In en, this message translates to:
  /// **'Unmatched Transactions'**
  String get unmatchedTransactions;

  /// No description provided for @reconcileSelected.
  ///
  /// In en, this message translates to:
  /// **'Reconcile Selected'**
  String get reconcileSelected;

  /// No description provided for @autoReconcile.
  ///
  /// In en, this message translates to:
  /// **'Auto Reconcile'**
  String get autoReconcile;

  /// No description provided for @reconcileAll.
  ///
  /// In en, this message translates to:
  /// **'Reconcile All'**
  String get reconcileAll;

  /// No description provided for @tolerance.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get tolerance;

  /// No description provided for @noUnmatchedTransactions.
  ///
  /// In en, this message translates to:
  /// **'No unmatched transactions'**
  String get noUnmatchedTransactions;

  /// No description provided for @accountingPeriods.
  ///
  /// In en, this message translates to:
  /// **'Accounting Periods'**
  String get accountingPeriods;

  /// No description provided for @autoGenerate.
  ///
  /// In en, this message translates to:
  /// **'Auto Generate'**
  String get autoGenerate;

  /// No description provided for @cancelAutoGeneration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Auto Generation'**
  String get cancelAutoGeneration;

  /// No description provided for @periodName.
  ///
  /// In en, this message translates to:
  /// **'Period Name'**
  String get periodName;

  /// No description provided for @examplePeriodName.
  ///
  /// In en, this message translates to:
  /// **'Example: January 2026'**
  String get examplePeriodName;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @existingPeriods.
  ///
  /// In en, this message translates to:
  /// **'Existing Periods'**
  String get existingPeriods;

  /// No description provided for @noAccountingPeriods.
  ///
  /// In en, this message translates to:
  /// **'No Accounting Periods'**
  String get noAccountingPeriods;

  /// No description provided for @closePeriod.
  ///
  /// In en, this message translates to:
  /// **'Close Period'**
  String get closePeriod;

  /// No description provided for @openPeriod.
  ///
  /// In en, this message translates to:
  /// **'Open Period'**
  String get openPeriod;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @periodAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Period added successfully'**
  String get periodAddedSuccessfully;

  /// No description provided for @confirmClosePeriod.
  ///
  /// In en, this message translates to:
  /// **'Confirm Close Period'**
  String get confirmClosePeriod;

  /// No description provided for @closePeriodMessage.
  ///
  /// In en, this message translates to:
  /// **'Profits will be transferred to retained earnings.'**
  String get closePeriodMessage;

  /// No description provided for @confirmGeneric.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmGeneric;

  /// No description provided for @failedToClosePeriod.
  ///
  /// In en, this message translates to:
  /// **'Failed to close period'**
  String get failedToClosePeriod;

  /// No description provided for @failedToReopenPeriod.
  ///
  /// In en, this message translates to:
  /// **'Failed to reopen period'**
  String get failedToReopenPeriod;

  /// No description provided for @cannotDeleteClosedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete a closed period'**
  String get cannotDeleteClosedPeriod;

  /// No description provided for @cannotDeletePeriodWithEntries.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete period: GL entries exist in this period'**
  String get cannotDeletePeriodWithEntries;

  /// No description provided for @periodDeleted.
  ///
  /// In en, this message translates to:
  /// **'Period deleted'**
  String get periodDeleted;

  /// No description provided for @createAutoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Create Auto Periods'**
  String get createAutoPeriods;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @periodType.
  ///
  /// In en, this message translates to:
  /// **'Period Type'**
  String get periodType;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly (12 periods)'**
  String get monthly;

  /// No description provided for @quarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly (4 periods)'**
  String get quarterly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly (1 period)'**
  String get yearly;

  /// No description provided for @autoPeriodInfo.
  ///
  /// In en, this message translates to:
  /// **'Periods will be created automatically based on selection.'**
  String get autoPeriodInfo;

  /// No description provided for @periodsCreated.
  ///
  /// In en, this message translates to:
  /// **'{count} accounting periods created successfully'**
  String periodsCreated(Object count);

  /// No description provided for @failedToCreatePeriods.
  ///
  /// In en, this message translates to:
  /// **'Failed to create periods: {error}'**
  String failedToCreatePeriods(Object error);

  /// No description provided for @reopenPeriod.
  ///
  /// In en, this message translates to:
  /// **'Reopen Period'**
  String get reopenPeriod;

  /// No description provided for @addPeriod.
  ///
  /// In en, this message translates to:
  /// **'Add Period'**
  String get addPeriod;

  /// No description provided for @addManualPeriod.
  ///
  /// In en, this message translates to:
  /// **'Add Manual Period'**
  String get addManualPeriod;

  /// No description provided for @manualJournalEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Journal Entry'**
  String get manualJournalEntry;

  /// No description provided for @addAccountToEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Account to Entry'**
  String get addAccountToEntry;

  /// No description provided for @entryDescription.
  ///
  /// In en, this message translates to:
  /// **'Entry Description'**
  String get entryDescription;

  /// No description provided for @entryDate.
  ///
  /// In en, this message translates to:
  /// **'Entry Date'**
  String get entryDate;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @costCenter.
  ///
  /// In en, this message translates to:
  /// **'Cost Center'**
  String get costCenter;

  /// No description provided for @noCostCenter.
  ///
  /// In en, this message translates to:
  /// **'No Cost Center'**
  String get noCostCenter;

  /// No description provided for @saveAndPost.
  ///
  /// In en, this message translates to:
  /// **'Save & Post'**
  String get saveAndPost;

  /// No description provided for @entryNotBalanced.
  ///
  /// In en, this message translates to:
  /// **'Entry Not Balanced'**
  String get entryNotBalanced;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the entry description'**
  String get pleaseEnterDescription;

  /// No description provided for @cannotPostToClosedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Cannot post to a closed accounting period'**
  String get cannotPostToClosedPeriod;

  /// No description provided for @pleaseSelectAccountForLine.
  ///
  /// In en, this message translates to:
  /// **'Please select an account for line {lineNumber}'**
  String pleaseSelectAccountForLine(Object lineNumber);

  /// No description provided for @lineCannotHaveDebitAndCredit.
  ///
  /// In en, this message translates to:
  /// **'Line {lineNumber} cannot have both debit and credit'**
  String lineCannotHaveDebitAndCredit(Object lineNumber);

  /// No description provided for @lineHasAccountWithoutAmount.
  ///
  /// In en, this message translates to:
  /// **'Line {lineNumber} has an account without a debit or credit value'**
  String lineHasAccountWithoutAmount(Object lineNumber);

  /// No description provided for @entrySavedAndPosted.
  ///
  /// In en, this message translates to:
  /// **'Entry saved and posted successfully'**
  String get entrySavedAndPosted;

  /// No description provided for @failedToSaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Failed to save entry: {error}'**
  String failedToSaveEntry(Object error);

  /// No description provided for @recurringEntries.
  ///
  /// In en, this message translates to:
  /// **'Recurring Entries'**
  String get recurringEntries;

  /// No description provided for @executeDueEntries.
  ///
  /// In en, this message translates to:
  /// **'Execute Due Entries'**
  String get executeDueEntries;

  /// No description provided for @addRecurringEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Recurring Entry'**
  String get addRecurringEntry;

  /// No description provided for @noRecurringEntries.
  ///
  /// In en, this message translates to:
  /// **'No recurring entries'**
  String get noRecurringEntries;

  /// No description provided for @tapToAddRecurringEntry.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new recurring entry'**
  String get tapToAddRecurringEntry;

  /// No description provided for @dailyFreq.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailyFreq;

  /// No description provided for @weeklyFreq.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyFreq;

  /// No description provided for @biweeklyFreq.
  ///
  /// In en, this message translates to:
  /// **'Biweekly'**
  String get biweeklyFreq;

  /// No description provided for @monthlyFreq.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyFreq;

  /// No description provided for @quarterlyFreq.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get quarterlyFreq;

  /// No description provided for @yearlyFreq.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyFreq;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @fromToAccounts.
  ///
  /// In en, this message translates to:
  /// **'From: {debitAccount} To: {creditAccount}'**
  String fromToAccounts(Object creditAccount, Object debitAccount);

  /// No description provided for @nextExecutionDate.
  ///
  /// In en, this message translates to:
  /// **'Next execution: {date}'**
  String nextExecutionDate(Object date);

  /// No description provided for @executedCount.
  ///
  /// In en, this message translates to:
  /// **'Executed: {count}/{total}'**
  String executedCount(Object count, Object total);

  /// No description provided for @executedCountNoLimit.
  ///
  /// In en, this message translates to:
  /// **'Executed: {count}'**
  String executedCountNoLimit(Object count);

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @executeNow.
  ///
  /// In en, this message translates to:
  /// **'Execute Now'**
  String get executeNow;

  /// No description provided for @executionHistory.
  ///
  /// In en, this message translates to:
  /// **'Execution History'**
  String get executionHistory;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteRecurringEntry.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{entryName}\"?'**
  String confirmDeleteRecurringEntry(Object entryName);

  /// No description provided for @entryName.
  ///
  /// In en, this message translates to:
  /// **'Entry Name'**
  String get entryName;

  /// No description provided for @debitAccountCode.
  ///
  /// In en, this message translates to:
  /// **'Debit Account Code'**
  String get debitAccountCode;

  /// No description provided for @creditAccountCode.
  ///
  /// In en, this message translates to:
  /// **'Credit Account Code'**
  String get creditAccountCode;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @referenceType.
  ///
  /// In en, this message translates to:
  /// **'Reference Type'**
  String get referenceType;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseType;

  /// No description provided for @revenueType.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenueType;

  /// No description provided for @customType.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customType;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @executionHistoryFor.
  ///
  /// In en, this message translates to:
  /// **'Execution History - {name}'**
  String executionHistoryFor(Object name);

  /// No description provided for @noExecutionHistory.
  ///
  /// In en, this message translates to:
  /// **'No execution history'**
  String get noExecutionHistory;

  /// No description provided for @entryExecutedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Entry executed successfully'**
  String get entryExecutedSuccessfully;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @executionResult.
  ///
  /// In en, this message translates to:
  /// **'Executed: {success} succeeded, {fail} failed'**
  String executionResult(Object fail, Object success);

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithMessage(Object error);

  /// No description provided for @cashReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Cash Receipt Voucher'**
  String get cashReceiptVoucher;

  /// No description provided for @cashPaymentVoucher.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Voucher'**
  String get cashPaymentVoucher;

  /// No description provided for @receiptIn.
  ///
  /// In en, this message translates to:
  /// **'Receipt (In)'**
  String get receiptIn;

  /// No description provided for @paymentOut.
  ///
  /// In en, this message translates to:
  /// **'Payment (Out)'**
  String get paymentOut;

  /// No description provided for @creditAccountSource.
  ///
  /// In en, this message translates to:
  /// **'Credit Account (Source)'**
  String get creditAccountSource;

  /// No description provided for @debitAccountEntity.
  ///
  /// In en, this message translates to:
  /// **'Debit Account (Entity)'**
  String get debitAccountEntity;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Category (e.g. Rent, Salaries)'**
  String get categoryHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @voucherSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved successfully'**
  String get voucherSavedSuccessfully;

  /// No description provided for @saveReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Save Receipt Voucher'**
  String get saveReceiptVoucher;

  /// No description provided for @savePaymentVoucher.
  ///
  /// In en, this message translates to:
  /// **'Save Payment Voucher'**
  String get savePaymentVoucher;

  /// No description provided for @checkManagement.
  ///
  /// In en, this message translates to:
  /// **'Check Management'**
  String get checkManagement;

  /// No description provided for @checkType.
  ///
  /// In en, this message translates to:
  /// **'Check Type'**
  String get checkType;

  /// No description provided for @receivedChecks.
  ///
  /// In en, this message translates to:
  /// **'Received Checks (from customers)'**
  String get receivedChecks;

  /// No description provided for @issuedChecks.
  ///
  /// In en, this message translates to:
  /// **'Issued Checks (to suppliers)'**
  String get issuedChecks;

  /// No description provided for @checkNumber.
  ///
  /// In en, this message translates to:
  /// **'Check Number'**
  String get checkNumber;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @paymentCollectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Payment/Collection Account'**
  String get paymentCollectionAccount;

  /// No description provided for @saveCheck.
  ///
  /// In en, this message translates to:
  /// **'Save Check'**
  String get saveCheck;

  /// No description provided for @noChecks.
  ///
  /// In en, this message translates to:
  /// **'No checks.'**
  String get noChecks;

  /// No description provided for @checkInfo.
  ///
  /// In en, this message translates to:
  /// **'Check No: {number} - {bank}'**
  String checkInfo(Object bank, Object number);

  /// No description provided for @checkDetails.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount} - Due: {dueDate}\nStatus: {status}'**
  String checkDetails(Object amount, Object dueDate, Object status);

  /// No description provided for @collect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collect;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject/Bounce'**
  String get reject;

  /// No description provided for @checkCollected.
  ///
  /// In en, this message translates to:
  /// **'Collection of check: {checkNumber}'**
  String checkCollected(Object checkNumber);

  /// No description provided for @checkBounced.
  ///
  /// In en, this message translates to:
  /// **'Bounced check: {checkNumber}'**
  String checkBounced(Object checkNumber);

  /// No description provided for @checkStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Check status updated to {status}'**
  String checkStatusUpdated(Object status);

  /// No description provided for @fixedAssetsManagement.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets Management'**
  String get fixedAssetsManagement;

  /// No description provided for @confirmDepreciation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to run monthly depreciation for all assets? This will happen in the background.'**
  String get confirmDepreciation;

  /// No description provided for @run.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get run;

  /// No description provided for @depreciationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Depreciation calculation completed successfully.'**
  String get depreciationCompleted;

  /// No description provided for @calculateMonthlyDepreciation.
  ///
  /// In en, this message translates to:
  /// **'Calculate Monthly Depreciation'**
  String get calculateMonthlyDepreciation;

  /// No description provided for @noFixedAssets.
  ///
  /// In en, this message translates to:
  /// **'No fixed assets registered yet.'**
  String get noFixedAssets;

  /// No description provided for @startAddingAsset.
  ///
  /// In en, this message translates to:
  /// **'Start by adding a new asset from the button below.'**
  String get startAddingAsset;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get addAsset;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @originalCost.
  ///
  /// In en, this message translates to:
  /// **'Original Cost'**
  String get originalCost;

  /// No description provided for @usefulLife.
  ///
  /// In en, this message translates to:
  /// **'Useful Life'**
  String get usefulLife;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String years(Object years);

  /// No description provided for @salvageValue.
  ///
  /// In en, this message translates to:
  /// **'Salvage Value'**
  String get salvageValue;

  /// No description provided for @accumulatedDepreciation.
  ///
  /// In en, this message translates to:
  /// **'Accumulated Depreciation'**
  String get accumulatedDepreciation;

  /// No description provided for @netBookValue.
  ///
  /// In en, this message translates to:
  /// **'Net Book Value'**
  String get netBookValue;

  /// No description provided for @accountOptional.
  ///
  /// In en, this message translates to:
  /// **'Accounting Account (Optional)'**
  String get accountOptional;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes...'**
  String get additionalNotes;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// No description provided for @autoReconcileCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transaction(s) auto-reconciled'**
  String autoReconcileCount(Object count);

  /// No description provided for @autoReconcileError.
  ///
  /// In en, this message translates to:
  /// **'Auto reconcile error: {error}'**
  String autoReconcileError(Object error);

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @budgetCreated.
  ///
  /// In en, this message translates to:
  /// **'Budget created successfully'**
  String get budgetCreated;

  /// No description provided for @budgetList.
  ///
  /// In en, this message translates to:
  /// **'Budget List'**
  String get budgetList;

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget Name'**
  String get budgetName;

  /// No description provided for @budgeted.
  ///
  /// In en, this message translates to:
  /// **'Budgeted'**
  String get budgeted;

  /// No description provided for @budgetedAmount.
  ///
  /// In en, this message translates to:
  /// **'Budgeted Amount'**
  String get budgetedAmount;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @cashOverShortNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cash or cash over/short account not found'**
  String get cashOverShortNotFound;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @checkDueDate.
  ///
  /// In en, this message translates to:
  /// **'Check Due Date: {date}'**
  String checkDueDate(Object date);

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @confirmAndRecordReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Confirm and Record Reconciliation'**
  String get confirmAndRecordReconciliation;

  /// No description provided for @consumedPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% consumed'**
  String consumedPercent(Object percent);

  /// No description provided for @costCenterOptional.
  ///
  /// In en, this message translates to:
  /// **'Cost Center (Optional)'**
  String get costCenterOptional;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get createBudget;

  /// No description provided for @createBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Create a new budget from the second tab'**
  String get createBudgetHint;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterAmountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get enterAmountPrompt;

  /// No description provided for @enterBudgetNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget name'**
  String get enterBudgetNameError;

  /// No description provided for @errorLoadingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Error loading transactions: {error}'**
  String errorLoadingTransactions(Object error);

  /// No description provided for @fromAccount.
  ///
  /// In en, this message translates to:
  /// **'From Account'**
  String get fromAccount;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @noBudgetsFound.
  ///
  /// In en, this message translates to:
  /// **'No budgets found'**
  String get noBudgetsFound;

  /// No description provided for @payTo.
  ///
  /// In en, this message translates to:
  /// **'Pay To'**
  String get payTo;

  /// No description provided for @paymentVoucher.
  ///
  /// In en, this message translates to:
  /// **'Payment Voucher'**
  String get paymentVoucher;

  /// No description provided for @paymentVoucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Payment voucher saved successfully'**
  String get paymentVoucherSaved;

  /// No description provided for @periodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period: {period}'**
  String periodLabel(Object period);

  /// No description provided for @q1.
  ///
  /// In en, this message translates to:
  /// **'Q1'**
  String get q1;

  /// No description provided for @q2.
  ///
  /// In en, this message translates to:
  /// **'Q2'**
  String get q2;

  /// No description provided for @q3.
  ///
  /// In en, this message translates to:
  /// **'Q3'**
  String get q3;

  /// No description provided for @q4.
  ///
  /// In en, this message translates to:
  /// **'Q4'**
  String get q4;

  /// No description provided for @receiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Receipt Voucher'**
  String get receiptVoucher;

  /// No description provided for @receiptVoucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Receipt voucher saved successfully'**
  String get receiptVoucherSaved;

  /// No description provided for @receiveFrom.
  ///
  /// In en, this message translates to:
  /// **'Receive From'**
  String get receiveFrom;

  /// No description provided for @reconcileAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reconcile all {count} unmatched transactions?'**
  String reconcileAllConfirm(Object count);

  /// No description provided for @reconcileAllSuccess.
  ///
  /// In en, this message translates to:
  /// **'All {count} transactions reconciled successfully'**
  String reconcileAllSuccess(Object count);

  /// No description provided for @reconcileSuccessCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transaction(s) reconciled successfully'**
  String reconcileSuccessCount(Object count);

  /// No description provided for @reconciliationDescription.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation: {note}'**
  String reconciliationDescription(Object note);

  /// No description provided for @reconciliationError.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation error: {error}'**
  String reconciliationError(Object error);

  /// No description provided for @reconciliationNotes.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation Notes'**
  String get reconciliationNotes;

  /// No description provided for @reconciliationNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation notes...'**
  String get reconciliationNotesHint;

  /// No description provided for @reconciliationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation recorded successfully'**
  String get reconciliationSuccess;

  /// No description provided for @recordTransfer.
  ///
  /// In en, this message translates to:
  /// **'Record Transfer'**
  String get recordTransfer;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(Object error);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @selectAccountsError.
  ///
  /// In en, this message translates to:
  /// **'Please select accounts'**
  String get selectAccountsError;

  /// No description provided for @selectBankAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a bank account to start reconciliation'**
  String get selectBankAccountPrompt;

  /// No description provided for @selectCustomerOrSupplier.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer or supplier'**
  String get selectCustomerOrSupplier;

  /// No description provided for @selectedTransactions.
  ///
  /// In en, this message translates to:
  /// **'Selected Transactions'**
  String get selectedTransactions;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To Account'**
  String get toAccount;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @transferCompany.
  ///
  /// In en, this message translates to:
  /// **'Transfer Company'**
  String get transferCompany;

  /// No description provided for @transferItem.
  ///
  /// In en, this message translates to:
  /// **'Transfer: {amount}'**
  String transferItem(Object amount);

  /// No description provided for @transferSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transfer completed successfully'**
  String get transferSuccess;

  /// No description provided for @transferType.
  ///
  /// In en, this message translates to:
  /// **'Transfer Type'**
  String get transferType;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Financial Transfers'**
  String get transfers;

  /// No description provided for @variance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get variance;

  /// No description provided for @customizeDashboard.
  ///
  /// In en, this message translates to:
  /// **'Customize Dashboard'**
  String get customizeDashboard;

  /// No description provided for @dragToReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder, tap the eye to show/hide section'**
  String get dragToReorderHint;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @tapStarToPin.
  ///
  /// In en, this message translates to:
  /// **'Tap ⭐ on any screen to pin it here'**
  String get tapStarToPin;

  /// No description provided for @favoriteItems.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String favoriteItems(Object count);

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @saleInvoice.
  ///
  /// In en, this message translates to:
  /// **'Sale Invoice'**
  String get saleInvoice;

  /// No description provided for @saleInvoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new sale invoice'**
  String get saleInvoiceDescription;

  /// No description provided for @priceQuote.
  ///
  /// In en, this message translates to:
  /// **'Price Quote'**
  String get priceQuote;

  /// No description provided for @priceQuoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a price quote for customer'**
  String get priceQuoteDescription;

  /// No description provided for @customerOrder.
  ///
  /// In en, this message translates to:
  /// **'Customer Order'**
  String get customerOrder;

  /// No description provided for @customerOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive an order from customer'**
  String get customerOrderDescription;

  /// No description provided for @purchaseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get purchaseInvoice;

  /// No description provided for @purchaseInvoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new purchase invoice'**
  String get purchaseInvoiceDescription;

  /// No description provided for @purchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order'**
  String get purchaseOrder;

  /// No description provided for @purchaseOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a purchase order from supplier'**
  String get purchaseOrderDescription;

  /// No description provided for @newOperation.
  ///
  /// In en, this message translates to:
  /// **'New Operation'**
  String get newOperation;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @cashboxes.
  ///
  /// In en, this message translates to:
  /// **'Cash Boxes'**
  String get cashboxes;

  /// No description provided for @stockTake.
  ///
  /// In en, this message translates to:
  /// **'Stock Take'**
  String get stockTake;

  /// No description provided for @inventoryTransfer.
  ///
  /// In en, this message translates to:
  /// **'Inventory Transfer'**
  String get inventoryTransfer;

  /// No description provided for @printBarcode.
  ///
  /// In en, this message translates to:
  /// **'Print Barcode'**
  String get printBarcode;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @salesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReport;

  /// No description provided for @purchasesReport.
  ///
  /// In en, this message translates to:
  /// **'Purchases Report'**
  String get purchasesReport;

  /// No description provided for @profitReport.
  ///
  /// In en, this message translates to:
  /// **'Profit Report'**
  String get profitReport;

  /// No description provided for @inventoryReport.
  ///
  /// In en, this message translates to:
  /// **'Inventory Report'**
  String get inventoryReport;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(Object days);

  /// No description provided for @todaysBusiness.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Business'**
  String get todaysBusiness;

  /// No description provided for @todayPurchases.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Purchases'**
  String get todayPurchases;

  /// No description provided for @invoiceCount.
  ///
  /// In en, this message translates to:
  /// **'Invoice Count'**
  String get invoiceCount;

  /// No description provided for @newCustomers.
  ///
  /// In en, this message translates to:
  /// **'New Customers'**
  String get newCustomers;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @productsSold.
  ///
  /// In en, this message translates to:
  /// **'Products Sold'**
  String get productsSold;

  /// No description provided for @thisWeekSales.
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Sales'**
  String get thisWeekSales;

  /// No description provided for @thisWeekPurchases.
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Purchases'**
  String get thisWeekPurchases;

  /// No description provided for @transactionSettings.
  ///
  /// In en, this message translates to:
  /// **'Transaction Settings'**
  String get transactionSettings;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @thisFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldRequired;

  /// No description provided for @transactionSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved successfully'**
  String get transactionSavedSuccessfully;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @quickPos.
  ///
  /// In en, this message translates to:
  /// **'Quick POS'**
  String get quickPos;

  /// No description provided for @sellMode.
  ///
  /// In en, this message translates to:
  /// **'Sell Mode'**
  String get sellMode;

  /// No description provided for @retailMode.
  ///
  /// In en, this message translates to:
  /// **'Retail Mode'**
  String get retailMode;

  /// No description provided for @wholesaleModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Wholesale Mode'**
  String get wholesaleModeDescription;

  /// No description provided for @holdSale.
  ///
  /// In en, this message translates to:
  /// **'Hold Sale'**
  String get holdSale;

  /// No description provided for @saleHeld.
  ///
  /// In en, this message translates to:
  /// **'Sale held'**
  String get saleHeld;

  /// No description provided for @recallSale.
  ///
  /// In en, this message translates to:
  /// **'Recall Held Sale'**
  String get recallSale;

  /// No description provided for @heldSales.
  ///
  /// In en, this message translates to:
  /// **'Held Sales'**
  String get heldSales;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(Object count);

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySar;

  /// No description provided for @checkoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sale completed successfully'**
  String get checkoutSuccess;

  /// No description provided for @cashCustomer.
  ///
  /// In en, this message translates to:
  /// **'Cash Customer'**
  String get cashCustomer;

  /// No description provided for @howToSendInvoice.
  ///
  /// In en, this message translates to:
  /// **'How would you like to send the invoice?'**
  String get howToSendInvoice;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @returnSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Return Processed Successfully'**
  String get returnSuccessTitle;

  /// No description provided for @returnId.
  ///
  /// In en, this message translates to:
  /// **'Return ID: {id}'**
  String returnId(Object id);

  /// No description provided for @originalInvoice.
  ///
  /// In en, this message translates to:
  /// **'Original Invoice: {id}'**
  String originalInvoice(Object id);

  /// No description provided for @returnAmount.
  ///
  /// In en, this message translates to:
  /// **'Return Amount: {amount} SAR'**
  String returnAmount(Object amount);

  /// No description provided for @salesReturnDescription.
  ///
  /// In en, this message translates to:
  /// **'Return products from a sale invoice'**
  String get salesReturnDescription;

  /// No description provided for @purchaseReturnDescription.
  ///
  /// In en, this message translates to:
  /// **'Return products to a supplier'**
  String get purchaseReturnDescription;

  /// No description provided for @saleInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale Invoice'**
  String get saleInvoiceLabel;

  /// No description provided for @purchaseInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get purchaseInvoiceLabel;

  /// No description provided for @salesReturnLabel.
  ///
  /// In en, this message translates to:
  /// **'Sales Return'**
  String get salesReturnLabel;

  /// No description provided for @purchaseReturnLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Return'**
  String get purchaseReturnLabel;

  /// No description provided for @priceQuoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Quote'**
  String get priceQuoteLabel;

  /// No description provided for @purchaseOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order'**
  String get purchaseOrderLabel;

  /// No description provided for @customerOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Order'**
  String get customerOrderLabel;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get transactionDate;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @cashCustomerFallback.
  ///
  /// In en, this message translates to:
  /// **'Cash Customer'**
  String get cashCustomerFallback;

  /// No description provided for @invoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Invoice No: #{id}'**
  String invoiceNo(Object id);

  /// No description provided for @totalAmountWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount} SAR'**
  String totalAmountWithCurrency(Object amount);

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer: {customer}'**
  String customerNameLabel(Object customer);

  /// No description provided for @thankYouForShopping.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with us!'**
  String get thankYouForShopping;

  /// No description provided for @supplierStatement.
  ///
  /// In en, this message translates to:
  /// **'Supplier Statement'**
  String get supplierStatement;

  /// No description provided for @todaySalesKpi.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaySalesKpi;

  /// No description provided for @todayPurchasesKpi.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Purchases'**
  String get todayPurchasesKpi;

  /// No description provided for @freshCustomers.
  ///
  /// In en, this message translates to:
  /// **'New Customers'**
  String get freshCustomers;

  /// No description provided for @itemsSold.
  ///
  /// In en, this message translates to:
  /// **'Products Sold'**
  String get itemsSold;

  /// No description provided for @selectCustomerField.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get selectCustomerField;

  /// No description provided for @selectSupplierField.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get selectSupplierField;

  /// No description provided for @dateField.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateField;

  /// No description provided for @notesField.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesField;

  /// No description provided for @amountField.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountField;

  /// No description provided for @paymentMethodField.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodField;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @accessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you do not have permission to access this page.'**
  String get accessDeniedMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noTransactionsToPrint.
  ///
  /// In en, this message translates to:
  /// **'No transactions to print'**
  String get noTransactionsToPrint;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// No description provided for @noFinancialMovements.
  ///
  /// In en, this message translates to:
  /// **'No financial movements for this customer'**
  String get noFinancialMovements;

  /// No description provided for @statementLabel.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statementLabel;

  /// No description provided for @payInvoicesFor.
  ///
  /// In en, this message translates to:
  /// **'Pay Invoices for {name}'**
  String payInvoicesFor(Object name);

  /// No description provided for @selectAtLeastOneInvoice.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one invoice'**
  String get selectAtLeastOneInvoice;

  /// No description provided for @invoiceHash.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{id}'**
  String invoiceHash(Object id);

  /// No description provided for @amountPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaidLabel;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @pendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingOrders;

  /// No description provided for @stockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Stock Alerts'**
  String get stockAlerts;

  /// No description provided for @creditExceeded.
  ///
  /// In en, this message translates to:
  /// **'Credit Exceeded'**
  String get creditExceeded;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @topSellingToday.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Today'**
  String get topSellingToday;

  /// No description provided for @qtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty}'**
  String qtyLabel(Object qty);

  /// No description provided for @remainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String remainingLabel(Object amount);

  /// No description provided for @productCategories.
  ///
  /// In en, this message translates to:
  /// **'Product Categories'**
  String get productCategories;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(Object error);

  /// No description provided for @cashBalance.
  ///
  /// In en, this message translates to:
  /// **'Cash Balance'**
  String get cashBalance;

  /// No description provided for @lowStockSupply.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStockSupply;

  /// No description provided for @newOperationDesc.
  ///
  /// In en, this message translates to:
  /// **'Sale, Purchase, Return, Voucher, or any other operation'**
  String get newOperationDesc;

  /// No description provided for @quickOperations.
  ///
  /// In en, this message translates to:
  /// **'Quick Operations'**
  String get quickOperations;

  /// No description provided for @buyAction.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyAction;

  /// No description provided for @customerAction.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerAction;

  /// No description provided for @productAction.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productAction;

  /// No description provided for @supplierAction.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplierAction;

  /// No description provided for @reportAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportAction;

  /// No description provided for @mainSections.
  ///
  /// In en, this message translates to:
  /// **'Main Sections'**
  String get mainSections;

  /// No description provided for @operationsSection.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operationsSection;

  /// No description provided for @accountingSection.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get accountingSection;

  /// No description provided for @partiesSection.
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get partiesSection;

  /// No description provided for @adminSection.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminSection;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @menuLabel.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuLabel;

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

  /// No description provided for @attentionCenter.
  ///
  /// In en, this message translates to:
  /// **'Attention Center'**
  String get attentionCenter;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts currently'**
  String get noAlerts;

  /// No description provided for @timelineLabel.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineLabel;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No operations yet'**
  String get timelineEmpty;

  /// No description provided for @allocateAmountToInvoices.
  ///
  /// In en, this message translates to:
  /// **'Allocate Amount to Invoices'**
  String get allocateAmountToInvoices;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated: {amount}'**
  String allocated(Object amount);

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @approvalWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Approval Workflow'**
  String get approvalWorkflow;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get assetName;

  /// No description provided for @assetsAndLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Assets: {assets} | Liabilities: {liabilities}'**
  String assetsAndLiabilities(Object assets, Object liabilities);

  /// No description provided for @autoAllocateOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Auto-Allocate (Oldest First)'**
  String get autoAllocateOldestFirst;

  /// No description provided for @byUser.
  ///
  /// In en, this message translates to:
  /// **'by {user}'**
  String byUser(Object user);

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @calculateNewZakat.
  ///
  /// In en, this message translates to:
  /// **'Calculate New Zakat'**
  String get calculateNewZakat;

  /// No description provided for @calculateZakat.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get calculateZakat;

  /// No description provided for @calculationType.
  ///
  /// In en, this message translates to:
  /// **'Calculation Type'**
  String get calculationType;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @closeDate.
  ///
  /// In en, this message translates to:
  /// **'Close Date: {date}'**
  String closeDate(Object date);

  /// No description provided for @closeFailed.
  ///
  /// In en, this message translates to:
  /// **'Close failed: {error}'**
  String closeFailed(Object error);

  /// No description provided for @closeYearDescription.
  ///
  /// In en, this message translates to:
  /// **'All revenue and expense balances will be transferred to retained earnings, and temporary accounts will be zeroed for the new year.'**
  String get closeYearDescription;

  /// No description provided for @commissions.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get commissions;

  /// No description provided for @confirmClose.
  ///
  /// In en, this message translates to:
  /// **'Confirm Close'**
  String get confirmClose;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @confirmPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to record payment for this tax?'**
  String get confirmPaymentMessage;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @createRevaluationEntry.
  ///
  /// In en, this message translates to:
  /// **'Create Revaluation Entry'**
  String get createRevaluationEntry;

  /// No description provided for @demoRequest.
  ///
  /// In en, this message translates to:
  /// **'Demo Request'**
  String get demoRequest;

  /// No description provided for @demoRequestNote.
  ///
  /// In en, this message translates to:
  /// **'Demo request to activate the approval workflow until it is linked to purchase forms.'**
  String get demoRequestNote;

  /// No description provided for @dividends.
  ///
  /// In en, this message translates to:
  /// **'Dividends'**
  String get dividends;

  /// No description provided for @dividendsInterest.
  ///
  /// In en, this message translates to:
  /// **'Dividends / Interest'**
  String get dividendsInterest;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get editAsset;

  /// No description provided for @enterReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter reference number'**
  String get enterReferenceNumber;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'Entries ({count})'**
  String entriesCount(Object count);

  /// No description provided for @entryCount.
  ///
  /// In en, this message translates to:
  /// **'Entry Count'**
  String get entryCount;

  /// No description provided for @errorLoadingApprovalRequests.
  ///
  /// In en, this message translates to:
  /// **'Error loading approval requests: {error}'**
  String errorLoadingApprovalRequests(Object error);

  /// No description provided for @failedToAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Failed to add asset: {error}'**
  String failedToAddAsset(Object error);

  /// No description provided for @failedToCalculateDepreciation.
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate depreciation: {error}'**
  String failedToCalculateDepreciation(Object error);

  /// No description provided for @failedToLoadAssets.
  ///
  /// In en, this message translates to:
  /// **'Failed to load assets: {error}'**
  String failedToLoadAssets(Object error);

  /// No description provided for @failedToUpdateAsset.
  ///
  /// In en, this message translates to:
  /// **'Failed to update asset: {error}'**
  String failedToUpdateAsset(Object error);

  /// No description provided for @failedToUpdateRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to update approval request: {error}'**
  String failedToUpdateRequest(Object error);

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @fileTax.
  ///
  /// In en, this message translates to:
  /// **'File Tax'**
  String get fileTax;

  /// No description provided for @filed.
  ///
  /// In en, this message translates to:
  /// **'Filed'**
  String get filed;

  /// No description provided for @grossAmount.
  ///
  /// In en, this message translates to:
  /// **'Gross Amount'**
  String get grossAmount;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @invoiceAlreadyApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved Invoice: Cannot Edit'**
  String get invoiceAlreadyApproved;

  /// No description provided for @invoiceApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'This invoice has been approved. Would you like to make a correction?'**
  String get invoiceApprovedMessage;

  /// No description provided for @invoiceWithId.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{id}'**
  String invoiceWithId(Object id);

  /// No description provided for @largePurchaseRequest.
  ///
  /// In en, this message translates to:
  /// **'Large Purchase Request'**
  String get largePurchaseRequest;

  /// No description provided for @manualJournalEntryAudit.
  ///
  /// In en, this message translates to:
  /// **'Manual entry: {description}, Total: {total}'**
  String manualJournalEntryAudit(Object description, Object total);

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @netAmount.
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get netAmount;

  /// No description provided for @newAsset.
  ///
  /// In en, this message translates to:
  /// **'New Asset'**
  String get newAsset;

  /// No description provided for @noApprovalRequests.
  ///
  /// In en, this message translates to:
  /// **'No approval requests at this time'**
  String get noApprovalRequests;

  /// No description provided for @noOutstandingInvoices.
  ///
  /// In en, this message translates to:
  /// **'No outstanding invoices for this customer.'**
  String get noOutstandingInvoices;

  /// No description provided for @noTaxEntriesInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No tax entries in this period'**
  String get noTaxEntriesInPeriod;

  /// No description provided for @noZakatCalculations.
  ///
  /// In en, this message translates to:
  /// **'No zakat calculations'**
  String get noZakatCalculations;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @paidZakat.
  ///
  /// In en, this message translates to:
  /// **'Paid Zakat'**
  String get paidZakat;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment: {paymentId}'**
  String paymentLabel(Object paymentId);

  /// No description provided for @pendingZakat.
  ///
  /// In en, this message translates to:
  /// **'Pending Zakat'**
  String get pendingZakat;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Period (Year)'**
  String get periodYear;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @purchaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date: {date}'**
  String purchaseDateLabel(Object date);

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @remainingToAllocate.
  ///
  /// In en, this message translates to:
  /// **'Remaining to allocate: {amount}'**
  String remainingToAllocate(Object amount);

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @revaluationReason.
  ///
  /// In en, this message translates to:
  /// **'Payment revaluation'**
  String get revaluationReason;

  /// No description provided for @requestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved'**
  String get requestApproved;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get requestRejected;

  /// No description provided for @royalties.
  ///
  /// In en, this message translates to:
  /// **'Royalties'**
  String get royalties;

  /// No description provided for @royaltiesServices.
  ///
  /// In en, this message translates to:
  /// **'Royalties / Services'**
  String get royaltiesServices;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @serviceFees.
  ///
  /// In en, this message translates to:
  /// **'Service Fees'**
  String get serviceFees;

  /// No description provided for @statusWithValue.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusWithValue(Object status);

  /// No description provided for @taxFiledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tax filed successfully'**
  String get taxFiledSuccessfully;

  /// No description provided for @taxWithRate.
  ///
  /// In en, this message translates to:
  /// **'Tax ({rate}%)'**
  String taxWithRate(Object rate);

  /// No description provided for @technicalFees.
  ///
  /// In en, this message translates to:
  /// **'Technical Fees'**
  String get technicalFees;

  /// No description provided for @technicalFeesCommissionsRent.
  ///
  /// In en, this message translates to:
  /// **'Technical Fees / Commissions / Rent'**
  String get technicalFeesCommissionsRent;

  /// No description provided for @totalAndBalance.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} | Remaining: {balance}'**
  String totalAndBalance(Object balance, Object total);

  /// No description provided for @totalZakat.
  ///
  /// In en, this message translates to:
  /// **'Total Zakat'**
  String get totalZakat;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @unbalancedEntryError.
  ///
  /// In en, this message translates to:
  /// **'Entry is not balanced. Debit: {debit}, Credit: {credit}'**
  String unbalancedEntryError(Object credit, Object debit);

  /// No description provided for @unifiedStatement.
  ///
  /// In en, this message translates to:
  /// **'Unified Statement'**
  String get unifiedStatement;

  /// No description provided for @usefulLifeYears.
  ///
  /// In en, this message translates to:
  /// **'Useful Life (Years)'**
  String get usefulLifeYears;

  /// No description provided for @withholdingTax.
  ///
  /// In en, this message translates to:
  /// **'Withholding Tax'**
  String get withholdingTax;

  /// No description provided for @withholdingTaxRates.
  ///
  /// In en, this message translates to:
  /// **'Withholding Tax Rates'**
  String get withholdingTaxRates;

  /// No description provided for @withholdingTaxSummary.
  ///
  /// In en, this message translates to:
  /// **'Withholding Tax Summary'**
  String get withholdingTaxSummary;

  /// No description provided for @yearClosedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Financial year closed successfully'**
  String get yearClosedSuccessfully;

  /// No description provided for @zakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakat;

  /// No description provided for @zakatAmount.
  ///
  /// In en, this message translates to:
  /// **'Zakat: {amount}'**
  String zakatAmount(Object amount);

  /// No description provided for @zakatCalculatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Zakat calculated successfully'**
  String get zakatCalculatedSuccessfully;

  /// No description provided for @zakatFiledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Zakat filed successfully'**
  String get zakatFiledSuccessfully;

  /// No description provided for @zakatPaidSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Zakat paid successfully'**
  String get zakatPaidSuccessfully;

  /// No description provided for @serialNumbers.
  ///
  /// In en, this message translates to:
  /// **'Serial Numbers'**
  String get serialNumbers;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noSerialNumbers.
  ///
  /// In en, this message translates to:
  /// **'No serial numbers'**
  String get noSerialNumbers;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @soldStatus.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get soldStatus;

  /// No description provided for @reservedStatus.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reservedStatus;

  /// No description provided for @returnedStatus.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returnedStatus;

  /// No description provided for @productWithName.
  ///
  /// In en, this message translates to:
  /// **'Product: {name}'**
  String productWithName(Object name);

  /// No description provided for @warehouseWithName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse: {name}'**
  String warehouseWithName(Object name);

  /// No description provided for @batchWithName.
  ///
  /// In en, this message translates to:
  /// **'Batch: {name}'**
  String batchWithName(Object name);

  /// No description provided for @receivedDateWithDate.
  ///
  /// In en, this message translates to:
  /// **'Received Date: {date}'**
  String receivedDateWithDate(Object date);

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @restock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// No description provided for @addSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Add Serial Number'**
  String get addSerialNumber;

  /// No description provided for @serialNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumberLabel;

  /// No description provided for @serialNumberAdded.
  ///
  /// In en, this message translates to:
  /// **'Serial number added successfully'**
  String get serialNumberAdded;

  /// No description provided for @bulkRegister.
  ///
  /// In en, this message translates to:
  /// **'Add Multiple Serial Numbers'**
  String get bulkRegister;

  /// No description provided for @serialNumbersOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'Serial numbers (one per line)'**
  String get serialNumbersOnePerLine;

  /// No description provided for @registerAll.
  ///
  /// In en, this message translates to:
  /// **'Register All'**
  String get registerAll;

  /// No description provided for @enterAtLeastOneSerial.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one serial number'**
  String get enterAtLeastOneSerial;

  /// No description provided for @serialBulkRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered {count} of {total} serial numbers'**
  String serialBulkRegistered(Object count, Object total);

  /// No description provided for @reserveSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Reserve Serial Number'**
  String get reserveSerialNumber;

  /// No description provided for @salesOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Sales Order Number'**
  String get salesOrderNumber;

  /// No description provided for @enterSalesOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the sales order number'**
  String get enterSalesOrderNumber;

  /// No description provided for @serialReserved.
  ///
  /// In en, this message translates to:
  /// **'Serial number reserved'**
  String get serialReserved;

  /// No description provided for @registerSerialSale.
  ///
  /// In en, this message translates to:
  /// **'Register Serial Sale'**
  String get registerSerialSale;

  /// No description provided for @saleNumber.
  ///
  /// In en, this message translates to:
  /// **'Sale Number'**
  String get saleNumber;

  /// No description provided for @enterSaleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the sale number'**
  String get enterSaleNumber;

  /// No description provided for @saleRegistered.
  ///
  /// In en, this message translates to:
  /// **'Sale registered successfully'**
  String get saleRegistered;

  /// No description provided for @registerSale.
  ///
  /// In en, this message translates to:
  /// **'Register Sale'**
  String get registerSale;

  /// No description provided for @confirmReturn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Return'**
  String get confirmReturn;

  /// No description provided for @confirmReturnMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark serial number \"{serialNumber}\" as returned?'**
  String confirmReturnMessage(Object serialNumber);

  /// No description provided for @returnRegistered.
  ///
  /// In en, this message translates to:
  /// **'Return registered successfully'**
  String get returnRegistered;

  /// No description provided for @serialNumberHistory.
  ///
  /// In en, this message translates to:
  /// **'Serial Number History'**
  String get serialNumberHistory;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @shiftReport.
  ///
  /// In en, this message translates to:
  /// **'Shift Report'**
  String get shiftReport;

  /// No description provided for @noShiftsYet.
  ///
  /// In en, this message translates to:
  /// **'No shifts yet'**
  String get noShiftsYet;

  /// No description provided for @openStatus.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openStatus;

  /// No description provided for @closedStatus.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedStatus;

  /// No description provided for @userWithId.
  ///
  /// In en, this message translates to:
  /// **'User: {userId}'**
  String userWithId(Object userId);

  /// No description provided for @openingCashAmount.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash: {amount}'**
  String openingCashAmount(Object amount);

  /// No description provided for @closingCashAmount.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash: {amount}'**
  String closingCashAmount(Object amount);

  /// No description provided for @noteWithText.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteWithText(Object note);

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @shiftStart.
  ///
  /// In en, this message translates to:
  /// **'Shift Start'**
  String get shiftStart;

  /// No description provided for @shiftEnd.
  ///
  /// In en, this message translates to:
  /// **'Shift End'**
  String get shiftEnd;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @expectedCashAmount.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash: {amount}'**
  String expectedCashAmount(Object amount);

  /// No description provided for @differenceAmount.
  ///
  /// In en, this message translates to:
  /// **'Difference: {amount}'**
  String differenceAmount(Object amount);

  /// No description provided for @cashTotal.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashTotal;

  /// No description provided for @cardTotal.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get cardTotal;

  /// No description provided for @shiftNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {note}'**
  String shiftNotes(Object note);

  /// No description provided for @stockTakeTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Take'**
  String get stockTakeTitle;

  /// No description provided for @selectWarehouseToStart.
  ///
  /// In en, this message translates to:
  /// **'Please select a warehouse to start stock take'**
  String get selectWarehouseToStart;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @targetWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Target Warehouse'**
  String get targetWarehouse;

  /// No description provided for @startStockTakeSession.
  ///
  /// In en, this message translates to:
  /// **'Start New Stock Take Session'**
  String get startStockTakeSession;

  /// No description provided for @noItemsInSession.
  ///
  /// In en, this message translates to:
  /// **'No items in this session yet'**
  String get noItemsInSession;

  /// No description provided for @expectedSystem.
  ///
  /// In en, this message translates to:
  /// **'Expected (System)'**
  String get expectedSystem;

  /// No description provided for @actualQtyDiscovered.
  ///
  /// In en, this message translates to:
  /// **'Actual Quantity Discovered'**
  String get actualQtyDiscovered;

  /// No description provided for @varianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get varianceLabel;

  /// No description provided for @finalNotes.
  ///
  /// In en, this message translates to:
  /// **'Final Stock Take Notes'**
  String get finalNotes;

  /// No description provided for @approveAndCloseStockTake.
  ///
  /// In en, this message translates to:
  /// **'Approve and Close Stock Take'**
  String get approveAndCloseStockTake;

  /// No description provided for @stockTakeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Stock take completed, inventory and accounting entries updated successfully'**
  String get stockTakeCompleted;

  /// No description provided for @stockTakeError.
  ///
  /// In en, this message translates to:
  /// **'Error completing stock take: {error}'**
  String stockTakeError(Object error);

  /// No description provided for @addProductToStockTake.
  ///
  /// In en, this message translates to:
  /// **'Add Product to Stock Take'**
  String get addProductToStockTake;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get searchProduct;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @qtyOfProduct.
  ///
  /// In en, this message translates to:
  /// **'Quantity of {name}'**
  String qtyOfProduct(Object name);

  /// No description provided for @actualQtyNow.
  ///
  /// In en, this message translates to:
  /// **'Current Actual Quantity'**
  String get actualQtyNow;

  /// No description provided for @addToStockTake.
  ///
  /// In en, this message translates to:
  /// **'Add to Stock Take'**
  String get addToStockTake;

  /// No description provided for @warehouseManagement.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Management'**
  String get warehouseManagement;

  /// No description provided for @noWarehousesAdded.
  ///
  /// In en, this message translates to:
  /// **'No warehouses added'**
  String get noWarehousesAdded;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get noLocation;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @addNewWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Add New Warehouse'**
  String get addNewWarehouse;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @warehouseNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Warehouse name is required'**
  String get warehouseNameRequired;

  /// No description provided for @warehouseCreated.
  ///
  /// In en, this message translates to:
  /// **'Warehouse created successfully'**
  String get warehouseCreated;

  /// No description provided for @warehouseCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create warehouse: {error}'**
  String warehouseCreateFailed(Object error);

  /// No description provided for @editWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Edit Warehouse'**
  String get editWarehouse;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @warehouseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Warehouse updated successfully'**
  String get warehouseUpdated;

  /// No description provided for @warehouseUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update warehouse: {error}'**
  String warehouseUpdateFailed(Object error);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this warehouse?'**
  String get confirmDeleteWarehouse;

  /// No description provided for @warehouseDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete warehouse: {error}'**
  String warehouseDeleteFailed(Object error);

  /// No description provided for @cannotDeleteWarehouseWithStock.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete warehouse because it contains stock.'**
  String get cannotDeleteWarehouseWithStock;

  /// No description provided for @warehouseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Warehouse deleted successfully'**
  String get warehouseDeleted;

  /// No description provided for @warehouseManager.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Manager'**
  String get warehouseManager;

  /// No description provided for @codeJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Code: {code} | Job: {jobTitle}'**
  String codeJobTitle(Object code, Object jobTitle);

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not Specified'**
  String get notSpecified;

  /// No description provided for @editPurchaseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Edit Purchase Invoice'**
  String get editPurchaseInvoice;

  /// No description provided for @purchaseInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get purchaseInvoiceTitle;

  /// No description provided for @periodClosedMessage.
  ///
  /// In en, this message translates to:
  /// **'The accounting period is closed. Invoices cannot be posted until a new period is opened.'**
  String get periodClosedMessage;

  /// No description provided for @lockedInvoiceMessage.
  ///
  /// In en, this message translates to:
  /// **'This invoice is not a draft, so it cannot be edited directly. Use a correction document or return instead.'**
  String get lockedInvoiceMessage;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @representativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get representativeLabel;

  /// No description provided for @generalRepresentative.
  ///
  /// In en, this message translates to:
  /// **'General Representative'**
  String get generalRepresentative;

  /// No description provided for @selectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select Product'**
  String get selectProduct;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @taxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get taxLabel;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @shippingLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shippingLabel;

  /// No description provided for @otherExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other Expenses'**
  String get otherExpensesLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @needTaxPermission.
  ///
  /// In en, this message translates to:
  /// **'You need tax edit permission'**
  String get needTaxPermission;

  /// No description provided for @addExistingItem.
  ///
  /// In en, this message translates to:
  /// **'Add Existing Item'**
  String get addExistingItem;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @cannotEditNonDraftItems.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit items of a non-draft purchase invoice'**
  String get cannotEditNonDraftItems;

  /// No description provided for @fixFinancialFields.
  ///
  /// In en, this message translates to:
  /// **'Please fix the financial fields before saving'**
  String get fixFinancialFields;

  /// No description provided for @noTaxPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to edit tax'**
  String get noTaxPermission;

  /// No description provided for @pleaseSelectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Please select a supplier'**
  String get pleaseSelectSupplier;

  /// No description provided for @pleaseSelectWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Please select a warehouse'**
  String get pleaseSelectWarehouse;

  /// No description provided for @pleaseAddItems.
  ///
  /// In en, this message translates to:
  /// **'Please add items'**
  String get pleaseAddItems;

  /// No description provided for @quantityMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than zero'**
  String get quantityMustBeGreaterThanZero;

  /// No description provided for @priceMustBeNonNegative.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than or equal to zero'**
  String get priceMustBeNonNegative;

  /// No description provided for @cannotEditNonDraftInvoice.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit a non-draft purchase invoice. Use a correction document or return instead.'**
  String get cannotEditNonDraftInvoice;

  /// No description provided for @newPurchaseInvoiceValue.
  ///
  /// In en, this message translates to:
  /// **'New purchase invoice worth {amount}'**
  String newPurchaseInvoiceValue(Object amount);

  /// No description provided for @invoiceModifiedValue.
  ///
  /// In en, this message translates to:
  /// **'Invoice modified to {amount}'**
  String invoiceModifiedValue(Object amount);

  /// No description provided for @invoicePosted.
  ///
  /// In en, this message translates to:
  /// **'Invoice posted'**
  String get invoicePosted;

  /// No description provided for @purchaseSavedAndPosted.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved, posted, and inventory updated successfully'**
  String get purchaseSavedAndPosted;

  /// No description provided for @invoiceModifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice modified successfully'**
  String get invoiceModifiedSuccessfully;

  /// No description provided for @draftSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Draft saved successfully'**
  String get draftSavedSuccessfully;

  /// No description provided for @errorSavingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Error saving invoice: {error}'**
  String errorSavingInvoice(Object error);

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while saving.'**
  String get unexpectedError;

  /// No description provided for @foreignKeyError.
  ///
  /// In en, this message translates to:
  /// **'Link error: please verify the selected data (warehouse, supplier, or items).'**
  String get foreignKeyError;

  /// No description provided for @uniqueConstraintError.
  ///
  /// In en, this message translates to:
  /// **'Duplicate error: invoice number or other data already exists.'**
  String get uniqueConstraintError;

  /// No description provided for @periodClosedCannotPost.
  ///
  /// In en, this message translates to:
  /// **'The accounting period is closed. Cannot post.'**
  String get periodClosedCannotPost;

  /// No description provided for @purchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get purchaseOrders;

  /// No description provided for @noPurchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders'**
  String get noPurchaseOrders;

  /// No description provided for @purchaseOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order: {number}'**
  String purchaseOrderTitle(Object number);

  /// No description provided for @supplierStatus.
  ///
  /// In en, this message translates to:
  /// **'Supplier: {name} | Status: {status}'**
  String supplierStatus(Object name, Object status);

  /// No description provided for @confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmTitle;

  /// No description provided for @convertOrderToInvoice.
  ///
  /// In en, this message translates to:
  /// **'Convert purchase order {number} to invoice?'**
  String convertOrderToInvoice(Object number);

  /// No description provided for @convert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convert;

  /// No description provided for @conversionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Conversion successful'**
  String get conversionSuccess;

  /// No description provided for @generateAutoOrders.
  ///
  /// In en, this message translates to:
  /// **'Generate Auto Purchase Orders'**
  String get generateAutoOrders;

  /// No description provided for @ordersGenerated.
  ///
  /// In en, this message translates to:
  /// **'Purchase orders generated successfully'**
  String get ordersGenerated;

  /// No description provided for @supplierPerformance.
  ///
  /// In en, this message translates to:
  /// **'Supplier Performance Report'**
  String get supplierPerformance;

  /// No description provided for @invoiceCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoices: {count}'**
  String invoiceCountLabel(Object count);

  /// No description provided for @totalPurchasesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String totalPurchasesLabel(Object amount);

  /// No description provided for @averageInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Invoice: {amount}'**
  String averageInvoiceLabel(Object amount);

  /// No description provided for @priceQuotes.
  ///
  /// In en, this message translates to:
  /// **'Price Quotes'**
  String get priceQuotes;

  /// No description provided for @noPriceQuotes.
  ///
  /// In en, this message translates to:
  /// **'No price quotes'**
  String get noPriceQuotes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
