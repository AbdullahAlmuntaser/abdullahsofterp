# تقرير تدقيق واجهات المستخدم (UI/UX) — نظام ERP

النطاق: ملفات `sales` و`sales_orders` و`returns` و`pos` و`purchases` و`suppliers`
(الصفحات + الـ widgets + الـ bloc/providers) مقابَلةً مع الـ DAOs والجداول في
`core_tables.dart` و`app_database.dart` و`injection_container.dart`.

المبدأ: لا تخمين — كل بند بدليل `الملف:السطر` واقتباس فعلي من الكود. المصطلحات:
`[حرج]` = خطأ وظيفي/بيانات، `[متوسط]` = عيب سلوكي/معماري، `[منخفض]` = تجربة/ترجمة/أداء.

---

## طلبيات العملاء (sales_orders)

### sales_orders_page.dart
- [متوسط] البحث يَعِد بالبحث باسم العميل لكن التنفيذ يفحص رقم الطلبية وid فقط:
  - `sales_orders_page.dart:102` → `hintText: 'بحث برقم الطلبية أو اسم العميل...'`
  - `sales_orders_page.dart:270-273` → `filteredOrders = filteredOrders.where((o) { return (o.orderNumber?.toLowerCase().contains(query) ?? false) || o.id.toLowerCase().contains(query); }).toList();`
- [متوسط] التحويل لأمر شراء يُنفَّذ بحقن Drift خام داخل الواجهة متجاوزاً الخدمة/DAO، دون `supplierId` ودون فحص أخطاء لكل بند:
  - `sales_orders_page.dart:469-476` → `final poId = await db.into(db.purchaseOrders).insert(PurchaseOrdersCompanion.insert(total: drift.Value(order.total), status: const drift.Value('PENDING'), notes: ...));`
  - `sales_orders_page.dart:478-487` → حلقة `db.into(db.purchaseOrderItems).insert(...)` دون try/catch.
  - ثم تحديث حالة الطلبية إلى `DELIVERED` (`:489-490`) رغم أن التحويل لم يُترحّل كمشتريات.
- [متوسط] لا ترقيم صفحات — القائمة تحمّل كل الطلبيات عبر `getAllOrders()` من provider.
- [منخفض] تنسيق تاريخ غربي `MM/dd` في تطبيق عربي:
  - `sales_orders_page.dart:134` و`:163` → `DateFormat('MM/dd').format(_dateFrom!)`
- [منخفض] النصوص كلها عربي مكتوب بلا l10n: العنوان `:46` `'طلبيات العملاء'`، `:81` `'غير مصرح لك بإنشاء طلبية'`، `:87` `'طلبية جديدة'`، `:129/:159` `'من'/'إلى'`، `:185-198` أسماء الحالات، `:218`، `:259` `'لا توجد طلبيات'`، `:332` `'${order.total} ر.س'`، `:341-361` قائمة الإجراءات، `:406-407/:430/:439` نصوص الحوارات.

### sales_orders_provider.dart
- [منخفض/أداء] خمسة استعلامات COUNT متسلسلة عند كل تحميل، بلا عدّاد لحالة `INVOICED`:
  - `sales_orders_provider.dart:57-65` → `_statusCounts = { 'PENDING': await ..., 'ORDERED': ..., 'READY': ..., 'DELIVERED': ..., 'CANCELLED': ... };`
- [متوسط] `loadOrders` بلا حد/صفحات (`:37-55`) → `_orders = await _service.getAllOrders();` كلها دفعة واحدة.

### add_sales_order_page.dart
- [متوسط] الأصناف الجديدة تُضاف دون `unitId` فيُفقد تحديد الوحدة عند الإنشاء:
  - `add_sales_order_page.dart:304-310` → `_items.add(_OrderItem(productId: result['productId'], productName: result['productName'] ?? '', quantity: result['quantity'] ?? 1.0, price: result['price'] ?? 0.0));` (لا `unitId`)
  - `add_sales_order_page.dart:334` → `unitId: item.unitId` (دائماً null للأصناف الجديدة)
- [منخفض/معماري] منتقي العميل StreamBuilder خام على `db` متجاوزاً الـ DAO/repository:
  - `add_sales_order_page.dart:112-116` → `stream: di.sl<AppDatabase>().select(di.sl<AppDatabase>().customers).watch(),`
- [منخفض] إنشاء `SalesOrdersProvider` جديد لكل عملية حفظ/حذف بدل مشاركة provider واحد:
  - `add_sales_order_page.dart:327` و`:389` → `final provider = SalesOrdersProvider(di.sl<SalesOrderService>());`
- [منخفض/أداء] حوار إضافة الصنف يحمّل كل المنتجات النشطة دفعة واحدة بلا بحث خادمي:
  - `add_sales_order_page.dart:440-451` → `final products = await (db.select(db.products)..where((p) => p.isActive.equals(true))).get();`
- [منخفض] نصوص مكتوبة بلا l10n: `:74` `'تعديل الطلبية'/'طلبية جديدة'`، `:109` `'العميل'`، `:123/:127`، `:151/:157/:165`، `:202/:218` `'الكمية'/'السعر'`، `:248/:249`، `:266/:269` `'الإجمالي:'/ر.س`، `:291/:318`، وحوار `_AddProductDialog` كاملاً `:469/:479/:495/:517/:529/:543/:557`.

### sales_order_detail_page.dart
- [متوسط] أخطاء التحميل تُبتلع وتُعرض خطأً على أنه "غير موجودة":
  - `sales_order_detail_page.dart:60` → `debugPrint('Error loading order: $e');`
  - `sales_order_detail_page.dart:75-80` → عند `_order == null` يظهر `'الطلبية غير موجودة'` — فلا تمييز بين خطأ وعدم وجود.
- [متوسط] `_convertToPurchaseOrder` يكرر نفس الحقن الخام لـ Drift (تكرار لـ sales_orders_page):
  - `sales_order_detail_page.dart:367-385` → `db.into(db.purchaseOrders).insert(...)` ثم حلقة `db.into(db.purchaseOrderItems)...` ثم `updateStatus(... 'DELIVERED' ...)`.
- [منخفض] نصوص مكتوبة: `:70/:77/:78`، `:95-102`، `:140-145`، `:157/:165`، `:181/:185`، `:206/:214/:222`، `:254/:255`، `:282/:290`، `:300-308/:348-356`.

### sales_order_service.dart
- [حرج] `convertToSale` ينشئ الفاتورة والأصناف دون أي حركة مخزون ولا تحديث لرصيد العميل — تحويل الطلبية يَتَجاوز `TransactionEngine.postSale`:
  - `sales_order_service.dart:246-282` → داخل المعاملة فقط: `db.into(db.sales).insert(SalesCompanion.insert(...))` + حلقة `db.into(db.saleItems)...` + `updateStatus(orderId,'INVOICED')` + سجل تدقيق. لا يوجد أي إدراج في جدول `stockMovements` في كامل الملف (تحقّق: صفر نتائج لـ `stockMovements`).
  - أثره: تحويل طلبية→فاتورة لا يُنقص المخزون ولا يُغيّر رصيد العميل، خلافاً للبيع العادي عبر `postSale`.
- [متوسط/أداء] `getAllOrders` بلا حد/فرز صفحات (`:12-16`).

---
## المشتريات (purchases)

### purchase_details_page.dart
- [متوسط] الإجمالي الفرعي المعروض محسوب خطأً عند وجود خصم/شحن/تكاليف:
  - `purchase_details_page.dart:169` → `final subtotal = purchase.total - purchase.tax;`
  - بينما معادلة الإجمالي الفعلية في `add_purchase_page.dart:71-72` → `_subtotal - _discount + _shippingCost + _otherExpenses + _landedCosts + _tax` — فالفرق `subtotal - discount + shipping + otherExpenses + landedCosts` يظهر كـ"إجمالي فرعي".
- [متوسط] الفاتورة المطبوعة (PDF) تعرض معرّف المنتج المبتور بدل اسم الصنف:
  - `purchase_details_page.dart:295-298` → `buffer.writeln('${item.productId.substring(0, 8)} | ${item.quantity} | ${item.unitPrice}');` — لا يجلب أسماء المنتجات إطلاقاً.
- [منخفض/أداء] استعلام N+1 في جلب الأصناف: استعلام مستقل عن كل صنف لجلب منتجه:
  - `purchase_details_page.dart:203-219` → داخل الحلقة `for (var item in items)` → `await (db.select(db.products)..where((t) => t.id.equals(item.productId))).getSingleOrNull();`
- [منخفض] نصوص/تلميحات مكتوبة بلا l10n: `:88` `tooltip: 'إرسال'`، `:92-94` `'SMS'/'WhatsApp'`، `:99` `'طباعة'`، `:245` `'تعذر فتح التطبيق'`، `:266` `'جاري تحضير الطباعة...'`، `:273` `'خطأ في الطباعة: $e'`.

### purchases_page.dart
- [متوسط] خيار "طباعة" في ورقة الإجراءات لا يطبع شيئاً — يُظهر SnackBar فقط:
  - `purchases_page.dart:272-278` → `ListTile(leading: const Icon(Icons.print), title: const Text('طباعة'), onTap: () { ... ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تحضير الطباعة...'))); })` — لا استدعاء لأي خدمة طباعة.
- [منخفض/أداء] مؤشر التمرير اللانهائي كود ميت: `_isLoadingMore` ثابت `false` لا يتغير أبداً:
  - `purchases_page.dart:24` → `final bool _isLoadingMore = false;` والشرط `:117` `itemCount: purchases.length + (_isLoadingMore ? 1 : 0)` لا يتحقق أبداً.
- [منخفض] ترجمة جزئية/عملة احتياطية: `:176` → `'${NumberFormat.currency(symbol: '', decimalDigits: 2).format(purchase.total)} ${purchase.currencyId ?? 'USD'}'` — تظهر `USD` افتراضياً في تطبيق عربي.
- [منخفض] استعلامات N+1 داخل `_showJournalEntry` (FutureBuilder لكل سطر):
  - `purchases_page.dart:427-431` → `future: (db.select(db.gLLines)..where((l) => l.entryId.equals(entry.id))).get(),` داخل itemBuilder.
- [منخفض] نصوص مكتوبة بلا l10n: `:57/:63`، `:104` `'إجمالي X عملية شراء'`، `:108` `'صفحة X من Y'`، `:193` `'آجل'`، `:264` `'عرض التفاصيل'`، `:272` `'طباعة'`، `:283` `'عرض قيد اليومية'`، `:293/:302`، `:318/:320/:324`، `:345` `'تم حذف عملية الشراء بنجاح'`، `:352` `'فشل الحذف: ...'`، `:409/:410/:414/:420/:434`.

### purchase_orders_page.dart
- [منخفض/معماري] StreamBuilder خام على `db` بلا DAO، ولا ترقيم صفحات:
  - `purchase_orders_page.dart:24-28` → `stream: (db.select(db.purchaseOrders).join([leftOuterJoin(db.suppliers, db.suppliers.id.equalsExp(db.purchaseOrders.supplierId))])).watch(),`
- [منخفض] نصوص مكتوبة: `:23` `'أوامر الشراء'`، `:34` `'خطأ: ...'`، `:38` `'لا توجد أوامر شراء'`.

### supplier_performance_page.dart
- [منخفض] لا سحب للتحديث ولا إعادة تحميل، ولا معالجة أخطاء — التحميل مرة واحدة في `initState`، وأي استثناء في `getSupplierPerformanceReport()` ينهار التطبيق:
  - `supplier_performance_page.dart:21-28` → `initState() { super.initState(); _loadReport(); }` ثم `_loadReport() async { setState(...); _report = await _service.getSupplierPerformanceReport(); setState(...); }` بلا try/catch.
- [منخفض] نصوص مكتوبة: `:33` `'تقرير أداء الموردين'`، `:47` `'عدد الفواتير: ${p.totalInvoices}'`، `:53` `'الإجمالي: ...'`.

### add_purchase_page.dart
- [منخفض] نصوص مكتوبة في ملخص الإجماليات:
  - `add_purchase_page.dart:432-439` → `_buildRow('الإجمالي الفرعي', _subtotal)` و`_buildRow('الإجمالي النهائي', _total, isBold: true)`.
- [منخفض] الوحدة الافتراضية في `quick_product_add_dialog.dart` عربي مكتوب: `:24` → `'حبة'`.

### add_purchase_return_page.dart / purchase_return_page.dart
- لا مشاكل مؤكدة: تستخدمان `l10n` (`add_purchase_return_page.dart:31` `l10n.newPurchaseReturn`، `:41` `l10n.noPurchasesFound`؛ `purchase_return_page.dart:17/:35/:40`).

---
## الموردون (suppliers)

### suppliers_page.dart
- [منخفض] رسالة الخطأ عند إضافة مورد غير مترجمة:
  - `suppliers_page.dart:373-377` → `catch (e) { ... ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'))); }`
- ملاحظة تحقق: في وضع التعديل يُنشأ `SuppliersCompanion` دون `id` (`widgets/add_edit_supplier_dialog.dart:124-129`)، لكن المتصل `_editSupplier` يقيّد التحديث بـ `supplier.id` (`suppliers_page.dart:390-393` `(db.update(db.suppliers)..where((t) => t.id.equals(supplier.id))).write(companion);`) — لذا ليست مشكلة فعلية، وأُسقطت من التقرير.

### supplier_payments_page.dart
- [متوسط] الصفحة كاملة عربي مكتوب + StreamBuilder خام على `db` بلا DAO/l10n/ترقيم صفحات، وحالة ثابتة مكتوبة:
  - `supplier_payments_page.dart:15` → `appBar: AppBar(title: const Text('دفعات الموردين'))`
  - `supplier_payments_page.dart:16-23` → `stream: (db.select(db.supplierPayments).join([drift.innerJoin(db.suppliers, db.suppliers.id.equalsExp(db.supplierPayments.supplierId))])..orderBy([...])).watch(),`
  - `supplier_payments_page.dart:29` → `Text('خطأ: ${snapshot.error}')`، `:33` `'لا توجد دفعات مسجلة'`
  - `supplier_payments_page.dart:60-63` → `const Text('COMPLETED', // Status or fixed value)`
  - `supplier_payments_page.dart:47` → `DateFormat('yyyy-MM-dd')` و`:54` → `'${payment.amount.toStringAsFixed(2)} ر.س'`

### add_supplier_payment_page.dart
- [منخفض] نصوص مكتوبة بلا l10n: `:54` `'سند صرف للمورد: ${_supplier!.name}'`، `:67` `'الرصيد الحالي المستحق'`، `:86` `'المبلغ المدفوع'`، `:92/:95` رسائل التحقق، `:104` `'ملاحظات'`.

### supplier_statement_page.dart
- [منخفض] نصوص مكتوبة: `:49` `'كشف حساب المورد: ${_supplier!.name}'`، `:61` `'لا توجد معاملات للطباعة'`.

### supplier_payment_dialog.dart
- [منخفض] العنوان مكتوب: `:104` → `'دفع فواتير ${widget.supplier.name}'`.
- التحقق سليم: `_submit` يرفض المبلغ الفارغ (`:85`).

---

## المبيعات (sales)

### sales_invoice_page.dart
- [حرج] خيار الدفع "مجزأ" (split) قابل للاختيار وتظهر حقوله ويجمع المبالغ لكن `_saveInvoice` يتجاهلها تماماً، والـ mapping يحوّل `split`/`partial` إلى نقد:
  - `sales_invoice_page.dart:415-417` → `DropdownMenuItem(value: 'split', child: Text('مجزأ'))`
  - `sales_invoice_page.dart:422` → `_isSplitPayment = (value == 'split');` و`:461` → `if (_isSplitPayment) _buildSplitPaymentFields(),`
  - `sales_invoice_page.dart:767-823` → `_buildSplitPaymentFields` يكتب `_cashPayment`/`_creditPayment` (`:787/:802/:805`).
  - `sales_invoice_page.dart:973-978` → `PaymentMethod method = PaymentMethod.cash; if (_paymentType == 'bank') ... else if (_paymentType == 'check') ...` — لا يُعالج `split`/`partial`، و`_cashPayment`/`_creditPayment` غير مقروءين إطلاقاً داخل `_saveInvoice` (884-1110).
  - الأثر: العميل يختار "مجزأ" ويُدخل كاش/آجل ثم يُحفظ كفاتورة نقدية كاملة دون أي تطبيق للمبالغ.
- [منخفض] مستوى التسعير يعرض أسماء الحالات الإنجليزية كما هي دون ترجمة:
  - `sales_invoice_page.dart:436-438` → `const ['RETAIL', 'WHOLESALE', 'SPECIAL'].map((l) => DropdownMenuItem(value: l, child: Text(l)))`
- [منخفض] نصوص مكتوبة: `:408` `'طريقة الدفع'`، `:413-417` `'نقد'/'آجل'/'جزئي'/'مجزأ'`، `:432` `'مستوى التسعير'`، `:781-799` `'كاش'/'آجل'`، `:814` `'المتبقي: ...'`، `:891/:903/:909/:916/:921/:926/:933/:939/:955/:1036/:1070/:1080/:1089/:1104`.

### sales_history_page.dart
- [متوسط] الترقيم (pagination) معطّل فعلياً: `_currentPage` لا يزيد أبداً — القائمة تُقصّ على الصفحة الأولى دائماً ولا يوجد أي زر للتنقل:
  - `sales_history_page.dart:20-21` → `final int _pageSize = 20; int _currentPage = 0;`
  - `sales_history_page.dart:80-84` → `final sales = allSales.sublist(start, end);` وكل تعيينات `_currentPage` هي صفر فقط (`:48/:236/:247`).
- [متوسط] فلترا العميل/المستودع موجودان في الكود والاستعلام لكن بلا أي واجهة لتعيينهما:
  - `sales_history_page.dart:26-27` → `String? _customerIdFilter; String? _warehouseIdFilter;`
  - `sales_history_page.dart:271-275` → `if (_customerIdFilter != null) { query = query..where((s) => s.customerId.equals(_customerIdFilter!)); } ...` بينما لوحة الفلاتر (`:157-256`) تعرض التاريخ والحالة فقط.
- [منخفض] نصوص مكتوبة: `:43` `'فلترة'`، `:55` `'إعادة تعيين'`، `:63` `'فاتورة مبيعات'`، `:121` `'غير مرحل'`، `:172` `'من تاريخ'`، `:190` `'إلى تاريخ'`، `:211` `'الحالة'`، `:216/:218/:220/:222`، `:235` `'بحث'`، `:249` `'مسح'`.

### sales_return_page.dart
- [منخفض/معماري] StreamBuilder خام على `db` (`:18-21`) ونصوص مكتوبة: `:35` `'مرتجع رقم:'`، `:37`.

### commissions_page.dart
- [منخفض] نصوص مكتوبة: `:397` `'لا توجد عمولات'`، `:402`.

### proforma_invoices_page.dart
- لا مشاكل مؤكدة تستحق الإدراج.

---

## المرتجعات (returns)

### returns_page.dart
- سليم: يستخدم `l10n` في تبويباته (`:119`).

### create_return_page.dart
- سليم، مع تمييز `ReturnType {sale, purchase}`.

### sale_details_bottom_sheet.dart
- سليم وظيفياً (DraggableScrollableSheet بـ 0.6/0.4/0.9).

---

## نقطة البيع (pos)

### pos_bloc.dart
- [منخفض] البحث في المنتجات مقيّد بعشرة نتائج بلا ترقيم واضح:
  - `pos_bloc.dart:440-458` → بحث `limit 10`.
- [متوسط] إضافة منتج بتعبئة (pack/عبوة) يكسرها تلقائياً إلى وحدات بالجملة دون تأكيد من المستخدم:
  - `pos_bloc.dart:461-491` → `_onAddProduct` (تقسيم retails عند `:487-491`).

### pos_return_widget.dart
- [منخفض] نصوص مكتوبة: `:48` `'وضع المرتجعات'`، `:288` `'${sum} ر.س'`.

### category_selector.dart
- [منخفض] نصوص مكتوبة: `:31` `'الكل'`.

### add_unit_dialog.dart
- [منخفض] نصوص مكتوبة: `:36` `'إضافة وحدة لـ ...'`، `:46` `'اسم الوحدة (مثلاً: كرتون)'`، `:48` `'مطلوب'`، `:53` `'المعامل ...'`، `:54` helper، `:59` `'أدخل رقماً صحيحاً'`، `:60` `'المعامل يجب أن يكون أكبر من 1'`.

### barcode_scanner_dialog.dart
- [منخفض] نصوص مكتوبة: `:13` `'ماسح الباركود'`.

### checkout_dialog.dart
- [منخفض] العملة الاحتياطية `'SAR'` مكتوبة (fallback) بلا l10n.

### cart_widget.dart / pos_page.dart / product_search_widget.dart
- سليم وظيفياً؛ `product_search_widget.dart` يستخدم debounce (`:79`).

---

## الخاتمة: أهم 20 مشكلة (بلا تكرار، كلها بأدلة أعلاه)

1. [حرج] `convertToSale` لا ينشئ حركات مخزون ولا يحدّث رصيد العميل — تحويل طلبية→فاتورة يتجاوز `postSale` (sales_order_service.dart:246-282).
2. [حرج] الدفع "المجزأ" في sales_invoice_page: حقوله تجمع المبالغ لكن `_saveInvoice` يتجاهلها وتُحفظ الفاتورة نقداً كاملة (sales_invoice_page.dart:415-417/461/767-823/973-978).
3. [متوسط] زر "طباعة" في purchases_page يُظهر SnackBar فقط دون طباعة فعلية (purchases_page.dart:270-278).
4. [متوسط] pagination معطّلة في sales_history_page: `_currentPage` لا يتقدم أبداً (sales_history_page.dart:20-21/80-84).
5. [متوسط] فلترا العميل/المستودع في sales_history_page بلا أي واجهة (sales_history_page.dart:26-27/271-275).
6. [متوسط] البحث في sales_orders_page يَعِد باسم العميل لكنه يفحص orderNumber/id فقط (sales_orders_page.dart:102 مقابل 268-273).
7. [متوسط] التحويل لأمر شراء يُنفَّذ بحقن Drift خام في الواجهة دون `supplierId` ودون فحص أخطاء (sales_orders_page.dart:469-487، sales_order_detail_page.dart:367-385).
8. [متوسط] الإجمالي الفرعي في purchase_details_page محسوب خطأً `total - tax` عند وجود خصم/شحن/تكاليف (purchase_details_page.dart:169 مقابل add_purchase_page.dart:71-72).
9. [متوسط] طباعة PDF في purchase_details_page تعرض `productId.substring(0,8)` بدل اسم الصنف (purchase_details_page.dart:295-298).
10. [متوسط] الأصناف الجديدة في add_sales_order_page بلا `unitId` فيفقد تحديد الوحدة (add_sales_order_page.dart:304-310/334).
11. [متوسط] أخطاء التحميل في sales_order_detail_page تُبتلع وتظهر كـ"الطلبية غير موجودة" (sales_order_detail_page.dart:60/75-80).
12. [متوسط] supplier_payments_page كاملة عربي مكتوب + StreamBuilder خام بلا DAO/l10n/ترقيم (supplier_payments_page.dart:15-33).
13. [متوسط/أداء] لا ترقيم صفحات في قوائم الطلبيات: `getAllOrders` بلا حد (sales_order_service.dart:12-16، sales_orders_provider.dart:37-55).
14. [منخفض/أداء] خمسة استعلامات COUNT متسلسلة عند كل تحميل في sales_orders_provider (sales_orders_provider.dart:57-65) مع غياب عدّاد `INVOICED`.
15. [منخفض] تنسيق تاريخ غربي `MM/dd` في تطبيق عربي (sales_orders_page.dart:134/163) وتاريخ `yyyy-MM-dd` في supplier_payments_page.dart:47.
16. [منخفض/أداء] تحميل كل المنتجات دفعة واحدة في حوار إضافة الصنف (add_sales_order_page.dart:440-451).
17. [منخفض/معماري] StreamBuilder خام على `db` بدل الـ DAO في add_sales_order_page.dart:112-134 وpurchase_orders_page.dart:24-28 وsales_return_page.dart:18-21.
18. [منخفض] عملة احتياطية `'USD'` في purchases_page.dart:176 و`'SAR'` في checkout_dialog — ترجمة/عملة جزئية.
19. [منخفض] supplier_performance_page بلا سحب للتحديث وبلا معالجة أخطاء (يُنهار عند فشل الخدمة) (supplier_performance_page.dart:21-28).
20. [منخفض] استعلامات N+1 متكررة: جلب أصناف المشتريات (purchase_details_page.dart:203-219) وقيد اليومية (purchases_page.dart:427-431).

### ملاحظات إضافية (نطاق واسع)
- عربي مكتوب بلا l10n منتشر بكثافة في: sales_orders كاملة، purchases_page، supplier_payments_page، add_supplier_payment_page، supplier_statement_page، sales_invoice_page، sales_history_page، pos (add_unit_dialog/barcode/category_selector/pos_return_widget)، commissions_page، purchase_orders_page، supplier_performance_page.
- صيغ العملة مكتوبة حرفياً (`'ر.س'`) في sales_orders_page.dart:332 وadd_sales_order_page.dart:269 وsupplier_payments_page.dart:54 وpos_return_widget.dart:288 بدل استخدام `NumberFormat.currency`.
- النوافذ الجيدة (بلا مشاكل مؤكدة): purchase_return_page، add_purchase_return_page، returns_page، create_return_page، sale_details_bottom_sheet، cart_widget، product_search_widget، purchase_details_page (من ناحية l10n جزئياً).
- تصحيح عن جولة سابقة: `add_edit_supplier_dialog.dart:124-129` (companion بدون id) ليست مشكلة لأن `_editSupplier` يحدّث بمعيار `supplier.id` — أُسقطت من التقرير.
