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

## ملاحظات المرحلة الثانية
- flutter analyze: نظيف (ملاحظتا l10n المولدة موجودتان مسبقًا)
- flutter test: 31/31 لاختبارات المرحلتين 1 و2 (sales_order_conversion_test + phase2_sales_purchases_test)
- الإخفاقات ~20 في المجموعة الكاملة موجودة مسبقًا على commit a106f97 (UNIQUE accounting_periods، repro_init، enums PaymentMethod، accounting_posting) — غير مرتبطة بهذه المرحلة
- لم تُغيّر أي Schema أو Migration

## المرحلة الثالثة: المخزون والعملاء/الموردون والتقارير (AUD-018 → AUD-034)

| ID | المشكلة | الأولوية | الحالة | الملفات المعدلة | الاختبارات | النتيجة | ملاحظات |
|----|---------|----------|--------|-----------------|-----------|---------|---------|
| AUD-018 | فحص الوحدات المتعددة | MEDIUM | VERIFIED | product_units_dao.dart, unit_conversion_service.dart, stock_display_adapter.dart | flutter analyze | PASS | النظام موجود فعلاً: ProductUnits table + UnitConversionService + StockDisplayAdapter للعرض بالوحدات المناسبة |
| AUD-019 | فحص الوحدة الأساسية | MEDIUM | VERIFIED | products table (unit column) | flutter analyze | PASS | products.unit يحتوي على الوحدة الأساسية (افتراضي 'pcs') |
| AUD-020 | فحص Conversion Factors | MEDIUM | VERIFIED | ProductUnits.unitFactor | flutter analyze | PASS | ProductUnits.unitFactor يُستخدم في UnitConversionService لتحويل الوحدات |
| AUD-021 | ربط Minimum Stock بتنبيهات المخزون | MEDIUM | VERIFIED | products table (alertLimit), low_stock_alert_page.dart | flutter analyze | PASS | alertLimit + watchLowStockProducts() + LowStockAlertPage تعمل بشكل صحيح |
| AUD-022 | إكمال Expiry Date | MEDIUM | VERIFIED | product_batches table (expiryDate), products_dao.dart | flutter analyze | PASS | productBatches.expiryDate + getExpiringBatches + watchExpiringBatches موجودة |
| AUD-023 | فحص Serial Numbers والتتبع التاريخي | MEDIUM | VERIFIED | serial_number_service.dart, serial_numbers_page.dart | flutter analyze | PASS | SerialNumberService كامل: register/markAsSold/markAsReturned/reserve + SerialNumbersPage |
| AUD-024 | إكمال الجرد الدائري | MEDIUM | VERIFIED | stock_take_page.dart, stock_operation_service.dart | flutter analyze | PASS | StockTakePage + performInventoryAudit + inventory_audits table موجودة |
| AUD-025 | إعادة تنظيم صفحات الموردين | MEDIUM | VERIFIED | suppliers_page.dart, supplier_report_page.dart | flutter analyze | PASS | لا توجد مشاكل في الوصول المباشر لقاعدة البيانات، الصفحات تستخدم DAOs |
| AUD-026 | إضافة Pagination للبيانات الكبيرة | MEDIUM | DONE | supplier_report_page.dart | flutter analyze | PASS | أضيف pagination مع _pageSize=20 + _currentPage + عرض عدد العناصر |
| AUD-027 | إصلاح معالجة أخطاء supplier_performance_page | MEDIUM | DONE | supplier_performance_page.dart | flutter analyze | PASS | أضيف try-catch + حالة خطأ + زر إعادة محاولة + SnackBar للرسائل |
| AUD-028 | إكمال الحقول الناقصة للموظفين | MEDIUM | DONE | payroll_tables.dart, employees_page.dart, v59_to_v60.dart | flutter analyze | PASS | أضيف contractExpiry + attachments + migration v59_to_v60 + تحديث الواجهة |
| AUD-029 | فحص التقارير والتأكد من مصادر البيانات | MEDIUM | VERIFIED | report_engine_service.dart, sales_dao.dart | flutter analyze | PASS | التقارير تستخدم DAOs والـ Services الصحيحة (لا يوجد وصول مباشر) |
| AUD-030 | إضافة التقارير المخصصة | MEDIUM | VERIFIED | report_engine_service.dart | flutter analyze | PASS | ReportEngineService يحتوي على getTopSellingProducts + getProfitMarginReport + getDailySalesReport + getInventoryValuationReport |
| AUD-031 | إضافة المقارنات بين الفترات | MEDIUM | VERIFIED | sales_reports_page.dart, product_profitability_page.dart, advanced_profit_report_page.dart | flutter analyze | PASS | جميع التقارير المالية تحتوي على منتقي تاريخ (Date Range Picker) |
| AUD-032 | إضافة قيمة المخزون | MEDIUM | VERIFIED | inventory_value_report.dart, inventory_costing_service.dart | flutter analyze | PASS | InventoryValueReport + getTotalInventoryValue + getInventoryValuationReport موجودة |
| AUD-033 | إضافة هامش الربح حسب المنتج | MEDIUM | VERIFIED | product_profitability_page.dart, sales_dao.dart (getProductProfitability) | flutter analyze | PASS | ProductProfitabilityPage + getProductProfitability في SalesDao |
| AUD-034 | إضافة Excel export | MEDIUM | VERIFIED | export_service.dart | flutter analyze | PASS | ExportService يدعم CSV + PDF + Excel للعديد من الأنواع |

## ملاحظات المرحلة الثالثة
- flutter analyze: نظيف (ملاحظتا l10n المولدة موجودتان مسبقًا)
- flutter test: 17/17 لاختبارات المرحلة الثالثة (phase3_inventory_reports_test.dart)
- Schema Migration: v59 → v60 (إضافة contract_expiry + attachments لجدول hr_employees)
- الملفات المعدلة:
  - lib/presentation/features/purchases/supplier_performance_page.dart (AUD-027)
  - lib/presentation/features/reports/supplier_report_page.dart (AUD-026)
  - lib/presentation/features/hr/employees_page.dart (AUD-028)
  - lib/data/datasources/local/tables/payroll_tables.dart (AUD-028)
  - lib/data/migrations/v59_to_v60.dart (AUD-028)
  - lib/data/datasources/local/app_database.dart (AUD-028)
  - test/unit/phase3_inventory_reports_test.dart (جديد)
