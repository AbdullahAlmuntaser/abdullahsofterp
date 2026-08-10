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

### AUD-018: فحص الوحدات المتعددة (IN_PROGRESS)
- Root cause: (قيد الفحص)
- Planned change: (قيد الفحص)
- Files expected: (قيد الفحص)
