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
    return 'هل أنت متأكد من حذف \'$entryName\'?';
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
    return 'هل تريد تسجيل رقم التسلسل \'$serialNumber\' كمرجع؟';
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
    return 'الخصم يتجاوز الحد الأقصى $max';
  }

  @override
  String get posOriginalInvoiceNotFound => 'الفاتورة الأصلية غير موجودة';

  @override
  String posErrorSearchInvoice(Object error) {
    return 'خطأ في البحث عن الفاتورة: $error';
  }

  @override
  String get posNoReturnItemsSelected => 'لم يتم تحديد أصناف للمردود';

  @override
  String posErrorProcessReturn(Object error) {
    return 'خطأ في معالجة المردود: $error';
  }

  @override
  String get posProductNotFound => 'المنتج غير موجود';

  @override
  String posProductOutOfStock(Object name) {
    return '$name غير متوفر في المخزون';
  }

  @override
  String posErrorAddProduct(Object error) {
    return 'خطأ في إضافة المنتج: $error';
  }

  @override
  String posQuantityExceedsStock(Object quantity, Object stock) {
    return 'الكمية $quantity تتجاوز المخزون المتاح $stock';
  }

  @override
  String get posMustOpenShift => 'يجب فتح وردية أولاً';

  @override
  String get posCreditLimitExceeded => 'تم تجاوز الحد الائتماني للعميل';

  @override
  String get posLoyaltyReason => 'برنامج الولاء';
}
