import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Accounting App';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get pos => 'POS';

  @override
  String get products => 'Products';

  @override
  String get categories => 'Categories';

  @override
  String get customers => 'Customers';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get purchases => 'Purchases';

  @override
  String get returns => 'Returns';

  @override
  String get reports => 'Reports';

  @override
  String get sales => 'Sales History';

  @override
  String get logout => 'Logout';

  @override
  String get backupDb => 'Backup DB';

  @override
  String get welcome => 'Welcome';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get accountingSystem => 'Accounting System';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get loginHint => 'Enter your registered user credentials';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get seedProducts => 'Seed Products';

  @override
  String get viewSales => 'View Sales';

  @override
  String get overview => 'Overview';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get todaySales => 'Today\'s Sales';

  @override
  String get revenue => 'Revenue';

  @override
  String get pendingSync => 'Pending Sync';

  @override
  String get seedDataAdded => 'Seed data added!';

  @override
  String get wholesale => 'Wholesale';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get cartEmpty => 'Cart is empty';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get proceedToCheckout => 'PROCEED TO CHECKOUT';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get selectCustomer => 'Select Customer (Optional)';

  @override
  String get cashPayment => 'Cash Payment';

  @override
  String get creditSale => 'Credit Sale';

  @override
  String get selectCustomerError => 'Please select a customer for credit sale';

  @override
  String get customerNameHint => 'Start typing to search or add new customer';

  @override
  String get addCustomerForCredit => 'Add New Customer for Credit Sale';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get skuLabel => 'SKU';

  @override
  String get stockLabel => 'Stock';

  @override
  String get stock => 'Stock';

  @override
  String get category => 'Category';

  @override
  String get price => 'Price';

  @override
  String get productAdded => 'Product added successfully';

  @override
  String get productUpdated => 'Product updated successfully';

  @override
  String get searchCustomers => 'Search customers...';

  @override
  String get noCustomersFound => 'No customers found';

  @override
  String get noPhone => 'No phone';

  @override
  String balanceLabel(Object balance) {
    return 'Bal: $balance';
  }

  @override
  String limitLabel(Object limit) {
    return 'Limit: $limit';
  }

  @override
  String get customerAdded => 'Customer added successfully';

  @override
  String get customerUpdated => 'Customer updated successfully';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get customerName => 'Customer Name';

  @override
  String get enterNameError => 'Please enter a name';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get creditLimitLabel => 'Credit Limit';

  @override
  String get totalCustomers => 'Total Customers';

  @override
  String get searchSuppliers => 'Search suppliers...';

  @override
  String get noSuppliersFound => 'No suppliers found';

  @override
  String get noContactPerson => 'No contact person';

  @override
  String get supplierAdded => 'Supplier added successfully';

  @override
  String get supplierUpdated => 'Supplier updated successfully';

  @override
  String get addSupplier => 'Add Supplier';

  @override
  String get editSupplier => 'Edit Supplier';

  @override
  String get supplierName => 'Supplier Name';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get purchasesHistory => 'Purchases History';

  @override
  String get noPurchases => 'No purchases recorded yet.';

  @override
  String invoiceLabel(Object invoice) {
    return 'Invoice: $invoice';
  }

  @override
  String supplierLabel(Object supplier) {
    return 'Supplier: $supplier';
  }

  @override
  String dateLabel(Object date) {
    return 'Date: $date';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get newPurchase => 'New Purchase';

  @override
  String get purchaseDetails => 'Purchase Details';

  @override
  String get loading => 'Loading...';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get newPurchaseInvoice => 'New Purchase Invoice';

  @override
  String get selectSupplier => 'Select Supplier';

  @override
  String get invoiceNumberLabel => 'Invoice Number';

  @override
  String get noProductsAdded => 'No products added yet.';

  @override
  String qtyAtPrice(Object price, Object qty) {
    return 'Qty: $qty @ $price';
  }

  @override
  String get savePurchase => 'SAVE PURCHASE';

  @override
  String get purchaseSaved => 'Purchase saved successfully!';

  @override
  String get addProductToPurchase => 'Add Product to Purchase';

  @override
  String get productLabel => 'Product';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get buyPriceLabel => 'Buy Price';

  @override
  String get noSalesFound => 'No sales found';

  @override
  String saleIdLabel(Object id) {
    return 'Sale #$id';
  }

  @override
  String get synced => 'Synced';

  @override
  String get pending => 'Pending';

  @override
  String get saleDetails => 'Sale Details';

  @override
  String get newSale => 'New Sale';

  @override
  String get returnsManagement => 'Returns Management';

  @override
  String get salesReturns => 'Sales Returns';

  @override
  String get purchaseReturns => 'Purchase Returns';

  @override
  String get newReturn => 'New Return';

  @override
  String get noReturnsFound => 'No returns found.';

  @override
  String returnIdLabel(Object id) {
    return 'Return ID: $id';
  }

  @override
  String amountReturnedLabel(Object amount) {
    return 'Amount: $amount';
  }

  @override
  String get createReturn => 'Create Return';

  @override
  String get fromSale => 'From a Sale';

  @override
  String get fromPurchase => 'From a Purchase';

  @override
  String txLabel(Object id) {
    return 'Tx: $id';
  }

  @override
  String get financialReports => 'Financial Reports';

  @override
  String get totalProfitLoss => 'Total Profit/Loss';

  @override
  String get totalSalesRevenue => 'Total Sales (Revenue)';

  @override
  String get totalPurchasesExpenses => 'Total Purchases (Expenses)';

  @override
  String get grossProfit => 'Gross Profit';

  @override
  String get outstandingBalances => 'Outstanding Balances';

  @override
  String get customerDebts => 'Customer Debts';

  @override
  String get supplierDebts => 'Supplier Debts';

  @override
  String get inventoryValue => 'Inventory Value';

  @override
  String get totalStockValue => 'Total Stock Value (at Buy Price)';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productNameLabel => 'Product Name';

  @override
  String get skuBarcodeLabel => 'SKU/Barcode';

  @override
  String get enterSkuError => 'Please enter an SKU';

  @override
  String get categoryLabel => 'Category';

  @override
  String get sellPriceLabel => 'Sell Price';

  @override
  String get initialStockLabel => 'Initial Stock';

  @override
  String get payAmount => 'Pay Amount';

  @override
  String get paymentAmount => 'Payment Amount';

  @override
  String get paymentSuccess => 'Payment recorded successfully';

  @override
  String get enterAmountError => 'Please enter a valid amount';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get inventoryReports => 'Inventory Reports';

  @override
  String get lowStockProducts => 'Low Stock Products';

  @override
  String get noLowStockProducts => 'No products with low stock.';

  @override
  String get productName => 'Product Name';

  @override
  String get alertLimit => 'Alert Limit';

  @override
  String get viewDetails => 'View Details';

  @override
  String get lowStockItems => 'items with low stock';

  @override
  String get noLowStockItems => 'No low stock items';

  @override
  String get stockLevel => 'Stock Level';

  @override
  String get items => 'Items';

  @override
  String get searchByInvoiceId => 'Search by Invoice ID';

  @override
  String get invoiceNotFound => 'Invoice not found';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get categoryCode => 'Category Code';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get all => 'All';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryAdded => 'Category added successfully';

  @override
  String get categoryUpdated => 'Category updated successfully';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get sku => 'SKU';

  @override
  String get enterSku => 'Enter SKU';

  @override
  String get buyPrice => 'Buy Price';

  @override
  String get sellPrice => 'Sell Price';

  @override
  String get wholesalePrice => 'Wholesale Price';

  @override
  String get costCenters => 'Cost Centers';

  @override
  String get addCostCenter => 'Add Cost Center';

  @override
  String get code => 'Code';

  @override
  String get noCostCentersFound => 'No cost centers found';

  @override
  String get accounting => 'Accounting';

  @override
  String get chartOfAccounts => 'Chart of Accounts';

  @override
  String get generalLedger => 'General Ledger';

  @override
  String get trialBalance => 'Trial Balance';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountCode => 'Account Code';

  @override
  String get accountType => 'Account Type';

  @override
  String get balance => 'Balance';

  @override
  String get debit => 'Debit';

  @override
  String get credit => 'Credit';

  @override
  String get asset => 'Asset';

  @override
  String get liability => 'Liability';

  @override
  String get equity => 'Equity';

  @override
  String get expense => 'Expense';

  @override
  String get addAccount => 'Add Account';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get isHeader => 'Is Header?';

  @override
  String get parentAccount => 'Parent Account';

  @override
  String get balanceSheet => 'Balance Sheet';

  @override
  String get incomeStatement => 'Income Statement';

  @override
  String get expenses => 'Expenses';

  @override
  String get inventoryAudit => 'Inventory Audit';

  @override
  String get userRoles => 'User Roles';

  @override
  String get thermalPrinting => 'Thermal Printing';

  @override
  String get printReceipt => 'Print Receipt';

  @override
  String get fixedAssets => 'Fixed Assets';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get totalAssets => 'Total Assets';

  @override
  String get totalLiabilities => 'Total Liabilities';

  @override
  String get totalEquity => 'Total Equity';

  @override
  String get netIncome => 'Net Income';

  @override
  String get operatingExpenses => 'Operating Expenses';

  @override
  String get saveSuccess => 'Saved successfully';

  @override
  String get shiftManagement => 'Shift Management';

  @override
  String get openShift => 'Open Shift';

  @override
  String get closeShift => 'Close Shift';

  @override
  String get openingCash => 'Opening Cash';

  @override
  String get closingCash => 'Closing Cash';

  @override
  String get expectedCash => 'Expected Cash';

  @override
  String get difference => 'Difference';

  @override
  String get shiftOpened => 'Shift opened successfully';

  @override
  String get shiftClosed => 'Shift closed successfully';

  @override
  String get noOpenShift => 'No open shift found';

  @override
  String get currentShift => 'Current Shift';

  @override
  String get manualJournalEntries => 'Manual Journal Entries';

  @override
  String get financialYearClosing => 'Financial Year Closing';

  @override
  String get reconciliation => 'Bank/Cash Reconciliation';

  @override
  String get auditLog => 'Audit Log';

  @override
  String get vatReturn => 'VAT Return Report';

  @override
  String get cashFlow => 'Cash Flow Statement';

  @override
  String get selectAccount => 'Select Account';

  @override
  String get actualBalance => 'Actual Balance';

  @override
  String get bookBalance => 'Book Balance';

  @override
  String get notes => 'Notes';

  @override
  String get reconciliationAdjustment => 'Reconciliation adjustment';

  @override
  String get cashOverShortAccount => 'Cash Over/Short Account';

  @override
  String get selectAccountError => 'Please select an account';

  @override
  String get enterActualBalanceError => 'Please enter the actual balance';

  @override
  String get reconciliationDifference => 'Reconciliation Difference';

  @override
  String get vatOnSales => 'VAT on Sales (Output VAT)';

  @override
  String get vatOnPurchases => 'VAT on Purchases (Input VAT)';

  @override
  String get netVatPayable => 'Net VAT Payable';

  @override
  String get noDataAvailable => 'No data available for the selected period';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get welcomeAdmin => 'Welcome Admin';

  @override
  String get adminDashboardDescription => 'Manage your supermarket operations with ease.';

  @override
  String get manageStaff => 'Manage Staff';

  @override
  String get viewReports => 'View Reports';

  @override
  String get asOf => 'As of';

  @override
  String get balanceSheetBalanced => 'Assets = Liabilities + Equity';

  @override
  String get balanceSheetNotBalanced => 'Balance Sheet is not balanced!';

  @override
  String get operatingActivities => 'Operating Activities';

  @override
  String get netCashFromOperating => 'Net Cash From Operating Activities';

  @override
  String get investingActivities => 'Investing Activities';

  @override
  String get netCashFromInvesting => 'Net Cash From Investing Activities';

  @override
  String get financingActivities => 'Financing Activities';

  @override
  String get netCashFromFinancing => 'Net Cash From Financing Activities';

  @override
  String get netChangeInCash => 'Net Change In Cash';

  @override
  String get beginningCashBalance => 'Beginning Cash Balance';

  @override
  String get endingCashBalance => 'Ending Cash Balance';

  @override
  String get assets => 'Assets';

  @override
  String get liabilities => 'Liabilities';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get days => 'Days';

  @override
  String get noPurchasesFound => 'No Purchases Found';

  @override
  String get walkInSupplier => 'Walk-in Supplier';

  @override
  String get currencySymbol => 'SAR';

  @override
  String get backupAndSync => 'Backup and Sync';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get localBackup => 'Local Backup';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get restoreFromCloud => 'Restore from Cloud';

  @override
  String get noCloudBackups => 'No Cloud Backups';

  @override
  String get restore => 'Restore';

  @override
  String get restoreFromLocalFile => 'Restore from Local File';

  @override
  String get pickBackupFile => 'Pick Backup File';

  @override
  String get confirmRestore => 'Confirm Restore';

  @override
  String get restoreWarning => 'Restoring will overwrite current data. Are you sure?';

  @override
  String get simplifiedTaxInvoice => 'Simplified Tax Invoice';

  @override
  String vatNumber(Object vatNumber) {
    return 'VAT Number: $vatNumber';
  }

  @override
  String invoiceNumber(Object invoiceNumber) {
    return 'Invoice No: $invoiceNumber';
  }

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get date => 'Date';

  @override
  String get supplier => 'Supplier';

  @override
  String get cash => 'Cash';

  @override
  String get sale => 'Sale';

  @override
  String get purchase => 'Purchase';

  @override
  String get purchaseId => 'Purchase ID';

  @override
  String get totalReturnAmount => 'Total Return Amount';

  @override
  String get purchaseNotFound => 'Purchase not found';

  @override
  String get thankYou => 'Thank you for your business!';

  @override
  String get closeFinancialYear => 'Close Financial Year';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get staffManagement => 'Staff Management';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get addUser => 'Add User';

  @override
  String get editUser => 'Edit User';

  @override
  String get deleteUser => 'Delete User';

  @override
  String confirmDeleteUser(Object name) {
    return 'Are you sure you want to delete user $name?';
  }

  @override
  String get leaveEmptyToKeep => 'Leave empty to keep current password';

  @override
  String get role => 'Role/Permission';

  @override
  String get customerStatement => 'Customer Statement';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get payment => 'Payment';

  @override
  String get cart => 'Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get allChangesSynced => 'All changes synced';

  @override
  String unsyncedChanges(Object count) {
    return '$count unsynced changes';
  }

  @override
  String get syncNow => 'Sync Now';

  @override
  String lastSync(Object time) {
    return 'Last Sync: $time';
  }

  @override
  String get name => 'Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get status => 'Status';

  @override
  String get warehouse => 'Warehouse';

  @override
  String get batchNumber => 'Batch Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get draft => 'Draft';

  @override
  String get ordered => 'Ordered';

  @override
  String get received => 'Received';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get selectWarehouse => 'Select Warehouse';

  @override
  String get noWarehousesFound => 'No warehouses found';

  @override
  String get addWarehouse => 'Add Warehouse';

  @override
  String get warehouseName => 'Warehouse Name';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get whatWouldYouLikeToDo => 'What would you like to do?';

  @override
  String get downloadPdfInvoice => 'Download PDF Invoice';

  @override
  String get done => 'Done';

  @override
  String get vatReport => 'VAT Report';

  @override
  String get vatSummary => 'VAT Summary';

  @override
  String get totalOutputVat => 'Total Output VAT';

  @override
  String get totalInputVat => 'Total Input VAT';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get unknownProduct => 'Unknown Product';

  @override
  String get viewInvoice => 'View Invoice';

  @override
  String get confirmDeleteCategory => 'Are you sure you want to delete this category? This will prevent access to associated products.';

  @override
  String get categoryHasProductsError => 'Cannot delete category because it is associated with existing products.';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get customerStatementTooltip => 'Account Statement';

  @override
  String get newPurchaseReturn => 'New Purchase Return';

  @override
  String get selectPurchase => 'Select Purchase';

  @override
  String get selectAPurchaseToContinue => 'Select a purchase to continue';

  @override
  String get processReturn => 'Process Return';

  @override
  String get returnProcessedSuccessfully => 'Return processed successfully';

  @override
  String get noReturnsYet => 'No returns yet';

  @override
  String get newSalesReturn => 'New Sales Return';

  @override
  String get selectSale => 'Select Sale';

  @override
  String get failedToSaveProduct => 'Failed to save product';

  @override
  String get failedToSaveCategory => 'Failed to save category';

  @override
  String get failedToDeleteProduct => 'Failed to delete product';

  @override
  String deleteProductConfirmation(Object productName) {
    return 'Are you sure you want to delete $productName?';
  }

  @override
  String get failedToSavePurchase => 'Failed to save purchase';

  @override
  String get selectASaleToContinue => 'Select a sale to continue';

  @override
  String get unit => 'Unit';

  @override
  String get cartonUnit => 'Carton Unit';

  @override
  String get piecesPerCarton => 'Pieces per Carton';

  @override
  String get baseUnit => 'Base Unit';

  @override
  String get isCarton => 'Is Carton?';

  @override
  String get accountsPayable => 'Accounts Payable';

  @override
  String get apInvoices => 'AP Invoices';

  @override
  String get supplierLedger => 'Supplier Ledger';

  @override
  String get newAPInvoice => 'New AP Invoice';

  @override
  String get invoiceDate => 'Invoice Date';

  @override
  String get dueDate => 'Due Date';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get taxAmount => 'Tax Amount';

  @override
  String get paidAmount => 'Paid Amount';

  @override
  String get apInvoiceAdded => 'AP Invoice added successfully';

  @override
  String get accountsReceivable => 'Accounts Receivable';

  @override
  String get arInvoices => 'AR Invoices';

  @override
  String get customerLedger => 'Customer Ledger';

  @override
  String get newARInvoice => 'New AR Invoice';

  @override
  String get arInvoiceAdded => 'AR Invoice added successfully';

  @override
  String get agingReport => 'Aging Report';

  @override
  String get current => 'Current';

  @override
  String get days30 => '30 Days';

  @override
  String get days60 => '60 Days';

  @override
  String get days90Plus => '90+ Days';

  @override
  String get totalDue => 'Total Due';

  @override
  String get selectType => 'Select Type';

  @override
  String get cashFlowForecast => 'Cash Flow Forecast';

  @override
  String get inflow => 'Cash Inflow (AR)';

  @override
  String get outflow => 'Cash Outflow (AP)';

  @override
  String get netCash => 'Net Cash';

  @override
  String get next30Days => 'Next 30 Days';

  @override
  String get next60Days => 'Next 60 Days';

  @override
  String get next90Days => 'Next 90 Days';

  @override
  String get period => 'Period';

  @override
  String get noItemsSelected => 'No items selected';

  @override
  String get deleteCustomer => 'Delete Customer';

  @override
  String get deleteSupplier => 'Delete Supplier';

  @override
  String confirmDeleteCustomer(Object customerName) {
    return 'Are you sure you want to delete $customerName?';
  }

  @override
  String confirmDeleteSupplier(Object supplierName) {
    return 'Are you sure you want to delete $supplierName?';
  }

  @override
  String get customerDeleted => 'Customer deleted';

  @override
  String get supplierDeleted => 'Supplier deleted';

  @override
  String get failedToDeleteCustomer => 'Failed to delete customer';

  @override
  String get failedToDeleteSupplier => 'Failed to delete supplier';

  @override
  String get manufacturing => 'Manufacturing';

  @override
  String get productionOrders => 'Production Orders';

  @override
  String get bomManagement => 'BOM Management';

  @override
  String get createOrder => 'Create Order';

  @override
  String get plannedQuantity => 'Planned Quantity';

  @override
  String get productionOrderCreated => 'Production order created successfully';

  @override
  String get complete => 'Complete';

  @override
  String get bom => 'Bill of Materials';

  @override
  String get executeAssembly => 'Execute Assembly';

  @override
  String get assemblySuccess => 'Assembly executed successfully';

  @override
  String get finishedProduct => 'Finished Product';

  @override
  String get rawMaterials => 'Raw Materials';

  @override
  String get bankReconciliation => 'Bank Reconciliation';

  @override
  String get autoBreakService => 'Auto-Break Service';

  @override
  String get unitHierarchy => 'Unit Hierarchy';

  @override
  String get addUnit => 'Add Unit';

  @override
  String get removeUnit => 'Remove Unit';

  @override
  String get unitName => 'Unit Name';

  @override
  String get unitFactor => 'Unit Factor';

  @override
  String get returnMode => 'Return Mode';

  @override
  String get returnFromSale => 'Return from Sale';

  @override
  String get originalSaleReference => 'Original Sale Reference';

  @override
  String get searchSale => 'Search Sale';

  @override
  String get returnItem => 'Return Item';

  @override
  String get returnQuantity => 'Return Quantity';

  @override
  String get returnReason => 'Return Reason';

  @override
  String get returnSuccess => 'Return processed successfully';

  @override
  String get totalRefund => 'Total Refund';

  @override
  String get cancelReturn => 'Cancel Return';

  @override
  String get unmatchedTransactions => 'Unmatched Transactions';

  @override
  String get reconcileSelected => 'Reconcile Selected';

  @override
  String get autoReconcile => 'Auto Reconcile';

  @override
  String get reconcileAll => 'Reconcile All';

  @override
  String get tolerance => 'Tolerance';

  @override
  String get noUnmatchedTransactions => 'No unmatched transactions';

  @override
  String get accountingPeriods => 'Accounting Periods';

  @override
  String get autoGenerate => 'Auto Generate';

  @override
  String get cancelAutoGeneration => 'Cancel Auto Generation';

  @override
  String get periodName => 'Period Name';

  @override
  String get examplePeriodName => 'Example: January 2026';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get existingPeriods => 'Existing Periods';

  @override
  String get noAccountingPeriods => 'No Accounting Periods';

  @override
  String get closePeriod => 'Close Period';

  @override
  String get openPeriod => 'Open Period';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get periodAddedSuccessfully => 'Period added successfully';

  @override
  String get confirmClosePeriod => 'Confirm Close Period';

  @override
  String get closePeriodMessage => 'Profits will be transferred to retained earnings.';

  @override
  String get confirmGeneric => 'Confirm';

  @override
  String get failedToClosePeriod => 'Failed to close period';

  @override
  String get failedToReopenPeriod => 'Failed to reopen period';

  @override
  String get cannotDeleteClosedPeriod => 'Cannot delete a closed period';

  @override
  String get cannotDeletePeriodWithEntries => 'Cannot delete period: GL entries exist in this period';

  @override
  String get periodDeleted => 'Period deleted';

  @override
  String get createAutoPeriods => 'Create Auto Periods';

  @override
  String get year => 'Year';

  @override
  String get periodType => 'Period Type';

  @override
  String get monthly => 'Monthly (12 periods)';

  @override
  String get quarterly => 'Quarterly (4 periods)';

  @override
  String get yearly => 'Yearly (1 period)';

  @override
  String get autoPeriodInfo => 'Periods will be created automatically based on selection.';

  @override
  String periodsCreated(Object count) {
    return '$count accounting periods created successfully';
  }

  @override
  String failedToCreatePeriods(Object error) {
    return 'Failed to create periods: $error';
  }

  @override
  String get reopenPeriod => 'Reopen Period';

  @override
  String get addPeriod => 'Add Period';

  @override
  String get addManualPeriod => 'Add Manual Period';

  @override
  String get manualJournalEntry => 'Manual Journal Entry';

  @override
  String get addAccountToEntry => 'Add Account to Entry';

  @override
  String get entryDescription => 'Entry Description';

  @override
  String get entryDate => 'Entry Date';

  @override
  String get account => 'Account';

  @override
  String get amount => 'Amount';

  @override
  String get costCenter => 'Cost Center';

  @override
  String get noCostCenter => 'No Cost Center';

  @override
  String get saveAndPost => 'Save & Post';

  @override
  String get entryNotBalanced => 'Entry Not Balanced';

  @override
  String get pleaseEnterDescription => 'Please enter the entry description';

  @override
  String get cannotPostToClosedPeriod => 'Cannot post to a closed accounting period';

  @override
  String pleaseSelectAccountForLine(Object lineNumber) {
    return 'Please select an account for line $lineNumber';
  }

  @override
  String lineCannotHaveDebitAndCredit(Object lineNumber) {
    return 'Line $lineNumber cannot have both debit and credit';
  }

  @override
  String lineHasAccountWithoutAmount(Object lineNumber) {
    return 'Line $lineNumber has an account without a debit or credit value';
  }

  @override
  String get entrySavedAndPosted => 'Entry saved and posted successfully';

  @override
  String failedToSaveEntry(Object error) {
    return 'Failed to save entry: $error';
  }

  @override
  String get recurringEntries => 'Recurring Entries';

  @override
  String get executeDueEntries => 'Execute Due Entries';

  @override
  String get addRecurringEntry => 'Add Recurring Entry';

  @override
  String get noRecurringEntries => 'No recurring entries';

  @override
  String get tapToAddRecurringEntry => 'Tap + to add a new recurring entry';

  @override
  String get dailyFreq => 'Daily';

  @override
  String get weeklyFreq => 'Weekly';

  @override
  String get biweeklyFreq => 'Biweekly';

  @override
  String get monthlyFreq => 'Monthly';

  @override
  String get quarterlyFreq => 'Quarterly';

  @override
  String get yearlyFreq => 'Yearly';

  @override
  String get statusActive => 'Active';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String fromToAccounts(Object creditAccount, Object debitAccount) {
    return 'From: $debitAccount To: $creditAccount';
  }

  @override
  String nextExecutionDate(Object date) {
    return 'Next execution: $date';
  }

  @override
  String executedCount(Object count, Object total) {
    return 'Executed: $count/$total';
  }

  @override
  String executedCountNoLimit(Object count) {
    return 'Executed: $count';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get executeNow => 'Execute Now';

  @override
  String get executionHistory => 'Execution History';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String confirmDeleteRecurringEntry(Object entryName) {
    return 'Are you sure you want to delete \"$entryName\"?';
  }

  @override
  String get entryName => 'Entry Name';

  @override
  String get debitAccountCode => 'Debit Account Code';

  @override
  String get creditAccountCode => 'Credit Account Code';

  @override
  String get frequency => 'Frequency';

  @override
  String get referenceType => 'Reference Type';

  @override
  String get expenseType => 'Expense';

  @override
  String get revenueType => 'Revenue';

  @override
  String get customType => 'Custom';

  @override
  String get close => 'Close';

  @override
  String executionHistoryFor(Object name) {
    return 'Execution History - $name';
  }

  @override
  String get noExecutionHistory => 'No execution history';

  @override
  String get entryExecutedSuccessfully => 'Entry executed successfully';

  @override
  String get pleaseFillRequiredFields => 'Please fill all required fields';

  @override
  String executionResult(Object fail, Object success) {
    return 'Executed: $success succeeded, $fail failed';
  }

  @override
  String errorWithMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get cashReceiptVoucher => 'Cash Receipt Voucher';

  @override
  String get cashPaymentVoucher => 'Cash Payment Voucher';

  @override
  String get receiptIn => 'Receipt (In)';

  @override
  String get paymentOut => 'Payment (Out)';

  @override
  String get creditAccountSource => 'Credit Account (Source)';

  @override
  String get debitAccountEntity => 'Debit Account (Entity)';

  @override
  String get categoryHint => 'Category (e.g. Rent, Salaries)';

  @override
  String get requiredField => 'Required';

  @override
  String get voucherSavedSuccessfully => 'Voucher saved successfully';

  @override
  String get saveReceiptVoucher => 'Save Receipt Voucher';

  @override
  String get savePaymentVoucher => 'Save Payment Voucher';

  @override
  String get checkManagement => 'Check Management';

  @override
  String get checkType => 'Check Type';

  @override
  String get receivedChecks => 'Received Checks (from customers)';

  @override
  String get issuedChecks => 'Issued Checks (to suppliers)';

  @override
  String get checkNumber => 'Check Number';

  @override
  String get bankName => 'Bank Name';

  @override
  String get customer => 'Customer';

  @override
  String get paymentCollectionAccount => 'Payment/Collection Account';

  @override
  String get saveCheck => 'Save Check';

  @override
  String get noChecks => 'No checks.';

  @override
  String checkInfo(Object bank, Object number) {
    return 'Check No: $number - $bank';
  }

  @override
  String checkDetails(Object amount, Object dueDate, Object status) {
    return 'Amount: $amount - Due: $dueDate\nStatus: $status';
  }

  @override
  String get collect => 'Collect';

  @override
  String get reject => 'Reject/Bounce';

  @override
  String checkCollected(Object checkNumber) {
    return 'Collection of check: $checkNumber';
  }

  @override
  String checkBounced(Object checkNumber) {
    return 'Bounced check: $checkNumber';
  }

  @override
  String checkStatusUpdated(Object status) {
    return 'Check status updated to $status';
  }

  @override
  String get fixedAssetsManagement => 'Fixed Assets Management';

  @override
  String get confirmDepreciation => 'Are you sure you want to run monthly depreciation for all assets? This will happen in the background.';

  @override
  String get run => 'Run';

  @override
  String get depreciationCompleted => 'Depreciation calculation completed successfully.';

  @override
  String get calculateMonthlyDepreciation => 'Calculate Monthly Depreciation';

  @override
  String get noFixedAssets => 'No fixed assets registered yet.';

  @override
  String get startAddingAsset => 'Start by adding a new asset from the button below.';

  @override
  String get addAsset => 'Add Asset';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get originalCost => 'Original Cost';

  @override
  String get usefulLife => 'Useful Life';

  @override
  String years(Object years) {
    return '$years years';
  }

  @override
  String get salvageValue => 'Salvage Value';

  @override
  String get accumulatedDepreciation => 'Accumulated Depreciation';

  @override
  String get netBookValue => 'Net Book Value';

  @override
  String get accountOptional => 'Accounting Account (Optional)';

  @override
  String get active => 'Active';

  @override
  String get additionalNotes => 'Additional notes...';

  @override
  String get actual => 'Actual';

  @override
  String autoReconcileCount(Object count) {
    return '$count transaction(s) auto-reconciled';
  }

  @override
  String autoReconcileError(Object error) {
    return 'Auto reconcile error: $error';
  }

  @override
  String get bankAccount => 'Bank Account';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get budgetCreated => 'Budget created successfully';

  @override
  String get budgetList => 'Budget List';

  @override
  String get budgetName => 'Budget Name';

  @override
  String get budgeted => 'Budgeted';

  @override
  String get budgetedAmount => 'Budgeted Amount';

  @override
  String get budgets => 'Budgets';

  @override
  String get cashOverShortNotFound => 'Cash or cash over/short account not found';

  @override
  String get check => 'Check';

  @override
  String checkDueDate(Object date) {
    return 'Check Due Date: $date';
  }

  @override
  String get closed => 'Closed';

  @override
  String get commission => 'Commission';

  @override
  String get confirmAndRecordReconciliation => 'Confirm and Record Reconciliation';

  @override
  String consumedPercent(Object percent) {
    return '$percent% consumed';
  }

  @override
  String get costCenterOptional => 'Cost Center (Optional)';

  @override
  String get createBudget => 'Create Budget';

  @override
  String get createBudgetHint => 'Create a new budget from the second tab';

  @override
  String get creating => 'Creating...';

  @override
  String get description => 'Description';

  @override
  String get enterAmountPrompt => 'Please enter an amount';

  @override
  String get enterBudgetNameError => 'Please enter a budget name';

  @override
  String errorLoadingTransactions(Object error) {
    return 'Error loading transactions: $error';
  }

  @override
  String get fromAccount => 'From Account';

  @override
  String get fromDate => 'From Date';

  @override
  String get general => 'General';

  @override
  String get noBudgetsFound => 'No budgets found';

  @override
  String get payTo => 'Pay To';

  @override
  String get paymentVoucher => 'Payment Voucher';

  @override
  String get paymentVoucherSaved => 'Payment voucher saved successfully';

  @override
  String periodLabel(Object period) {
    return 'Period: $period';
  }

  @override
  String get q1 => 'Q1';

  @override
  String get q2 => 'Q2';

  @override
  String get q3 => 'Q3';

  @override
  String get q4 => 'Q4';

  @override
  String get receiptVoucher => 'Receipt Voucher';

  @override
  String get receiptVoucherSaved => 'Receipt voucher saved successfully';

  @override
  String get receiveFrom => 'Receive From';

  @override
  String reconcileAllConfirm(Object count) {
    return 'Do you want to reconcile all $count unmatched transactions?';
  }

  @override
  String reconcileAllSuccess(Object count) {
    return 'All $count transactions reconciled successfully';
  }

  @override
  String reconcileSuccessCount(Object count) {
    return '$count transaction(s) reconciled successfully';
  }

  @override
  String reconciliationDescription(Object note) {
    return 'Reconciliation: $note';
  }

  @override
  String reconciliationError(Object error) {
    return 'Reconciliation error: $error';
  }

  @override
  String get reconciliationNotes => 'Reconciliation Notes';

  @override
  String get reconciliationNotesHint => 'Reconciliation notes...';

  @override
  String get reconciliationSuccess => 'Reconciliation recorded successfully';

  @override
  String get recordTransfer => 'Record Transfer';

  @override
  String get reference => 'Reference';

  @override
  String get refresh => 'Refresh';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get search => 'Search';

  @override
  String get selectAccountsError => 'Please select accounts';

  @override
  String get selectBankAccountPrompt => 'Select a bank account to start reconciliation';

  @override
  String get selectCustomerOrSupplier => 'Please select a customer or supplier';

  @override
  String get selectedTransactions => 'Selected Transactions';

  @override
  String get toAccount => 'To Account';

  @override
  String get toDate => 'To Date';

  @override
  String get transferCompany => 'Transfer Company';

  @override
  String transferItem(Object amount) {
    return 'Transfer: $amount';
  }

  @override
  String get transferSuccess => 'Transfer completed successfully';

  @override
  String get transferType => 'Transfer Type';

  @override
  String get transfers => 'Financial Transfers';

  @override
  String get variance => 'Variance';

  @override
  String get customizeDashboard => 'Customize Dashboard';

  @override
  String get dragToReorderHint => 'Drag to reorder, tap the eye to show/hide section';

  @override
  String get favorites => 'Favorites';

  @override
  String get tapStarToPin => 'Tap ⭐ on any screen to pin it here';

  @override
  String favoriteItems(Object count) {
    return '$count items';
  }

  @override
  String get sell => 'Sell';

  @override
  String get saleInvoice => 'Sale Invoice';

  @override
  String get saleInvoiceDescription => 'Create a new sale invoice';

  @override
  String get priceQuote => 'Price Quote';

  @override
  String get priceQuoteDescription => 'Create a price quote for customer';

  @override
  String get customerOrder => 'Customer Order';

  @override
  String get customerOrderDescription => 'Receive an order from customer';

  @override
  String get purchaseInvoice => 'Purchase Invoice';

  @override
  String get purchaseInvoiceDescription => 'Create a new purchase invoice';

  @override
  String get purchaseOrder => 'Purchase Order';

  @override
  String get purchaseOrderDescription => 'Create a purchase order from supplier';

  @override
  String get newOperation => 'New Operation';

  @override
  String get inventory => 'Inventory';

  @override
  String get cashboxes => 'Cash Boxes';

  @override
  String get stockTake => 'Stock Take';

  @override
  String get inventoryTransfer => 'Inventory Transfer';

  @override
  String get printBarcode => 'Print Barcode';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get transfer => 'Transfer';

  @override
  String get salesReport => 'Sales Report';

  @override
  String get purchasesReport => 'Purchases Report';

  @override
  String get profitReport => 'Profit Report';

  @override
  String get inventoryReport => 'Inventory Report';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get now => 'Now';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get todaysBusiness => 'Today\'s Business';

  @override
  String get todayPurchases => 'Today\'s Purchases';

  @override
  String get invoiceCount => 'Invoice Count';

  @override
  String get newCustomers => 'New Customers';

  @override
  String get profit => 'Profit';

  @override
  String get productsSold => 'Products Sold';

  @override
  String get thisWeekSales => 'This Week\'s Sales';

  @override
  String get thisWeekPurchases => 'This Week\'s Purchases';

  @override
  String get transactionSettings => 'Transaction Settings';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get thisFieldRequired => 'This field is required';

  @override
  String get transactionSavedSuccessfully => 'Transaction saved successfully';

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get quickPos => 'Quick POS';

  @override
  String get sellMode => 'Sell Mode';

  @override
  String get retailMode => 'Retail Mode';

  @override
  String get wholesaleModeDescription => 'Wholesale Mode';

  @override
  String get holdSale => 'Hold Sale';

  @override
  String get saleHeld => 'Sale held';

  @override
  String get recallSale => 'Recall Held Sale';

  @override
  String get heldSales => 'Held Sales';

  @override
  String itemsCount(Object count) {
    return '$count items';
  }

  @override
  String get currencySar => 'SAR';

  @override
  String get checkoutSuccess => 'Sale completed successfully';

  @override
  String get cashCustomer => 'Cash Customer';

  @override
  String get howToSendInvoice => 'How would you like to send the invoice?';

  @override
  String get later => 'Later';

  @override
  String get print => 'Print';

  @override
  String get share => 'Share';

  @override
  String get returnSuccessTitle => 'Return Processed Successfully';

  @override
  String returnId(Object id) {
    return 'Return ID: $id';
  }

  @override
  String originalInvoice(Object id) {
    return 'Original Invoice: $id';
  }

  @override
  String returnAmount(Object amount) {
    return 'Return Amount: $amount SAR';
  }

  @override
  String get salesReturnDescription => 'Return products from a sale invoice';

  @override
  String get purchaseReturnDescription => 'Return products to a supplier';

  @override
  String get saleInvoiceLabel => 'Sale Invoice';

  @override
  String get purchaseInvoiceLabel => 'Purchase Invoice';

  @override
  String get salesReturnLabel => 'Sales Return';

  @override
  String get purchaseReturnLabel => 'Purchase Return';

  @override
  String get priceQuoteLabel => 'Price Quote';

  @override
  String get purchaseOrderLabel => 'Purchase Order';

  @override
  String get customerOrderLabel => 'Customer Order';

  @override
  String get transactionDate => 'Transaction date';

  @override
  String get bank => 'Bank';

  @override
  String get cashCustomerFallback => 'Cash Customer';

  @override
  String invoiceNo(Object id) {
    return 'Invoice No: #$id';
  }

  @override
  String totalAmountWithCurrency(Object amount) {
    return 'Total: $amount SAR';
  }

  @override
  String customerNameLabel(Object customer) {
    return 'Customer: $customer';
  }

  @override
  String get thankYouForShopping => 'Thank you for shopping with us!';

  @override
  String get supplierStatement => 'Supplier Statement';

  @override
  String get todaySalesKpi => 'Today\'s Sales';

  @override
  String get todayPurchasesKpi => 'Today\'s Purchases';

  @override
  String get freshCustomers => 'New Customers';

  @override
  String get itemsSold => 'Products Sold';

  @override
  String get selectCustomerField => 'Customer';

  @override
  String get selectSupplierField => 'Supplier';

  @override
  String get dateField => 'Date';

  @override
  String get notesField => 'Notes';

  @override
  String get amountField => 'Amount';

  @override
  String get paymentMethodField => 'Payment Method';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get accessDeniedMessage => 'Sorry, you do not have permission to access this page.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noTransactionsToPrint => 'No transactions to print';

  @override
  String get customerNotFound => 'Customer not found';

  @override
  String get totalPayments => 'Total Payments';

  @override
  String get remainingBalance => 'Remaining Balance';

  @override
  String get noFinancialMovements => 'No financial movements for this customer';

  @override
  String get statementLabel => 'Statement';

  @override
  String payInvoicesFor(Object name) {
    return 'Pay Invoices for $name';
  }

  @override
  String get selectAtLeastOneInvoice => 'Please select at least one invoice';

  @override
  String invoiceHash(Object id) {
    return 'Invoice #$id';
  }

  @override
  String get amountPaidLabel => 'Amount Paid';

  @override
  String get netProfit => 'Net Profit';

  @override
  String get pendingOrders => 'Pending Orders';

  @override
  String get stockAlerts => 'Stock Alerts';

  @override
  String get creditExceeded => 'Credit Exceeded';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get topSellingToday => 'Top Selling Today';

  @override
  String qtyLabel(Object qty) {
    return 'Qty: $qty';
  }

  @override
  String remainingLabel(Object amount) {
    return 'Remaining: $amount';
  }

  @override
  String get productCategories => 'Product Categories';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No Data';

  @override
  String errorLabel(Object error) {
    return 'Error: $error';
  }

  @override
  String get cashBalance => 'Cash Balance';

  @override
  String get lowStockSupply => 'Low Stock';

  @override
  String get newOperationDesc => 'Sale, Purchase, Return, Voucher, or any other operation';

  @override
  String get quickOperations => 'Quick Operations';

  @override
  String get buyAction => 'Buy';

  @override
  String get customerAction => 'Customer';

  @override
  String get productAction => 'Product';

  @override
  String get supplierAction => 'Supplier';

  @override
  String get reportAction => 'Report';

  @override
  String get mainSections => 'Main Sections';

  @override
  String get operationsSection => 'Operations';

  @override
  String get accountingSection => 'Accounting';

  @override
  String get partiesSection => 'Parties';

  @override
  String get adminSection => 'Admin';

  @override
  String get newLabel => 'New';

  @override
  String get menuLabel => 'Menu';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get attentionCenter => 'Attention Center';

  @override
  String get noAlerts => 'No alerts currently';

  @override
  String get timelineLabel => 'Timeline';

  @override
  String get timelineEmpty => 'No operations yet';

  @override
  String get allocateAmountToInvoices => 'Allocate Amount to Invoices';

  @override
  String allocated(Object amount) {
    return 'Allocated: $amount';
  }

  @override
  String get annual => 'Annual';

  @override
  String get approvalWorkflow => 'Approval Workflow';

  @override
  String get approve => 'Approve';

  @override
  String get approved => 'Approved';

  @override
  String get assetName => 'Asset Name';

  @override
  String assetsAndLiabilities(Object assets, Object liabilities) {
    return 'Assets: $assets | Liabilities: $liabilities';
  }

  @override
  String get autoAllocateOldestFirst => 'Auto-Allocate (Oldest First)';

  @override
  String byUser(Object user) {
    return 'by $user';
  }

  @override
  String get calculate => 'Calculate';

  @override
  String get calculateNewZakat => 'Calculate New Zakat';

  @override
  String get calculateZakat => 'Calculate Zakat';

  @override
  String get calculationType => 'Calculation Type';

  @override
  String get change => 'Change';

  @override
  String closeDate(Object date) {
    return 'Close Date: $date';
  }

  @override
  String closeFailed(Object error) {
    return 'Close failed: $error';
  }

  @override
  String get closeYearDescription => 'All revenue and expense balances will be transferred to retained earnings, and temporary accounts will be zeroed for the new year.';

  @override
  String get commissions => 'Commissions';

  @override
  String get confirmClose => 'Confirm Close';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get confirmPaymentMessage => 'Are you sure you want to record payment for this tax?';

  @override
  String get cost => 'Cost';

  @override
  String get createRevaluationEntry => 'Create Revaluation Entry';

  @override
  String get demoRequest => 'Demo Request';

  @override
  String get demoRequestNote => 'Demo request to activate the approval workflow until it is linked to purchase forms.';

  @override
  String get dividends => 'Dividends';

  @override
  String get dividendsInterest => 'Dividends / Interest';

  @override
  String get editAsset => 'Edit Asset';

  @override
  String get enterReferenceNumber => 'Enter reference number';

  @override
  String entriesCount(Object count) {
    return 'Entries ($count)';
  }

  @override
  String get entryCount => 'Entry Count';

  @override
  String errorLoadingApprovalRequests(Object error) {
    return 'Error loading approval requests: $error';
  }

  @override
  String failedToAddAsset(Object error) {
    return 'Failed to add asset: $error';
  }

  @override
  String failedToCalculateDepreciation(Object error) {
    return 'Failed to calculate depreciation: $error';
  }

  @override
  String failedToLoadAssets(Object error) {
    return 'Failed to load assets: $error';
  }

  @override
  String failedToUpdateAsset(Object error) {
    return 'Failed to update asset: $error';
  }

  @override
  String failedToUpdateRequest(Object error) {
    return 'Failed to update approval request: $error';
  }

  @override
  String get file => 'File';

  @override
  String get fileTax => 'File Tax';

  @override
  String get filed => 'Filed';

  @override
  String get grossAmount => 'Gross Amount';

  @override
  String get insurance => 'Insurance';

  @override
  String get interest => 'Interest';

  @override
  String get invoiceAlreadyApproved => 'Approved Invoice: Cannot Edit';

  @override
  String get invoiceApprovedMessage => 'This invoice has been approved. Would you like to make a correction?';

  @override
  String invoiceWithId(Object id) {
    return 'Invoice #$id';
  }

  @override
  String get largePurchaseRequest => 'Large Purchase Request';

  @override
  String manualJournalEntryAudit(Object description, Object total) {
    return 'Manual entry: $description, Total: $total';
  }

  @override
  String get net => 'Net';

  @override
  String get netAmount => 'Net Amount';

  @override
  String get newAsset => 'New Asset';

  @override
  String get noApprovalRequests => 'No approval requests at this time';

  @override
  String get noOutstandingInvoices => 'No outstanding invoices for this customer.';

  @override
  String get noTaxEntriesInPeriod => 'No tax entries in this period';

  @override
  String get noZakatCalculations => 'No zakat calculations';

  @override
  String get paid => 'Paid';

  @override
  String get paidZakat => 'Paid Zakat';

  @override
  String get pay => 'Pay';

  @override
  String paymentLabel(Object paymentId) {
    return 'Payment: $paymentId';
  }

  @override
  String get pendingZakat => 'Pending Zakat';

  @override
  String get periodYear => 'Period (Year)';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String purchaseDateLabel(Object date) {
    return 'Purchase Date: $date';
  }

  @override
  String get recordPayment => 'Record Payment';

  @override
  String get referenceNumber => 'Reference Number';

  @override
  String get rejected => 'Rejected';

  @override
  String remainingToAllocate(Object amount) {
    return 'Remaining to allocate: $amount';
  }

  @override
  String get rent => 'Rent';

  @override
  String get revaluationReason => 'Payment revaluation';

  @override
  String get requestApproved => 'Request approved';

  @override
  String get requestRejected => 'Request rejected';

  @override
  String get royalties => 'Royalties';

  @override
  String get royaltiesServices => 'Royalties / Services';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get serviceFees => 'Service Fees';

  @override
  String statusWithValue(Object status) {
    return 'Status: $status';
  }

  @override
  String get taxFiledSuccessfully => 'Tax filed successfully';

  @override
  String taxWithRate(Object rate) {
    return 'Tax ($rate%)';
  }

  @override
  String get technicalFees => 'Technical Fees';

  @override
  String get technicalFeesCommissionsRent => 'Technical Fees / Commissions / Rent';

  @override
  String totalAndBalance(Object balance, Object total) {
    return 'Total: $total | Remaining: $balance';
  }

  @override
  String get totalZakat => 'Total Zakat';

  @override
  String get typeLabel => 'Type';

  @override
  String unbalancedEntryError(Object credit, Object debit) {
    return 'Entry is not balanced. Debit: $debit, Credit: $credit';
  }

  @override
  String get unifiedStatement => 'Unified Statement';

  @override
  String get usefulLifeYears => 'Useful Life (Years)';

  @override
  String get withholdingTax => 'Withholding Tax';

  @override
  String get withholdingTaxRates => 'Withholding Tax Rates';

  @override
  String get withholdingTaxSummary => 'Withholding Tax Summary';

  @override
  String get yearClosedSuccessfully => 'Financial year closed successfully';

  @override
  String get zakat => 'Zakat';

  @override
  String zakatAmount(Object amount) {
    return 'Zakat: $amount';
  }

  @override
  String get zakatCalculatedSuccessfully => 'Zakat calculated successfully';

  @override
  String get zakatFiledSuccessfully => 'Zakat filed successfully';

  @override
  String get zakatPaidSuccessfully => 'Zakat paid successfully';

  @override
  String get serialNumbers => 'Serial Numbers';

  @override
  String get history => 'History';

  @override
  String get noSerialNumbers => 'No serial numbers';

  @override
  String get inStock => 'In Stock';

  @override
  String get soldStatus => 'Sold';

  @override
  String get reservedStatus => 'Reserved';

  @override
  String get returnedStatus => 'Returned';

  @override
  String productWithName(Object name) {
    return 'Product: $name';
  }

  @override
  String warehouseWithName(Object name) {
    return 'Warehouse: $name';
  }

  @override
  String batchWithName(Object name) {
    return 'Batch: $name';
  }

  @override
  String receivedDateWithDate(Object date) {
    return 'Received Date: $date';
  }

  @override
  String get reserve => 'Reserve';

  @override
  String get restock => 'Restock';

  @override
  String get addSerialNumber => 'Add Serial Number';

  @override
  String get serialNumberLabel => 'Serial Number';

  @override
  String get serialNumberAdded => 'Serial number added successfully';

  @override
  String get bulkRegister => 'Add Multiple Serial Numbers';

  @override
  String get serialNumbersOnePerLine => 'Serial numbers (one per line)';

  @override
  String get registerAll => 'Register All';

  @override
  String get enterAtLeastOneSerial => 'Please enter at least one serial number';

  @override
  String serialBulkRegistered(Object count, Object total) {
    return 'Registered $count of $total serial numbers';
  }

  @override
  String get reserveSerialNumber => 'Reserve Serial Number';

  @override
  String get salesOrderNumber => 'Sales Order Number';

  @override
  String get enterSalesOrderNumber => 'Please enter the sales order number';

  @override
  String get serialReserved => 'Serial number reserved';

  @override
  String get registerSerialSale => 'Register Serial Sale';

  @override
  String get saleNumber => 'Sale Number';

  @override
  String get enterSaleNumber => 'Please enter the sale number';

  @override
  String get saleRegistered => 'Sale registered successfully';

  @override
  String get registerSale => 'Register Sale';

  @override
  String get confirmReturn => 'Confirm Return';

  @override
  String confirmReturnMessage(Object serialNumber) {
    return 'Do you want to mark serial number \"$serialNumber\" as returned?';
  }

  @override
  String get returnRegistered => 'Return registered successfully';

  @override
  String get serialNumberHistory => 'Serial Number History';

  @override
  String get viewHistory => 'View History';

  @override
  String get shiftReport => 'Shift Report';

  @override
  String get noShiftsYet => 'No shifts yet';

  @override
  String get openStatus => 'Open';

  @override
  String get closedStatus => 'Closed';

  @override
  String userWithId(Object userId) {
    return 'User: $userId';
  }

  @override
  String openingCashAmount(Object amount) {
    return 'Opening Cash: $amount';
  }

  @override
  String closingCashAmount(Object amount) {
    return 'Closing Cash: $amount';
  }

  @override
  String noteWithText(Object note) {
    return 'Note: $note';
  }

  @override
  String get viewReport => 'View Report';

  @override
  String get shiftStart => 'Shift Start';

  @override
  String get shiftEnd => 'Shift End';

  @override
  String get durationLabel => 'Duration';

  @override
  String expectedCashAmount(Object amount) {
    return 'Expected Cash: $amount';
  }

  @override
  String differenceAmount(Object amount) {
    return 'Difference: $amount';
  }

  @override
  String get cashTotal => 'Cash';

  @override
  String get cardTotal => 'Card';

  @override
  String shiftNotes(Object note) {
    return 'Notes: $note';
  }

  @override
  String get stockTakeTitle => 'Stock Take';

  @override
  String get selectWarehouseToStart => 'Please select a warehouse to start stock take';

  @override
  String get addItem => 'Add Item';

  @override
  String get targetWarehouse => 'Target Warehouse';

  @override
  String get startStockTakeSession => 'Start New Stock Take Session';

  @override
  String get noItemsInSession => 'No items in this session yet';

  @override
  String get expectedSystem => 'Expected (System)';

  @override
  String get actualQtyDiscovered => 'Actual Quantity Discovered';

  @override
  String get varianceLabel => 'Variance';

  @override
  String get finalNotes => 'Final Stock Take Notes';

  @override
  String get approveAndCloseStockTake => 'Approve and Close Stock Take';

  @override
  String get stockTakeCompleted => 'Stock take completed, inventory and accounting entries updated successfully';

  @override
  String stockTakeError(Object error) {
    return 'Error completing stock take: $error';
  }

  @override
  String get addProductToStockTake => 'Add Product to Stock Take';

  @override
  String get searchProduct => 'Search Product';

  @override
  String get noResults => 'No results';

  @override
  String qtyOfProduct(Object name) {
    return 'Quantity of $name';
  }

  @override
  String get actualQtyNow => 'Current Actual Quantity';

  @override
  String get addToStockTake => 'Add to Stock Take';

  @override
  String get warehouseManagement => 'Warehouse Management';

  @override
  String get noWarehousesAdded => 'No warehouses added';

  @override
  String get noLocation => 'No location';

  @override
  String get defaultLabel => 'Default';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get addNewWarehouse => 'Add New Warehouse';

  @override
  String get locationLabel => 'Location';

  @override
  String get warehouseNameRequired => 'Warehouse name is required';

  @override
  String get warehouseCreated => 'Warehouse created successfully';

  @override
  String warehouseCreateFailed(Object error) {
    return 'Failed to create warehouse: $error';
  }

  @override
  String get editWarehouse => 'Edit Warehouse';

  @override
  String get update => 'Update';

  @override
  String get warehouseUpdated => 'Warehouse updated successfully';

  @override
  String warehouseUpdateFailed(Object error) {
    return 'Failed to update warehouse: $error';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteWarehouse => 'Are you sure you want to delete this warehouse?';

  @override
  String warehouseDeleteFailed(Object error) {
    return 'Failed to delete warehouse: $error';
  }

  @override
  String get cannotDeleteWarehouseWithStock => 'Cannot delete warehouse because it contains stock.';

  @override
  String get warehouseDeleted => 'Warehouse deleted successfully';

  @override
  String get warehouseManager => 'Warehouse Manager';

  @override
  String codeJobTitle(Object code, Object jobTitle) {
    return 'Code: $code | Job: $jobTitle';
  }

  @override
  String get notSpecified => 'Not Specified';

  @override
  String get editPurchaseInvoice => 'Edit Purchase Invoice';

  @override
  String get purchaseInvoiceTitle => 'Purchase Invoice';

  @override
  String get periodClosedMessage => 'The accounting period is closed. Invoices cannot be posted until a new period is opened.';

  @override
  String get lockedInvoiceMessage => 'This invoice is not a draft, so it cannot be edited directly. Use a correction document or return instead.';

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get representativeLabel => 'Representative';

  @override
  String get generalRepresentative => 'General Representative';

  @override
  String get selectProduct => 'Select Product';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get taxLabel => 'Tax';

  @override
  String get discountLabel => 'Discount';

  @override
  String get shippingLabel => 'Shipping';

  @override
  String get otherExpensesLabel => 'Other Expenses';

  @override
  String get totalLabel => 'Total';

  @override
  String get optional => 'Optional';

  @override
  String get needTaxPermission => 'You need tax edit permission';

  @override
  String get addExistingItem => 'Add Existing Item';

  @override
  String get addNewItem => 'Add New Item';

  @override
  String get cannotEditNonDraftItems => 'Cannot edit items of a non-draft purchase invoice';

  @override
  String get fixFinancialFields => 'Please fix the financial fields before saving';

  @override
  String get noTaxPermission => 'You do not have permission to edit tax';

  @override
  String get pleaseSelectSupplier => 'Please select a supplier';

  @override
  String get pleaseSelectWarehouse => 'Please select a warehouse';

  @override
  String get pleaseAddItems => 'Please add items';

  @override
  String get quantityMustBeGreaterThanZero => 'Quantity must be greater than zero';

  @override
  String get priceMustBeNonNegative => 'Price must be greater than or equal to zero';

  @override
  String get cannotEditNonDraftInvoice => 'Cannot edit a non-draft purchase invoice. Use a correction document or return instead.';

  @override
  String newPurchaseInvoiceValue(Object amount) {
    return 'New purchase invoice worth $amount';
  }

  @override
  String invoiceModifiedValue(Object amount) {
    return 'Invoice modified to $amount';
  }

  @override
  String get invoicePosted => 'Invoice posted';

  @override
  String get purchaseSavedAndPosted => 'Purchase saved, posted, and inventory updated successfully';

  @override
  String get invoiceModifiedSuccessfully => 'Invoice modified successfully';

  @override
  String get draftSavedSuccessfully => 'Draft saved successfully';

  @override
  String errorSavingInvoice(Object error) {
    return 'Error saving invoice: $error';
  }

  @override
  String get unexpectedError => 'An unexpected error occurred while saving.';

  @override
  String get foreignKeyError => 'Link error: please verify the selected data (warehouse, supplier, or items).';

  @override
  String get uniqueConstraintError => 'Duplicate error: invoice number or other data already exists.';

  @override
  String get periodClosedCannotPost => 'The accounting period is closed. Cannot post.';

  @override
  String get purchaseOrders => 'Purchase Orders';

  @override
  String get noPurchaseOrders => 'No purchase orders';

  @override
  String purchaseOrderTitle(Object number) {
    return 'Purchase Order: $number';
  }

  @override
  String supplierStatus(Object name, Object status) {
    return 'Supplier: $name | Status: $status';
  }

  @override
  String get confirmTitle => 'Confirm';

  @override
  String convertOrderToInvoice(Object number) {
    return 'Convert purchase order $number to invoice?';
  }

  @override
  String get convert => 'Convert';

  @override
  String get conversionSuccess => 'Conversion successful';

  @override
  String get generateAutoOrders => 'Generate Auto Purchase Orders';

  @override
  String get ordersGenerated => 'Purchase orders generated successfully';

  @override
  String get supplierPerformance => 'Supplier Performance Report';

  @override
  String invoiceCountLabel(Object count) {
    return 'Invoices: $count';
  }

  @override
  String totalPurchasesLabel(Object amount) {
    return 'Total: $amount';
  }

  @override
  String averageInvoiceLabel(Object amount) {
    return 'Avg Invoice: $amount';
  }

  @override
  String get priceQuotes => 'Price Quotes';

  @override
  String get noPriceQuotes => 'No price quotes';
}
