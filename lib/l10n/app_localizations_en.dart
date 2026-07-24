import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

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
    return 'Are you sure you want to delete \'$entryName\'?';
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
    return 'Do you want to mark serial number \'$serialNumber\' as returned?';
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

  @override
  String get fatwrhMshtryat => '       فاتورة مشتريات         ';

  @override
  String get ywm => ' يوم';

  @override
  String get n8AhrfAlaAlaql => '8 أحرف على الأقل';

  @override
  String get ajl => 'آجل';

  @override
  String get akhrAlamlyat => 'آخر العمليات';

  @override
  String get adkhlRqmAlfatwrhAwla => 'أدخل رقم الفاتورة أولاً';

  @override
  String get adkhlRqmAlfatwrhAlaslyhLlbhth => 'أدخل رقم الفاتورة الأصلية للبحث';

  @override
  String get adkhlRqmaShyha => 'أدخل رقماً صحيحاً';

  @override
  String get adkhlMarfAlamylWalmblghBshklShyh => 'أدخل معرف العميل والمبلغ بشكل صحيح';

  @override
  String get adkhlMarfAlamylWaddAlnqatBshklShyh => 'أدخل معرف العميل وعدد النقاط بشكل صحيح';

  @override
  String get adkhlNsbhByn1W100 => 'أدخل نسبة بين 1 و 100';

  @override
  String get adwarAlmstkhdmyn => 'أدوار المستخدمين';

  @override
  String get arqamAltslsl => 'أرقام التسلسل';

  @override
  String get arqamAltslslRqmWahdFyKlStr => 'أرقام التسلسل (رقم واحد في كل سطر) *';

  @override
  String get asaarSrfAlamlat => 'أسعار صرف العملات';

  @override
  String get adfSnfaWahdaAlaAlaql => 'أضف صنفاً واحداً على الأقل';

  @override
  String get adfMlahzatLltlbyh => 'أضف ملاحظات للطلبية...';

  @override
  String get aamarAldywn => 'أعمار الديون';

  @override
  String get akthrAlmntjatMbyaa => 'أكثر المنتجات مبيعاً';

  @override
  String get amrSHraa => 'أمر شراء';

  @override
  String get anwaaAlijazat => 'أنواع الإجازات';

  @override
  String get awamrAlintaj => 'أوامر الإنتاج';

  @override
  String get awamrAlshraa => 'أوامر الشراء';

  @override
  String get awlAlmdhTswyhAlmkhzwnAlawly => 'أول المدة - تسوية المخزون الأولي';

  @override
  String get ayamAlaftrady => 'أيام الافتراضي';

  @override
  String get itmamAmlyhAlbya => 'إتمام عملية البيع';

  @override
  String get ijazh => 'إجازة';

  @override
  String get ijmalyAlayam => 'إجمالي الأيام';

  @override
  String get ijmalyAlrbh => 'إجمالي الربح';

  @override
  String get ijmalyAlsadr => 'إجمالي الصادر';

  @override
  String get ijmalyAlamlaa => 'إجمالي العملاء';

  @override
  String get ijmalyAlamwlh => 'إجمالي العمولة';

  @override
  String get ijmalyAlmbyaat => 'إجمالي المبيعات';

  @override
  String get ijmalyAlmbyaatAlkhadahLldrybh => 'إجمالي المبيعات الخاضعة للضريبة';

  @override
  String get ijmalyAlmdywnyh => 'إجمالي المديونية';

  @override
  String get ijmalyAlmrtja => 'إجمالي المرتجع:';

  @override
  String get ijmalyAlmshtryatAlkhadahLldrybh => 'إجمالي المشتريات الخاضعة للضريبة';

  @override
  String get ijmalyAlmkafat => 'إجمالي المكافآت';

  @override
  String get ijmalyAlmwrdyn => 'إجمالي الموردين';

  @override
  String get ijmalyAlward => 'إجمالي الوارد';

  @override
  String get ijmalyTklfhAlbdaah => 'إجمالي تكلفة البضاعة';

  @override
  String get ijmalyDrybhAlmkhrjat => 'إجمالي ضريبة المخرجات';

  @override
  String get ijmalyDrybhAlmdkhlat => 'إجمالي ضريبة المدخلات';

  @override
  String get ikhfaaAsaarAlbya => 'إخفاء أسعار البيع';

  @override
  String get ikhfaaAsaarAlbyaFySHashatMaynh => 'إخفاء أسعار البيع في شاشات معينة';

  @override
  String get idarhAsaarSrfAlamlat => 'إدارة أسعار صرف العملات';

  @override
  String get idarhAmynAlmkhzn => 'إدارة أمين المخزن';

  @override
  String get idarhAlijazat => 'إدارة الإجازات';

  @override
  String get idarhAliadadat => 'إدارة الإعدادات';

  @override
  String get idarhAltsnya => 'إدارة التصنيع';

  @override
  String get idarhAlhsabat => 'إدارة الحسابات';

  @override
  String get idarhAlhdwrWalansraf => 'إدارة الحضور والانصراف';

  @override
  String get idarhAlshykat => 'إدارة الشيكات';

  @override
  String get idarhAlslahyat => 'إدارة الصلاحيات';

  @override
  String get idarhAlamlaa => 'إدارة العملاء';

  @override
  String get idarhAlmkhzwn => 'إدارة المخزون';

  @override
  String get idarhAlmstkhdmyn => 'إدارة المستخدمين';

  @override
  String get idarhAlmstwdaat => 'إدارة المستودعات';

  @override
  String get idarhAlmwrdyn => 'إدارة الموردين';

  @override
  String get idarhAlmwzfyn => 'إدارة الموظفين';

  @override
  String get idarhAlwrdyat => 'إدارة الورديات';

  @override
  String get idkhalWtadylAldrybh => 'إدخال وتعديل الضريبة';

  @override
  String get idhaKantHdhhAlamlhAlasasyhAdkhl1 => 'إذا كانت هذه العملة الأساسية، أدخل 1';

  @override
  String get irjaaAsnaf => 'إرجاع أصناف';

  @override
  String get irsal => 'إرسال';

  @override
  String get ishaarDaenJdyd => 'إشعار دائن جديد';

  @override
  String get ishaaratAldaen => 'إشعارات الدائن';

  @override
  String get idafh => 'إضافة';

  @override
  String get idafhArqamTslslMtaddh => 'إضافة أرقام تسلسل متعددة';

  @override
  String get idafhDwr => 'إضافة دور';

  @override
  String get idafhDwrJdyd => 'إضافة دور جديد';

  @override
  String get idafhRqmTslsl => 'إضافة رقم تسلسل';

  @override
  String get idafhSlahyh => 'إضافة صلاحية';

  @override
  String get idafhSnf => 'إضافة صنف';

  @override
  String get idafhSnfJdyd => 'إضافة صنف جديد';

  @override
  String get idafhSnfLlthwyl => 'إضافة صنف للتحويل';

  @override
  String get idafhSnfMwjwd => 'إضافة صنف موجود';

  @override
  String get idafhAmlhJdydh => 'إضافة عملة جديدة';

  @override
  String get idafhQydTrhylJdyd => 'إضافة قيد ترحيل جديد';

  @override
  String get idafhLljrd => 'إضافة للجرد';

  @override
  String get idafhMrkzTklfh => 'إضافة مركز تكلفة';

  @override
  String get idafhMstkhdm => 'إضافة مستخدم';

  @override
  String get idafhMstkhdmJdyd => 'إضافة مستخدم جديد';

  @override
  String get idafhMstwdaJdyd => 'إضافة مستودع جديد';

  @override
  String get idafhMntjJdydSrya => 'إضافة منتج جديد سريع';

  @override
  String get idafhMntjLljrd => 'إضافة منتج للجرد';

  @override
  String get idafhMntjYdwya => 'إضافة منتج يدوياً';

  @override
  String get idafhMwzf => 'إضافة موظف';

  @override
  String get idafhNqatMnBya => 'إضافة نقاط من بيع';

  @override
  String get idafhNwaIjazh => 'إضافة نوع إجازة';

  @override
  String get idafhWhdh => 'إضافة وحدة';

  @override
  String get idafhWhdhThwyl => 'إضافة وحدة تحويل';

  @override
  String get idafhWhdhThwylJdydh => 'إضافة وحدة تحويل جديدة';

  @override
  String get iaadhAlmhawlh => 'إعادة المحاولة';

  @override
  String get iaadhThmyl => 'إعادة تحميل';

  @override
  String get iaadhThmylAlamlat => 'إعادة تحميل العملات';

  @override
  String get iaadhTayyn => 'إعادة تعيين';

  @override
  String get iaadhLlmkhzwn => 'إعادة للمخزون';

  @override
  String get iadadatAlfwatyr => 'إعدادات الفواتير';

  @override
  String get iadadatAlqywdAlmhasbyh => 'إعدادات القيود المحاسبية';

  @override
  String get iadadatAlnzam => 'إعدادات النظام';

  @override
  String get iadadatAamh => 'إعدادات عامة';

  @override
  String get ighlaq => 'إغلاق';

  @override
  String get ighlaqAlwrdyh => 'إغلاق الوردية';

  @override
  String get ilghaa => 'إلغاء';

  @override
  String get ilghaaAlthdyd => 'إلغاء التحديد';

  @override
  String get ilghaaAltlbyh => 'إلغاء الطلبية';

  @override
  String get ilghaaAlmaamlat => 'إلغاء المعاملات';

  @override
  String get ilghaaAmlyh => 'إلغاء عملية';

  @override
  String get ilghaaWdaAlmrtjaat => 'إلغاء وضع المرتجعات';

  @override
  String get ila => 'إلى';

  @override
  String get ilaTarykh => 'إلى تاريخ';

  @override
  String get ilaMstwda => 'إلى مستودع';

  @override
  String get inshaa => 'إنشاء';

  @override
  String get inshaaAlhsabatAlaftradyh => 'إنشاء الحسابات الافتراضية';

  @override
  String get inshaaAltlbyh => 'إنشاء الطلبية';

  @override
  String get inshaaAlmswwlWaldkhwl => 'إنشاء المسؤول والدخول';

  @override
  String get inshaaArdSarJdyd => 'إنشاء عرض سعر جديد';

  @override
  String get inshaaMbyaat => 'إنشاء مبيعات';

  @override
  String get inshaaMshtryat => 'إنشاء مشتريات';

  @override
  String get inshaaNskhhAhtyatyhMhlyh => 'إنشاء نسخة احتياطية محلية';

  @override
  String get inshaaHdfMbyaat => 'إنشاء هدف مبيعات';

  @override
  String get iyrad => 'إيراد';

  @override
  String get abhthAnAlmntj => 'ابحث عن المنتج';

  @override
  String get abhthAnSHashhAwWzyfhMthlaMkhznByaKshf => 'ابحث عن شاشة أو وظيفة... (مثلاً: مخزن، بيع، كشف)';

  @override
  String get atrkhFarghaLlahtfazBklmhAlmrwr => 'اتركه فارغاً للاحتفاظ بكلمة المرور';

  @override
  String get atrkhFarghaLltwlydAltlqaey => 'اتركه فارغاً للتوليد التلقائي';

  @override
  String get atsal => 'اتصال';

  @override
  String get akhtrAlhsab => 'اختر الحساب';

  @override
  String get akhtrAldfahalmntj => 'اختر الدفعة/المنتج';

  @override
  String get akhtrAldwr => 'اختر الدور';

  @override
  String get akhtrAlamyl => 'اختر العميل';

  @override
  String get akhtrAlamylAkhtyary => 'اختر العميل (اختياري)';

  @override
  String get akhtrTarykhAlanthaa => 'اختر تاريخ الانتهاء';

  @override
  String get akhtrFtrhTqryrAldrybh => 'اختر فترة تقرير الضريبة';

  @override
  String get akhtrMlfNskhhAhtyatyhLastaadhAlbyanat => 'اختر ملف نسخة احتياطية لاستعادة البيانات';

  @override
  String get akhtrMntj => 'اختر منتج';

  @override
  String get akhtsaratSryah => 'اختصارات سريعة';

  @override
  String get akhtyarAlamyl => 'اختيار العميل';

  @override
  String get akhtyarAlmwrd => 'اختيار المورد';

  @override
  String get akhtyarAmyl => 'اختيار عميل';

  @override
  String get akhtyarMstwda => 'اختيار مستودع';

  @override
  String get akhtyarMntj => 'اختيار منتج';

  @override
  String get akhtyarMwrd => 'اختيار مورد';

  @override
  String get akhtyary => 'اختياري';

  @override
  String get astbdalNqat => 'استبدال نقاط';

  @override
  String get astaadh => 'استعادة';

  @override
  String get astaadhAlnskhhAlahtyatyhStqwmBhdhfAlbyanatAlhalyhS => 'استعادة النسخة الاحتياطية ستقوم بحذف البيانات الحالية. سيتم إنشاء نسخة أمان قبل الاستعادة. هل أنت متأكد؟';

  @override
  String get astaadhMnMlfMhly => 'استعادة من ملف محلي';

  @override
  String get asmAlijazh => 'اسم الإجازة';

  @override
  String get asmAldwr => 'اسم الدور';

  @override
  String get asmAlamlh => 'اسم العملة';

  @override
  String get asmAlamlhDwlarAmryky => 'اسم العملة (دولار أمريكي)';

  @override
  String get asmAlamlhAlkaml => 'اسم العملة الكامل';

  @override
  String get asmAlamyl => 'اسم العميل';

  @override
  String get asmAlmswwl => 'اسم المسؤول';

  @override
  String get asmAlmstkhdm => 'اسم المستخدم';

  @override
  String get asmAlmstwda => 'اسم المستودع';

  @override
  String get asmAlmstwdaMtlwb => 'اسم المستودع مطلوب';

  @override
  String get asmAlmntj => 'اسم المنتج';

  @override
  String get asmAlwhdhMthlaKrtwn => 'اسم الوحدة (مثلاً: كرتون)';

  @override
  String get ashtrWahsl => 'اشتر واحصل';

  @override
  String get adghtLinshaaHdfMbyaatJdyd => 'اضغط لإنشاء هدف مبيعات جديد';

  @override
  String get aatmadWiqfalAljrdNhaeya => 'اعتماد وإقفال الجرد نهائياً';

  @override
  String get aftrady => 'افتراضي';

  @override
  String get aladwar => 'الأدوار';

  @override
  String get aladwarAlmwjwdh => 'الأدوار الموجودة';

  @override
  String get alarbah => 'الأرباح';

  @override
  String get alarbahAlmtqdm => 'الأرباح المتقدم';

  @override
  String get alarbahHsbAltsnyf => 'الأرباح حسب التصنيف';

  @override
  String get alarsdh => 'الأرصدة';

  @override
  String get alarqamAltslslyh => 'الأرقام التسلسلية';

  @override
  String get alasnaf => 'الأصناف';

  @override
  String get alatraf => 'الأطراف';

  @override
  String get alaqlAhmyh => 'الأقل أهمية';

  @override
  String get alakthrAhmyh => 'الأكثر أهمية';

  @override
  String get alijmaly => 'الإجمالي';

  @override
  String get alijmalyAlfray => 'الإجمالي الفرعي';

  @override
  String get alijmalyAlnhaey => 'الإجمالي النهائي';

  @override
  String get alijmaly_1 => 'الإجمالي:';

  @override
  String get alidarh => 'الإدارة';

  @override
  String get alishaarat => 'الإشعارات';

  @override
  String get aliadadatAlmtqdmh => 'الإعدادات المتقدمة';

  @override
  String get aliyrad => 'الإيراد';

  @override
  String get aliyradat => 'الإيرادات';

  @override
  String get alasm => 'الاسم';

  @override
  String get alasmAlkaml => 'الاسم الكامل';

  @override
  String get alasmMtlwb => 'الاسم مطلوب';

  @override
  String get alasmYjbAnYkwnAlaAlaqlHrfyn => 'الاسم يجب أن يكون على الأقل حرفين';

  @override
  String get alaftrady => 'الافتراضي';

  @override
  String get albarkwd => 'الباركود';

  @override
  String get albarkwdSKU => 'الباركود / SKU';

  @override
  String get albrydAlilktrwny => 'البريد الإلكتروني';

  @override
  String get altarykh => 'التاريخ';

  @override
  String get althsylat => 'التحصيلات';

  @override
  String get althwylAlmkhzny => 'التحويل المخزني';

  @override
  String get althwylat => 'التحويلات';

  @override
  String get altdfqatAlnqdyh => 'التدفقات النقدية';

  @override
  String get altrakmy => 'التراكمي %';

  @override
  String get altsnyaBOM => 'التصنيع (BOM)';

  @override
  String get altsnyf => 'التصنيف';

  @override
  String get altqaryr => 'التقارير';

  @override
  String get altklfh => 'التكلفة';

  @override
  String get aljanb => 'الجانب';

  @override
  String get alhalh => 'الحالة';

  @override
  String get alhsabAlthlyly => 'الحساب التحليلي';

  @override
  String get alhsabAlmhasby => 'الحساب المحاسبي';

  @override
  String get alhsabat => 'الحسابات';

  @override
  String get alkhsm => 'الخصم';

  @override
  String get aldwr => 'الدور';

  @override
  String get alreysyh => 'الرئيسية';

  @override
  String get alratbAlasasy => 'الراتب الأساسي';

  @override
  String get alrbh => 'الربح';

  @override
  String get alrjaaIdkhalAlhdAladna => 'الرجاء إدخال الحد الأدنى';

  @override
  String get alrjaaIdkhalAlftrh => 'الرجاء إدخال الفترة';

  @override
  String get alrjaaIdkhalAlmblgh => 'الرجاء إدخال المبلغ';

  @override
  String get alrjaaIdkhalAlnsbh => 'الرجاء إدخال النسبة';

  @override
  String get alrjaaIdkhalRsalhAlfatwrh => 'الرجاء إدخال رسالة الفاتورة';

  @override
  String get alrjaaIdkhalSarAlsrf => 'الرجاء إدخال سعر الصرف';

  @override
  String get alrjaaIdkhalNsbhAldrybh => 'الرجاء إدخال نسبة الضريبة';

  @override
  String get alrjaaIdafhAsnaf => 'الرجاء إضافة أصناف';

  @override
  String get alrjaaInshaaNskhhAhtyatyhAwla => 'الرجاء إنشاء نسخة احتياطية أولاً';

  @override
  String get alrjaaAkhtyarAlmstwda => 'الرجاء اختيار المستودع';

  @override
  String get alrjaaAkhtyarAlmwrd => 'الرجاء اختيار المورد';

  @override
  String get alrjaaAkhtyarAmlh => 'الرجاء اختيار عملة';

  @override
  String get alrjaaAkhtyarMntjLklSnf => 'الرجاء اختيار منتج لكل صنف';

  @override
  String get alrjaaAkhtyarMndwb => 'الرجاء اختيار مندوب';

  @override
  String get alrsyd => 'الرصيد';

  @override
  String get alrsydAlijmaly => 'الرصيد الإجمالي';

  @override
  String get alrsydAlhalyAlmsthq => 'الرصيد الحالي المستحق';

  @override
  String get alrsydAlmtwqa => 'الرصيد المتوقع';

  @override
  String get alrsydAlmsthqLlmwrd => 'الرصيد المستحق للمورد';

  @override
  String get alrqm => 'الرقم';

  @override
  String get alrqmAldrybyVATNo => 'الرقم الضريبي (VAT No.)';

  @override
  String get alsbb => 'السبب';

  @override
  String get alsbb_1 => 'السبب *';

  @override
  String get alsjl => 'السجل';

  @override
  String get alsar => 'السعر';

  @override
  String get alsarAqlBkthyrMnMtwstAltklfh => 'السعر أقل بكثير من متوسط التكلفة';

  @override
  String get alsarAqlMnAltklfh => 'السعر أقل من التكلفة';

  @override
  String get alsarYjbAnYkwnAkbrMnAwYsawyAlsfr => 'السعر يجب أن يكون أكبر من أو يساوي الصفر.';

  @override
  String get alsarYjbAnYkwnAkbrMnAwYsawySfr => 'السعر يجب أن يكون أكبر من أو يساوي صفر';

  @override
  String get alslhFarghh => 'السلة فارغة';

  @override
  String get alslfWalkhswmat => 'السلف والخصومات';

  @override
  String get alsmahBalbyaBaqlMnAltklfh => 'السماح بالبيع بأقل من التكلفة';

  @override
  String get alsmahBalbyaHtaFyHalhAdmTwfrKmyh => 'السماح بالبيع حتى في حالة عدم توفر كمية';

  @override
  String get alsmahBalmkhzwnAlslby => 'السماح بالمخزون السلبي';

  @override
  String get alsmahBbyaMntjatBdwnRsydKaf => 'السماح ببيع منتجات بدون رصيد كافٍ';

  @override
  String get alsnh => 'السنة';

  @override
  String get alsnhGHyrShyhh => 'السنة غير صحيحة';

  @override
  String get alshhn => 'الشحن';

  @override
  String get alshhr => 'الشهر';

  @override
  String get alshhrYjbAnYkwnByn1W12 => 'الشهر يجب أن يكون بين 1 و12';

  @override
  String get alsafy => 'الصافي';

  @override
  String get alsafyAlmsthq => 'الصافي المستحق';

  @override
  String get alslahyat => 'الصلاحيات';

  @override
  String get alslahyatAlmtahh => 'الصلاحيات المتاحة';

  @override
  String get alsndwq => 'الصندوق';

  @override
  String get alsnfAlkmyhAlsar => 'الصنف          | الكمية | السعر';

  @override
  String get alsyghhYYYYMM => 'الصيغة: YYYY-MM';

  @override
  String get aldraeb => 'الضرائب';

  @override
  String get aldrybh => 'الضريبة';

  @override
  String get altabah => 'الطابعة';

  @override
  String get altlbyhGHyrMwjwdh => 'الطلبية غير موجودة';

  @override
  String get aladd => 'العدد';

  @override
  String get alarbyh => 'العربية';

  @override
  String get alarwdWalbrwmwshnz => 'العروض والبروموشنز';

  @override
  String get alamlaa => 'العملاء';

  @override
  String get alamlh => 'العملة';

  @override
  String get alamlyat => 'العمليات';

  @override
  String get alamwlat => 'العمولات';

  @override
  String get alamyl => 'العميل';

  @override
  String get alamyl_1 => 'العميل *';

  @override
  String get alamylTjawzAlhdAlaetmanyAlmsmwhBh => 'العميل تجاوز الحد الائتماني المسموح به';

  @override
  String get alamylTjawzHdAlaetman => 'العميل تجاوز حد الائتمان!';

  @override
  String get alanwan => 'العنوان';

  @override
  String get alfeat => 'الفئات';

  @override
  String get alfeh => 'الفئة';

  @override
  String get alfehAltsnyf => 'الفئة / التصنيف';

  @override
  String get alfatwrhAlaslyhGHyrMwjwdh => 'الفاتورة الأصلية غير موجودة';

  @override
  String get alfatwrhFarghhAlrjaaIdafhAsnaf => 'الفاتورة فارغة - الرجاء إضافة أصناف';

  @override
  String get alfarq => 'الفارق';

  @override
  String get alftratAlmhasbyh => 'الفترات المحاسبية';

  @override
  String get alftrh => 'الفترة';

  @override
  String get alftrhYYYYMM => 'الفترة (YYYY-MM)';

  @override
  String get alftrhAlmhasbyhMghlqhLaYmknAltrhyl => 'الفترة المحاسبية مغلقة. لا يمكن الترحيل.';

  @override
  String get alftrhAlmhasbyhMghlqhLaYmknTrhylAlfwatyrHtaFthFtrh => 'الفترة المحاسبية مغلقة. لا يمكن ترحيل الفواتير حتى فتح فترة جديدة.';

  @override
  String get alfraAlaftrady => 'الفرع الافتراضي';

  @override
  String get alfrq => 'الفرق';

  @override
  String get alqymhYjbAnTkwnRqmMwjb => 'القيمة يجب أن تكون رقم موجب';

  @override
  String get alqywdAlydwyh => 'القيود اليدوية';

  @override
  String get alqywdAlywmyh => 'القيود اليومية';

  @override
  String get alkamyra => 'الكاميرا';

  @override
  String get alkl => 'الكل';

  @override
  String get alkmyh => 'الكمية';

  @override
  String get alkmyhAlfalyhAlmktshfh => 'الكمية الفعلية المكتشفة';

  @override
  String get alkmyhAlfalyhAlmwjwdhAlan => 'الكمية الفعلية الموجودة الآن';

  @override
  String get alkmyhAlmtbqyh => 'الكمية المتبقية';

  @override
  String get alkmyhAlmrtjah => 'الكمية المرتجعة: ';

  @override
  String get alkmyhAlmntjh => 'الكمية المُنتَجة';

  @override
  String get alkmyhYjbAnTkwnAkbrMnAlsfr => 'الكمية يجب أن تكون أكبر من الصفر.';

  @override
  String get alkmyhYjbAnTkwnAkbrMnSfr => 'الكمية يجب أن تكون أكبر من صفر';

  @override
  String get alkwd => 'الكود';

  @override
  String get alkwdMtlwb => 'الكود مطلوب';

  @override
  String get alkwdYjbAnYkwnAlaAlaqlHrfyn => 'الكود يجب أن يكون على الأقل حرفين';

  @override
  String get almwshratAlmalyhAldhkyh => 'المؤشرات المالية الذكية';

  @override
  String get almblgh => 'المبلغ';

  @override
  String get almblghAlijmaly => 'المبلغ الإجمالي';

  @override
  String get almblghAlmdfwa => 'المبلغ المدفوع';

  @override
  String get almblghAlmstlm => 'المبلغ المستلم';

  @override
  String get almblghAlmsthdf => 'المبلغ المستهدف';

  @override
  String get almbyaatWalmkhrjat => 'المبيعات والمخرجات';

  @override
  String get almtbqyAlfkh => 'المتبقي (الفكة):';

  @override
  String get almtwqaAlnzam => 'المتوقع (النظام)';

  @override
  String get almjmwaAlfray => 'المجموع الفرعي';

  @override
  String get almhqq => 'المحقق';

  @override
  String get almkhzwn => 'المخزون';

  @override
  String get almkhzwnGHyrKaf => 'المخزون غير كافٍ';

  @override
  String get almdh => 'المدة';

  @override
  String get almdfwaat => 'المدفوعات';

  @override
  String get almdfwah => 'المدفوعة';

  @override
  String get almrtjaat => 'المرتجعات';

  @override
  String get almrja => 'المرجع';

  @override
  String get almzamnh => 'المزامنة';

  @override
  String get almstwda => 'المستودع';

  @override
  String get almstwda_1 => 'المستودع *';

  @override
  String get almstwdaAlaftrady => 'المستودع الافتراضي';

  @override
  String get almstwdaAlmsthdf => 'المستودع المستهدف';

  @override
  String get almstwdaWalfra => 'المستودع والفرع';

  @override
  String get almstwda_2 => 'المستودع:';

  @override
  String get almstwdaat => 'المستودعات';

  @override
  String get almshtryatWalmdkhlat => 'المشتريات والمدخلات';

  @override
  String get almsrwfat => 'المصروفات';

  @override
  String get almsrwfatHsbAlmrkz => 'المصروفات حسب المركز';

  @override
  String get almsrwfatHsbMrkzAltklfh => 'المصروفات حسب مركز التكلفة';

  @override
  String get almaamlKmWhdhAsasyhFyHdhhAlwhdh => 'المعامل (كم وحدة أساسية في هذه الوحدة؟)';

  @override
  String get almaamlYjbAnYkwnAkbrMn1 => 'المعامل يجب أن يكون أكبر من 1';

  @override
  String get almard => 'المعرض';

  @override
  String get almarfatAlaftradyh => 'المعرفات الافتراضية';

  @override
  String get almalqh => 'المعلقة';

  @override
  String get almkwnatAlmtlwbh => 'المكونات المطلوبة:';

  @override
  String get almntj => 'المنتج';

  @override
  String get almntjAkhtyary => 'المنتج (اختياري)';

  @override
  String get almntj_1 => 'المنتج *';

  @override
  String get almntjAlmsna => 'المنتج المُصنَّع';

  @override
  String get almntjGHyrMwjwd => 'المنتج غير موجود';

  @override
  String get almntjat => 'المنتجات';

  @override
  String get almntjatAlakthrMbyaa => 'المنتجات الأكثر مبيعاً';

  @override
  String get almntjatAlrakdh => 'المنتجات الراكدة';

  @override
  String get almndwb => 'المندوب';

  @override
  String get almnsb => 'المنصب';

  @override
  String get almwafqhAlaAlkhswmat => 'الموافقة على الخصومات';

  @override
  String get almwafqhAlaKHsm => 'الموافقة على خصم';

  @override
  String get almwrd => 'المورد';

  @override
  String get almwrdyn => 'الموردين';

  @override
  String get almwzf => 'الموظف';

  @override
  String get almwzfyn => 'الموظفين';

  @override
  String get almwqa => 'الموقع';

  @override
  String get almyzanyhAlamwmyh => 'الميزانية العمومية';

  @override
  String get alnsbh => 'النسبة';

  @override
  String get alnsbh_1 => 'النسبة %';

  @override
  String get alnsbhYjbAnTkwnByn0W100 => 'النسبة يجب أن تكون بين 0 و 100';

  @override
  String get alnskhAlahtyaty => 'النسخ الاحتياطي';

  @override
  String get alnskhAlahtyatyWalastaadh => 'النسخ الاحتياطي والاستعادة';

  @override
  String get alnskhAlmhlyh => 'النسخ المحلية';

  @override
  String get alnwa => 'النوع';

  @override
  String get alhamsh => 'الهامش';

  @override
  String get alhdf => 'الهدف';

  @override
  String get alwhdh => 'الوحدة';

  @override
  String get alwhdhAlasasyhAlmaaml1 => 'الوحدة الأساسية (المعامل: 1)';

  @override
  String get ansrafMbkr => 'انصراف مبكر';

  @override
  String get barkwdAlwhdhAkhtyary => 'باركود الوحدة (اختياري)';

  @override
  String get bhth => 'بحث';

  @override
  String get bhthBalasmAwAlkwdAwAlbarkwd => 'بحث بالاسم أو الكود أو الباركود...';

  @override
  String get bhthBalasmAwAlkwd => 'بحث بالاسم أو الكود...';

  @override
  String get bhthBalasmAwAlhatf => 'بحث بالاسم أو الهاتف...';

  @override
  String get bhthBrqmAltlbyhAwAsmAlamyl => 'بحث برقم الطلبية أو اسم العميل...';

  @override
  String get bhthSryaCtrlK => 'بحث سريع... (Ctrl+K)';

  @override
  String get bhthAnAmyl => 'بحث عن عميل...';

  @override
  String get bhthAnMntj => 'بحث عن منتج...';

  @override
  String get bhthAnMwrd => 'بحث عن مورد...';

  @override
  String get bhth_1 => 'بحث...';

  @override
  String get bdaJlshJrdJdydh => 'بدء جلسة جرد جديدة';

  @override
  String get bdayhAlwrdyh => 'بداية الوردية';

  @override
  String get bdwnAjr => 'بدون أجر';

  @override
  String get bdwnAmyl => 'بدون عميل';

  @override
  String get bdwnMwqa => 'بدون موقع';

  @override
  String get btaqh => 'بطاقة';

  @override
  String get badAlasnafBdwnSbbIrjaaHlTrydAlmtabah => 'بعض الأصناف بدون سبب إرجاع. هل تريد المتابعة؟';

  @override
  String get bnk => 'بنك';

  @override
  String get bya => 'بيع';

  @override
  String get byaJdydPOS => 'بيع جديد (POS)';

  @override
  String get takyd => 'تأكيد';

  @override
  String get takydAlirjaa => 'تأكيد الإرجاع';

  @override
  String get takydAlilghaa => 'تأكيد الإلغاء';

  @override
  String get takydAlthwyl => 'تأكيد التحويل';

  @override
  String get takydAltsdyd => 'تأكيد التسديد';

  @override
  String get takydAlhdhf => 'تأكيد الحذف';

  @override
  String get takydAldfa => 'تأكيد الدفع';

  @override
  String get takydAlmrtja => 'تأكيد المرتجع';

  @override
  String get takydHfzAlarsdhAlawlyh => 'تأكيد حفظ الأرصدة الأولية';

  @override
  String get takydKlmhAlmrwr => 'تأكيد كلمة المرور';

  @override
  String get tarykhAlanthaa => 'تاريخ الانتهاء';

  @override
  String get tarykhAlandmam => 'تاريخ الانضمام';

  @override
  String get tarykhAlbdayh => 'تاريخ البداية';

  @override
  String get tarykhAltrhyl => 'تاريخ الترحيل';

  @override
  String get tarykhAldfa => 'تاريخ الدفع';

  @override
  String get tarykhAlslahyh => 'تاريخ الصلاحية';

  @override
  String get tarykhAlftrh => 'تاريخ الفترة:';

  @override
  String get tarykhAlnhayh => 'تاريخ النهاية';

  @override
  String get ttrawhByn0W25 => 'تتراوح بين 0% و 25%';

  @override
  String get tjzeh => 'تجزئة';

  @override
  String get thtajSlahyhTadylAldrybh => 'تحتاج صلاحية تعديل الضريبة';

  @override
  String get thdyth => 'تحديث';

  @override
  String get thdythAltnbyhat => 'تحديث التنبيهات';

  @override
  String get thdythAltlbyh => 'تحديث الطلبية';

  @override
  String get thdythAlqaemh => 'تحديث القائمة';

  @override
  String get thdythHalhAltlbyh => 'تحديث حالة الطلبية';

  @override
  String get thdythTmAltwsyl => 'تحديث: تم التوصيل';

  @override
  String get thdythTmAltlb => 'تحديث: تم الطلب';

  @override
  String get thdythJahz => 'تحديث: جاهز';

  @override
  String get thdydAlkl => 'تحديد الكل';

  @override
  String get thdydAlklKmqrwa => 'تحديد الكل كمقروء';

  @override
  String get thdhyr => 'تحذير';

  @override
  String get thlylABCLlmntjat => 'تحليل ABC للمنتجات';

  @override
  String get thlylSafyAlrbh7Ayam => 'تحليل صافي الربح (7 أيام)';

  @override
  String get thmyl => 'تحميل...';

  @override
  String get thwyl => 'تحويل';

  @override
  String get thwylAltlbyhLamrSHraa => 'تحويل الطلبية لأمر شراء';

  @override
  String get thwylAltlbyhLfatwrh => 'تحويل الطلبية لفاتورة';

  @override
  String get thwylAlwhdat => 'تحويل الوحدات';

  @override
  String get thwylSadr => 'تحويل صادر';

  @override
  String get thwylLamrSHraa => 'تحويل لأمر شراء';

  @override
  String get thwylLfatwrh => 'تحويل لفاتورة';

  @override
  String get thwylLfatwrhQydAlttwyr => 'تحويل لفاتورة - قيد التطوير';

  @override
  String get thwylMkhzny => 'تحويل مخزني';

  @override
  String get thwylWard => 'تحويل وارد';

  @override
  String get tdqyqAlmkhzwn => 'تدقيق المخزون';

  @override
  String get trhyl => 'ترحيل';

  @override
  String get tsjylAlbya => 'تسجيل البيع';

  @override
  String get tsjylAlkhrwj => 'تسجيل الخروج';

  @override
  String get tsjylAlkl => 'تسجيل الكل';

  @override
  String get tsjylAnsraf => 'تسجيل انصراف';

  @override
  String get tsjylByaRqmAltslsl => 'تسجيل بيع رقم التسلسل';

  @override
  String get tsjylHdwr => 'تسجيل حضور';

  @override
  String get tsjylSlfhKHsm => 'تسجيل سلفة / خصم';

  @override
  String get tsdyd => 'تسديد';

  @override
  String get tsdyrExcel => 'تصدير Excel';

  @override
  String get tsdyrPDF => 'تصدير PDF';

  @override
  String get tsfyhAlntaej => 'تصفية النتائج';

  @override
  String get ttbyq => 'تطبيق';

  @override
  String get tadyl => 'تعديل';

  @override
  String get tadylAldrybh => 'تعديل الضريبة';

  @override
  String get tadylAltlbyh => 'تعديل الطلبية';

  @override
  String get tadylAlamlh => 'تعديل العملة';

  @override
  String get tadylAlmkhzwnYtmAbrAljrdAwAlthwyl => 'تعديل المخزون يتم عبر الجرد أو التحويل';

  @override
  String get tadylAlmntj => 'تعديل المنتج';

  @override
  String get tadylFatwrhMbyaat => 'تعديل فاتورة مبيعات';

  @override
  String get tadylFatwrhMshtryat => 'تعديل فاتورة مشتريات';

  @override
  String get tadylQydAltrhyl => 'تعديل قيد الترحيل';

  @override
  String get tadylMkhzwn => 'تعديل مخزون';

  @override
  String get tadylMstwda => 'تعديل مستودع';

  @override
  String get tadylMwzf => 'تعديل موظف';

  @override
  String get tadhrInshaaHsabAlmwrdLanAlfraAwAlhsabAlabGHyrMhyaT => 'تعذر إنشاء حساب المورد لأن الفرع أو الحساب الأب غير مهيأ. تمت محاولة التهيئة التلقائية، يرجى إعادة المحاولة.';

  @override
  String get tadhrThmylAlamlatYrjaIaadhAlmhawlhAwThyehByanatAln => 'تعذر تحميل العملات. يرجى إعادة المحاولة أو تهيئة بيانات النظام.';

  @override
  String get tadhrFthAlttbyq => 'تعذر فتح التطبيق';

  @override
  String get tatyl => 'تعطيل';

  @override
  String get tayynAlslahyat => 'تعيين الصلاحيات';

  @override
  String get tayynKaftrady => 'تعيين كافتراضي';

  @override
  String get tghyyr => 'تغيير';

  @override
  String get tghyyrAlftrh => 'تغيير الفترة';

  @override
  String get tfasylAltlbyh => 'تفاصيل الطلبية';

  @override
  String get tfasylSndAlaetman => 'تفاصيل سند الائتمان';

  @override
  String get tfsylAlmsrwfat => 'تفصيل المصروفات';

  @override
  String get tfayl => 'تفعيل';

  @override
  String get tqaryrAlmbyaat => 'تقارير المبيعات';

  @override
  String get tqaryrAlmkhzwn => 'تقارير المخزون';

  @override
  String get tqaryrAlmshtryat => 'تقارير المشتريات';

  @override
  String get tqryrAdaaAlmwrdyn => 'تقرير أداء الموردين';

  @override
  String get tqryrAlarbahAlshhryh => 'تقرير الأرباح الشهرية';

  @override
  String get tqryrAlarbahAlmtqdm => 'تقرير الأرباح المتقدم';

  @override
  String get tqryrAliyradatWalmsrwfat => 'تقرير الإيرادات والمصروفات';

  @override
  String get tqryrAlsnadyq => 'تقرير الصناديق';

  @override
  String get tqryrAldrybh => 'تقرير الضريبة';

  @override
  String get tqryrAlamlaa => 'تقرير العملاء';

  @override
  String get tqryrAlqymhAlmdafh => 'تقرير القيمة المضافة';

  @override
  String get tqryrAlmshtryat => 'تقرير المشتريات';

  @override
  String get tqryrAlmwrdyn => 'تقرير الموردين';

  @override
  String get tqryrAlwrdyat => 'تقرير الورديات';

  @override
  String get tqryrAlwrdyh => 'تقرير الوردية';

  @override
  String get tqryrTslymAlwrdyat => 'تقرير تسليم الورديات';

  @override
  String get tqryrHrkhAlsnf => 'تقرير حركة الصنف';

  @override
  String get tqryrHrkhAlmkhzwn => 'تقرير حركة المخزون';

  @override
  String get tqryrRbhyhAlmntjat => 'تقرير ربحية المنتجات';

  @override
  String get tqryrDrybhAlqymhAlmdafh => 'تقرير ضريبة القيمة المضافة';

  @override
  String get tqryrHamshAlrbhHsbAltsnyf => 'تقرير هامش الربح حسب التصنيف';

  @override
  String get tklfhAlbdaah => 'تكلفة البضاعة';

  @override
  String get tklfhMbyaat => 'تكلفة مبيعات';

  @override
  String get tmIrsalTlbAlijazh => 'تم إرسال طلب الإجازة';

  @override
  String get tmIdafhAlmwzf => 'تم إضافة الموظف';

  @override
  String get tmIdafhRqmAltslslBnjah => 'تم إضافة رقم التسلسل بنجاح';

  @override
  String get tmIdafhNwaAlijazh => 'تم إضافة نوع الإجازة';

  @override
  String get tmIqfalAljrdWthdythAlmkhzwnWalqywdAlmhasbyhBnjah => 'تم إقفال الجرد وتحديث المخزون والقيود المحاسبية بنجاح';

  @override
  String get tmIlghaaAlard => 'تم إلغاء العرض';

  @override
  String get tmIlghaaSndAlaetman => 'تم إلغاء سند الائتمان';

  @override
  String get tmInshaaIshaarAldaenBnjah => 'تم إنشاء إشعار الدائن بنجاح';

  @override
  String get tmInshaaAlardYhtajIlaIdafhAlasnaf => 'تم إنشاء العرض - يحتاج إلى إضافة الأصناف';

  @override
  String get tmInshaaAlmswwlLknFshlTsjylAldkhwlAltlqaey => 'تم إنشاء المسؤول، لكن فشل تسجيل الدخول التلقائي';

  @override
  String get tmInshaaAlmstwdaBnjah => 'تم إنشاء المستودع بنجاح';

  @override
  String get tmInshaaAlhdfBnjah => 'تم إنشاء الهدف بنجاح';

  @override
  String get tmAlinshaaBnjah => 'تم الإنشاء بنجاح';

  @override
  String get tmAlbya => 'تم البيع';

  @override
  String get tmAlthdyth => 'تم التحديث';

  @override
  String get tmAlthdythBnjah => 'تم التحديث بنجاح';

  @override
  String get tmAlthwylBnjah => 'تم التحويل بنجاح';

  @override
  String get tmAlthwylLamrSHraaBnjah => 'تم التحويل لأمر شراء بنجاح';

  @override
  String get tmAltwsyl => 'تم التوصيل';

  @override
  String get tmAltlb => 'تم الطلب';

  @override
  String get tmThdythAlmstwdaBnjah => 'تم تحديث المستودع بنجاح';

  @override
  String get tmTrhylAlfatwrh => 'تم ترحيل الفاتورة';

  @override
  String get tmTrhylAlfatwrhBnjah => 'تم ترحيل الفاتورة بنجاح';

  @override
  String get tmTrhylSndAlaetmanBnjah => 'تم ترحيل سند الائتمان بنجاح';

  @override
  String get tmTsjylAlirjaaBnjah => 'تم تسجيل الإرجاع بنجاح';

  @override
  String get tmTsjylAlansrafBnjah => 'تم تسجيل الانصراف بنجاح';

  @override
  String get tmTsjylAlbyaBnjah => 'تم تسجيل البيع بنجاح';

  @override
  String get tmTsjylAlhdwrBnjah => 'تم تسجيل الحضور بنجاح';

  @override
  String get tmTsjylAldfa => 'تم تسجيل الدفع';

  @override
  String get tmTsjylAlamlyhBnjah => 'تم تسجيل العملية بنجاح';

  @override
  String get tmTsdydAlamwlatBnjah => 'تم تسديد العمولات بنجاح';

  @override
  String get tmTadylAlfatwrhBnjah => 'تم تعديل الفاتورة بنجاح';

  @override
  String get tmTadylAlmwzf => 'تم تعديل الموظف';

  @override
  String get tmTwlydAwamrAlshraaBnjah => 'تم توليد أوامر الشراء بنجاح';

  @override
  String get tmHjzRqmAltslsl => 'تم حجز رقم التسلسل';

  @override
  String get tmHdhfAlamlh => 'تم حذف العملة';

  @override
  String get tmHdhfAlfatwrhBnjah => 'تم حذف الفاتورة بنجاح';

  @override
  String get tmHdhfAlmstwdaBnjah => 'تم حذف المستودع بنجاح';

  @override
  String get tmHdhfAlmntj => 'تم حذف المنتج';

  @override
  String get tmHdhfAlmwzf => 'تم حذف الموظف';

  @override
  String get tmHdhfAlnskhhAlahtyatyh => 'تم حذف النسخة الاحتياطية';

  @override
  String get tmHdhfAmlyhAlshraaBnjah => 'تم حذف عملية الشراء بنجاح';

  @override
  String get tmHdhfNwaAlijazh => 'تم حذف نوع الإجازة';

  @override
  String get tmHfzIadadAltrhylBnjah => 'تم حفظ إعداد الترحيل بنجاح';

  @override
  String get tmHfzAliadadatBnjah => 'تم حفظ الإعدادات بنجاح';

  @override
  String get tmHfzAlsndBnjah => 'تم حفظ السند بنجاح';

  @override
  String get tmHfzAlmswdh => 'تم حفظ المسودة';

  @override
  String get tmHfzAlmswdhBnjah => 'تم حفظ المسودة بنجاح';

  @override
  String get tmHfzWtrhylAlfatwrhWthdythAlmkhzwnBnjah => 'تم حفظ وترحيل الفاتورة وتحديث المخزون بنجاح';

  @override
  String get tmRfdAlijazh => 'تم رفض الإجازة';

  @override
  String get tmtAlidafh => 'تمت الإضافة';

  @override
  String get tmtAlmwafqhAlaAlijazh => 'تمت الموافقة على الإجازة';

  @override
  String get tnbyh => 'تنبيه';

  @override
  String get tnbyhatAlnqs => 'تنبيهات النقص';

  @override
  String get tnbyhatAnkhfadAlmkhzwn => 'تنبيهات انخفاض المخزون';

  @override
  String get tnfydhAltjmya => 'تنفيذ التجميع';

  @override
  String get tnfydhAlmrtja => 'تنفيذ المرتجع';

  @override
  String get thyehAlmswwlAlawl => 'تهيئة المسؤول الأول';

  @override
  String get twzyaAlmntjatHsbAlfeh => 'توزيع المنتجات حسب الفئة';

  @override
  String get twqaAltdfqAlnqdy => 'توقع التدفق النقدي';

  @override
  String get twlyd => 'توليد';

  @override
  String get twlydAwamrSHraaTlqaeyh => 'توليد أوامر شراء تلقائية';

  @override
  String get twlydBarkwdTlqaey => 'توليد باركود تلقائي';

  @override
  String get twlydBarkwdJmaay => 'توليد باركود جماعي';

  @override
  String get twlydBarkwdLlmntjatBdwnBarkwd => 'توليد باركود للمنتجات بدون باركود';

  @override
  String get twlydMsyrRwatb => 'توليد مسير رواتب';

  @override
  String get jaryAlinshaa => 'جاري الإنشاء...';

  @override
  String get jaryAlthmyl => 'جاري التحميل...';

  @override
  String get jaryAlmaaljh => 'جاري المعالجة...';

  @override
  String get jaryThdyrAltbaah => 'جاري تحضير الطباعة...';

  @override
  String get jaryThmylAlamlat => 'جاري تحميل العملات...';

  @override
  String get jary => 'جاري...';

  @override
  String get jahz => 'جاهز';

  @override
  String get jrdAlmkhzwn => 'جرد المخزون';

  @override
  String get jrdAlmstwdaat => 'جرد المستودعات';

  @override
  String get jzey => 'جزئي';

  @override
  String get jmlh => 'جملة';

  @override
  String get jmyaAlmkhzwnDmnAlhdwdAlamnh => 'جميع المخزون ضمن الحدود الآمنة';

  @override
  String get jmyaAlmntjatLhaBarkwdBalfal => 'جميع المنتجات لها باركود بالفعل';

  @override
  String get hadr => 'حاضر';

  @override
  String get hbh => 'حبة';

  @override
  String get hjz => 'حجز';

  @override
  String get hjzRqmAltslsl => 'حجز رقم التسلسل';

  @override
  String get hdAltnbyhLlmkhzwnAlmnkhfd => 'حد التنبيه للمخزون المنخفض';

  @override
  String get hdthKHta => 'حدث خطأ';

  @override
  String get hdthKHtaGHyrMtwqaAthnaaAlhfz => 'حدث خطأ غير متوقع أثناء الحفظ.';

  @override
  String get hdthKHtaFyThmylAlbyanat => 'حدث خطأ في تحميل البيانات';

  @override
  String get hddKmyhAlsnadyqAlmrtjah => 'حدد كمية الصناديق المرتجعة';

  @override
  String get hdhf => 'حذف';

  @override
  String get hdhfAltlbyh => 'حذف الطلبية';

  @override
  String get hdhfAlamlh => 'حذف العملة';

  @override
  String get hdhfAlfwatyr => 'حذف الفواتير';

  @override
  String get hdhfAlmntj => 'حذف المنتج';

  @override
  String get hdhfFatwrh => 'حذف فاتورة';

  @override
  String get hdhfMstkhdm => 'حذف مستخدم';

  @override
  String get hdhfNskhhAhtyatyh => 'حذف نسخة احتياطية';

  @override
  String get hrkatAlmkhzn => 'حركات المخزن';

  @override
  String get hrkatAlmkhzwnAlakhyrh => 'حركات المخزون الأخيرة';

  @override
  String get hrkhSnf => 'حركة صنف';

  @override
  String get hsab => 'حساب';

  @override
  String get hsabMkafahJdydh => 'حساب مكافأة جديدة';

  @override
  String get hsabMkafahNhayhAlkhdmh => 'حساب مكافأة نهاية الخدمة';

  @override
  String get hfz => 'حفظ';

  @override
  String get hfzAlarsdhAlawlyh => 'حفظ الأرصدة الأولية';

  @override
  String get hfzAliadadat => 'حفظ الإعدادات';

  @override
  String get hfzAltghyyrat => 'حفظ التغييرات';

  @override
  String get hfzAlsnd => 'حفظ السند';

  @override
  String get hfzJmyaAlbyanatFyMlfAlaAljhaz => 'حفظ جميع البيانات في ملف على الجهاز';

  @override
  String get hfzWidafhLlfatwrh => 'حفظ وإضافة للفاتورة';

  @override
  String get hfzWtrhyl => 'حفظ وترحيل';

  @override
  String get khsm => 'خصم';

  @override
  String get khsmTjryby10 => 'خصم تجريبي 10%';

  @override
  String get khsmMblgh => 'خصم مبلغ';

  @override
  String get khsmNsbh => 'خصم نسبة';

  @override
  String get khta => 'خطأ';

  @override
  String get khtaFyAltkrarRqmAlfatwrhAwByanatAkhraMwjwdhMsbqa => 'خطأ في التكرار: رقم الفاتورة أو بيانات أخرى موجودة مسبقاً.';

  @override
  String get khtaFyAlhsab => 'خطأ في الحساب';

  @override
  String get khtaFyAlrbtTakdMnShhAlbyanatAlmkhtarhAlmstwdaAwAlm => 'خطأ في الربط: تأكد من صحة البيانات المختارة (المستودع أو المورد أو الأصناف).';

  @override
  String get daen => 'دائن';

  @override
  String get dftrAlastadh => 'دفتر الأستاذ';

  @override
  String get dfaatAlmntjatAlmtwfrh => 'دفعات المنتجات المتوفرة';

  @override
  String get dfaatAlmwrdyn => 'دفعات الموردين';

  @override
  String get dfahLlmwrd => 'دفعة للمورد';

  @override
  String get dhmmDaenh => 'ذمم دائنة';

  @override
  String get dhmmMdynh => 'ذمم مدينة';

  @override
  String get rS => 'ر.س';

  @override
  String get rbhyhAlmntjat => 'ربحية المنتجات';

  @override
  String get rsalhAlfatwrhAlaftradyh => 'رسالة الفاتورة الافتراضية';

  @override
  String get rsydAlbdayh => 'رصيد البداية';

  @override
  String get rsydAlnhayh => 'رصيد النهاية';

  @override
  String get rfd => 'رفض';

  @override
  String get rfdAlijazh => 'رفض الإجازة';

  @override
  String get rqmAlbatsh => 'رقم الباتش';

  @override
  String get rqmAlbya => 'رقم البيع *';

  @override
  String get rqmAltslsl => 'رقم التسلسل *';

  @override
  String get rqmAldfah => 'رقم الدفعة';

  @override
  String get rqmAldfahAkhtyary => 'رقم الدفعة (اختياري)';

  @override
  String get rqmAlfatwrh => 'رقم الفاتورة...';

  @override
  String get rqmAlmrjaAlkharjy => 'رقم المرجع الخارجي';

  @override
  String get rqmAlmstkhdm => 'رقم المستخدم';

  @override
  String get rqmTlbAlbya => 'رقم طلب البيع *';

  @override
  String get rqmHatfAlshrkh => 'رقم هاتف الشركة';

  @override
  String get rmzAlamlh => 'رمز العملة';

  @override
  String get rmzAlamlhUSD => 'رمز العملة (USD)';

  @override
  String get saaatIdafyh => 'ساعات إضافية';

  @override
  String get sbbAlijazh => 'سبب الإجازة';

  @override
  String get sbbAlirjaa => 'سبب الإرجاع...';

  @override
  String get sbbAlrfd => 'سبب الرفض';

  @override
  String get sjlArqamAltslsl => 'سجل أرقام التسلسل';

  @override
  String get sjlAltdqyq => 'سجل التدقيق';

  @override
  String get sjlAltdqyqWalrqabh => 'سجل التدقيق والرقابة';

  @override
  String get sjlAltadylat => 'سجل التعديلات';

  @override
  String get sjlAlmbyaat => 'سجل المبيعات';

  @override
  String get sdad => 'سداد';

  @override
  String get sarAlbya => 'سعر البيع';

  @override
  String get sarAltjzeh => 'سعر التجزئة';

  @override
  String get sarAltklfh => 'سعر التكلفة';

  @override
  String get sarAljmlh => 'سعر الجملة';

  @override
  String get sarAlshraa => 'سعر الشراء';

  @override
  String get sarAlsrf => 'سعر الصرف';

  @override
  String get sarAlsrfGHyrSalh => 'سعر الصرف غير صالح';

  @override
  String get sarAlsrfMqablAlasasy => 'سعر الصرف مقابل الأساسي';

  @override
  String get sarAlwhdh => 'سعر الوحدة';

  @override
  String get sarAlwhdhAkhtyary => 'سعر الوحدة (اختياري)';

  @override
  String get sndSrf => 'سند صرف';

  @override
  String get sndQbd => 'سند قبض';

  @override
  String get sndatAlqbdWalsrf => 'سندات القبض والصرف';

  @override
  String get sytmAhtsabAlamwlatTlqaeyaAndTsjylAlmbyaat => 'سيتم احتساب العمولات تلقائياً عند تسجيل المبيعات';

  @override
  String get sytmThdythKmyhWtklfhJmyaAlmntjatAlmadlhHlTrydAlmta => 'سيتم تحديث كمية وتكلفة جميع المنتجات المعدلة. هل تريد المتابعة؟';

  @override
  String get sytmHnaArdSjlAlmzamnhWtfasylAlamlyatAlmalqh => 'سيتم هنا عرض سجل المزامنة وتفاصيل العمليات المعلقة.';

  @override
  String get syrAlmwafqat => 'سير الموافقات';

  @override
  String get shjrhAlhsabat => 'شجرة الحسابات';

  @override
  String get shraa => 'شراء';

  @override
  String get shraaJdyd => 'شراء جديد';

  @override
  String get shrwtAldfa => 'شروط الدفع';

  @override
  String get shkraLtaamlkmManan => 'شكراً لتعاملكم معنا!\\n';

  @override
  String get shkraLtaamlkmMana => 'شكراً لتعاملكم معنا...';

  @override
  String get safyAldkhl => 'صافي الدخل';

  @override
  String get safyAlrbh => 'صافي الربح';

  @override
  String get safyAldrybhAlmsthqhLldfallastrdad => 'صافي الضريبة المستحقة (للدفع/للاسترداد)';

  @override
  String get salhHta => 'صالح حتى';

  @override
  String get sndwq => 'صندوق';

  @override
  String get swrhAlmntj => 'صورة المنتج';

  @override
  String get drybh => 'ضريبة';

  @override
  String get drybhAlqymhAlmdafh => 'ضريبة القيمة المضافة';

  @override
  String get tbaah => 'طباعة';

  @override
  String get tbaahAlbarkwdWalmlsqat => 'طباعة الباركود والملصقات';

  @override
  String get tbaahAlmhdd => 'طباعة المحدد';

  @override
  String get tbaahMbashrh => 'طباعة مباشرة';

  @override
  String get tryqhAlhsab => 'طريقة الحساب';

  @override
  String get tryqhAldfa => 'طريقة الدفع';

  @override
  String get tlbIjazhJdyd => 'طلب إجازة جديد';

  @override
  String get tlbatAlijazh => 'طلبات الإجازة';

  @override
  String get tlbyatAlamlaa => 'طلبيات العملاء';

  @override
  String get tlbyatMbyaat => 'طلبيات مبيعات';

  @override
  String get tlbyhJdydh => 'طلبية جديدة';

  @override
  String get addAlayam => 'عدد الأيام';

  @override
  String get addAlamlyat => 'عدد العمليات';

  @override
  String get addAlfwatyr => 'عدد الفواتير';

  @override
  String get addAlkswr => 'عدد الكسور';

  @override
  String get addAlkswrAlashryh => 'عدد الكسور العشرية';

  @override
  String get addAlmlsqat => 'عدد الملصقات: ';

  @override
  String get ard => 'عرض';

  @override
  String get ardAlbyanatAlmalyh => 'عرض البيانات المالية';

  @override
  String get ardAltfasyl => 'عرض التفاصيل';

  @override
  String get ardAltqaryr => 'عرض التقارير';

  @override
  String get ardAltqryr => 'عرض التقرير';

  @override
  String get ardAlsjl => 'عرض السجل';

  @override
  String get ardTjryby => 'عرض تجريبي';

  @override
  String get ardQydAlywmyh => 'عرض قيد اليومية';

  @override
  String get arwdAlasaar => 'عروض الأسعار';

  @override
  String get arwdAlasaarBrwFwrma => 'عروض الأسعار (برو فورما)';

  @override
  String get amlaa => 'عملاء';

  @override
  String get amlaaBdyn => 'عملاء بدين';

  @override
  String get amlhAsasyh => 'عملة أساسية';

  @override
  String get amlhAlamyl => 'عملة العميل';

  @override
  String get amwlh => 'عمولة';

  @override
  String get amyl => 'عميل';

  @override
  String get amylJdyd => 'عميل جديد';

  @override
  String get ghaeb => 'غائب';

  @override
  String get ghyrMhdd => 'غير محدد';

  @override
  String get ghyrMrhl => 'غير مرحل';

  @override
  String get ghyrMsrhLkBinshaaTlbyh => 'غير مصرح لك بإنشاء طلبية';

  @override
  String get ghyrMarwf => 'غير معروف';

  @override
  String get fatwrhAlmbyaatAlmrjayh => 'فاتورة المبيعات المرجعية *';

  @override
  String get fatwrhMbyaat => 'فاتورة مبيعات';

  @override
  String get fatwrhMshtryat_1 => 'فاتورة مشتريات';

  @override
  String get fth => 'فتح';

  @override
  String get ftrhAltqryr => 'فترة التقرير';

  @override
  String get frdy => 'فردي';

  @override
  String get fshlInshaaIshaarAldaen => 'فشل إنشاء إشعار الدائن';

  @override
  String get fshlAlilghaa => 'فشل الإلغاء';

  @override
  String get fshlTrhylSndAlaetman => 'فشل ترحيل سند الائتمان';

  @override
  String get fshlHdhfAlnskhh => 'فشل حذف النسخة';

  @override
  String get fkhAlamlh => 'فكة العملة';

  @override
  String get fkhAlamlhSnt => 'فكة العملة (سنت)';

  @override
  String get fltrh => 'فلترة';

  @override
  String get fwatyrAlbya => 'فواتير البيع';

  @override
  String get fwatyrAlshraa => 'فواتير الشراء';

  @override
  String get fwatyrMbyaat => 'فواتير مبيعات';

  @override
  String get fwatyrMshtryat => 'فواتير مشتريات';

  @override
  String get fyAlmkhzwn => 'في المخزون';

  @override
  String get qaemhAldkhl => 'قائمة الدخل';

  @override
  String get qaemhAlamlaa => 'قائمة العملاء';

  @override
  String get qaemhAlmntjat => 'قائمة المنتجات';

  @override
  String get qaemhAlmwrdyn => 'قائمة الموردين';

  @override
  String get qtah => 'قطعة';

  @override
  String get qyasyh => 'قياسية';

  @override
  String get qydAlantzar => 'قيد الانتظار';

  @override
  String get qydAlywmyh => 'قيد اليومية';

  @override
  String get kash => 'كاش';

  @override
  String get kashyr => 'كاشير';

  @override
  String get kshfHsab => 'كشف حساب';

  @override
  String get klAlhalat => 'كل الحالات';

  @override
  String get klAlamlaa => 'كل العملاء';

  @override
  String get klmhAlmrwr => 'كلمة المرور';

  @override
  String get klmhAlmrwrYjbAnTkwn8AhrfAlaAlaql => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get klmtaAlmrwrGHyrMttabqtyn => 'كلمتا المرور غير متطابقتين';

  @override
  String get kwdAlmwzf => 'كود الموظف';

  @override
  String get la => 'لا';

  @override
  String get laTwjdAdwar => 'لا توجد أدوار';

  @override
  String get laTwjdArsdhNqatHalya => 'لا توجد أرصدة نقاط حالياً';

  @override
  String get laTwjdArqamTslsl => 'لا توجد أرقام تسلسل';

  @override
  String get laTwjdAsnaf => 'لا توجد أصناف';

  @override
  String get laTwjdAsnafFyAlfatwrhAlaslyh => 'لا توجد أصناف في الفاتورة الأصلية';

  @override
  String get laTwjdAsnafFyHdhhAljlshBad => 'لا توجد أصناف في هذه الجلسة بعد';

  @override
  String get laTwjdAsnafMdafh => 'لا توجد أصناف مضافة';

  @override
  String get laTwjdAwamrSHraa => 'لا توجد أوامر شراء';

  @override
  String get laTwjdIshaaratJdydh => 'لا توجد إشعارات جديدة';

  @override
  String get laTwjdIshaaratDaen => 'لا توجد إشعارات دائن';

  @override
  String get laTwjdByanat => 'لا توجد بيانات';

  @override
  String get laTwjdByanatLlard => 'لا توجد بيانات للعرض';

  @override
  String get laTwjdByanatLlftrhAlmhddh => 'لا توجد بيانات للفترة المحددة';

  @override
  String get laTwjdByanatMbyaat => 'لا توجد بيانات مبيعات';

  @override
  String get laTwjdByanatMbyaatHalya => 'لا توجد بيانات مبيعات حالياً';

  @override
  String get laTwjdHrkatLhdhaAlsnf => 'لا توجد حركات لهذا الصنف';

  @override
  String get laTwjdHrkatMkhzwn => 'لا توجد حركات مخزون';

  @override
  String get laTwjdHsabatMkafat => 'لا توجد حسابات مكافآت';

  @override
  String get laTwjdHsabat => 'لا توجد حسابات.';

  @override
  String get laTwjdDfaatHalya => 'لا توجد دفعات حالياً';

  @override
  String get laTwjdDfaatMsjlh => 'لا توجد دفعات مسجلة';

  @override
  String get laTwjdSjlat => 'لا توجد سجلات';

  @override
  String get laTwjdSjlatHdwr => 'لا توجد سجلات حضور';

  @override
  String get laTwjdTlbyat => 'لا توجد طلبيات';

  @override
  String get laTwjdArwdAsaar => 'لا توجد عروض أسعار';

  @override
  String get laTwjdArwdHalya => 'لا توجد عروض حالياً';

  @override
  String get laTwjdAmlatMtahhYrjaThyehByanatAlnzam => 'لا توجد عملات متاحة. يرجى تهيئة بيانات النظام.';

  @override
  String get laTwjdAmlatMdafhHalyaAdghtAlaLidafhAmlh => 'لا توجد عملات مضافة حالياً. اضغط على + لإضافة عملة.';

  @override
  String get laTwjdAmwlat => 'لا توجد عمولات';

  @override
  String get laTwjdAmwlatMalqhMhddh => 'لا توجد عمولات معلقة محددة';

  @override
  String get laTwjdFwatyrMsthqhLhdhaAlamyl => 'لا توجد فواتير مستحقة لهذا العميل';

  @override
  String get laTwjdFwatyrMsthqhLhdhaAlmwrd => 'لا توجد فواتير مستحقة لهذا المورد';

  @override
  String get laTwjdMbyaatFyHdhhAlftrh => 'لا توجد مبيعات في هذه الفترة.';

  @override
  String get laTwjdMstwdaatMdafh => 'لا توجد مستودعات مضافة';

  @override
  String get laTwjdMaamlatBad => 'لا توجد معاملات بعد.';

  @override
  String get laTwjdMaamlatLltbaah => 'لا توجد معاملات للطباعة';

  @override
  String get laTwjdMaamlatMwkhra => 'لا توجد معاملات مؤخراً';

  @override
  String get laTwjdMntjat => 'لا توجد منتجات';

  @override
  String get laTwjdMntjatTtabqBhthk => 'لا توجد منتجات تطابق بحثك';

  @override
  String get laTwjdMntjatRakdh => 'لا توجد منتجات راكدة';

  @override
  String get laTwjdNtaej => 'لا توجد نتائج';

  @override
  String get laTwjdNtaejMtabqh => 'لا توجد نتائج مطابقة';

  @override
  String get laTwjdNskhAhtyatyhMhlyhHtaAlan => 'لا توجد نسخ احتياطية محلية حتى الآن';

  @override
  String get laTwjdWrdyatBad => 'لا توجد ورديات بعد';

  @override
  String get laYmknIdafhAsnafIlaFatwrhMbyaatGHyrMswdh => 'لا يمكن إضافة أصناف إلى فاتورة مبيعات غير مسودة';

  @override
  String get laYmknIdafhWhdhBnfsAsmAlwhdhAlasasyh => 'لا يمكن إضافة وحدة بنفس اسم الوحدة الأساسية';

  @override
  String get laYmknAkhtyarHsabReysy => 'لا يمكن اختيار حساب رئيسي';

  @override
  String get laYmknTadylAsnafFatwrhMshtryatGHyrMswdh => 'لا يمكن تعديل أصناف فاتورة مشتريات غير مسودة';

  @override
  String get laYmknTadylFatwrhMbyaatGHyrMswdhAstkhdmMrtjaaAwMst => 'لا يمكن تعديل فاتورة مبيعات غير مسودة. استخدم مرتجعاً أو مستند تصحيح بدلاً من التعديل المباشر.';

  @override
  String get laYmknTadylFatwrhMshtryatGHyrMswdhAstkhdmMstndTshy => 'لا يمكن تعديل فاتورة مشتريات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من التعديل المباشر.';

  @override
  String get laYmknHdhfAsnafMnFatwrhMbyaatGHyrMswdh => 'لا يمكن حذف أصناف من فاتورة مبيعات غير مسودة';

  @override
  String get laYmknHdhfAlmstwdaLanhYhtwyAlaMkhzwn => 'لا يمكن حذف المستودع لأنه يحتوي على مخزون.';

  @override
  String get laYmknHfzAlfatwrhAlamylTjawzAlhdAlaetmanyAlmsmwhBh => 'لا يمكن حفظ الفاتورة: العميل تجاوز الحد الائتماني المسموح به';

  @override
  String get laYwjdAsnafMdafhLlthwyl => 'لا يوجد أصناف مضافة للتحويل';

  @override
  String get laYwjdThwylatMdafhBad => 'لا يوجد تحويلات مضافة بعد.';

  @override
  String get laYwjdSjlatTdqyqBad => 'لا يوجد سجلات تدقيق بعد.';

  @override
  String get laYwjdQydMhasbyLhdhhAlfatwrh => 'لا يوجد قيد محاسبي لهذه الفاتورة';

  @override
  String get laYwjdMstkhdmwnBadAnsheHsabMswwlBklmhMrwrQwyhLlbda => 'لا يوجد مستخدمون بعد. أنشئ حساب مسؤول بكلمة مرور قوية للبدء.';

  @override
  String get laYwjdMntjatFyHdhhAlfeh => 'لا يوجد منتجات في هذه الفئة';

  @override
  String get laYwjdMndwbynMsjlyn => 'لا يوجد مندوبين مسجلين';

  @override
  String get laYwjdHdfLhdhhAlftrh => 'لا يوجد هدف لهذه الفترة';

  @override
  String get lghhAlttbyq => 'لغة التطبيق';

  @override
  String get lmTtmIdafhAsnafBad => 'لم تتم إضافة أصناف بعد';

  @override
  String get lmYtmAlathwrAlaAyAmlatBadAlthyeh => 'لم يتم العثور على أي عملات بعد التهيئة.';

  @override
  String get lmYtmAlathwrAlaAltfasyl => 'لم يتم العثور على التفاصيل';

  @override
  String get lmYtmThdydAyAsnafLlmrtja => 'لم يتم تحديد أي أصناف للمرتجع';

  @override
  String get lmYsjlAnsraf => 'لم يسجل انصراف';

  @override
  String get lwhhAlthkmAlreysy => 'لوحة التحكم الرئيسي';

  @override
  String get lystLdykSlahyhIdkhalAwTadylAldrybh => 'ليست لديك صلاحية إدخال أو تعديل الضريبة';

  @override
  String get mashAlbarkwd => 'ماسح الباركود';

  @override
  String get mblghAlbyaAwAlnqat => 'مبلغ البيع أو النقاط';

  @override
  String get mbyaatAltjzeh => 'مبيعات التجزئة';

  @override
  String get mbyaatAljmlh => 'مبيعات الجملة';

  @override
  String get mbyaatAlywm => 'مبيعات اليوم';

  @override
  String get mtakhr => 'متأخر';

  @override
  String get mtabah => 'متابعة';

  @override
  String get mtqdmh => 'متقدمة';

  @override
  String get mtwstAlahmyh => 'متوسط الأهمية';

  @override
  String get mthal10 => 'مثال: 10';

  @override
  String get mthal15 => 'مثال: 15';

  @override
  String get mthalIdhaKanAlkrtwn20HbhAdkhl20 => 'مثال: إذا كان الكرتون = 20 حبة، أدخل 20';

  @override
  String get mthlaUSDYERSAR => 'مثلاً: USD, YER, SAR';

  @override
  String get mjza => 'مجزأ';

  @override
  String get mhjwz => 'محجوز';

  @override
  String get mhswbh => 'محسوبة';

  @override
  String get mhwlLfatwrh => 'محول لفاتورة';

  @override
  String get mhwl => 'محوّل';

  @override
  String get mhwlLfatwrh_1 => 'محوّل لفاتورة';

  @override
  String get mkhzwn => 'مخزون';

  @override
  String get mdfwa => 'مدفوع';

  @override
  String get mdfwah => 'مدفوعة';

  @override
  String get mdfwahAlajr => 'مدفوعة الأجر';

  @override
  String get mdyr => 'مدير';

  @override
  String get mdyrAlmstwda => 'مدير المستودع';

  @override
  String get mdyrAlnzam => 'مدير النظام';

  @override
  String get mdyn => 'مدين';

  @override
  String get mrakzAltklfh => 'مراكز التكلفة';

  @override
  String get mrtja => 'مرتجع';

  @override
  String get mrtjaSHraa => 'مرتجع شراء';

  @override
  String get mrtjaMbyaat => 'مرتجع مبيعات';

  @override
  String get mrtjaMshtryat => 'مرتجع مشتريات';

  @override
  String get mrtjaatAlmbyaat => 'مرتجعات المبيعات';

  @override
  String get mrtjaatAlmshtryat => 'مرتجعات المشتريات';

  @override
  String get mrja => 'مرجع';

  @override
  String get mrhbaNwdAltwaslBkhswsAltlbat => 'مرحباً، نود التواصل بخصوص الطلبات.';

  @override
  String get mrhl => 'مرحّل';

  @override
  String get mrfwdh => 'مرفوضة';

  @override
  String get mrkzAltqaryr => 'مركز التقارير';

  @override
  String get mrkzTklfh => 'مركز تكلفة';

  @override
  String get msahhAmlAlatraf => 'مساحة عمل الأطراف';

  @override
  String get msahhAmlAlidarh => 'مساحة عمل الإدارة';

  @override
  String get msahhAmlAltqaryr => 'مساحة عمل التقارير';

  @override
  String get msahhAmlAlhsabat => 'مساحة عمل الحسابات';

  @override
  String get msahhAmlAlamlyat => 'مساحة عمل العمليات';

  @override
  String get msahhAmlAlmkhzwn => 'مساحة عمل المخزون';

  @override
  String get mstkhdm => 'مستخدم';

  @override
  String get mstwda => 'مستودع';

  @override
  String get mstwdaJdyd => 'مستودع جديد';

  @override
  String get mstwaAltsayr => 'مستوى التسعير';

  @override
  String get msh => 'مسح';

  @override
  String get mshAlbarkwd => 'مسح الباركود';

  @override
  String get mshBarkwdAwBhth => 'مسح باركود أو بحث...';

  @override
  String get mswdh => 'مسودة';

  @override
  String get msyratAlrwatb => 'مسيرات الرواتب';

  @override
  String get msharkh => 'مشاركة';

  @override
  String get msharkhAkhrNskhhAhtyatyh => 'مشاركة آخر نسخة احتياطية';

  @override
  String get mshtryatAlywm => 'مشتريات اليوم';

  @override
  String get mshtryatMnNqthBya => 'مشتريات من نقطة بيع';

  @override
  String get msaryfAkhra => 'مصاريف أخرى';

  @override
  String get msrwf => 'مصروف';

  @override
  String get mtlwb => 'مطلوب';

  @override
  String get maaynhAltbaah => 'معاينة الطباعة';

  @override
  String get matmd => 'معتمد';

  @override
  String get marfAlamyl => 'معرف العميل';

  @override
  String get malq => 'معلق';

  @override
  String get malwmatAlshrkh => 'معلومات الشركة';

  @override
  String get mghlqh => 'مغلقة';

  @override
  String get mftwhh => 'مفتوحة';

  @override
  String get mfswlhBfwasl => 'مفصولة بفواصل';

  @override
  String get mkafatNhayhAlkhdmh => 'مكافآت نهاية الخدمة';

  @override
  String get mlahzat => 'ملاحظات';

  @override
  String get mlahzatAkhtyary => 'ملاحظات (اختياري)';

  @override
  String get mlahzatAlfatwrh => 'ملاحظات الفاتورة';

  @override
  String get mlahzatNhaeyhLljrd => 'ملاحظات نهائية للجرد';

  @override
  String get mlahzhYmknTghyyrAlmstwdaWalfraMnSHashhNqthAlbyaAwA => 'ملاحظة: يمكن تغيير المستودع والفرع من شاشة نقطة البيع أو الفواتير';

  @override
  String get mlkhsAlhdwr => 'ملخص الحضور';

  @override
  String get mlkhsAlamwlat => 'ملخص العمولات';

  @override
  String get mlghah => 'ملغاة';

  @override
  String get mlgha => 'ملغى';

  @override
  String get mlghy => 'ملغي';

  @override
  String get mn => 'من';

  @override
  String get mnTarykh => 'من تاريخ';

  @override
  String get mnMstwda => 'من مستودع';

  @override
  String get mntj => 'منتج';

  @override
  String get mntjJdyd => 'منتج جديد';

  @override
  String get mntjat => 'منتجات';

  @override
  String get mndwbAlmbyaat => 'مندوب المبيعات';

  @override
  String get mndwbAam => 'مندوب عام';

  @override
  String get mndh => 'منذ ';

  @override
  String get mwafqAlyha => 'موافق عليها';

  @override
  String get mwafqh => 'موافقة';

  @override
  String get mwafqhAlaAlijazh => 'موافقة على الإجازة';

  @override
  String get mwrd => 'مورد';

  @override
  String get mwrdJdyd => 'مورد جديد';

  @override
  String get mwrdyn => 'موردين';

  @override
  String get mwrdynBdyn => 'موردين بدين';

  @override
  String get mwzf => 'موظف';

  @override
  String get mwzfGHyrMarwf => 'موظف غير معروف';

  @override
  String get myzanAlmrajah => 'ميزان المراجعة';

  @override
  String get mnjz => 'مُنجَز';

  @override
  String get nsbhAlinjaz => 'نسبة الإنجاز';

  @override
  String get nsbhAlsywlh => 'نسبة السيولة';

  @override
  String get nsbhAldrybh => 'نسبة الضريبة (%)';

  @override
  String get nsbhAlamwlh => 'نسبة العمولة (%)';

  @override
  String get nsbhAlhamsh => 'نسبة الهامش %';

  @override
  String get nshrAlmbyaat => 'نشر المبيعات';

  @override
  String get nshrAlmshtryat => 'نشر المشتريات';

  @override
  String get nshrMrtjaatAlmbyaat => 'نشر مرتجعات المبيعات';

  @override
  String get nshrMrtjaatAlmshtryat => 'نشر مرتجعات المشتريات';

  @override
  String get nsht => 'نشط';

  @override
  String get nzrhAamh => 'نظرة عامة';

  @override
  String get nam => 'نعم';

  @override
  String get nqatAlwlaa => 'نقاط الولاء';

  @override
  String get nqd => 'نقد';

  @override
  String get nqdbnk => 'نقد/بنك';

  @override
  String get nqda => 'نقداً';

  @override
  String get nqthAlbyaPOS => 'نقطة البيع (POS)';

  @override
  String get nhayhAlwrdyh => 'نهاية الوردية';

  @override
  String get nwaAlijazh => 'نوع الإجازة';

  @override
  String get nwaAlbarkwd => 'نوع الباركود: ';

  @override
  String get nwaAlhsab => 'نوع الحساب';

  @override
  String get nwaAlsjl => 'نوع السجل';

  @override
  String get nwaAlamlyh => 'نوع العملية';

  @override
  String get nwaAlamlyhWnwaAlhsabMtlwban => 'نوع العملية ونوع الحساب مطلوبان';

  @override
  String get nwaAlamyl => 'نوع العميل';

  @override
  String get hamshAlrbh => 'هامش الربح';

  @override
  String get hamshAlrbhAlijmaly => 'هامش الربح الإجمالي';

  @override
  String get hamshAlrbhAlsafy => 'هامش الربح الصافي';

  @override
  String get hamshAlrbhHsbAltsnyf => 'هامش الربح حسب التصنيف';

  @override
  String get hdfAlmbyaat => 'هدف المبيعات';

  @override
  String get hdhhAlfatwrhLystMswdhLdhlkLaYmknTadylhaMbashrhAstk => 'هذه الفاتورة ليست مسودة، لذلك لا يمكن تعديلها مباشرة. استخدم مرتجعاً أو مستند تصحيح عند الحاجة.';

  @override
  String get hdhhAlfatwrhLystMswdhLdhlkLaYmknTadylhaMbashrhAstk_1 => 'هذه الفاتورة ليست مسودة، لذلك لا يمكن تعديلها مباشرة. استخدم مستند تصحيح أو مرتجع عند الحاجة.';

  @override
  String get hdhhAlwhdhMwjwdhBalfal => 'هذه الوحدة موجودة بالفعل';

  @override
  String get hdhhHyAlamlhAlasasyh => 'هذه هي العملة الأساسية';

  @override
  String get hlAntMtakdMnIlghaaSndAlaetman => 'هل أنت متأكد من إلغاء سند الائتمان؟';

  @override
  String get hlAntMtakdMnHdhfHdhaAlmstwda => 'هل أنت متأكد من حذف هذا المستودع؟';

  @override
  String get hlTrydIlghaaHdhhAltlbyh => 'هل تريد إلغاء هذه الطلبية؟';

  @override
  String get hlTrydThwylHdhhAltlbyhLamrSHraaMnAlmwrd => 'هل تريد تحويل هذه الطلبية لأمر شراء من المورد؟';

  @override
  String get hlTrydThwylHdhhAltlbyhLfatwrhMbyaat => 'هل تريد تحويل هذه الطلبية لفاتورة مبيعات؟';

  @override
  String get hlTrydHdhfHdhhAltlbyhNhaeya => 'هل تريد حذف هذه الطلبية نهائياً؟';

  @override
  String get wahd => 'واحد';

  @override
  String get whdatAltabeh => 'وحدات التعبئة';

  @override
  String get wrqhBarkwd => 'ورقة باركود';

  @override
  String get wdaAltjzeh => 'وضع التجزئة';

  @override
  String get wdaAljmlh => 'وضع الجملة';

  @override
  String get wdaAlmrtjaat => 'وضع المرتجعات';

  @override
  String get yjbIdafhAsnafAwla => 'يجب إضافة أصناف أولاً';

  @override
  String get yjbAkhtyarAmylLlbyaAlajl => 'يجب اختيار عميل للبيع الآجل';

  @override
  String get yjbAkhtyarMwrdLlbyaAlajl => 'يجب اختيار مورد للبيع الآجل';

  @override
  String get yjbFthWrdyhAmlQblIjraaAmlyhByaNqdy => 'يجب فتح وردية عمل قبل إجراء عملية بيع نقدي';

  @override
  String get yrjaIdkhalArqamTslslWahdhAlaAlaql => 'يرجى إدخال أرقام تسلسل واحدة على الأقل';

  @override
  String get yrjaIdkhalAsmAlijazh => 'يرجى إدخال اسم الإجازة';

  @override
  String get yrjaIdkhalAsmAlamlh => 'يرجى إدخال اسم العملة';

  @override
  String get yrjaIdkhalAsmAlmstkhdm => 'يرجى إدخال اسم المستخدم';

  @override
  String get yrjaIdkhalAlkwd => 'يرجى إدخال الكود';

  @override
  String get yrjaIdkhalAlmblgh => 'يرجى إدخال المبلغ';

  @override
  String get yrjaIdkhalTwarykhShyhh => 'يرجى إدخال تواريخ صحيحة';

  @override
  String get yrjaIdkhalRqmAlbya => 'يرجى إدخال رقم البيع';

  @override
  String get yrjaIdkhalRqmShyh => 'يرجى إدخال رقم صحيح';

  @override
  String get yrjaIdkhalRqmTlbAlbya => 'يرجى إدخال رقم طلب البيع';

  @override
  String get yrjaIdkhalRmzAlamlh => 'يرجى إدخال رمز العملة';

  @override
  String get yrjaIdkhalSbbAlrfd => 'يرجى إدخال سبب الرفض';

  @override
  String get yrjaIdkhalSarSrfShyh => 'يرجى إدخال سعر صرف صحيح';

  @override
  String get yrjaIdkhalSHhrWsnhShyhyn => 'يرجى إدخال شهر وسنة صحيحين';

  @override
  String get yrjaIdkhalAddAyamShyh => 'يرجى إدخال عدد أيام صحيح';

  @override
  String get yrjaIdkhalMblghShyh => 'يرجى إدخال مبلغ صحيح';

  @override
  String get yrjaIdafhSnfWahdAlaAlaql => 'يرجى إضافة صنف واحد على الأقل';

  @override
  String get yrjaAkhtyarAlmntjWalmstwda => 'يرجى اختيار المنتج والمستودع';

  @override
  String get yrjaAkhtyarAlmwzf => 'يرجى اختيار الموظف';

  @override
  String get yrjaAkhtyarHsabTfsylyLltrhyl => 'يرجى اختيار حساب تفصيلي للترحيل';

  @override
  String get yrjaAkhtyarFatwrhWahdhAlaAlaql => 'يرجى اختيار فاتورة واحدة على الأقل';

  @override
  String get yrjaAkhtyarMstwdaLbdaAljrd => 'يرجى اختيار مستودع لبدء الجرد';

  @override
  String get yrjaAkhtyarNwaAlijazh => 'يرجى اختيار نوع الإجازة';

  @override
  String get yrjaTshyhAlakhtaaAltalyh => 'يرجى تصحيح الأخطاء التالية:';

  @override
  String get yrjaTshyhAlhqwlAlmalyhQblAlhfz => 'يرجى تصحيح الحقول المالية قبل الحفظ';

  @override
  String get yrjaMlaJmyaAlhqwlAlmtlwbh => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String posDiscountExceeds(Object max) {
    return 'Discount exceeds maximum $max';
  }

  @override
  String get posOriginalInvoiceNotFound => 'Original invoice not found';

  @override
  String posErrorSearchInvoice(Object error) {
    return 'Error searching invoice: $error';
  }

  @override
  String get posNoReturnItemsSelected => 'No return items selected';

  @override
  String posErrorProcessReturn(Object error) {
    return 'Error processing return: $error';
  }

  @override
  String get posProductNotFound => 'Product not found';

  @override
  String posProductOutOfStock(Object name) {
    return '$name is out of stock';
  }

  @override
  String posErrorAddProduct(Object error) {
    return 'Error adding product: $error';
  }

  @override
  String posQuantityExceedsStock(Object quantity, Object stock) {
    return 'Quantity $quantity exceeds available stock $stock';
  }

  @override
  String get posMustOpenShift => 'You must open a shift first';

  @override
  String get posCreditLimitExceeded => 'Customer credit limit exceeded';

  @override
  String get posLoyaltyReason => 'Loyalty program';
}
