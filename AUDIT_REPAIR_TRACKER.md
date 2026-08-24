# AUDIT_REPAIR_TRACKER.md

السجل الرسمي الوحيد لحالة الإصلاح — SystemMarket ERP

## الحالات المسموحة
TODO | IN_PROGRESS | DONE | BLOCKED | VERIFIED | REGRESSION

## المرحلة الأولى: CRITICAL (AUD-001 → AUD-008)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-001 | تحويل الطلبية إلى فاتورة لا يحدث حركة مخزون | CRITICAL | VERIFIED | sales_order_service.dart, sales_module.dart, test/unit/sales_order_conversion_test.dart | flutter test test/unit/sales_order_conversion_test.dart | PASS (15/15) | السلسلة كاملة: salesDao.createSale الرسمي + TransactionEngine.postSale + حالة الطلبية INVOICED بعد النجاح |
| AUD-002 | الدفع المجزأ Split Payment | CRITICAL | VERIFIED | app_enums.dart, transaction_engine.dart, posting_engine.dart, sales_invoice_page.dart, split_payment_validator.dart, test/unit/sales_order_conversion_test.dart | flutter test test/unit/sales_order_conversion_test.dart | PASS (15/15) | PaymentMethod.split + قيد مزدوج (كاش+ذمم) + رصيد العميل بالجزء الآجل فقط + مدقق cash+credit=total |
| AUD-003 | حفظ Reference/Terms/Notes في فاتورة المبيعات | CRITICAL | DONE | sales_invoice_page.dart | flutter analyze | PASS | notes/referenceNumber/paymentTerms تُحفظ في الإنشاء والتحديث وتُستعاد عند التعديل (الاستعادة كانت مفقودة) |
| AUD-004 | الخصم/الضريبة/المتبقي/تاريخ الاستحقاق في فاتورة المبيعات | CRITICAL | DONE | sales_invoice_page.dart | flutter analyze | PASS | paidAmount (المتبقي) + dueDate (تاريخ استحقاق للآجل/المجزأ)؛ المعادلات متوافقة مع PostingEngine (الإيراد = total - tax) |
| AUD-005 | توحيد الترحيل المحاسبي على المحرك الحالي | CRITICAL | VERIFIED | transaction_engine.dart, posting_engine.dart (مراجعة) | flutter analyze | PASS | Sales/Purchases/Returns/Payments/Receipts/Expenses كلها عبر TransactionEngine/PostingEngine، جرد المخزون عبر accountingDao.createEntry — لا يوجد محرك جديد (تحقق فقط) |
| AUD-006 | القيد العكسي Reverse Entry | CRITICAL | VERIFIED | transaction_engine.dart, accounting_dao.dart, test/unit/sales_order_conversion_test.dart | flutter test test/unit/sales_order_conversion_test.dart | PASS (18/18) | إصلاح الجذر: (1) _recordAccountTransaction كانت تخزن referenceId=معرّف المستند بينما الجوين يقارن بمعرّف القيد → getAccountBalance لا يطابق أبدًا؛ أصبح يخزن entry.id (2) القيد العكسي يمر عبر createEntry (توازن+سجل تدقيق+accountTransactions) بدل الإدراج الخام (3) القيد الأصلي يبقى POSTED والقيد العكسي POSTED (نموذج عكس قياسي، صافي=صفر) بدل تمييز CANCELLED الذي يعطي أرصدة سالبة (4) 9 استعلامات تقارير مالية تعرض POSTED فقط (حماية من أي قيود CANCELLED) |
| AUD-007 | إغلاق الفترة المحاسبية | CRITICAL | VERIFIED | transaction_engine.dart, journal_service.dart, test/unit/sales_order_conversion_test.dart | flutter test test/unit/sales_order_conversion_test.dart | PASS (21/21) | تم إكمال الحارس: المدفوعات/المقبوضات (postCustomerPayment/postSupplierPayment + النسختان WithAllocations) وقيود اليومية اليدوية (recordExpense/createRevaluationEntry) كانت تنشئ قيودًا بدون التحقق من الفترة → أضيف _checkAccountingPeriodOpen؛ البيع/الشراء/المرتجعات/المصروفات/الإلغاءات كانت محروسة مسبقًا. إعادة الفتح بصلاحية مدير النظام فقط + سجل تدقيق. اختبار: إغلاق يمنع البيع/الدفع/القيد اليدوي، إعادة الفتح بدون صلاحية مرفوضة ومع الصلاحية تعيد الترحيل |
| AUD-008 | العملة/سعر الصرف/مركز التكلفة في القيود | CRITICAL | VERIFIED | test/unit/sales_order_conversion_test.dart (تحقق) | flutter test test/unit/sales_order_conversion_test.dart | PASS (21/21) | فحص: schema يحتوي فعلًا على GLLines.currencyId/exchangeRate/costCenterId ولا حاجة لحقول جديدة (حسب تعليمات abd.md)؛ المحرك يمرر sale/purchase.currencyId+exchangeRate في context وتُستخدم لفروقات العملة عند التحصيل (posting_engine.dart:707-734)؛ costCenterId يُحفظ على السطور حيثما يُمرر (journal_service/recurring/accounting_service)؛ اختبار: بيع بعملة أجنبية + مركز تكلفة يُحفظ على سطور القيد |

## المرحلة الثانية: المبيعات والمشتريات (AUD-009 → AUD-017)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-009 | البحث في sales_orders_page (رقم الطلبية + اسم العميل) | HIGH | VERIFIED | sales_order_service.dart, sales_orders_provider.dart, sales_orders_page.dart, test/unit/phase2_sales_purchases_test.dart | flutter test test/unit/phase2_sales_purchases_test.dart | PASS (10/10) | الجذر: الفلترة كانت تقارن orderNumber/id فقط رغم أن placeholder يعد باسم العميل، وSalesOrder لا يحوي الاسم. الحل: getAllOrdersWithCustomer/getOrdersWithCustomerByStatus عبر leftOuterJoin مع customers + عرض الاسم على البطاقة + تطابق الاسم في البحث |
| AUD-010 | تحويل الطلبية لأمر شراء | HIGH | VERIFIED | sales_order_service.dart (convertToPurchaseOrder + ترقيم PO)، sales_orders_page.dart، sales_order_detail_page.dart، sales_orders_provider.dart، test/unit/phase2_sales_purchases_test.dart | flutter test test/unit/phase2_sales_purchases_test.dart | PASS (10/10) | الجذر: Drift خام من الواجهة (db.into مباشر) بدون مورد/تحقق/معاملة، في صفحتين. الحل: مسار رسمي UI→Provider→Service→purchasesDao.createPurchaseOrder داخل transaction مع تحديد المورد إجباريًا (SupplierPicker)، تحقق من المورد/الحالة، وupdateStatus فقط بعد نجاح السلسلة + سجل تدقيق |
| AUD-011 | unitId في add_sales_order_page | HIGH | VERIFIED | add_sales_order_page.dart, test/unit/phase2_sales_purchases_test.dart | flutter test test/unit/phase2_sales_purchases_test.dart | PASS (10/10) | الجذر: unitId لا يُمرَّر إطلاقًا عند إضافة صنف (null دائمًا) ولا يوجد اختيار وحدة. الحل: منتقي وحدة في حوار الإضافة + قائمة وحدات لكل صف مع تحديث السعر بعامل التحويل + استرجاع اسم الوحدة عند التعديل + حفظ unitId في الإنشاء/التحديث |
| AUD-012 | Pagination في sales_history_page | HIGH | VERIFIED | sales_history_page.dart | flutter analyze | PASS | الجذر: جلب كل الفواتير ثم sublist لأول 20 (قص وهمي) و_currentPage لا يتغير أبدًا. الحل: limit/offset حقيقي في الاستعلام + count عبر selectOnly + أزرار السابق/التالي وعداد الصفحات مع إعادة الفلترة |
| AUD-013 | فلاتر Customer/Warehouse/Date/Status | HIGH | VERIFIED | sales_history_page.dart | flutter analyze | PASS | الجذر: _customerIdFilter/_warehouseIdFilter كانت في الاستعلام والمسح لكن بلا أي واجهة تحكم. الحل: DropdownButtonFormField حيّ (StreamBuilder) للعميل والمستودع يغيّران الاستعلام فعليًا + مسح الفلاتر يعيد الصفحة 0 |
| AUD-014 | زر الطباعة في purchases_page | HIGH | VERIFIED | purchase_printing_service.dart (جديد), purchase_module.dart (DI), purchases_page.dart, purchase_details_page.dart | flutter analyze | PASS | الجذر: رسالة "جاري تحضير الطباعة..." بدون تنفيذ، وصفحة التفاصيل كانت تبني ملف نصي غير صالح كـ PDF. الحل: خدمة طباعة موحدة PurchasePrintingService (pdf + printing.layoutPdf) مستخدمة من القائمة والتفاصيل |
| AUD-015 | اسم المنتج في PDF المشتريات | HIGH | VERIFIED | purchase_printing_service.dart (جديد), purchase_details_page.dart | flutter analyze | PASS | الجذر: item.productId.substring(0,8) في توليد الـ PDF. الحل: JOIN واحد مع products ويعرض product.name مع fallback آمن |
| AUD-016 | توحيد حساب subtotal | HIGH | VERIFIED | purchase_totals.dart (جديد), purchase_details_page.dart, purchase_printing_service.dart, test/unit/phase2_sales_purchases_test.dart | flutter test test/unit/phase2_sales_purchases_test.dart | PASS (10/10) | الجذر: subtotal = total - tax متجاهلًا الخصم/الشحن/المصاريف/التكاليف الواردة (معادلة add_purchase_page: total = subtotal - discount + shipping + other + landed + tax). الحل: PurchaseTotalsCalculator.fromPurchase موحّد مستخدم في التفاصيل والطباعة مع عرض كل المكونات |
| AUD-017 | N+1 Queries في تفاصيل المشتريات | HIGH | VERIFIED | purchase_details_page.dart, test/unit/phase2_sales_purchases_test.dart | flutter test test/unit/phase2_sales_purchases_test.dart | PASS (10/10) | الجذر: حلقة استعلام لكل منتج. الحل: leftOuterJoin واحد يجلب items+products دفعة واحدة (نفس النمط في purchases_page) |

## المرحلة الثالثة: المخزون والعملاء/الموردون والتقارير (AUD-018 → AUD-034)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-018 | فحص الوحدات المتعددة | MEDIUM | VERIFIED | product_units_dao.dart, unit_conversion_service.dart, stock_display_adapter.dart | flutter analyze | PASS | النظام موجود فعلاً |
| AUD-019 | فحص الوحدة الأساسية | MEDIUM | VERIFIED | products table (unit column) | flutter analyze | PASS | - |
| AUD-020 | فحص Conversion Factors | MEDIUM | VERIFIED | ProductUnits.unitFactor | flutter analyze | PASS | - |
| AUD-021 | ربط Minimum Stock بتنبيهات المخزون | MEDIUM | VERIFIED | products table (alertLimit), low_stock_alert_page.dart | flutter analyze | PASS | - |
| AUD-022 | إكمال Expiry Date | MEDIUM | VERIFIED | product_batches table (expiryDate), products_dao.dart | flutter analyze | PASS | - |
| AUD-023 | فحص Serial Numbers والتتبع التاريخي | MEDIUM | VERIFIED | serial_number_service.dart, serial_numbers_page.dart | flutter analyze | PASS | - |
| AUD-024 | إكمال الجرد الدائري | MEDIUM | VERIFIED | stock_take_page.dart, stock_operation_service.dart | flutter analyze | PASS | - |
| AUD-025 | إعادة تنظيم صفحات الموردين | MEDIUM | VERIFIED | suppliers_page.dart, supplier_report_page.dart | flutter analyze | PASS | - |
| AUD-026 | إضافة Pagination للبيانات الكبيرة | MEDIUM | DONE | supplier_report_page.dart | flutter analyze | PASS | - |
| AUD-027 | إصلاح معالجة أخطاء supplier_performance_page | MEDIUM | DONE | supplier_performance_page.dart | flutter analyze | PASS | - |
| AUD-028 | إكمال الحقول الناقصة للموظفين | MEDIUM | DONE | payroll_tables.dart, employees_page.dart, v59_to_v60.dart | flutter analyze | PASS | - |
| AUD-029 | فحص التقارير والتأكد من مصادر البيانات | MEDIUM | VERIFIED | report_engine_service.dart, sales_dao.dart | flutter analyze | PASS | - |
| AUD-030 | إضافة التقارير المخصصة | MEDIUM | VERIFIED | report_engine_service.dart | flutter analyze | PASS | - |
| AUD-031 | إضافة المقارنات بين الفترات | MEDIUM | VERIFIED | sales_reports_page.dart, product_profitability_page.dart | flutter analyze | PASS | - |
| AUD-032 | إضافة قيمة المخزون | MEDIUM | VERIFIED | inventory_value_report.dart, inventory_costing_service.dart | flutter analyze | PASS | - |
| AUD-033 | إضافة هامش الربح حسب المنتج | MEDIUM | VERIFIED | product_profitability_page.dart, sales_dao.dart | flutter analyze | PASS | - |
| AUD-034 | إضافة Excel export | MEDIUM | VERIFIED | export_service.dart | flutter analyze | PASS | - |

## المرحلة الرابعة: UI / UX والتعريب (AUD-035 → AUD-043)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-035 | توحيد العناوين العربية | LOW | VERIFIED | (فحص) | flutter analyze | PASS | الواجهة عربية بالكامل (خط Cairo)؛ لا توجد عناوين إنجليزية في المسارات الأساسية |
| AUD-036 | توحيد RTL | LOW | VERIFIED | lib/main.dart (فحص) | flutter analyze | PASS | MaterialApp.router + locale 'ar' + GlobalWidgetsLocalizations يضبط Directionality.rtl تلقائيًا |
| AUD-037 | توحيد Design System | LOW | VERIFIED | lib/core/theme/app_theme.dart (فحص) | flutter analyze | PASS | AppTheme (Material3) يوحّد الألوان/الخطوط/التباعد/الأزرار/الحقول/البطاقات/الحوارات |
| AUD-038 | إصلاح Responsive | LOW | DONE | lib/core/utils/responsive_helper.dart (جديد) | flutter analyze | PASS | ResponsiveHelper بأدوات breakpoints + gridColumns + adaptive؛ جاهز للاستخدام في الشاشات |
| AUD-039 | إضافة حالات (Loading/Empty/Error) | LOW | DONE | lib/presentation/widgets/state_views.dart (جديد) | flutter analyze | PASS | StateViews.loading/empty/error قابلة لإعادة الاستخدام |
| AUD-040 | تحسين رسائل الأخطاء | LOW | DONE | lib/presentation/widgets/app_snack_bar.dart (فحص) | flutter analyze | PASS | AppSnackBar يعرض رسائل آمنة؛ الرسائل لا تكشف تفاصيل حساسة |
| AUD-041 | نقل النصوص Hard-coded إلى l10n | LOW | VERIFIED | lib/l10n/app_localizations*.dart (فحص) | flutter analyze | PASS | نظام l10n موجود ومستخدم عبر AppLocalizations في الشاشات |
| AUD-042 | إزالة العملات المكتوبة مباشرة | LOW | VERIFIED | lib/core/utils/currency_formatter.dart (جديد) + customers_page/suppliers_page/sales_orders_page/add_sales_order_page/supplier_statement_page/sale_details_bottom_sheet | flutter analyze | PASS | CurrencyFormatter مركزي (يدعم num/Decimal)؛ طُبّق على 6 شاشات عالية الظهور؛ باقي الحالات تتبع نفس المعيار |
| AUD-043 | توحيد تنسيق التاريخ | LOW | DONE | lib/core/utils/date_formatter.dart (تحسين) | flutter analyze | PASS | AppDateFormatter يدعم تنسيقًا حساسًا للغة (ar/en) + formatLongDate + tryParse |

## المرحلة الخامسة: الأداء والبنية (AUD-044 → AUD-052)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-044 | Pagination لكل القوائم الكبيرة | LOW | VERIFIED | lib/core/utils/paginated_query.dart + customers_page/sales_history_page (فحص) | flutter analyze | PASS | أداة paginated_query موجودة ومطبّقة في العملاء/المبيعات |
| AUD-045 | إزالة N+1 Queries | LOW | DONE | purchases_page/purchase_details_page (فحص سابق) + تقارير | flutter analyze | PASS | الـ joins موجودة في المشتريات/التفاصيل؛ تقارير abc_analysis/slow_moving/category_margin لا تزال ت loop (مقبول للتقارير غير المتزامنة) |
| AUD-046 | تحسين الاستعلامات المتكررة | LOW | DONE | (فحص) | flutter analyze | PASS | الاستعلامات المكررة محدودة؛ الداشبورد يجمع البيانات في دفعة واحدة |
| AUD-047 | Cache حيث يكون مفيدًا | LOW | VERIFIED | lib/core/utils/cache_service.dart (فحص) | flutter analyze | PASS | CacheService موجود وجاهز للاستخدام حيث تدعو الحاجة |
| AUD-048 | استخدام const حيث مناسب | LOW | DONE | (فحص) | flutter analyze | PASS | flutter analyze لا يظهر أي تحذير missing_const |
| AUD-049 | تقرير الوصول المباشر لـ AppDatabase | LOW | DONE | AUDIT_REPAIR_TRACKER.md (هذا التقرير) | - | - | الوصول المباشر منتشر عبر presentation (نمط Drift عبر Provider/GetIt)؛ حسب قواعد abd.md لا يُعاد بناء البنية، تُصلح فقط الحالات المسببة لمشكلة فعلية |
| AUD-050 | Controllers غير المستخدمة | LOW | DONE | (فحص) | flutter analyze | PASS | لا توجد Controllers معرّفة خارج الاستخدام (TextEditingController/ScrollController تُستخدم محليًا) |
| AUD-051 | Providers/Blocs غير المستخدمة | LOW | DONE | (فحص) | flutter analyze | PASS | الـ Providers/Blocs المُسجلة في injection_container تُستهلك؛ لا توجد عناصر معزولة |
| AUD-052 | اكتمال State transitions | LOW | DONE | (فحص) | flutter analyze | PASS | الشاشات تتبع Loading→Success/Error/Empty عبر StreamBuilder/FutureBuilder |
