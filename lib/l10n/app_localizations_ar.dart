import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق المحاسبة';

  @override
  String get home => 'الرئيسية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get pos => 'نقطة البيع';

  @override
  String get products => 'المنتجات';

  @override
  String get categories => 'الفئات';

  @override
  String get customers => 'العملاء';

  @override
  String get suppliers => 'الموردين';

  @override
  String get purchases => 'المشتريات';

  @override
  String get returns => 'المرتجعات';

  @override
  String get reports => 'التقارير';

  @override
  String get sales => 'سجل المبيعات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get backupDb => 'نسخ احتياطي';

  @override
  String get welcome => 'مرحباً';

  @override
  String get add => 'إضافة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get accountingSystem => 'نظام المحاسبة';

  @override
  String get loginButton => 'دخول';

  @override
  String get loginHint => 'أدخل بيانات المستخدم المسجلة';

  @override
  String get invalidCredentials => 'بيانات الدخول غير صحيحة';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get seedProducts => 'إضافة بيانات تجريبية';

  @override
  String get viewSales => 'عرض المبيعات';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get totalSales => 'إجمالي المبيعات';

  @override
  String get todaySales => 'مبيعات اليوم';

  @override
  String get revenue => 'إيراد';

  @override
  String get pendingSync => 'في انتظار المزامنة';

  @override
  String get seedDataAdded => 'تم إضافة البيانات التجريبية!';

  @override
  String get wholesale => 'جملة';

  @override
  String get clearCart => 'مسح السلة';

  @override
  String get cartEmpty => 'السلة فارغة';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get discount => 'الخصم';

  @override
  String get tax => 'الضريبة';

  @override
  String get total => 'الإجمالي';

  @override
  String get proceedToCheckout => 'إتمام عملية البيع';

  @override
  String get completePayment => 'إكمال الدفع';

  @override
  String get selectCustomer => 'اختر عميل (اختياري)';

  @override
  String get cashPayment => 'دفع نقدي';

  @override
  String get creditSale => 'بيع آجل';

  @override
  String get selectCustomerError => 'يرجى اختيار عميل للبيع الآجل';

  @override
  String get customerNameHint => 'ابدأ الكتابة للبحث أو إضافة عميل جديد';

  @override
  String get addCustomerForCredit => 'إضافة عميل جديد للبيع الآجل';

  @override
  String get searchProducts => 'البحث عن منتجات...';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get skuLabel => 'باركود';

  @override
  String get stockLabel => 'المخزون';

  @override
  String get stock => 'المخزون';

  @override
  String get category => 'الفئة';

  @override
  String get price => 'السعر';

  @override
  String get productAdded => 'تم إضافة المنتج بنجاح';

  @override
  String get productUpdated => 'تم تحديث المنتج بنجاح';

  @override
  String get searchCustomers => 'البحث عن عملاء...';

  @override
  String get noCustomersFound => 'لم يتم العثور على عملاء';

  @override
  String get noPhone => 'لا يوجد رقم هاتف';

  @override
  String balanceLabel(Object balance) {
    return 'الرصيد: $balance';
  }

  @override
  String limitLabel(Object limit) {
    return 'الحد: $limit';
  }

  @override
  String get customerAdded => 'تم إضافة العميل بنجاح';

  @override
  String get customerUpdated => 'تم تحديث العميل بنجاح';

  @override
  String get addCustomer => 'إضافة عميل';

  @override
  String get editCustomer => 'تعديل عميل';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get enterNameError => 'يرجى إدخال الاسم';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get creditLimitLabel => 'حد الائتمان';

  @override
  String get totalCustomers => 'إجمالي العملاء';

  @override
  String get searchSuppliers => 'البحث عن موردين...';

  @override
  String get noSuppliersFound => 'لم يتم العثور على موردين';

  @override
  String get noContactPerson => 'لا يوجد مسؤول اتصال';

  @override
  String get supplierAdded => 'تم إضافة المورد بنجاح';

  @override
  String get supplierUpdated => 'تم تحديث المورد بنجاح';

  @override
  String get addSupplier => 'إضافة مورد';

  @override
  String get editSupplier => 'تعديل مورد';

  @override
  String get supplierName => 'اسم المورد';

  @override
  String get contactPerson => 'مسؤول الاتصال';

  @override
  String get purchasesHistory => 'سجل المشتريات';

  @override
  String get noPurchases => 'لا يوجد مشتريات مسجلة بعد.';

  @override
  String invoiceLabel(Object invoice) {
    return 'فاتورة: $invoice';
  }

  @override
  String supplierLabel(Object supplier) {
    return 'المورد: $supplier';
  }

  @override
  String dateLabel(Object date) {
    return 'التاريخ: $date';
  }

  @override
  String get unknown => 'غير معروف';

  @override
  String get newPurchase => 'مشتريات جديدة';

  @override
  String get purchaseDetails => 'تفاصيل المشتريات';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get totalPaid => 'إجمالي المدفوع';

  @override
  String get newPurchaseInvoice => 'فاتورة مشتريات جديدة';

  @override
  String get selectSupplier => 'اختر مورد';

  @override
  String get invoiceNumberLabel => 'رقم الفاتورة';

  @override
  String get noProductsAdded => 'لم يتم إضافة منتجات بعد.';

  @override
  String qtyAtPrice(Object price, Object qty) {
    return 'الكمية: $qty @ $price';
  }

  @override
  String get savePurchase => 'حفظ المشتريات';

  @override
  String get purchaseSaved => 'تم حفظ المشتريات بنجاح!';

  @override
  String get addProductToPurchase => 'إضافة منتج للمشتريات';

  @override
  String get productLabel => 'المنتج';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get buyPriceLabel => 'سعر الشراء';

  @override
  String get noSalesFound => 'لم يتم العثور على مبيعات';

  @override
  String saleIdLabel(Object id) {
    return 'بيعة رقم $id';
  }

  @override
  String get synced => 'تم المزامنة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get saleDetails => 'تفاصيل البيع';

  @override
  String get newSale => 'بيع جديد';

  @override
  String get returnsManagement => 'إدارة المرتجعات';

  @override
  String get salesReturns => 'مرتجع مبيعات';

  @override
  String get purchaseReturns => 'مرتجع مشتريات';

  @override
  String get newReturn => 'مرتجع جديد';

  @override
  String get noReturnsFound => 'لم يتم العثور على مرتجعات.';

  @override
  String returnIdLabel(Object id) {
    return 'رقم المرتجع: $id';
  }

  @override
  String amountReturnedLabel(Object amount) {
    return 'المبلغ: $amount';
  }

  @override
  String get createReturn => 'إنشاء مرتجع';

  @override
  String get fromSale => 'من بيعة';

  @override
  String get fromPurchase => 'من مشتريات';

  @override
  String txLabel(Object id) {
    return 'رقم العملية: $id';
  }

  @override
  String get financialReports => 'التقارير المالية';

  @override
  String get totalProfitLoss => 'إجمالي الأرباح/الخسائر';

  @override
  String get totalSalesRevenue => 'إجمالي المبيعات (الإيرادات)';

  @override
  String get totalPurchasesExpenses => 'إجمالي المشتريات (المصاريف)';

  @override
  String get grossProfit => 'إجمالي الربح';

  @override
  String get outstandingBalances => 'الأرصدة المستحقة';

  @override
  String get customerDebts => 'ديون العملاء';

  @override
  String get supplierDebts => 'ديون الموردين';

  @override
  String get inventoryValue => 'قيمة المخزون';

  @override
  String get totalStockValue => 'إجمالي قيمة المخزون (بسعر الشراء)';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get editProduct => 'تعديل منتج';

  @override
  String get productNameLabel => 'اسم المنتج';

  @override
  String get skuBarcodeLabel => 'باركود';

  @override
  String get enterSkuError => 'يرجى إدخال الباركود';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get sellPriceLabel => 'سعر البيع';

  @override
  String get initialStockLabel => 'المخزون الأولي';

  @override
  String get payAmount => 'دفع مبلغ';

  @override
  String get paymentAmount => 'مبلغ الدفع';

  @override
  String get paymentSuccess => 'تم تسجيل الدفع بنجاح';

  @override
  String get enterAmountError => 'يرجى إدخال مبلغ صحيح';

  @override
  String get scanBarcode => 'مسح الباركود';

  @override
  String get inventoryReports => 'تقارير المخزون';

  @override
  String get lowStockProducts => 'منتجات منخفضة المخزون';

  @override
  String get noLowStockProducts => 'لا يوجد منتجات منخفضة المخزون.';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get alertLimit => 'حد التنبيه';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get lowStockItems => 'منتجات منخفضة المخزون';

  @override
  String get noLowStockItems => 'لا يوجد منتجات منخفضة';

  @override
  String get stockLevel => 'مستوى المخزون';

  @override
  String get items => 'منتجات';

  @override
  String get searchByInvoiceId => 'بحث برقم الفاتورة';

  @override
  String get invoiceNotFound => 'الفاتورة غير موجودة';

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get categoryCode => 'كود الفئة';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل فئة';

  @override
  String get all => 'الكل';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryAdded => 'تم إضافة الفئة بنجاح';

  @override
  String get categoryUpdated => 'تم تحديث الفئة بنجاح';

  @override
  String get enterProductName => 'أدخل اسم المنتج';

  @override
  String get sku => 'الباركود';

  @override
  String get enterSku => 'أدخل الباركود';

  @override
  String get buyPrice => 'سعر الشراء';

  @override
  String get sellPrice => 'سعر البيع';

  @override
  String get wholesalePrice => 'سعر الجملة';

  @override
  String get costCenters => 'مراكز التكلفة';

  @override
  String get addCostCenter => 'إضافة مركز تكلفة';

  @override
  String get code => 'الكود';

  @override
  String get noCostCentersFound => 'لم يتم العثور على مراكز تكلفة';

  @override
  String get accounting => 'المحاسبة';

  @override
  String get chartOfAccounts => 'شجرة الحسابات';

  @override
  String get generalLedger => 'دفتر الأستاذ';

  @override
  String get trialBalance => 'ميزان المراجعة';

  @override
  String get accountName => 'اسم الحساب';

  @override
  String get accountCode => 'كود الحساب';

  @override
  String get accountType => 'نوع الحساب';

  @override
  String get balance => 'الرصيد';

  @override
  String get debit => 'مدين';

  @override
  String get credit => 'آجل';

  @override
  String get asset => 'أصل';

  @override
  String get liability => 'التزام';

  @override
  String get equity => 'حقوق الملكية';

  @override
  String get expense => 'مصروف';

  @override
  String get addAccount => 'إضافة حساب';

  @override
  String get editAccount => 'تعديل حساب';

  @override
  String get isHeader => 'هل هو حساب رئيسي؟';

  @override
  String get parentAccount => 'الحساب الأب';

  @override
  String get balanceSheet => 'الميزانية العمومية';

  @override
  String get incomeStatement => 'قائمة الدخل';

  @override
  String get expenses => 'المصاريف';

  @override
  String get inventoryAudit => 'جرد المخزون';

  @override
  String get userRoles => 'صلاحيات المستخدمين';

  @override
  String get thermalPrinting => 'الطباعة الحرارية';

  @override
  String get printReceipt => 'طباعة الإيصال';

  @override
  String get fixedAssets => 'الأصول الثابتة';

  @override
  String get cloudSync => 'المزامنة السحابية';

  @override
  String get backupRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get totalAssets => 'إجمالي الأصول';

  @override
  String get totalLiabilities => 'إجمالي الالتزامات';

  @override
  String get totalEquity => 'إجمالي حقوق الملكية';

  @override
  String get netIncome => 'صافي الدخل';

  @override
  String get operatingExpenses => 'المصاريف التشغيلية';

  @override
  String get saveSuccess => 'تم الحفظ بنجاح';

  @override
  String get shiftManagement => 'إدارة الوردية';

  @override
  String get openShift => 'فتح وردية';

  @override
  String get closeShift => 'إغلاق الوردية';

  @override
  String get openingCash => 'رصيد الافتتاح';

  @override
  String get closingCash => 'رصيد الإغلاق';

  @override
  String get expectedCash => 'الرصيد المتوقع';

  @override
  String get difference => 'الفارق';

  @override
  String get shiftOpened => 'تم فتح الوردية بنجاح';

  @override
  String get shiftClosed => 'تم إغلاق الوردية بنجاح';

  @override
  String get noOpenShift => 'لا توجد وردية مفتوحة';

  @override
  String get currentShift => 'الوردية الحالية';

  @override
  String get manualJournalEntries => 'قيود يومية يدوية';

  @override
  String get financialYearClosing => 'إغلاق السنة المالية';

  @override
  String get reconciliation => 'تسوية بنكية/نقدية';

  @override
  String get auditLog => 'سجل التدقيق';

  @override
  String get vatReturn => 'إقرار ضريبة القيمة المضافة';

  @override
  String get cashFlow => 'قائمة التدفقات النقدية';

  @override
  String get selectAccount => 'اختر حساب';

  @override
  String get actualBalance => 'الرصيد الفعلي';

  @override
  String get bookBalance => 'الرصيد الدفتري';

  @override
  String get notes => 'ملاحظات';

  @override
  String get reconciliationAdjustment => 'تسوية الفرق';

  @override
  String get cashOverShortAccount => 'حساب عجز وزيادة الصندوق';

  @override
  String get selectAccountError => 'يرجى اختيار حساب';

  @override
  String get enterActualBalanceError => 'يرجى إدخال الرصيد الفعلي';

  @override
  String get reconciliationDifference => 'فرق التسوية';

  @override
  String get vatOnSales => 'ضريبة المخرجات (المبيعات)';

  @override
  String get vatOnPurchases => 'ضريبة المدخلات (المشتريات)';

  @override
  String get netVatPayable => 'صافي الضريبة المستحقة';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة للفترة المختارة';

  @override
  String get selectDateRange => 'اختر الفترة الزمنية';

  @override
  String get adminDashboard => 'لوحة تحكم المشرف';

  @override
  String get welcomeAdmin => 'مرحباً بك أيها المشرف';

  @override
  String get adminDashboardDescription => 'إدارة عمليات السوبر ماركت الخاصة بك بكل سهولة.';

  @override
  String get manageStaff => 'إدارة الموظفين';

  @override
  String get viewReports => 'عرض التقارير';

  @override
  String get asOf => 'اعتبارًا من';

  @override
  String get balanceSheetBalanced => 'الأصول = الخصوم + حقوق الملكية';

  @override
  String get balanceSheetNotBalanced => 'الميزانية العمومية غير متوازنة!';

  @override
  String get operatingActivities => 'الأنشطة التشغيلية';

  @override
  String get netCashFromOperating => 'صافي النقد من الأنشطة التشغيلية';

  @override
  String get investingActivities => 'الأنشطة الاستثمارية';

  @override
  String get netCashFromInvesting => 'صافي النقد من الأنشطة الاستثمارية';

  @override
  String get financingActivities => 'الأنشطة التمويلية';

  @override
  String get netCashFromFinancing => 'صافي النقد من الأنشطة التمويلية';

  @override
  String get netChangeInCash => 'صافي التغير في النقد';

  @override
  String get beginningCashBalance => 'رصيد النقد أول المدة';

  @override
  String get endingCashBalance => 'رصيد النقد آخر المدة';

  @override
  String get assets => 'الأصول';

  @override
  String get liabilities => 'الالتزامات';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get totalExpense => 'إجمالي المصاريف';

  @override
  String get days => 'أيام';

  @override
  String get noPurchasesFound => 'لم يتم العثور على مشتريات';

  @override
  String get walkInSupplier => 'مورد نقدي';

  @override
  String get currencySymbol => 'ر.س';

  @override
  String get backupAndSync => 'النسخ الاحتياطي والمزامنة';

  @override
  String get backupNow => 'نسخ احتياطي الآن';

  @override
  String get localBackup => 'نسخ احتياطي محلي';

  @override
  String get cloudBackup => 'نسخ احتياطي سحابي';

  @override
  String get restoreFromCloud => 'استعادة من السحابة';

  @override
  String get noCloudBackups => 'لا يوجد نسخ احتياطية سحابية';

  @override
  String get restore => 'استعادة';

  @override
  String get restoreFromLocalFile => 'استعادة من ملف محلي';

  @override
  String get pickBackupFile => 'اختر ملف النسخة الاحتياطية';

  @override
  String get confirmRestore => 'تأكيد الاستعادة';

  @override
  String get restoreWarning => 'الاستعادة ستؤدي إلى مسح البيانات الحالية. هل أنت متأكد؟';

  @override
  String get simplifiedTaxInvoice => 'فاتورة ضريبية مبسطة';

  @override
  String vatNumber(Object vatNumber) {
    return 'الرقم الضريبي: $vatNumber';
  }

  @override
  String invoiceNumber(Object invoiceNumber) {
    return 'رقم الفاتورة: $invoiceNumber';
  }

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get date => 'التاريخ';

  @override
  String get supplier => 'المورد';

  @override
  String get cash => 'نقدي';

  @override
  String get sale => 'بيعة';

  @override
  String get purchase => 'مشتريات';

  @override
  String get purchaseId => 'رقم المشتريات';

  @override
  String get totalReturnAmount => 'إجمالي مبلغ المرتجع';

  @override
  String get purchaseNotFound => 'المشتريات غير موجودة';

  @override
  String get thankYou => 'شكراً لتعاملكم معنا!';

  @override
  String get closeFinancialYear => 'إغلاق السنة المالية';

  @override
  String get manualEntry => 'قيد يدوي';

  @override
  String get staffManagement => 'إدارة الموظفين';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get addUser => 'إضافة مستخدم';

  @override
  String get editUser => 'تعديل مستخدم';

  @override
  String get deleteUser => 'حذف مستخدم';

  @override
  String confirmDeleteUser(Object name) {
    return 'هل أنت متأكد من حذف المستخدم $name؟';
  }

  @override
  String get leaveEmptyToKeep => 'اتركه فارغاً للحفاظ على كلمة المرور الحالية';

  @override
  String get role => 'الدور/الصلاحية';

  @override
  String get customerStatement => 'كشف حساب عميل';

  @override
  String get noTransactionsFound => 'لم يتم العثور على عمليات';

  @override
  String get payment => 'دفعة';

  @override
  String get cart => 'السلة';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get allChangesSynced => 'تم مزامنة جميع التغييرات';

  @override
  String unsyncedChanges(Object count) {
    return '$count تغييرات غير متزامنة';
  }

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String lastSync(Object time) {
    return 'آخر مزامنة: $time';
  }

  @override
  String get name => 'الاسم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get status => 'الحالة';

  @override
  String get warehouse => 'المستودع';

  @override
  String get batchNumber => 'رقم الدفعة';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get draft => 'مسودة';

  @override
  String get ordered => 'مطلوب';

  @override
  String get received => 'مستلم';

  @override
  String get cancelled => 'ملغي';

  @override
  String get selectWarehouse => 'اختر المستودع';

  @override
  String get noWarehousesFound => 'لم يتم العثور على مستودعات';

  @override
  String get addWarehouse => 'إضافة مستودع';

  @override
  String get warehouseName => 'اسم المستودع';

  @override
  String get errorLoadingData => 'خطأ في تحميل البيانات';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get whatWouldYouLikeToDo => 'ماذا تود أن تفعل؟';

  @override
  String get downloadPdfInvoice => 'تحميل الفاتورة PDF';

  @override
  String get done => 'تم';

  @override
  String get vatReport => 'تقرير ضريبة القيمة المضافة';

  @override
  String get vatSummary => 'ملخص الضريبة';

  @override
  String get totalOutputVat => 'إجمالي ضريبة المخرجات';

  @override
  String get totalInputVat => 'إجمالي ضريبة المدخلات';

  @override
  String get noItemsFound => 'لم يتم العثور على أصناف';

  @override
  String get unknownProduct => 'منتج غير معروف';

  @override
  String get viewInvoice => 'عرض الفاتورة';

  @override
  String get confirmDeleteCategory => 'هل أنت متأكد من حذف هذه الفئة؟ سيؤدي هذا إلى منع الوصول إلى المنتجات المرتبطة بها.';

  @override
  String get categoryHasProductsError => 'لا يمكن حذف الفئة لأنها مرتبطة بمنتجات موجودة.';

  @override
  String get deleteCategory => 'حذف فئة';

  @override
  String get customerStatementTooltip => 'كشف حساب';

  @override
  String get newPurchaseReturn => 'مرتجع مشتريات جديد';

  @override
  String get selectPurchase => 'اختر مشتريات';

  @override
  String get selectAPurchaseToContinue => 'اختر مشتريات للمتابعة';

  @override
  String get processReturn => 'تنفيذ المرتجع';

  @override
  String get returnProcessedSuccessfully => 'تم إتمام المرتجع بنجاح';

  @override
  String get noReturnsYet => 'لا يوجد مرتجعات بعد';

  @override
  String get newSalesReturn => 'مرتجع مبيعات جديد';

  @override
  String get selectSale => 'اختر بيعة';

  @override
  String get failedToSaveProduct => 'فشل حفظ المنتج';

  @override
  String get failedToSaveCategory => 'فشل حفظ الفئة';

  @override
  String get failedToDeleteProduct => 'فشل حذف المنتج';

  @override
  String deleteProductConfirmation(Object productName) {
    return 'هل أنت متأكد أنك تريد حذف $productName؟';
  }

  @override
  String get failedToSavePurchase => 'فشل حفظ المشتريات';

  @override
  String get selectASaleToContinue => 'اختر بيعة للمتابعة';

  @override
  String get unit => 'الوحدة';

  @override
  String get cartonUnit => 'وحدة الكرتون';

  @override
  String get piecesPerCarton => 'عدد القطع في الكرتون';

  @override
  String get baseUnit => 'الوحدة الأساسية';

  @override
  String get isCarton => 'كرتون؟';

  @override
  String get accountsPayable => 'الذمم الدائنة';

  @override
  String get apInvoices => 'فواتير الذمم الدائنة';

  @override
  String get supplierLedger => 'كشف حساب المورد';

  @override
  String get newAPInvoice => 'فاتورة ذمم دائنة جديدة';

  @override
  String get invoiceDate => 'تاريخ الفاتورة';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get totalAmount => 'إجمالي المبلغ';

  @override
  String get taxAmount => 'مبلغ الضريبة';

  @override
  String get paidAmount => 'المبلغ المدفوع';

  @override
  String get apInvoiceAdded => 'تم إضافة فاتورة الذمم الدائنة بنجاح';

  @override
  String get accountsReceivable => 'الذمم المدينة';

  @override
  String get arInvoices => 'فواتير الذمم المدينة';

  @override
  String get customerLedger => 'كشف حساب العميل';

  @override
  String get newARInvoice => 'فاتورة ذمم مدينة جديدة';

  @override
  String get arInvoiceAdded => 'تم إضافة فاتورة الذمم المدينة بنجاح';

  @override
  String get agingReport => 'تقرير أعمار الديون';

  @override
  String get current => 'حالياً';

  @override
  String get days30 => '30 يوم';

  @override
  String get days60 => '60 يوم';

  @override
  String get days90Plus => '90+ يوم';

  @override
  String get totalDue => 'إجمالي المستحق';

  @override
  String get selectType => 'اختر النوع';

  @override
  String get cashFlowForecast => 'توقعات التدفق النقدي';

  @override
  String get inflow => 'التدفقات الداخلة (AR)';

  @override
  String get outflow => 'التدفقات الخارجة (AP)';

  @override
  String get netCash => 'صافي النقد';

  @override
  String get next30Days => '30 يوم القادمة';

  @override
  String get next60Days => '60 يوم القادمة';

  @override
  String get next90Days => '90 يوم القادمة';

  @override
  String get period => 'الفترة';

  @override
  String get noItemsSelected => 'لم يتم اختيار أي أصناف';

  @override
  String get deleteCustomer => 'حذف العميل';

  @override
  String get deleteSupplier => 'حذف المورد';

  @override
  String confirmDeleteCustomer(Object customerName) {
    return 'هل أنت متأكد من حذف العميل $customerName؟';
  }

  @override
  String confirmDeleteSupplier(Object supplierName) {
    return 'هل أنت متأكد من حذف المورد $supplierName؟';
  }

  @override
  String get customerDeleted => 'تم حذف العميل';

  @override
  String get supplierDeleted => 'تم حذف المورد';

  @override
  String get failedToDeleteCustomer => 'فشل حذف العميل';

  @override
  String get failedToDeleteSupplier => 'فشل حذف المورد';

  @override
  String get manufacturing => 'التصنيع';

  @override
  String get productionOrders => 'أوامر الإنتاج';

  @override
  String get bomManagement => 'إدارة BOM';

  @override
  String get createOrder => 'إنشاء أمر';

  @override
  String get plannedQuantity => 'الكمية المخططة';

  @override
  String get productionOrderCreated => 'تم إنشاء أمر الإنتاج بنجاح';

  @override
  String get complete => 'إكمال';

  @override
  String get bom => 'قائمة المواد (BOM)';

  @override
  String get executeAssembly => 'تنفيذ التجميع';

  @override
  String get assemblySuccess => 'تم تنفيذ التجميع بنجاح';

  @override
  String get finishedProduct => 'منتج تام الصنع';

  @override
  String get rawMaterials => 'المواد الخام';

  @override
  String get bankReconciliation => 'تسوية البنك';

  @override
  String get autoBreakService => 'خدمة التفكيك التلقائي';

  @override
  String get unitHierarchy => 'هرمية الوحدات';

  @override
  String get addUnit => 'إضافة وحدة';

  @override
  String get removeUnit => 'إزالة وحدة';

  @override
  String get unitName => 'اسم الوحدة';

  @override
  String get unitFactor => 'معامل الوحدة';

  @override
  String get returnMode => 'وضع المرتجعات';

  @override
  String get returnFromSale => 'إرجاع من فاتورة';

  @override
  String get originalSaleReference => 'رقم الفاتورة الأصلية';

  @override
  String get searchSale => 'بحث عن فاتورة';

  @override
  String get returnItem => 'صنف مرتجع';

  @override
  String get returnQuantity => 'كمية الإرجاع';

  @override
  String get returnReason => 'سبب الإرجاع';

  @override
  String get returnSuccess => 'تم تنفيذ المرتجع بنجاح';

  @override
  String get totalRefund => 'إجمالي المرتجع';

  @override
  String get cancelReturn => 'إلغاء المرتجع';

  @override
  String get unmatchedTransactions => 'المعاملات غير المسوّاة';

  @override
  String get reconcileSelected => 'تسوية المحدد';

  @override
  String get autoReconcile => 'تسوية تلقائية';

  @override
  String get reconcileAll => 'تسوية الكل';

  @override
  String get tolerance => 'التحمّل';

  @override
  String get noUnmatchedTransactions => 'لا توجد معاملات غير مسوّاة';

  @override
  String get accountingPeriods => 'الفترات المحاسبية';

  @override
  String get autoGenerate => 'توليد تلقائي';

  @override
  String get cancelAutoGeneration => 'إلغاء التوليد التلقائي';

  @override
  String get periodName => 'اسم الفترة';

  @override
  String get examplePeriodName => 'مثال: يناير 2026';

  @override
  String get startDate => 'تاريخ البداية';

  @override
  String get endDate => 'تاريخ النهاية';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get existingPeriods => 'الفترات الموجودة';

  @override
  String get noAccountingPeriods => 'لا توجد فترات محاسبية';

  @override
  String get closePeriod => 'إغلاق';

  @override
  String get openPeriod => 'فتح';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get periodAddedSuccessfully => 'تم إضافة الفترة بنجاح';

  @override
  String get confirmClosePeriod => 'تأكيد إغلاق الفترة';

  @override
  String get closePeriodMessage => 'سيتم ترحيل الأرباح إلى الأرباح المحتجزة.';

  @override
  String get confirmGeneric => 'تأكيد';

  @override
  String get failedToClosePeriod => 'فشل في إغلاق الفترة';

  @override
  String get failedToReopenPeriod => 'فشل في إعادة فتح الفترة';

  @override
  String get cannotDeleteClosedPeriod => 'لا يمكن حذف فترة مغلقة';

  @override
  String get cannotDeletePeriodWithEntries => 'لا يمكن حذف الفترة: توجد قيود محاسبية مسجلة ضمن هذه الفترة';

  @override
  String get periodDeleted => 'تم حذف الفترة';

  @override
  String get createAutoPeriods => 'إنشاء فترات محاسبية تلقائية';

  @override
  String get year => 'السنة';

  @override
  String get periodType => 'نوع الفترة';

  @override
  String get monthly => 'شهرية (12 فترة)';

  @override
  String get quarterly => 'ربع سنوية (4 فترات)';

  @override
  String get yearly => 'سنوية (فترة واحدة)';

  @override
  String get autoPeriodInfo => 'سيتم إنشاء الفترات تلقائياً بناءً على الاختيار.';

  @override
  String periodsCreated(Object count) {
    return 'تم إنشاء $count فترات محاسبية بنجاح';
  }

  @override
  String failedToCreatePeriods(Object error) {
    return 'فشل في إنشاء الفترات: $error';
  }

  @override
  String get reopenPeriod => 'إعادة فتح الفترة';

  @override
  String get addPeriod => 'إضافة فترة';

  @override
  String get addManualPeriod => 'إضافة فترة يدوية';

  @override
  String get manualJournalEntry => 'قيد يومية يدوي';

  @override
  String get addAccountToEntry => 'إضافة حساب للقيد';

  @override
  String get entryDescription => 'وصف القيد العام';

  @override
  String get entryDate => 'تاريخ القيد';

  @override
  String get account => 'الحساب';

  @override
  String get amount => 'المبلغ';

  @override
  String get costCenter => 'مركز التكلفة';

  @override
  String get noCostCenter => 'بدون مركز';

  @override
  String get saveAndPost => 'حفظ وترحيل';

  @override
  String get entryNotBalanced => 'القيد غير متزن';

  @override
  String get pleaseEnterDescription => 'يرجى إدخال وصف القيد';

  @override
  String get cannotPostToClosedPeriod => 'لا يمكن الترحيل لفترة محاسبية مغلقة';

  @override
  String pleaseSelectAccountForLine(Object lineNumber) {
    return 'يرجى اختيار حساب للسطر رقم $lineNumber';
  }

  @override
  String lineCannotHaveDebitAndCredit(Object lineNumber) {
    return 'لا يمكن أن يحتوي السطر رقم $lineNumber على مدين ودائن معاً';
  }

  @override
  String lineHasAccountWithoutAmount(Object lineNumber) {
    return 'السطر رقم $lineNumber يحتوي على حساب بدون قيمة مدينة أو دائنة';
  }

  @override
  String get entrySavedAndPosted => 'تم حفظ وترحيل القيد بنجاح';

  @override
  String failedToSaveEntry(Object error) {
    return 'فشل حفظ القيد: $error';
  }

  @override
  String get recurringEntries => 'القيود المحاسبية الدورية';

  @override
  String get executeDueEntries => 'تنفيذ القيود المستحقة';

  @override
  String get addRecurringEntry => 'إضافة قيد دوري جديد';

  @override
  String get noRecurringEntries => 'لا توجد قيود دورية';

  @override
  String get tapToAddRecurringEntry => 'اضغط + لإضافة قيد دوري جديد';

  @override
  String get dailyFreq => 'يومي';

  @override
  String get weeklyFreq => 'أسبوعي';

  @override
  String get biweeklyFreq => 'كل أسبوعين';

  @override
  String get monthlyFreq => 'شهري';

  @override
  String get quarterlyFreq => 'ربع سنوي';

  @override
  String get yearlyFreq => 'سنوي';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusPaused => 'متوقف';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusUnknown => 'غير معروف';

  @override
  String fromToAccounts(Object creditAccount, Object debitAccount) {
    return 'من: $debitAccount إلى: $creditAccount';
  }

  @override
  String nextExecutionDate(Object date) {
    return 'التنفيذ التالي: $date';
  }

  @override
  String executedCount(Object count, Object total) {
    return 'المنفّذ: $count/$total';
  }

  @override
  String executedCountNoLimit(Object count) {
    return 'المنفّذ: $count';
  }

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'استئناف';

  @override
  String get executeNow => 'تنفيذ الآن';

  @override
  String get executionHistory => 'سجل التنفيذ';

  @override
  String get confirmDeleteTitle => 'تأكيد الحذف';

  @override
  String confirmDeleteRecurringEntry(Object entryName) {
    return 'هل أنت متأكد من حذف \"$entryName\"?';
  }

  @override
  String get entryName => 'اسم القيد';

  @override
  String get debitAccountCode => 'كود حساب المدين';

  @override
  String get creditAccountCode => 'كود حساب الدائن';

  @override
  String get frequency => 'التكرار';

  @override
  String get referenceType => 'نوع المرجع';

  @override
  String get expenseType => 'مصروف';

  @override
  String get revenueType => 'إيراد';

  @override
  String get customType => 'مخصص';

  @override
  String get close => 'إغلاق';

  @override
  String executionHistoryFor(Object name) {
    return 'سجل التنفيذ - $name';
  }

  @override
  String get noExecutionHistory => 'لا يوجد سجل تنفيذ';

  @override
  String get entryExecutedSuccessfully => 'تم تنفيذ القيد بنجاح';

  @override
  String get pleaseFillRequiredFields => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String executionResult(Object fail, Object success) {
    return 'تم التنفيذ: $success نجح، $fail فشل';
  }

  @override
  String errorWithMessage(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get cashReceiptVoucher => 'سند قبض نقدي';

  @override
  String get cashPaymentVoucher => 'سند صرف نقدي';

  @override
  String get receiptIn => 'قبض (In)';

  @override
  String get paymentOut => 'صرف (Out)';

  @override
  String get creditAccountSource => 'الحساب الدائن (المصدر)';

  @override
  String get debitAccountEntity => 'الحساب المدين (الجهة)';

  @override
  String get categoryHint => 'التصنيف (مثلاً: إيجار، رواتب)';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get voucherSavedSuccessfully => 'تم تسجيل السند بنجاح';

  @override
  String get saveReceiptVoucher => 'حفظ سند القبض';

  @override
  String get savePaymentVoucher => 'حفظ سند الصرف';

  @override
  String get checkManagement => 'إدارة الشيكات';

  @override
  String get checkType => 'نوع الشيك';

  @override
  String get receivedChecks => 'شيكات مستلمة (من العملاء)';

  @override
  String get issuedChecks => 'شيكات صادرة (للموردين)';

  @override
  String get checkNumber => 'رقم الشيك';

  @override
  String get bankName => 'اسم البنك';

  @override
  String get customer => 'العميل';

  @override
  String get paymentCollectionAccount => 'حساب الدفع/التحصيل';

  @override
  String get saveCheck => 'حفظ الشيك';

  @override
  String get noChecks => 'لا يوجد شيكات.';

  @override
  String checkInfo(Object bank, Object number) {
    return 'رقم الشيك: $number - $bank';
  }

  @override
  String checkDetails(Object amount, Object dueDate, Object status) {
    return 'المبلغ: $amount - الاستحقاق: $dueDate\nالحالة: $status';
  }

  @override
  String get collect => 'تحصيل';

  @override
  String get reject => 'رفض';

  @override
  String checkCollected(Object checkNumber) {
    return 'تحصيل شيك: $checkNumber';
  }

  @override
  String checkBounced(Object checkNumber) {
    return 'ارتداد شيك: $checkNumber';
  }

  @override
  String checkStatusUpdated(Object status) {
    return 'تم تحديث حالة الشيك إلى $status';
  }

  @override
  String get fixedAssetsManagement => 'إدارة الأصول الثابتة';

  @override
  String get confirmDepreciation => 'هل تريد بالتأكيد تشغيل الإهلاك الشهري لجميع الأصول؟ ستتم العملية في الخلفية.';

  @override
  String get run => 'تشغيل';

  @override
  String get depreciationCompleted => 'تمت عملية حساب الإهلاك بنجاح.';

  @override
  String get calculateMonthlyDepreciation => 'حساب الإهلاك الشهري';

  @override
  String get noFixedAssets => 'لا توجد أصول ثابتة مسجلة حالياً.';

  @override
  String get startAddingAsset => 'ابدأ بإضافة أصل جديد من الزر أدناه.';

  @override
  String get addAsset => 'إضافة أصل';

  @override
  String get purchaseDate => 'تاريخ الشراء';

  @override
  String get originalCost => 'التكلفة الأصلية';

  @override
  String get usefulLife => 'العمر الافتراضي';

  @override
  String years(Object years) {
    return '$years سنوات';
  }

  @override
  String get salvageValue => 'قيمة الخردة';

  @override
  String get accumulatedDepreciation => 'الإهلاك المتراكم';

  @override
  String get netBookValue => 'صافي القيمة الدفترية';

  @override
  String get accountOptional => 'الحساب المحاسبي (اختياري)';

  @override
  String get active => 'نشط';

  @override
  String get additionalNotes => 'ملاحظات إضافية...';

  @override
  String get actual => 'الفعلي';

  @override
  String autoReconcileCount(Object count) {
    return 'تم تسوية $count معاملة تلقائياً';
  }

  @override
  String autoReconcileError(Object error) {
    return 'خطأ في التسوية التلقائية: $error';
  }

  @override
  String get bankAccount => 'حساب البنك';

  @override
  String get bankTransfer => 'بنكي';

  @override
  String get budgetCreated => 'تم إنشاء الميزانية بنجاح';

  @override
  String get budgetList => 'الميزانيات';

  @override
  String get budgetName => 'اسم الميزانية';

  @override
  String get budgeted => 'الميزانية';

  @override
  String get budgetedAmount => 'المبلغ المقدر';

  @override
  String get budgets => 'الميزانيات التقديرية';

  @override
  String get cashOverShortNotFound => 'حساب الصندوق أو حساب العجز/الزيادة غير موجود';

  @override
  String get check => 'شيك';

  @override
  String checkDueDate(Object date) {
    return 'تاريخ استحقاق الشيك: $date';
  }

  @override
  String get closed => 'مغلق';

  @override
  String get commission => 'العمولة';

  @override
  String get confirmAndRecordReconciliation => 'تأكيد وتسجيل التسوية';

  @override
  String consumedPercent(Object percent) {
    return '$percent% مستهلك';
  }

  @override
  String get costCenterOptional => 'مركز التكلفة (اختياري)';

  @override
  String get createBudget => 'إنشاء ميزانية';

  @override
  String get createBudgetHint => 'قم بإنشاء ميزانية جديدة من التبويب الثاني';

  @override
  String get creating => 'جاري الإنشاء...';

  @override
  String get description => 'الوصف';

  @override
  String get enterAmountPrompt => 'يرجى إدخال المبلغ';

  @override
  String get enterBudgetNameError => 'يرجى إدخال اسم الميزانية';

  @override
  String errorLoadingTransactions(Object error) {
    return 'خطأ في تحميل المعاملات: $error';
  }

  @override
  String get fromAccount => 'من حساب';

  @override
  String get fromDate => 'من تاريخ';

  @override
  String get general => 'عام';

  @override
  String get noBudgetsFound => 'لا توجد ميزانيات تقديرية';

  @override
  String get payTo => 'الصرف إلى';

  @override
  String get paymentVoucher => 'سند صرف';

  @override
  String get paymentVoucherSaved => 'تم حفظ سند الصرف بنجاح';

  @override
  String periodLabel(Object period) {
    return 'الفترة: $period';
  }

  @override
  String get q1 => 'الربع الأول';

  @override
  String get q2 => 'الربع الثاني';

  @override
  String get q3 => 'الربع الثالث';

  @override
  String get q4 => 'الربع الرابع';

  @override
  String get receiptVoucher => 'سند قبض';

  @override
  String get receiptVoucherSaved => 'تم حفظ سند القبض بنجاح';

  @override
  String get receiveFrom => 'القبض من';

  @override
  String reconcileAllConfirm(Object count) {
    return 'هل تريد تسوية جميع $count معاملة غير مسوّاة؟';
  }

  @override
  String reconcileAllSuccess(Object count) {
    return 'تم تسوية جميع $count معاملة بنجاح';
  }

  @override
  String reconcileSuccessCount(Object count) {
    return 'تم تسوية $count معاملة بنجاح';
  }

  @override
  String reconciliationDescription(Object note) {
    return 'تسوية: $note';
  }

  @override
  String reconciliationError(Object error) {
    return 'خطأ في التسوية: $error';
  }

  @override
  String get reconciliationNotes => 'ملاحظات التسوية';

  @override
  String get reconciliationNotesHint => 'ملاحظات التسوية...';

  @override
  String get reconciliationSuccess => 'تم تسجيل التسوية بنجاح';

  @override
  String get recordTransfer => 'تسجيل التحويل';

  @override
  String get reference => 'المرجع';

  @override
  String get refresh => 'تحديث';

  @override
  String saveFailed(Object error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get search => 'بحث';

  @override
  String get selectAccountsError => 'يرجى اختيار الحسابات';

  @override
  String get selectBankAccountPrompt => 'اختر حساب بنك للبدء بالتسوية';

  @override
  String get selectCustomerOrSupplier => 'الرجاء اختيار عميل أو مورد';

  @override
  String get selectedTransactions => 'المعاملات المحددة';

  @override
  String get toAccount => 'إلى حساب';

  @override
  String get toDate => 'إلى تاريخ';

  @override
  String get transferCompany => 'شركة التحويل';

  @override
  String transferItem(Object amount) {
    return 'تحويل: $amount';
  }

  @override
  String get transferSuccess => 'تم التحويل بنجاح';

  @override
  String get transferType => 'نوع التحويل';

  @override
  String get transfers => 'الحوالات المالية';

  @override
  String get variance => 'التباين';

  @override
  String get customizeDashboard => 'تخصيص الداشبورد';

  @override
  String get dragToReorderHint => 'اسحب لإعادة الترتيب، واضغط على العين لإخفاء/إظهار القسم';

  @override
  String get favorites => 'المفضلة';

  @override
  String get tapStarToPin => 'اضغط على ⭐ في أي شاشة لتثبيتها هنا';

  @override
  String favoriteItems(Object count) {
    return '$count عناصر';
  }

  @override
  String get sell => 'بيع';

  @override
  String get saleInvoice => 'فاتورة بيع';

  @override
  String get saleInvoiceDescription => 'إنشاء فاتورة بيع جديدة';

  @override
  String get priceQuote => 'عرض سعر';

  @override
  String get priceQuoteDescription => 'إنشاء عرض سعر للعميل';

  @override
  String get customerOrder => 'طلبية عميل';

  @override
  String get customerOrderDescription => 'استلام طلبية من عميل';

  @override
  String get purchaseInvoice => 'فاتورة شراء';

  @override
  String get purchaseInvoiceDescription => 'إنشاء فاتورة شراء جديدة';

  @override
  String get purchaseOrder => 'طلب شراء';

  @override
  String get purchaseOrderDescription => 'إنشاء طلب شراء من مورد';

  @override
  String get newOperation => 'إنشاء عملية جديدة';

  @override
  String get inventory => 'المخزون';

  @override
  String get cashboxes => 'الصناديق';

  @override
  String get stockTake => 'جرد مخزون';

  @override
  String get inventoryTransfer => 'تحويل مخزني';

  @override
  String get printBarcode => 'طباعة باركود';

  @override
  String get deposit => 'إيداع';

  @override
  String get withdraw => 'سحب';

  @override
  String get transfer => 'تحويل';

  @override
  String get salesReport => 'تقرير المبيعات';

  @override
  String get purchasesReport => 'تقرير المشتريات';

  @override
  String get profitReport => 'تقرير الأرباح';

  @override
  String get inventoryReport => 'تقرير المخزون';

  @override
  String get quickAccess => 'الوصول السريع';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get now => 'الآن';

  @override
  String minutesAgo(Object minutes) {
    return 'منذ $minutes د';
  }

  @override
  String hoursAgo(Object hours) {
    return 'منذ $hours س';
  }

  @override
  String daysAgo(Object days) {
    return 'منذ $days ي';
  }

  @override
  String get todaysBusiness => 'أعمال اليوم';

  @override
  String get todayPurchases => 'مشتريات اليوم';

  @override
  String get invoiceCount => 'عدد الفواتير';

  @override
  String get newCustomers => 'العملاء الجدد';

  @override
  String get profit => 'الأرباح';

  @override
  String get productsSold => 'المنتجات المباعة';

  @override
  String get thisWeekSales => 'مبيعات هذا الأسبوع';

  @override
  String get thisWeekPurchases => 'مشتريات هذا الأسبوع';

  @override
  String get transactionSettings => 'إعدادات المعاملة';

  @override
  String get transactionType => 'نوع العملية';

  @override
  String get thisFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get transactionSavedSuccessfully => 'تم حفظ المعاملة بنجاح';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get quickPos => 'نقطة البيع السريع';

  @override
  String get sellMode => 'وضع البيع';

  @override
  String get retailMode => 'وضع التجزئة';

  @override
  String get wholesaleModeDescription => 'وضع الجملة';

  @override
  String get holdSale => 'تعليق البيع';

  @override
  String get saleHeld => 'تم تعليق البيع';

  @override
  String get recallSale => 'استدعاء البيع المعلق';

  @override
  String get heldSales => 'البيع المعلق';

  @override
  String itemsCount(Object count) {
    return '$count صنف';
  }

  @override
  String get currencySar => 'ر.س';

  @override
  String get checkoutSuccess => 'تمت عملية البيع بنجاح';

  @override
  String get cashCustomer => 'عميل نقدي';

  @override
  String get howToSendInvoice => 'كيف تريد إرسال الفاتورة؟';

  @override
  String get later => 'لاحقاً';

  @override
  String get print => 'طباعة';

  @override
  String get share => 'مشاركة';

  @override
  String get returnSuccessTitle => 'تم المرتجع بنجاح';

  @override
  String returnId(Object id) {
    return 'رقم المرتجع: $id';
  }

  @override
  String originalInvoice(Object id) {
    return 'الفاتورة الأصلية: $id';
  }

  @override
  String returnAmount(Object amount) {
    return 'المبلغ المرتجع: $amount ر.س';
  }

  @override
  String get salesReturnDescription => 'إرجاع منتجات من فاتورة بيع';

  @override
  String get purchaseReturnDescription => 'إرجاع منتجات لشركة شراء';

  @override
  String get saleInvoiceLabel => 'فاتورة بيع';

  @override
  String get purchaseInvoiceLabel => 'فاتورة شراء';

  @override
  String get salesReturnLabel => 'مرتجع بيع';

  @override
  String get purchaseReturnLabel => 'مرتجع شراء';

  @override
  String get priceQuoteLabel => 'عرض سعر';

  @override
  String get purchaseOrderLabel => 'طلب شراء';

  @override
  String get customerOrderLabel => 'طلبية عميل';

  @override
  String get transactionDate => 'تاريخ المعاملة';

  @override
  String get bank => 'بنكي';

  @override
  String get cashCustomerFallback => 'عميل نقدي';

  @override
  String invoiceNo(Object id) {
    return 'رقم الفاتورة: #$id';
  }

  @override
  String totalAmountWithCurrency(Object amount) {
    return 'الإجمالي: $amount ر.س';
  }

  @override
  String customerNameLabel(Object customer) {
    return 'العميل: $customer';
  }

  @override
  String get thankYouForShopping => 'شكراً لتسوقكم معنا!';

  @override
  String get supplierStatement => 'كشف حساب';

  @override
  String get todaySalesKpi => 'مبيعات اليوم';

  @override
  String get todayPurchasesKpi => 'مشتريات اليوم';

  @override
  String get freshCustomers => 'العملاء الجدد';

  @override
  String get itemsSold => 'المنتجات المباعة';

  @override
  String get selectCustomerField => 'اختر العميل';

  @override
  String get selectSupplierField => 'اختر المورد';

  @override
  String get dateField => 'التاريخ';

  @override
  String get notesField => 'ملاحظات';

  @override
  String get amountField => 'المبلغ';

  @override
  String get paymentMethodField => 'طريقة الدفع';

  @override
  String get accessDenied => 'خطأ في الصلاحيات';

  @override
  String get accessDeniedMessage => 'عذراً، لا تملك الصلاحية للوصول لهذه الصفحة.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get noTransactionsToPrint => 'لا توجد معاملات للطباعة';

  @override
  String get customerNotFound => 'لم يتم العثور على العميل';

  @override
  String get totalPayments => 'إجمالي المدفوعات';

  @override
  String get remainingBalance => 'الرصيد المتبقي';

  @override
  String get noFinancialMovements => 'لا توجد حركات مالية لهذا العميل';

  @override
  String get statementLabel => 'البيان';

  @override
  String payInvoicesFor(Object name) {
    return 'دفع فواتير $name';
  }

  @override
  String get selectAtLeastOneInvoice => 'يرجى اختيار فاتورة واحدة على الأقل';

  @override
  String invoiceHash(Object id) {
    return 'فاتورة #$id';
  }

  @override
  String get amountPaidLabel => 'المبلغ المدفوع';

  @override
  String get netProfit => 'صافي الربح';

  @override
  String get pendingOrders => 'طلبيات معلقة';

  @override
  String get stockAlerts => 'تنبيهات المخزون';

  @override
  String get creditExceeded => 'تجاوز ائتمان';

  @override
  String get sat => 'سبت';

  @override
  String get sun => 'أحد';

  @override
  String get mon => 'اثنين';

  @override
  String get tue => 'ثلاثاء';

  @override
  String get wed => 'أربعاء';

  @override
  String get thu => 'خميس';

  @override
  String get fri => 'جمعة';

  @override
  String get topSellingToday => 'الأكثر مبيعاً اليوم';

  @override
  String qtyLabel(Object qty) {
    return 'الكمية: $qty';
  }

  @override
  String remainingLabel(Object amount) {
    return 'المتبقي: $amount';
  }

  @override
  String get productCategories => 'تصنيفات المنتجات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String errorLabel(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get cashBalance => 'رصيد الصندوق';

  @override
  String get lowStockSupply => 'نواقص المخزون';

  @override
  String get newOperationDesc => 'بيع، شراء، مرتجع، سند، أو أي عملية أخرى';

  @override
  String get quickOperations => 'عمليات سريعة';

  @override
  String get buyAction => 'شراء';

  @override
  String get customerAction => 'عميل';

  @override
  String get productAction => 'منتج';

  @override
  String get supplierAction => 'مورد';

  @override
  String get reportAction => 'تقرير';

  @override
  String get mainSections => 'الأقسام الرئيسية';

  @override
  String get operationsSection => 'العمليات';

  @override
  String get accountingSection => 'الحسابات';

  @override
  String get partiesSection => 'الأطراف';

  @override
  String get adminSection => 'الإدارة';

  @override
  String get newLabel => 'جديد';

  @override
  String get menuLabel => 'القائمة';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get attentionCenter => 'مركز الانتباه';

  @override
  String get noAlerts => 'لا توجد تنبيهات حالياً';

  @override
  String get timelineLabel => 'الجدول الزمني';

  @override
  String get timelineEmpty => 'لم تُنفذ أي عملية بعد';

  @override
  String get allocateAmountToInvoices => 'توزيع المبلغ على الفواتير';

  @override
  String allocated(Object amount) {
    return 'تم توزيع: $amount';
  }

  @override
  String get annual => 'سنوي';

  @override
  String get approvalWorkflow => 'سير الموافقات';

  @override
  String get approve => 'موافقة';

  @override
  String get approved => 'موافق عليه';

  @override
  String get assetName => 'اسم الأصل';

  @override
  String assetsAndLiabilities(Object assets, Object liabilities) {
    return 'الأصول: $assets | الخصوم: $liabilities';
  }

  @override
  String get autoAllocateOldestFirst => 'توزيع آلي (الأقدم أولاً)';

  @override
  String byUser(Object user) {
    return 'بواسطة $user';
  }

  @override
  String get calculate => 'حساب';

  @override
  String get calculateNewZakat => 'حساب زكاة جديد';

  @override
  String get calculateZakat => 'حساب الزكاة';

  @override
  String get calculationType => 'نوع الحساب';

  @override
  String get change => 'تغيير';

  @override
  String closeDate(Object date) {
    return 'تاريخ الإغلاق: $date';
  }

  @override
  String closeFailed(Object error) {
    return 'فشل الإغلاق: $error';
  }

  @override
  String get closeYearDescription => 'سيتم ترحيل جميع أرصدة الإيرادات والمصاريف إلى حساب الأرباح المحتجزة، وتصفير الحسابات المؤقتة للسنة الجديدة.';

  @override
  String get commissions => 'عمولات';

  @override
  String get confirmClose => 'تأكيد الإغلاق';

  @override
  String get confirmPayment => 'تأكيد الدفع';

  @override
  String get confirmPaymentMessage => 'هل أنت متأكد من تسجيل الدفع لهذه الضريبة؟';

  @override
  String get cost => 'التكلفة';

  @override
  String get createRevaluationEntry => 'إنشاء قيد إعادة تقييم';

  @override
  String get demoRequest => 'طلب تجريبي';

  @override
  String get demoRequestNote => 'طلب تجريبي لتفعيل سير الموافقات حتى يتم ربطه بنماذج المشتريات.';

  @override
  String get dividends => 'أرباح';

  @override
  String get dividendsInterest => 'أرباح / فوائد';

  @override
  String get editAsset => 'تعديل أصل';

  @override
  String get enterReferenceNumber => 'أدخل رقم المرجع';

  @override
  String entriesCount(Object count) {
    return 'القيود ($count)';
  }

  @override
  String get entryCount => 'عدد القيود';

  @override
  String errorLoadingApprovalRequests(Object error) {
    return 'خطأ في تحميل طلبات الموافقة: $error';
  }

  @override
  String failedToAddAsset(Object error) {
    return 'فشل في إضافة الأصل: $error';
  }

  @override
  String failedToCalculateDepreciation(Object error) {
    return 'فشل في حساب الإهلاك: $error';
  }

  @override
  String failedToLoadAssets(Object error) {
    return 'فشل في تحميل الأصول: $error';
  }

  @override
  String failedToUpdateAsset(Object error) {
    return 'فشل في تحديث الأصل: $error';
  }

  @override
  String failedToUpdateRequest(Object error) {
    return 'تعذر تحديث طلب الموافقة: $error';
  }

  @override
  String get file => 'تقديم';

  @override
  String get fileTax => 'تقديم الضريبة';

  @override
  String get filed => 'مُقدَّم';

  @override
  String get grossAmount => 'المبلغ الإجمالي';

  @override
  String get insurance => 'تأمين';

  @override
  String get interest => 'فوائد';

  @override
  String get invoiceAlreadyApproved => 'فاتورة مرحلة: لا يمكن التعديل';

  @override
  String get invoiceApprovedMessage => 'هذه الفاتورة تم اعتمادها. هل تود القيام بإجراء تصحيحي؟';

  @override
  String invoiceWithId(Object id) {
    return 'فاتورة #$id';
  }

  @override
  String get largePurchaseRequest => 'طلب موافقة شراء كبير';

  @override
  String manualJournalEntryAudit(Object description, Object total) {
    return 'قيد يدوي: $description, الإجمالي: $total';
  }

  @override
  String get net => 'الصافي';

  @override
  String get netAmount => 'صافي المبلغ';

  @override
  String get newAsset => 'أصل جديد';

  @override
  String get noApprovalRequests => 'لا توجد طلبات موافقة حالياً';

  @override
  String get noOutstandingInvoices => 'لا توجد فواتير آجلة مستحقة لهذا العميل.';

  @override
  String get noTaxEntriesInPeriod => 'لا توجد قيود ضريبية في هذا الفترة';

  @override
  String get noZakatCalculations => 'لا توجد حسابات زكاة';

  @override
  String get paid => 'مدفوع';

  @override
  String get paidZakat => 'المدفوعة';

  @override
  String get pay => 'دفع';

  @override
  String paymentLabel(Object paymentId) {
    return 'دفعة: $paymentId';
  }

  @override
  String get pendingZakat => 'المعلقة';

  @override
  String get periodYear => 'الفترة (السنة)';

  @override
  String get pleaseEnterValidNumber => 'الرجاء إدخال رقم صحيح';

  @override
  String purchaseDateLabel(Object date) {
    return 'تاريخ الشراء: $date';
  }

  @override
  String get recordPayment => 'تسجيل الدفع';

  @override
  String get referenceNumber => 'رقم المرجع';

  @override
  String get rejected => 'مرفوض';

  @override
  String remainingToAllocate(Object amount) {
    return 'المتبقي للتوزيع: $amount';
  }

  @override
  String get rent => 'إيجار';

  @override
  String get revaluationReason => 'إعادة تقييم الدفعة';

  @override
  String get requestApproved => 'تمت الموافقة';

  @override
  String get requestRejected => 'تم الرفض';

  @override
  String get royalties => 'حقوق ملكية فكرية';

  @override
  String get royaltiesServices => 'حقوق ملكية فكرية / خدمات';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get serviceFees => 'أتعاب خدمات';

  @override
  String statusWithValue(Object status) {
    return 'الحالة: $status';
  }

  @override
  String get taxFiledSuccessfully => 'تم تقديم الضريبة بنجاح';

  @override
  String taxWithRate(Object rate) {
    return 'الضريبة ($rate%)';
  }

  @override
  String get technicalFees => 'أتعاب فنية';

  @override
  String get technicalFeesCommissionsRent => 'أتعاب فنية / عمولات / إيجار';

  @override
  String totalAndBalance(Object balance, Object total) {
    return 'الإجمالي: $total | المتبقي: $balance';
  }

  @override
  String get totalZakat => 'إجمالي الزكاة';

  @override
  String get typeLabel => 'النوع';

  @override
  String unbalancedEntryError(Object credit, Object debit) {
    return 'القيد غير متوازن. المدين: $debit, الدائن: $credit';
  }

  @override
  String get unifiedStatement => 'كشف حساب موحد';

  @override
  String get usefulLifeYears => 'العمر الافتراضي (سنوات)';

  @override
  String get withholdingTax => 'ضريبة المصدر';

  @override
  String get withholdingTaxRates => 'معدلات ضريبة المصدر';

  @override
  String get withholdingTaxSummary => 'ملخص ضريبة المصدر';

  @override
  String get yearClosedSuccessfully => 'تم إغلاق السنة المالية بنجاح';

  @override
  String get zakat => 'الزكاة';

  @override
  String zakatAmount(Object amount) {
    return 'الزكاة: $amount';
  }

  @override
  String get zakatCalculatedSuccessfully => 'تم حساب الزكاة بنجاح';

  @override
  String get zakatFiledSuccessfully => 'تم تقديم الزكاة';

  @override
  String get zakatPaidSuccessfully => 'تم دفع الزكاة';

  @override
  String get serialNumbers => 'أرقام التسلسل';

  @override
  String get history => 'السجل';

  @override
  String get noSerialNumbers => 'لا توجد أرقام تسلسل';

  @override
  String get inStock => 'في المخزون';

  @override
  String get soldStatus => 'تم البيع';

  @override
  String get reservedStatus => 'محجوز';

  @override
  String get returnedStatus => 'مرجع';

  @override
  String productWithName(Object name) {
    return 'المنتج: $name';
  }

  @override
  String warehouseWithName(Object name) {
    return 'المستودع: $name';
  }

  @override
  String batchWithName(Object name) {
    return 'الدفعة: $name';
  }

  @override
  String receivedDateWithDate(Object date) {
    return 'تاريخ الاستلام: $date';
  }

  @override
  String get reserve => 'حجز';

  @override
  String get restock => 'إعادة للمخزون';

  @override
  String get addSerialNumber => 'إضافة رقم تسلسل';

  @override
  String get serialNumberLabel => 'رقم التسلسل';

  @override
  String get serialNumberAdded => 'تم إضافة رقم التسلسل بنجاح';

  @override
  String get bulkRegister => 'إضافة أرقام تسلسل متعددة';

  @override
  String get serialNumbersOnePerLine => 'أرقام التسلسل (رقم واحد في كل سطر)';

  @override
  String get registerAll => 'تسجيل الكل';

  @override
  String get enterAtLeastOneSerial => 'يرجى إدخال أرقام تسلسل واحدة على الأقل';

  @override
  String serialBulkRegistered(Object count, Object total) {
    return 'تم تسجيل $count من $total أرقام تسلسل';
  }

  @override
  String get reserveSerialNumber => 'حجز رقم التسلسل';

  @override
  String get salesOrderNumber => 'رقم طلب البيع';

  @override
  String get enterSalesOrderNumber => 'يرجى إدخال رقم طلب البيع';

  @override
  String get serialReserved => 'تم حجز رقم التسلسل';

  @override
  String get registerSerialSale => 'تسجيل بيع رقم التسلسل';

  @override
  String get saleNumber => 'رقم البيع';

  @override
  String get enterSaleNumber => 'يرجى إدخال رقم البيع';

  @override
  String get saleRegistered => 'تم تسجيل البيع بنجاح';

  @override
  String get registerSale => 'تسجيل البيع';

  @override
  String get confirmReturn => 'تأكيد الإرجاع';

  @override
  String confirmReturnMessage(Object serialNumber) {
    return 'هل تريد تسجيل رقم التسلسل \"$serialNumber\" كمرجع؟';
  }

  @override
  String get returnRegistered => 'تم تسجيل الإرجاع بنجاح';

  @override
  String get serialNumberHistory => 'سجل أرقام التسلسل';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get shiftReport => 'تقرير تسليم الورديات';

  @override
  String get noShiftsYet => 'لا توجد ورديات بعد';

  @override
  String get openStatus => 'مفتوحة';

  @override
  String get closedStatus => 'مغلقة';

  @override
  String userWithId(Object userId) {
    return 'المستخدم: $userId';
  }

  @override
  String openingCashAmount(Object amount) {
    return 'رصيد البداية: $amount';
  }

  @override
  String closingCashAmount(Object amount) {
    return 'رصيد النهاية: $amount';
  }

  @override
  String noteWithText(Object note) {
    return 'ملاحظة: $note';
  }

  @override
  String get viewReport => 'عرض التقرير';

  @override
  String get shiftStart => 'بداية الوردية';

  @override
  String get shiftEnd => 'نهاية الوردية';

  @override
  String get durationLabel => 'المدة';

  @override
  String expectedCashAmount(Object amount) {
    return 'الرصيد المتوقع: $amount';
  }

  @override
  String differenceAmount(Object amount) {
    return 'الفرق: $amount';
  }

  @override
  String get cashTotal => 'نقداً';

  @override
  String get cardTotal => 'بطاقة';

  @override
  String shiftNotes(Object note) {
    return 'ملاحظات: $note';
  }

  @override
  String get stockTakeTitle => 'جرد المخزون';

  @override
  String get selectWarehouseToStart => 'يرجى اختيار مستودع لبدء الجرد';

  @override
  String get addItem => 'إضافة صنف';

  @override
  String get targetWarehouse => 'المستودع المستهدف';

  @override
  String get startStockTakeSession => 'بدء جلسة جرد جديدة';

  @override
  String get noItemsInSession => 'لا توجد أصناف في هذه الجلسة بعد';

  @override
  String get expectedSystem => 'المتوقع (النظام)';

  @override
  String get actualQtyDiscovered => 'الكمية الفعلية المكتشفة';

  @override
  String get varianceLabel => 'الفارق';

  @override
  String get finalNotes => 'ملاحظات نهائية للجرد';

  @override
  String get approveAndCloseStockTake => 'اعتماد وإقفال الجرد نهائياً';

  @override
  String get stockTakeCompleted => 'تم إقفال الجرد وتحديث المخزون والقيود المحاسبية بنجاح';

  @override
  String stockTakeError(Object error) {
    return 'خطأ في إقفال الجرد: $error';
  }

  @override
  String get addProductToStockTake => 'إضافة منتج للجرد';

  @override
  String get searchProduct => 'ابحث عن المنتج';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String qtyOfProduct(Object name) {
    return 'كمية $name';
  }

  @override
  String get actualQtyNow => 'الكمية الفعلية الموجودة الآن';

  @override
  String get addToStockTake => 'إضافة للجرد';

  @override
  String get warehouseManagement => 'إدارة المستودعات';

  @override
  String get noWarehousesAdded => 'لا توجد مستودعات مضافة';

  @override
  String get noLocation => 'بدون موقع';

  @override
  String get defaultLabel => 'الافتراضي';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get addNewWarehouse => 'إضافة مستودع جديد';

  @override
  String get locationLabel => 'الموقع';

  @override
  String get warehouseNameRequired => 'اسم المستودع مطلوب';

  @override
  String get warehouseCreated => 'تم إنشاء المستودع بنجاح';

  @override
  String warehouseCreateFailed(Object error) {
    return 'فشل إنشاء المستودع: $error';
  }

  @override
  String get editWarehouse => 'تعديل مستودع';

  @override
  String get update => 'تحديث';

  @override
  String get warehouseUpdated => 'تم تحديث المستودع بنجاح';

  @override
  String warehouseUpdateFailed(Object error) {
    return 'فشل تحديث المستودع: $error';
  }

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmDeleteWarehouse => 'هل أنت متأكد من حذف هذا المستودع؟';

  @override
  String warehouseDeleteFailed(Object error) {
    return 'فشل حذف المستودع: $error';
  }

  @override
  String get cannotDeleteWarehouseWithStock => 'لا يمكن حذف المستودع لأنه يحتوي على مخزون.';

  @override
  String get warehouseDeleted => 'تم حذف المستودع بنجاح';

  @override
  String get warehouseManager => 'إدارة أمين المخزن';

  @override
  String codeJobTitle(Object code, Object jobTitle) {
    return 'الكود: $code | الوظيفة: $jobTitle';
  }

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get editPurchaseInvoice => 'تعديل فاتورة مشتريات';

  @override
  String get purchaseInvoiceTitle => 'فاتورة مشتريات';

  @override
  String get periodClosedMessage => 'الفترة المحاسبية مغلقة. لا يمكن ترحيل الفواتير حتى فتح فترة جديدة.';

  @override
  String get lockedInvoiceMessage => 'هذه الفاتورة ليست مسودة، لذلك لا يمكن تعديلها مباشرة. استخدم مستند تصحيح أو مرتجع عند الحاجة.';

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get currencyLabel => 'العملة';

  @override
  String get representativeLabel => 'المندوب';

  @override
  String get generalRepresentative => 'مندوب عام';

  @override
  String get selectProduct => 'اختر منتج';

  @override
  String get subtotalLabel => 'الإجمالي الفرعي';

  @override
  String get taxLabel => 'الضريبة';

  @override
  String get discountLabel => 'الخصم';

  @override
  String get shippingLabel => 'الشحن';

  @override
  String get otherExpensesLabel => 'مصاريف أخرى';

  @override
  String get totalLabel => 'الإجمالي النهائي';

  @override
  String get optional => 'اختياري';

  @override
  String get needTaxPermission => 'تحتاج صلاحية تعديل الضريبة';

  @override
  String get addExistingItem => 'إضافة صنف موجود';

  @override
  String get addNewItem => 'إضافة صنف جديد';

  @override
  String get cannotEditNonDraftItems => 'لا يمكن تعديل أصناف فاتورة مشتريات غير مسودة';

  @override
  String get fixFinancialFields => 'يرجى تصحيح الحقول المالية قبل الحفظ';

  @override
  String get noTaxPermission => 'ليست لديك صلاحية إدخال أو تعديل الضريبة';

  @override
  String get pleaseSelectSupplier => 'الرجاء اختيار المورد';

  @override
  String get pleaseSelectWarehouse => 'الرجاء اختيار المستودع';

  @override
  String get pleaseAddItems => 'الرجاء إضافة أصناف';

  @override
  String get quantityMustBeGreaterThanZero => 'الكمية يجب أن تكون أكبر من صفر';

  @override
  String get priceMustBeNonNegative => 'السعر يجب أن يكون أكبر من أو يساوي صفر';

  @override
  String get cannotEditNonDraftInvoice => 'لا يمكن تعديل فاتورة مشتريات غير مسودة. استخدم مستند تصحيح أو مرتجع بدلاً من التعديل المباشر.';

  @override
  String newPurchaseInvoiceValue(Object amount) {
    return 'فاتورة مشتريات جديدة بقيمة $amount';
  }

  @override
  String invoiceModifiedValue(Object amount) {
    return 'تم تعديل الفاتورة بقيمة $amount';
  }

  @override
  String get invoicePosted => 'تم ترحيل الفاتورة';

  @override
  String get purchaseSavedAndPosted => 'تم حفظ وترحيل الفاتورة وتحديث المخزون بنجاح';

  @override
  String get invoiceModifiedSuccessfully => 'تم تعديل الفاتورة بنجاح';

  @override
  String get draftSavedSuccessfully => 'تم حفظ المسودة بنجاح';

  @override
  String errorSavingInvoice(Object error) {
    return 'خطأ في حفظ الفاتورة: $error';
  }

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع أثناء الحفظ.';

  @override
  String get foreignKeyError => 'خطأ في الربط: تأكد من صحة البيانات المختارة (المستودع أو المورد أو الأصناف).';

  @override
  String get uniqueConstraintError => 'خطأ في التكرار: رقم الفاتورة أو بيانات أخرى موجودة مسبقاً.';

  @override
  String get periodClosedCannotPost => 'الفترة المحاسبية مغلقة. لا يمكن الترحيل.';

  @override
  String get purchaseOrders => 'أوامر الشراء';

  @override
  String get noPurchaseOrders => 'لا توجد أوامر شراء';

  @override
  String purchaseOrderTitle(Object number) {
    return 'أمر شراء: $number';
  }

  @override
  String supplierStatus(Object name, Object status) {
    return 'المورد: $name | الحالة: $status';
  }

  @override
  String get confirmTitle => 'تأكيد';

  @override
  String convertOrderToInvoice(Object number) {
    return 'تحويل أمر الشراء $number إلى فاتورة؟';
  }

  @override
  String get convert => 'تحويل';

  @override
  String get conversionSuccess => 'تم التحويل بنجاح';

  @override
  String get generateAutoOrders => 'توليد أوامر شراء تلقائية';

  @override
  String get ordersGenerated => 'تم توليد أوامر الشراء بنجاح';

  @override
  String get supplierPerformance => 'تقرير أداء الموردين';

  @override
  String invoiceCountLabel(Object count) {
    return 'عدد الفواتير: $count';
  }

  @override
  String totalPurchasesLabel(Object amount) {
    return 'الإجمالي: $amount';
  }

  @override
  String averageInvoiceLabel(Object amount) {
    return 'متوسط الفاتورة: $amount';
  }

  @override
  String get priceQuotes => 'عروض الأسعار';

  @override
  String get noPriceQuotes => 'لا توجد عروض أسعار';
}
