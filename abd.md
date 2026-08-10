SYSTEMMARKET ERP — MASTER FORENSIC REPAIR & VERIFIED CHECKLIST

أنت تعمل الآن كمهندس Flutter/Dart وERP ومحاسبة وقواعد بيانات واختبارات برمجية.

لديك نظام SystemMarket ERP مبني بـ Flutter/Dart وقاعدة بيانات محلية، ويحتوي على المبيعات والمشتريات والمخزون والمحاسبة والعملاء والموردين والموارد البشرية والتقارير والإعدادات ونقطة البيع.

تم إجراء تدقيقين سابقين للنظام، ويجب اعتبارهما مرجع الإصلاح الرسمي.

القاعدة الذهبية

لا تخمّن، ولا تفترض أن المشكلة موجودة أو غير موجودة.

قبل إصلاح أي مشكلة:

1. افتح الملفات الفعلية.
2. اقرأ الكود المرتبط بالمشكلة.
3. تحقق من قاعدة البيانات والجداول والـ DAO والـ Service والـ Provider/Bloc والواجهة.
4. حدد السبب الجذري Root Cause.
5. أصلح السبب الجذري، وليس العرض فقط.
6. تحقق من أن الإصلاح لا يكسر وظائف أخرى.
7. شغّل الاختبارات المناسبة.
8. لا تعتبر المهمة منفذة إلا بعد التحقق الفعلي.

---

1. سجل الإصلاح المركزي — MANDATORY

أنشئ ملفًا في جذر المشروع باسم:

"AUDIT_REPAIR_TRACKER.md"

هذا الملف هو السجل الرسمي الوحيد لحالة الإصلاح.

يجب أن يحتوي على جدول:

ID| المشكلة| الأولوية| الحالة| الملفات المعدلة| الاختبارات| النتيجة| ملاحظات
AUD-001| تحويل الطلبية إلى فاتورة لا يحدث حركة مخزون| CRITICAL| TODO| -| -| -| -

الحالات المسموحة فقط:

- "TODO"
- "IN_PROGRESS"
- "DONE"
- "BLOCKED"
- "VERIFIED"
- "REGRESSION"

لا تضع "DONE" إلا بعد نجاح التنفيذ والتحقق.

بعد الإصلاح والاختبار الناجح تصبح:

"DONE → VERIFIED"

إذا فشل اختبار أو ظهر خلل جديد:

"VERIFIED → REGRESSION"

---

2. قاعدة مهمة جدًا في التعامل مع المهام

نفذ المهام بالترتيب.

لا تنتقل إلى المهمة التالية قبل:

1. إكمال الحالية.
2. اختبارها.
3. تحديث "AUDIT_REPAIR_TRACKER.md".
4. تسجيل الملفات التي تغيرت.
5. تسجيل الاختبارات التي تم تشغيلها.
6. تسجيل النتيجة.

إذا كانت المشكلة تحتاج تعديل قاعدة البيانات، لا تعدل Schema عشوائيًا.

يجب:

- فحص schema الحالية.
- فحص migrations.
- التأكد من backward compatibility.
- إنشاء migration صحيحة إذا كانت ضرورية.
- اختبار قاعدة البيانات القديمة والجديدة.
- التأكد من عدم فقد البيانات.

---

3. عدم حذف أو إعادة بناء المشروع

ممنوع:

- حذف ملفات المشروع.
- حذف Features تعمل حاليًا.
- استبدال Architecture بالكامل.
- إعادة كتابة المشروع من الصفر.
- حذف Provider/Bloc/Service لمجرد أنه غير مثالي.
- إزالة وظائف موجودة بدون دليل.
- تغيير أسماء الجداول أو الأعمدة بدون migration.
- تغيير منطق المحاسبة بدون فهم الدورة كاملة.

أي تعديل يجب أن يكون Minimal Safe Change قدر الإمكان.

---

4. قائمة الإصلاح الرسمية

CRITICAL — المرحلة الأولى

AUD-001

إصلاح تحويل طلبية العميل إلى فاتورة.

يجب أن يتحقق النظام من أن:

طلبية العميل
→ فاتورة مبيعات
→ حركة مخزون
→ تحديث رصيد العميل
→ القيد المحاسبي
→ تحديث حالة الطلبية

ويجب ألا يتم إنشاء فاتورة بطريقة مختلفة عن مسار البيع الرسمي إذا كان "TransactionEngine.postSale" هو المحرك المحاسبي المعتمد.

تحقق من:

"sales_order_service.dart"

و:

"TransactionEngine.postSale"

ثم وحّد مسار التنفيذ بطريقة صحيحة.

اختبر:

- Cash sale
- Credit sale
- Split payment
- Inventory movement
- Customer balance
- Journal entry
- Order status

---

AUD-002

إصلاح الدفع المجزأ Split Payment في:

"sales_invoice_page.dart"

يجب أن يكون:

Cash amount + Credit amount = Total

ويجب حفظ كل جزء في النموذج المحاسبي الصحيح.

ممنوع أن يختار المستخدم Split ثم يتم حفظ العملية كـ Cash كاملة.

أضف اختبارات للحالات:

- Cash كامل
- Credit كامل
- Split صحيح
- Split أكبر من الإجمالي
- Split أقل من الإجمالي
- مبلغ صفر
- إلغاء العملية

---

AUD-003

إصلاح حفظ:

- Reference
- Terms
- Notes

في فاتورة المبيعات.

تحقق من:

UI
→ Model
→ Companion
→ DAO/Service
→ Database

ولا تكتفِ بإظهار الحقول في الواجهة.

---

AUD-004

إكمال:

- الخصم العام
- الضريبة
- المبلغ المتبقي
- تاريخ الاستحقاق عند الحاجة

في فاتورة المبيعات.

يجب التأكد من أن المعادلات متوافقة مع النظام المحاسبي الحالي.

---

AUD-005

إصلاح الترحيل المحاسبي التلقائي.

لا تضف ترحيلاً جديدًا إذا كان هناك Posting/Transaction Engine موجود.

ابحث أولًا عن المحرك الحالي ووحّد جميع العمليات عليه.

تحقق من:

Sales
Purchases
Returns
Payments
Receipts
Expenses
Inventory adjustments

---

AUD-006

إكمال القيد العكسي Reverse Entry.

يجب أن يكون القيد العكسي عملية محاسبية صحيحة وليس حذفًا للقيد الأصلي.

يجب الاحتفاظ بسجل التدقيق.

---

AUD-007

إكمال إغلاق الفترة المحاسبية.

يجب منع العمليات غير المسموحة بعد الإغلاق.

اختبر:

- Open period
- Closed period
- Reopening حسب الصلاحية
- Posting
- Sales
- Purchases
- Journal entries

---

AUD-008

فحص وإكمال:

- العملة
- سعر الصرف
- مركز التكلفة

في القيود المحاسبية، لكن لا تضف حقولًا جديدة قبل التأكد من أن الـ schema الحالية تحتاجها فعلًا.

---

SALES

AUD-009

إصلاح البحث في "sales_orders_page.dart".

إذا كان placeholder يقول:

"بحث برقم الطلبية أو اسم العميل"

فالبحث يجب أن يعمل فعليًا بالاثنين.

---

AUD-010

إصلاح تحويل طلبية العميل إلى أمر شراء.

ممنوع تنفيذ SQL/Drift خام من الواجهة.

يجب أن يكون:

UI
→ Provider/Bloc
→ Service
→ DAO/Repository
→ Database

ويجب:

- تحديد المورد.
- التحقق من البيانات.
- تنفيذ العملية Transactionally.
- معالجة الأخطاء.
- عدم تغيير حالة الطلبية إلا بعد نجاح العملية.

---

AUD-011

إصلاح "unitId" في "add_sales_order_page.dart".

كل صنف يجب أن يحفظ وحدته الصحيحة.

اختبر:

- Base unit
- Alternative unit
- Conversion factor
- Quantity
- Price
- Save/reload

---

AUD-012

إصلاح Pagination في:

"sales_history_page.dart"

يجب أن تعمل الصفحات فعليًا، وليس مجرد قص القائمة إلى أول 20 عنصرًا.

---

AUD-013

إظهار واجهة حقيقية لفلاتر:

- Customer
- Warehouse
- Date
- Status

والتأكد أن الفلاتر تغير الاستعلام فعليًا.

---

PURCHASES

AUD-014

إصلاح زر الطباعة في "purchases_page.dart".

يجب أن ينفذ خدمة الطباعة الفعلية.

ممنوع إظهار:

"جاري تحضير الطباعة..."

بدون تنفيذ الطباعة.

---

AUD-015

إصلاح PDF المشتريات ليعرض اسم المنتج بدل:

"productId.substring(0,8)"

---

AUD-016

إصلاح حساب subtotal في "purchase_details_page.dart".

يجب أن يتطابق الحساب مع منطق:

add_purchase_page.dart

ويجب عدم تكرار معادلات مالية مختلفة بين الشاشات.

أنشئ دالة/Service موحدة لحساب الإجماليات إذا كان ذلك مناسبًا.

---

AUD-017

إزالة N+1 Queries في تفاصيل المشتريات.

استخدم Query/Join/DAO مناسب بدل Query لكل منتج.

---

INVENTORY

AUD-018

فحص الوحدات المتعددة.

AUD-019

فحص الوحدة الأساسية.

AUD-020

فحص Conversion Factors.

AUD-021

ربط Minimum Stock بتنبيهات المخزون.

AUD-022

إكمال Expiry Date إذا كانت قاعدة البيانات والنظام يدعمانها.

AUD-023

فحص Serial Numbers والتتبع التاريخي.

AUD-024

إكمال الجرد الدائري إن كان ضمن المتطلبات الفعلية.

في كل مهمة:

UI
→ State
→ Service
→ DAO
→ DB

يجب أن تكون السلسلة كاملة.

---

CUSTOMERS / SUPPLIERS

AUD-025

إعادة تنظيم صفحات الموردين التي تستخدم StreamBuilder مباشر على قاعدة البيانات عندما يكون ذلك ضروريًا.

لا تقم بإعادة الهيكلة لمجرد التغيير؛ احتفظ بما يعمل.

---

AUD-026

إضافة Pagination للبيانات الكبيرة.

---

AUD-027

إصلاح معالجة أخطاء "supplier_performance_page.dart".

أي فشل في الخدمة يجب أن يظهر كحالة Error واضحة، وليس انهيار الصفحة.

---

AUD-028

إكمال الحقول الناقصة للموظفين فقط بعد التحقق من Schema والمتطلبات:

- Basic salary
- Contract expiry
- Attachments
- Join date
- Position

---

REPORTS

AUD-029

فحص التقارير والتأكد أن البيانات تأتي من مصادرها المحاسبية والمخزنية الصحيحة.

AUD-030

إضافة التقارير المخصصة إذا كانت البنية الحالية تدعمها.

AUD-031

إضافة المقارنات بين الفترات.

AUD-032

إضافة قيمة المخزون.

AUD-033

إضافة هامش الربح حسب المنتج.

AUD-034

إضافة Excel export للتقارير المطلوبة.

لا تضف Export جديدًا إذا كانت هناك خدمة Export موجودة؛ أعد استخدامها.

---

UI / UX

AUD-035

توحيد جميع العناوين العربية.

إزالة العناوين الإنجليزية غير المقصودة.

AUD-036

توحيد RTL.

تحقق من:

- Alignment
- Icons
- Direction
- Tables
- Forms
- Buttons

AUD-037

توحيد Design System:

- Colors
- Typography
- Spacing
- Buttons
- Inputs
- Cards
- Dialogs

لا تنشئ Theme جديدًا إذا كان هناك Theme حالي.

AUD-038

إصلاح Responsive:

- Mobile
- Tablet
- Landscape
- Small screens

AUD-039

إضافة حالات:

- Loading
- Empty
- Error
- Success

للشاشات التي تحتاجها.

AUD-040

تحسين رسائل الأخطاء.

بدل:

"فشل الحفظ"

يجب أن تكون الرسالة مفيدة للمستخدم بدون كشف معلومات حساسة.

---

LOCALIZATION

AUD-041

فحص جميع النصوص المكتوبة Hard-coded.

نقلها إلى نظام "l10n" الموجود.

لا تغير Architecture الترجمة إذا كانت موجودة بالفعل.

AUD-042

إزالة العملات المكتوبة مباشرة مثل:

"ر.س"
"USD"
"SAR"

واستخدام نظام العملة الحالي.

AUD-043

توحيد تنسيق التاريخ حسب لغة التطبيق.

---

PERFORMANCE

AUD-044

فحص Pagination لجميع القوائم الكبيرة.

AUD-045

إزالة N+1 Queries.

AUD-046

تحسين الاستعلامات المتكررة.

AUD-047

فحص Cache فقط حيث يكون مفيدًا فعلًا.

AUD-048

استخدام "const" حيث يكون مناسبًا.

---

ARCHITECTURE

AUD-049

تحديد جميع الصفحات التي تصل مباشرة إلى "AppDatabase".

أنشئ تقريرًا:

File| Direct DB Access| Required Refactor| Status

ثم أصلح فقط الحالات التي تسبب مشكلة فعلية.

---

AUD-050

تحديد جميع Controllers غير المستخدمة أو غير المرتبطة.

AUD-051

تحديد جميع Providers/Blocs غير المستخدمة أو غير المرتبطة.

AUD-052

التأكد أن State transitions كاملة:

Loading
→ Success
→ Error
→ Empty

---

5. قبل كل إصلاح

قبل تنفيذ أي AUD-ID:

أضف:

"IN_PROGRESS"

ثم اكتب:

- Root cause
- Planned change
- Files expected to change

بعد التنفيذ:

- Files actually changed
- Tests executed
- Test result
- Regression check

ثم:

"DONE"

وبعد نجاح التحقق:

"VERIFIED"

---

6. الاختبارات المطلوبة

أنشئ أو حدّث الاختبارات المناسبة.

على الأقل:

Accounting

- Double entry balance
- Posting
- Reverse entry
- Period closing
- Customer balance

Sales

- Cash sale
- Credit sale
- Split payment
- Sales return
- Order → Invoice

Inventory

- Stock movement
- Unit conversion
- Quantity
- Warehouse
- Product balance

Purchases

- Purchase
- Purchase return
- Supplier balance
- Purchase totals

UI

- Search
- Filters
- Save
- Edit
- Delete
- Loading
- Error
- Empty state

---

7. التحقق بعد كل مرحلة

بعد كل مجموعة إصلاحات:

شغّل الأدوات المناسبة الموجودة في المشروع، مثل:

- "flutter analyze"
- "flutter test"

وأي اختبارات إضافية مناسبة.

إذا كان المشروع يستخدم build scripts أو code generation، شغّلها فقط إذا كانت مطلوبة.

لا تعتبر الإصلاح ناجحًا إذا فشل:

- Analyze
- Tests
- Compilation
- Database migration
- Critical business flow

---

8. Regression Protection

بعد كل إصلاح، تحقق من الوظائف التي قد تتأثر.

مثال:

إذا أصلحت Sales:

لا تختبر Sales فقط.

اختبر أيضًا:

Sales
→ Inventory
→ Customer balance
→ GL
→ Reports

إذا أصلحت Purchases:

اختبر:

Purchases
→ Inventory
→ Supplier balance
→ GL
→ Reports

إذا أصلحت Units:

اختبر:

Products
→ POS
→ Sales
→ Purchases
→ Inventory
→ Reports

---

9. ممنوع اعتبار المشكلة محلولة بسبب UI فقط

مثال:

إضافة حقل الضريبة إلى الشاشة لا يعني أن:

"AUD-004 = VERIFIED"

يجب أن تكون السلسلة:

UI
→ State
→ Model
→ Service
→ DAO
→ DB
→ Accounting
→ Reports

صحيحة.

---

10. في حالة اكتشاف مشكلة جديدة

لا تتجاهلها.

أضفها إلى:

"AUDIT_REPAIR_TRACKER.md"

باستخدام ID جديد:

"AUD-051"
"AUD-052"
...

ولا تغير IDs القديمة.

إذا كانت المشكلة نتيجة مباشرة لإصلاح سابق، اربطها به:

"Regression of AUD-012"

---

11. التقرير النهائي

بعد الانتهاء أنشئ:

"AUDIT_REPAIR_FINAL_REPORT.md"

ويحتوي على:

Summary

- Total issues
- Fixed
- Verified
- Blocked
- Regression

Verified Tasks

جدول بكل AUD-ID وحالته.

Files Changed

قائمة الملفات التي تم تعديلها.

Database Changes

كل migration/schema change.

Tests

كل الاختبارات التي تم تشغيلها ونتائجها.

Remaining Issues

أي مشكلة لم يتم حلها وسبب ذلك.

Regression Risks

أي أجزاء تحتاج اختبارًا إضافيًا.

---

12. قاعدة أخيرة مهمة جدًا

لا تقل "تم الإصلاح" بدون دليل.

كل مهمة يجب أن يكون لها:

1. ID
2. Root Cause
3. Fix
4. Files
5. Tests
6. Result
7. Verification status

ولا تستخدم:

"DONE"

أو:

"VERIFIED"

إلا بعد تنفيذ وفحص فعلي.

ابدأ الآن بالمرحلة الأولى فقط:

AUD-001 → AUD-008

اقرأ الكود الفعلي أولًا، ثم نفذ الإصلاحات، واختبرها، وحدّث "AUDIT_REPAIR_TRACKER.md".

بعد إكمال المرحلة الأولى بنجاح انتقل تلقائيًا إلى:

AUD-009 → AUD-017

ثم:

AUD-018 → AUD-034

ثم:

AUD-035 → AUD-043

ثم:

AUD-044 → AUD-052

وفي نهاية كل مرحلة أعطني تقريرًا مختصرًا يحتوي فقط على:

- ما تم إصلاحه
- AUD-IDs التي أصبحت VERIFIED
- الملفات المعدلة
- الاختبارات الناجحة
- المشاكل الجديدة المكتشفة
- المشاكل المتبقية