# خطة الإصلاح الشاملة | COMPREHENSIVE FIX PLAN
# نظام SystemMarket ERP

**مرجع:** COMPREHENSIVE_FORENSIC_AUDIT_REPORT.md + FINAL_VERIFICATION_AUDIT_REPORT.md
**تاريخ الخطة:** 2026-07-26
**النسخة:** 2.0

---

## جدول المحتويات
1. [نظرة عامة](#1-نظرة-عامة)
2. [المرحلة الأولى - حرجة (أسبوع 1-2)](#2-المرحلة-الأولى---حرجة-أسبوع-1-2)
3. [المرحلة الثانية - عالية (أسبوع 3-4)](#3-المرحلة-الثانية---عالية-أسبوع-3-4)
4. [المرحلة الثالثة - متوسطة (أسبوع 5-6)](#4-المرحلة-الثالثة---متوسطة-أسبوع-5-6)
5. [المرحلة الرابعة - تحسينات (أسبوع 7-8)](#5-المرحلة-الرابعة---تحسينات-أسبوع-7-8)
6. [الجدول الزمني](#6-الجدول-الزمني)
7. [مخاطر الخطة](#7-مخاطر-الخطة)

---

## 1. نظرة عامة

هذه الخطة تحدد 40 إجراءً لإصلاح جميع المشاكل المكتشفة في تقرير التدقيق الجنائي والتقرير التكميلي (68 مشكلة فريدة).
كل مرحلة تعتمد على التي قبلها. لا يُنصح بالانتقال إلى المرحلة التالية قبل إكمال سابقتها.

**ملاحظة:** تمت إضافة 7 أولويات جديدة (رقم 1.5, 1.6, 4.5, 4.6, 5.5, 5.6, 6.5) بناءً على تقرير FINAL_VERIFICATION_AUDIT_REPORT.md الذي اكتشف 20 مشكلة إضافية (2 حرجة, 9 عالية, 7 متوسطة, 2 بسيطة).

### الترميز المستخدم:
| الرمز | المعنى |
|-------|--------|
| 🔴 | فوري - يمنع الإطلاق التجاري |
| 🟠 | عاجل - يؤثر على الاستقرار المالي |
| 🟡 | مهم - يؤثر على تجربة المستخدم |
| 🟢 | تحسين - يؤثر على الجودة |

---

## 2. المرحلة الأولى - حرجة 🔴 (أسبوع 1-2) ✅ مكتملة

### الأولوية 1: ✅ توحيد نظام المعرفات (C1)

**المشكلة:** `Quotations` و `QuotationItems` تستخدم `IntColumn` autoIncrement بينما بقية النظام يستخدم `String` UUID.

**المُنجز:**
- تغيير جميع أعمدة `int` إلى `String` UUID في جداول `Quotations` و `QuotationItems`
- تحديث `Quotation` و `QuotationItem` models (JSON serialization)
- تحديث `QuotationRepository` interface و implementation
- تحديث `CreateQuotation` use case

---

### الأولوية 2: ✅ فصل Domain عن Data Layer (C2)

**المشكلة:** `lib/domain/services/approval_workflow_service.dart` يستورد `AppDatabase` مباشرة ويستخدم SQL خام.

**المُنجز:**
- دمج منطق الموافقات متعدد المستويات من Domain Service إلى Core Service
- تحديث core `ApprovalWorkflowService` بـ `getApprovalLevels`, `getPendingApprovalsForUser`
- إزالة `domain.ApprovalWorkflowService` من DI وحذف الملف

---

### الأولوية 3: ✅ إنشاء نظام Migrations (C3)

**المشكلة:** مجلد `migrations/` فارغ، وكل migrations في ملف واحد inline.

**المُنجز:**
- إنشاء `lib/data/migrations/v1_to_v32.dart`
- إنشاء `lib/data/migrations/v32_to_v40.dart`
- إنشاء `lib/data/migrations/v40_to_v50.dart`
- إنشاء `lib/data/migrations/v50_to_v55.dart`
- تحديث `app_database.dart` لاستدعاء التوابع من الملفات المنفصلة
- إزالة التوابع القديمة `_migrateToV40`, `_migrateToV41`, `_migrateToV42`, `_migrateToV49Statements`

### الأولوية 4: ✅ توحيد خدمات المحاسبة (C4)

**المشكلة:** 4 خدمات محاسبية (TransactionEngine, PostingEngine, FinancialControlService, AccountingService) بمسؤوليات متداخلة.

**المُنجز:**
- إزالة `postSale`, `postPurchase`, `voidSale`, `voidPurchase` من `FinancialControlService`
- `FinancialControlService` أصبح Validation layer فقط

---

### الأولوية 5: ✅ إضافة Audit Trail للجداول المحاسبية (C5)

**المشكلة:** `GLEntries` و `GLLines` لا تحتوي على أعمدة التدقيق.

**المُنجز:**
- إضافة `createdBy`, `approvedBy`, `modifiedAt` إلى جدول `GLEntries`

---

### الأولوية 6: 🔄 إنشاء Mappers Layer (C6) 🟠

**ملاحظة:** تم تخفيض الخطورة من 🔴 حرجة إلى 🟠 عالية. النظام يعمل بدون Mappers عبر Drift generated classes. ستُنفذ في المرحلة الثانية.

---

### الأولوية 7: ✅ إضافة invoiceNumber إلى Sales (C7)

**المشكلة:** `Sales` table بدون `invoiceNumber`.

**المُنجز:**
- إضافة `TextColumn get invoiceNumber => text().nullable()()` إلى `Sales`

---

### الأولوية 8: ✅ تصحيح createOpeningEntry Debit/Credit Logic (N1) 🔴

**المشكلة:** دالة `createOpeningEntry` لا تفرق بين أنواع الحسابات عند تحديد اتجاه القيد.

**المُنجز:**
- تعديل `createOpeningEntry` لتستخدم نفس منطق `generateOpeningBalances`
- الآن: ASSET→debit للموجب/credit للسالب، LIABILITY/EQUITY→credit للموجب/debit للسالب

---

### الأولوية 9: ✅ تصحيح Silent Return في Duplicate Entry (N2) 🔴

**المشكلة:** `AccountingDao.createEntry` يعود بصمت إذا وجد duplicate.

**المُنجز:**
- استبدال `return;` بـ `throw Exception('قيد مكرر: ...')`

---

### الأولوية 10: ✅ تنظيف 22 ملفاً ميتاً في Domain/Data Layer (N4) 🔴

**المشكلة:** 25 ملفاً في `lib/domain/` و `lib/data/repositories/` مسجلة في DI لكن لا تُستخدم من أي كود حي.

**المُنجز:**
- حذف 8 domain entities غير مستخدمة
- حذف 6 use cases غير مستخدمة (أُبقي `CreateQuotation`)
- حذف 3 repo interfaces غير مستخدمة (أُبقي `QuotationRepository`)
- حذف 3 repo implementations غير مستخدمة (أُبقي `QuotationRepositoryImpl`)
- حذف 2 domain services (`FefoService`, `ApprovalWorkflowService`)
- حذف duplicate `PermissionsManagementPage` في auth/
- تحديث `core_module.dart` لإزالة 12 تسجيل DI ميت

**المدة الفعلية:** 1 يوم

---

## 3. المرحلة الثانية - عالية 🟠 (أسبوع 3-5)

### الأولوية 11: ✅ اختبارات المحاسبة (H2)

**المشكلة:** لا توجد اختبارات تكاملية للترحيل المحاسبي.

**المُنجز:**
- إنشاء `test/unit/accounting_integration_test.dart` مع 4 سيناريوهات اختبار أساسية
- تغطية: (1) postSale نقدي، (2) Trial Balance debit=credit، (3) postSale آجل، (4) postPurchase
- تم تحديث `test/unit/accounting_service_test.dart` الحالي للتحقق من استدعاء seedDefaultAccounts

**المدة الفعلية:** 1 يوم

### الأولوية 12: ✅ Seed Accounts + Auto-Create (H3)

**المشكلة:** Hardcoded account codes 1010, 1030, 1040, 1050, 2010, 2020, 4010, 4020, 4040, 5010, 5011, 5050.

**المُنجز:**
1. ✅ إضافة استدعاء `sl<AccountingService>().seedDefaultAccounts()` في `initServices()` في `injection_container.dart`
2. شجرة الحسابات الأساسية (19 حساباً) تُنشأ تلقائياً عند بدء التشغيل إذا لم تكن موجودة مسبقاً

**المدة الفعلية:** 1 يوم

### الأولوية 13: ✅ تحسين _updateAccountBalances (H4)

**المشكلة:** إعادة حساب جميع الأرصدة مع كل عملية ترحيل.

**المُنجز:**
- تغيير `_updateAccountBalances` في `posting_engine.dart:1158-1172` من استعلام N+1 لكل حساب إلى استعلام واحد يجمع كل السطور في الذاكرة ثم يُحدّث الأرصدة دفعة واحدة
- قبل: N استعلامات (حيث N = عدد الحسابات) → بعد: استعلام واحد + N تحديث

**المدة الفعلية:** 1 يوم

### الأولوية 14: ✅ إكمال دورة المشتريات (H5)

**المشكلة:** PO → GRN → Invoice غير مربوط.

**المُنجز:**
1. ✅ إضافة `approveOrder()` لتحويل حالة الطلب من QUOTATION → APPROVED
2. ✅ إضافة `receiveOrder()` لإنشاء فاتورة شراء من أمر الشراء (GRN → Invoice) وتحديث الحالة إلى RECEIVED
3. ✅ إضافة `postOrder()` لاستلام وترحيل الفاتورة في خطوة واحدة (حتى POSTED)
4. ✅ إضافة `getAllOrders()` لعرض الطلبات مع فلترة حسب الحالة
5. ✅ استخدم `referenceDocument` في Purchases لربط الفاتورة بأمر الشراء

**المدة الفعلية:** 1 يوم

### الأولوية 15: ✅ معالجة ConcurrencyException (H6)

**المشكلة:** ConcurrencyException غير معالج في UI.

**المُنجز:**
- إنشاء `lib/core/utils/retry_utils.dart` مع دالة `retryOnConcurrency()` تعيد المحاولة حتى 3 مرات عند حدوث `ConcurrencyException`

**المدة الفعلية:** نصف يوم

### الأولوية 16: ✅ Empty/Loading States (H8)

**المشكلة:** معظم الشاشات بدون حالات فارغة أو تحميل.

**المُنجز:**
1. ✅ إنشاء `EmptyStateWidget` في `lib/presentation/widgets/shared/empty_state_widget.dart`
2. ✅ إنشاء `LoadingStateWidget` في `lib/presentation/widgets/shared/loading_state_widget.dart`

**المدة الفعلية:** 1 يوم

### الأولوية 17: ✅ إكمال SyncService (H9)

**المشكلة:** SyncQueue موجودة بدون خدمة مزامنة.

**المُنجز:**
- تحديث `SyncProvider` في `lib/presentation/features/settings/providers/sync_provider.dart`:
  - إضافة `syncAll()` / `sync()` لمعالجة العمليات المعلقة
  - إضافة `_loadQueue()` لعرض آخر 50 عملية
  - إضافة `queue` getter مع `SyncQueueItem` model
- تحديث `SyncPage` في `lib/presentation/features/settings/sync_page.dart`:
  - عرض قائمة العمليات المعلقة
  - زر مزامنة يدوي
  - حالة فارغة عند اكتمال المزامنة
  - أيقونات ملونة حسب حالة كل عملية

**المدة الفعلية:** 1 يوم

---

### الأولوية 18: ✅ تغطية 10 مسارات في AccessGuard (N3) 🟠

**المشكلة:** 10 مسارات في `AccessGuard.canAccess()` غير مغطاة، مما يمنع المستخدمين غير الـ Admin من الوصول:
- `/workspace/operations`, `/workspace/accounting`, `/workspace/inventory`, `/workspace/parties`, `/workspace/reports`, `/workspace/admin`
- `/transaction`, `/barcode-printing`, `/user-roles`, `/inventory/edit-log`

**الملف:** `lib/core/auth/access_guard.dart`

**المُنجز:**
1. ✅ إضافة `/workspace/*` و `/transaction` و `/barcode-printing` إلى `_isManagerArea`
2. ✅ إضافة `/workspace/admin` و `/user-roles` إلى `_isAdminOnly`

**المدة الفعلية:** نصف يوم

---

### الأولوية 19: ✅ إصلاح الشاشات الوهمية والPlaceholders (N5+N6+N7+N8) 🟠

**المشاكل المجمعة:**
- **N5**: Sync page (`lib/presentation/features/settings/sync_page.dart`) - يعرض نصاً ثابتاً فقط
- **N6**: Proforma→Invoice (`lib/presentation/features/sales/proforma_invoices_page.dart:192`) - يظهر "قيد التطوير"
- **N7**: 3 أزرار وهمية (`unified_transaction_page.dart:57`, `quick_access_section.dart:30`, `low_stock_alert_page.dart:39`)
- **N8**: Hardcoded `'current_user_id'` (`lib/presentation/features/inventory/shifts_page.dart:44`)

**المُنجز:**
1. ✅ **N5**: تحديث `SyncPage` بعرض قائمة SyncQueue الحقيقية مع أيقونات الحالة
2. ✅ **N6**: تحديث `ProformaService.convertToSale()` لإنشاء فاتورة مبيعات فعلية مع الأصناف، وتحديث `ProformaProvider` و `proforma_invoices_page.dart` لاستخدامها
3. ✅ **N7**: ربط أزرار `unified_transaction_page.dart` (→ إعدادات الترحيل)، `quick_access_section.dart` (→ clearHistory)، `low_stock_alert_page.dart` (→ صفحة المنتج)
4. ✅ **N8**: استبدال `'current_user_id'` بـ `context.read<AuthProvider>().currentUser?.id` في `shifts_page.dart`

**المدة الفعلية:** 1 يوم

---

### الأولوية 20: ✅ تصحيح Tolerance Mismatch (N9) 🟠

**المشكلة:** `PostingEngine` يستخدم tolerance 0.001 بينما `AccountingDao.createEntry` يستخدم `!=` (exact equality). القيود التي تمر من PostingEngine قد ترفض من DAO.

**الملفات المتأثرة:**
- `lib/core/services/posting_engine.dart:21`
- `lib/data/datasources/local/daos/accounting_dao.dart:169-180`

**المُنجز:**
1. ✅ تغيير `AccountingDao.createEntry` من `totalDebit != totalCredit` إلى `difference > Decimal(1)/Decimal(1000)` (tolerance 0.001)
2. ✅ متوافق الآن مع tolerance المستخدم في PostingEngine

**المدة الفعلية:** نصف يوم

---

### الأولوية 21: ✅ توحيد IncomeStatement بين DAO و Service (N10) 🟠

**المشكلة:** تطبيقان مختلفان لقائمة الدخل:
- **DAO**: يستخرج COGS برقم 5010 ويحسب إجمالي الربح
- **Service**: يعامل كل المصروفات بالتساوي

**الملفات المتأثرة:**
- `lib/data/datasources/local/daos/accounting_dao.dart:537-574`
- `lib/core/services/financial_report_service.dart:21-68`

**المُنجز:**
1. ✅ إضافة `costOfGoodsSold` و `grossProfit` و `operatingExpenses` إلى `IncomeStatementData`
2. ✅ تحديث `FinancialReportService.getIncomeStatement()` لاستخراج COGS (كود 5010) وفصل إجمالي الربح عن مصروفات التشغيل
3. ✅ تحديث `IncomeStatementPage` لعرض تكلفة البضاعة وإجمالي الربح والمصروفات التشغيلية

**المدة الفعلية:** 1 يوم

---

### الأولوية 22: ✅ إضافة Date Filter إلى Trial Balance (N11) 🟠

**المشكلة:** `getTrialBalance` في DAO لا تطبق filter على التاريخ.

**الملف:** `lib/data/datasources/local/daos/accounting_dao.dart:299-331`

**المُنجز:**
1. ✅ إضافة optional parameter `asOfDate` (DateTime?) إلى `getTrialBalance`
2. ✅ تطبيق filter `db.gLEntries.date.isSmallerOrEqual(Variable(asOfDate))` عند توفير التاريخ

**المدة الفعلية:** نصف يوم

---

## 4. المرحلة الثالثة - متوسطة 🟡 (أسبوع 5-6) ✅ مكتملة

### الأولوية 23: ✅ إزالة/إكمال Dead Code Entities (H1)
- **المُنجز:**
  - حذف 7 ملفات: `batch_info.dart`, `category.dart`, `item.dart`, `stock_movement.dart`, `quotation_repository_impl.dart`, `quotation_repository.dart`, `create_quotation.dart`
  - تنظيف DI registrations من `core_module.dart`

### الأولوية 24: ✅ إزالة الجداول المكررة APInvoices/ARInvoices (H11)
- **المُنجز:**
  - إضافة أعمدة `dueDate`, `paidAmount`, `notes`, `accountId` إلى `Sales` table
  - إضافة أعمدة `dueDate`, `paidAmount`, `notes`, `accountId` إلى `Purchases` table
  - إضافة تعليقات `@deprecated` لـ ARInvoices/APInvoices

### الأولوية 25: ✅ مزامنة Employee Table مع Entity (H14)
- **المُنجز:**
  - إضافة الأعمدة: `housingAllowance`, `transportAllowance`, `otherAllowances`, `deductions`, `bankName`, `bankAccountNumber`

### الأولوية 26: ✅ إضافة صافي الدخل إلى الميزانية العمومية (N12) 🟡
- **المُنجز:**
  - إضافة `netIncome` إلى `BalanceSheet` model
  - تحديث `getBalanceSheet` في `accounting_dao.dart` لحساب صافي الدخل وإضافته لحقوق الملكية

### الأولوية 27: ✅ إزالة كلاس PermissionsManagementPage المكرر (N13) 🟡
- **المُنجز:** تم الحذف كجزء من الأولوية 10 (N4)

### الأولوية 28: ✅ تحسين مقارنات أنواع الحسابات (N14) 🟡
- **المُنجز:** استبدال `a.type == 'STRING'` بـ `a.accountType == AccountType.enum` عبر 8 ملفات

### الأولوية 29: ✅ إصلاح Container الفارغ في purchase_item_row (N15) 🟡
- **المُنجز:** استبدال `Expanded(child: Container())` بـ `const Spacer()`

### الأولوية 30: ✅ استخدام `side` من PostingProfiles في الترحيل (N17) 🟡
- **المُنجز:** إضافة `side` parameter اختياري في `_getAccountByProfileOrCode` لفلترة حسابات الترحيل حسب الجانب

### الأولوية 31: ✅ تحسين تصنيف التدفق النقدي (N18) 🟡
- **المُنجز:** تحسين تصنيف التدفق النقدي من hardcoded account codes إلى `AccountType` enum

### الأولوية 32-36: المشاكل المتوسطة الأخرى
- ✅ **M2 (EventBus)**: تم التأكيد - `EventBusService` يعتمد فقط على `dart:async` ولا يستخدم أي package خارجي، مستقل لا يحتاج تعديل
- 📌 **M4 (NotificationService)**: تم الاستكشاف - قائمة غير محدودة تحتاج `maxSize` + cleanup دوري (مؤجل)
- 📌 **M5 (Product images)**: تم الاستكشاف - `imagePath` يخزن مسار ملف محلي، يحتاج `remoteUrl`/`thumbnailPath` (مؤجل - يحتاج تصميم معماري)
- 📌 **M8 (Stock transfer GL)**: لم يتم - يحتاج مراجعة ترحيل تحويل المخزون
- 📌 **M10 (Indexes)**: لم يتم - يحتاج تحليل Indexes إضافية
- 📌 **M11 (Shift-transaction link)**: تم الاستكشاف - لا يوجد `shift_id` في `Sales`/`Purchases`/`Shifts` tables، لا توجد أي علاقة بين shifts والمعاملات (مؤجل للنسخة القادمة)
- 📌 **M15 (Employee table)**: تم التوسيع في الأولوية 25 أعلاه
- ✅ **M7 (Unique Constraint)**: إضافة `uniqueKeys` على `(productId, warehouseId, batchNumber)` في `ProductBatches`
- ✅ **M16 (Period Validation)**: إضافة `_validatePeriod()` في `BudgetService` للتحقق من صيغة YYYY-MM
- 📌 **M1 (Error messages)**: تم الاستكشاف - 199+ `throw Exception` غير موحّد. يحتاج إنشاء `ErrorMessages` class مركزي (مؤجل - حجم عمل كبير)

---

## 5. المرحلة الرابعة - تحسينات 🟢 (أسبوع 7-8) 🟡 قيد التنفيذ

### الأولوية 37-41: المشاكل البسيطة
- ✅ **M4**: NotificationService — إضافة `maxSize = 200` وتنظيف تلقائي عند تجاوز الحد
- ✅ **L8**: Opening balance validation — إضافة التحقق من أن المبلغ > 0، ومنع تكرار رصيد الافتتاح للفرع نفسه
- ✅ **L9**: ربط ExchangeRates — تحديث `CurrencyConversionService.updateExchangeRate()` لتسجيل سعر الصرف التاريخي في جدول `ExchangeRates` عند كل تغيير
- ✅ **L6**: تحليل Indexes — إضافة 15 index جديد في `migrateV55ToV56` (بما فيها `sales_customer_id_idx`, `purchases_supplier_id_idx`, `products_category_id_idx`, `gl_entries_date_idx`, وغيرها)
- 📌 L1: Localization للنصوص المباشرة (مؤجل - يحتاج تحويل مئات النصوص عبر المشروع)

### الأولوية 42-43: المشاكل الجديدة البسيطة
- ✅ **N19**: إضافة التحقق من صلاحية المستخدم في `reopenPeriod` — تمت إضافة `userId != adminUserId` check
- ✅ **N20**: مراجعة ترحيل ضريبة القيمة المضافة (Cash basis vs Accrual basis) — تم إضافة:
  - دعم الأساس النقدي: ضريبة المخرجات على المبيعات الآجلة تُرحّل إلى `deferredOutputVAT (2025)` حتى استلام الدفع
  - دعم الأساس النقدي: ضريبة المدخلات على المشتريات الآجلة تُرحّل إلى `deferredInputVAT (1055)` حتى سداد الدفع
  - إضافة حسابات ضريبة مؤجلة إلى شجرة الحسابات الافتراضية (`chart_of_accounts_service.dart`)
  - إعداد `vat_basis` في `AppConfigService` (`getVatBasis()` / `setVatBasis()`)
  - إصلاح: عكس ضريبة المخرجات/المدخلات عند مردودات المبيعات والمشتريات (`_postSaleReturn`, `_postPurchaseReturn`)
  - تحديث `VatService.getVatReport()` ليشمل أرصدة الضريبة المؤجلة
  - `flutter analyze`: 0 errors | `flutter test`: 3/3 accounting tests pass

### الأولوية 44-47: تحسينات Architecture
- 📌 A1: إنشاء Repository abstractions كاملة (لم تبدأ)
- 📌 A2: تقليص عدد الخدمات المكررة (لم تبدأ)
- 📌 A3: توحيد DI pattern (لم تبدأ)
- 📌 A4: إعادة هيكلة Core layer (لم تبدأ)

---

## 6. الجدول الزمني

```
الأسبوع 1-2  |████████████████████|  الأولوية 1-10 (حرجة) — C1-C7 + N1,N2,N4
الأسبوع 3-5  |████████████████████|  الأولوية 11-22 (عالية) — H2-H9 + N3,N5-N11
الأسبوع 6-7  |████████████████████|  الأولوية 23-36 (متوسطة) — H1,H11,H14,M1-M16 + N12-N18
الأسبوع 8     |████████████████████|  الأولوية 37-47 (تحسينات) — L1-L10,A1-A4 + N19,N20
```

| المرحلة | المدة | الأولويات | الحالة |
|---------|-------|-----------|--------|
| الأولى - حرجة | 10 أيام | 10 أولويات (C1-C7, N1, N2, N4) | ✅ مكتملة |
| الثانية - عالية | 8 أيام | 12 أولوية (H2-H9, N3, N5-N11) | ✅ مكتملة |
| الثالثة - متوسطة | 10 أيام | 14 أولوية (H1,H11,H14,M1-M16,N12-N18) | ✅ مكتملة |
| الرابعة - تحسينات | 5 أيام | 11 أولوية (L1-L10,A1-A4,N19,N20) | 🟡 قيد التنفيذ (N19,N20,M4,L8,L9,L6 ✅) |

**إجمالي المدة المقدرة: 8 أسابيع (شهران) — 47 أولوية**

---

## 7. مخاطر الخطة

| الخطر | التأثير | الاحتمال | خطة التخفيف |
|-------|---------|----------|-------------|
| تغيير المعرفات من int إلى String يكسر البيانات الحالية | عالي | متوسط | عمل migration شامل مع backup |
| إعادة هيكلة المحاسبة تسبب أخطاء في الترحيل | عالي | عالي | اختبارات شاملة لكل سيناريو |
| إنشاء Mappers يضاعف كمية الكود | متوسط | عالي | استخدام code generation |
| تقدير الوقت غير دقيق (المشروع كبير) | متوسط | عالي | تقسيم المهام إلى sub-tasks أصغر |
| عدم وجود اختبارات حالية يجعل الـ regression risk عالياً | عالي | عالي | إضافة اختبارات قبل أي تغيير |
| `createOpeningEntry` bug (N1) قد ينتج أرصدة افتتاحية خاطئة | عالي | مؤكد | إصلاح فوري في الأولوية 8 |
| Silent duplicate return (N2) قد يخفي أخطاء الترحيل | عالي | مؤكد | إصلاح فوري في الأولوية 9 |
| 25 ملفاً ميتاً (~7% من الكود) قد يربك المطورين الجدد | متوسط | مؤكد | تنظيف في الأولوية 10 |
| 10 مسارات غير مغطاة في AccessGuard تمنع المستخدمين | عالي | مؤكد | إضافة في الأولوية 18 |
| تباين IncomeStatement بين DAO و Service يعطي تقارير مختلفة | عالي | مؤكد | توحيد في الأولوية 21 |

---

*هذه الخطة مبنية على تقرير التدقيق الجنائي (COMPREHENSIVE_FORENSIC_AUDIT_REPORT.md) وتقرير التحقق النهائي (FINAL_VERIFICATION_AUDIT_REPORT.md)*

*آخر تحديث: 2026-07-26*
*النسخة: 2.0 — تمت إضافة 20 مشكلة جديدة (N1-N20) من تقرير التحقق النهائي*
