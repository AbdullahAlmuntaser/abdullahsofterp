# خطة الإصلاح الشاملة | COMPREHENSIVE FIX PLAN
# نظام SystemMarket ERP

**مرجع:** COMPREHENSIVE_FORENSIC_AUDIT_REPORT.md
**تاريخ الخطة:** 2026-07-26
**النسخة:** 1.0

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

هذه الخطة تحدد 25 إجراءً لإصلاح جميع المشاكل المكتشفة في تقرير التدقيق الجنائي.
كل مرحلة تعتمد على التي قبلها. لا يُنصح بالانتقال إلى المرحلة التالية قبل إكمال سابقتها.

### الترميز المستخدم:
| الرمز | المعنى |
|-------|--------|
| 🔴 | فوري - يمنع الإطلاق التجاري |
| 🟠 | عاجل - يؤثر على الاستقرار المالي |
| 🟡 | مهم - يؤثر على تجربة المستخدم |
| 🟢 | تحسين - يؤثر على الجودة |

---

## 2. المرحلة الأولى - حرجة 🔴 (أسبوع 1-2)

### الأولوية 1: توحيد نظام المعرفات (C1)

**المشكلة:** `Quotations` و `QuotationItems` تستخدم `IntColumn` autoIncrement بينما بقية النظام يستخدم `String` UUID.

**الملفات المتأثرة:**
- `lib/data/datasources/local/tables/core_tables.dart` ← جداول `Quotations`, `QuotationItems`
- `lib/data/models/quotation.dart` ← `Quotation`, `QuotationItem` models
- `lib/data/models/quotation.g.dart` ← Generated code
- `lib/data/repositories/quotation_repository_impl.dart` ← Repository impl
- `lib/domain/repositories/quotation_repository.dart` ← Repository interface
- `lib/domain/usecases/create_quotation.dart` ← Use case

**خطوات التنفيذ:**
1. تغيير `IntColumn get id => integer().autoIncrement()()` → `TextColumn get id => text()()`
2. تغيير `IntColumn get customerId => integer()()` → `TextColumn get customerId => text()()`
3. تغيير `IntColumn get productId => integer()()` → `TextColumn get productId => text()()` في `QuotationItems`
4. تحديث `Quotation` model و `.g.dart`
5. تحديث `QuotationRepository` interface (إزالة `int` واستبدال بـ `String`)
6. تحديث `QuotationRepositoryImpl`
7. تحديث `CreateQuotation` use case
8. إضافة migration v56 لتحويل البيانات إن وجدت

**الاختبارات:**
- اختبار إنشاء Quotation بـ UUID
- اختبار ربط Quotation مع Customer و Product

**المدة المقدرة:** 2-3 أيام

---

### الأولوية 2: فصل Domain عن Data Layer (C2)

**المشكلة:** `lib/domain/services/approval_workflow_service.dart` يستورد `AppDatabase` مباشرة ويستخدم SQL خام.

**الملفات المتأثرة:**
- `lib/domain/services/approval_workflow_service.dart` ← نقل/إعادة هيكلة
- `lib/core/di/core_module.dart` ← تحديث التسجيل

**خطوات التنفيذ:**
1. إنشاء `ApprovalWorkflowRepository` interface في `lib/domain/repositories/`
2. نقل المنطق من `DomainApprovalWorkflowService` إلى `CoreApprovalWorkflowService`
3. جعل خدمة Core تستخدم Repository interface
4. تسجيل الـ Repository implementation و Core service في DI
5. إزالة الـ Domain service
6. (توجد خدمة `ApprovalWorkflowService` مكررة في core - يجب دمجها)

**المدة المقدرة:** 1-2 يوم

---

### الأولوية 3: إنشاء نظام Migrations (C3)

**المشكلة:** مجلد `migrations/` فارغ، وكل migrations في ملف واحد inline.

**الملفات المتأثرة:**
- `lib/data/migrations/` ← إنشاء ملفات منفصلة
- `lib/data/datasources/local/app_database.dart` ← إعادة هيكلة

**خطوات التنفيذ:**
1. إنشاء `lib/data/migrations/v1_to_v32.dart`
2. إنشاء `lib/data/migrations/v32_to_v40.dart`
3. إنشاء `lib/data/migrations/v40_to_v50.dart`
4. إنشاء `lib/data/migrations/v50_to_v55.dart`
5. تحديث `app_database.dart` لاستخدام الملفات المنفصلة
6. إضافة migration من v1 إلى v32 (مفقودة حالياً)
7. اختبار الترقية من v1 → v55

-

### الأولوية 4: توحيد خدمات المحاسبة (C4)

**المشكلة:** 4 خدمات محاسبية (TransactionEngine, PostingEngine, FinancialControlService, AccountingService) بمسؤوليات متداخلة.

**الملفات المتأثرة:**
- `lib/core/services/transaction_engine.dart`
- `lib/core/services/posting_engine.dart`
- `lib/core/services/financial_control_service.dart`
- `lib/core/services/accounting_service.dart`

**خطوات التنفيذ:**
1. تحديد `PostingEngine` كـ single source of truth لإنشاء GL entries
2. `TransactionEngine` يبقى للعمليات التجارية (sale, purchase) ويستدعي `PostingEngine`
3. `FinancialControlService` يصبح Validation layer فقط (يزال posting منه)
4. إزالة طرق posting المكررة من `FinancialControlService`
5. توثيق المسؤوليات لكل service

**المدة المقدرة:** 3-4 أيام

---

### الأولوية 5: إضافة Audit Trail للجداول المحاسبية (C5)

**المشكلة:** `GLEntries` و `GLLines` لا تحتوي على أعمدة التدقيق.

**الملفات المتأثرة:**
- `lib/data/datasources/local/tables/advanced_accounting_tables.dart`

**خطوات التنفيذ:**
1. إضافة `createdBy` (`TextColumn`) إلى `GLEntries`
2. إضافة `approvedBy` (`TextColumn`, nullable) إلى `GLEntries`
3. إضافة `modifiedAt` (`DateTimeColumn`) إلى `GLEntries`
4. تحديث `SyncableTable` mixin ليشمل هذه الأعمدة للحسابات
5. ملء `createdBy` و `modifiedAt` في DAO
6. إضافة migration v56

**المدة المقدرة:** 1 يوم

---

### الأولوية 6: إنشاء Mappers Layer (C6)

**المشكلة:** مجلد `mappers/` فارغ.

**الملفات المتأثرة:**
- `lib/data/mappers/` ← إنشاء مابيرز جديدة

**خطوات التنفيذ:**
1. إنشاء `product_mapper.dart` (Item → Product)
2. إنشاء `customer_mapper.dart` (Customer → domain entity)
3. إنشاء `supplier_mapper.dart`
4. إنشاء `sales_mapper.dart`
5. إنشاء `purchase_mapper.dart`
6. إنشاء `account_mapper.dart` (GLAccount → GLAccountEntity)
7. ربط المابيرز في Repositories

**المدة المقدرة:** 3-4 أيام

---

### الأولوية 7: إضافة invoiceNumber إلى Sales (C7)

**المشكلة:** `Sales` table بدون `invoiceNumber`.

**الملفات المتأثرة:**
- `lib/data/datasources/local/tables/core_tables.dart`
- `lib/core/services/sales_order_service.dart` أو `transaction_engine.dart`

**خطوات التنفيذ:**
1. إضافة `TextColumn get invoiceNumber => text().nullable()()` إلى `Sales`
2. إضافة auto-numbering logic في `TransactionEngine.postSale()`
3. إضافة migration v56 لترقيم الفواتير القديمة
4. عرض `invoiceNumber` في شاشات المبيعات والتقارير

**المدة المقدرة:** 1 يوم

---

## 3. المرحلة الثانية - عالية 🟠 (أسبوع 3-4)

### الأولوية 8: اختبارات المحاسبة (H2)

**المشكلة:** لا توجد اختبارات تكاملية للترحيل المحاسبي.

**المدة المقدرة:** 4-5 أيام

**سناريوهات الاختبار:**
```
1. postSale مع فاتورة نقدية → GL entry صحيح
2. postSale مع فاتورة آجلة → GL entry + Customer balance
3. postPurchase → GL entry + Supplier balance + Batch creation
4. postSaleReturn → GL reversal
5. postPurchaseReturn → GL reversal + Stock deduction
6. cancelSale → GL reversal entries
7. cancelPurchase → GL reversal entries
8. trial balance → يجب أن يكون debit = credit
```

### الأولوية 9: Seed Accounts + Auto-Create (H3)

**المشكلة:** Hardcoded account codes 1010, 1030, 1040, 1050, 2010, 2020, 4010, 4020, 4040, 5010, 5011, 5050.

**المدة المقدرة:** 1-2 يوم

**خطوات التنفيذ:**
1. إنشاء seed data في `initServices()` لإنشاء الحسابات الأساسية
2. إضافة `ensureAccountExists()` في `PostingEngine`
3. إظهار صفحة إعدادات شجرة الحسابات عند التشغيل الأول

### الأولوية 10: تحسين _updateAccountBalances (H4)

**المشكلة:** إعادة حساب جميع الأرصدة مع كل عملية ترحيل.

**المدة المقدرة:** 2-3 أيام

**الحل:**
```dart
// بدلاً من إعادة حساب كل شيء:
Future<void> _updateAccountBalance(String accountId, Decimal delta) async {
  final current = await getBalanceForAccount(accountId);
  await (db.update(db.gLAccounts)..where((a) => a.id.equals(accountId)))
      .write(GLAccountsCompanion(balance: Value(current + delta)));
}
```

### الأولوية 11: إكمال دورة المشتريات (H5)

**المشكلة:** PO → GRN → Invoice غير مربوط.

**المدة المقدرة:** 2-3 أيام

**خطوات التنفيذ:**
1. ربط Purchase Order بالـ GRN
2. ربط GRN بالـ Purchase Invoice
3. تتبع الحالة: QUOTATION → APPROVED → RECEIVED (GRN) → POSTED
4. إظهار التتبع في شاشة تفاصيل المشتريات

### الأولوية 12: معالجة ConcurrencyException (H6)

**المشكلة:** ConcurrencyException غير معالج في UI.

**المدة المقدرة:** 1 يوم

### الأولوية 13: Empty/Loading States (H8)

**المشكلة:** معظم الشاشات بدون حالات فارغة أو تحميل.

**المدة المقدرة:** 3-4 أيام

**خطوات التنفيذ:**
1. إنشاء `EmptyStateWidget` قابل لإعادة الاستخدام
2. إنشاء `LoadingStateWidget`
3. إضافتها لجميع الشاشات الرئيسية

### الأولوية 14: إكمال SyncService (H9)

**المشكلة:** SyncQueue موجودة بدون خدمة مزامنة.

**المدة المقدرة:** 3-4 أيام

---

## 4. المرحلة الثالثة - متوسطة 🟡 (أسبوع 5-6)

### الأولوية 15: إزالة/إكمال Dead Code Entities (H1)
- إزالة entities غير المستخدمة أو إكمال ربطها

### الأولوية 16: إزالة الجداول المكررة APInvoices/ARInvoices (H11)
- دمج ARInvoices ← Sales / APInvoices ← Purchases
- أو إنشاء Views بدلاً من الجداول الفعلية

### الأولوية 17: مزامنة Employee Table مع Entity (H14)
- إضافة الأعمدة المفقودة: housingAllowance, transportAllowance, otherAllowances, deductions, bank info

### الأولوية 18: توحيد رسائل الخطأ (M1)
- ترجمة جميع رسائل الخطأ للعربية

### الأولوية 19: إضافة Unique Constraint على ProductBatches (M7)
- (productId, warehouseId, batchNumber) unique

### الأولوية 20: إضافة Period Validation في BudgetService (M16)

### الأولوية 21-25: المشاكل المتوسطة الأخرى
- M2: EventBus استقلالية
- M4: NotificationService caching
- M5: Product image storage
- M8: Stock transfer GL fallback
- M10: Add Indexes
- M11: Shift-transaction link
- M15: Employee table expansion

---

## 5. المرحلة الرابعة - تحسينات 🟢 (أسبوع 7-8)

### الأولوية 26-30: المشاكل البسيطة
- L1: Localization للنصوص المباشرة
- L4: توحيد State Management
- L6: تحليل Indexes
- L8: Opening balance validation
- L9: ربط ExchangeRates

### الأولوية 31-35: تحسينات Architecture
- A1: إنشاء Repository abstractions كاملة
- A2: تقليص عدد الخدمات المكررة
- A3: توحيد DI pattern
- A4: إعادة هيكلة Core layer

---

## 6. الجدول الزمني

```
الأسبوع 1-2  |████████████████████|  الأولوية 1-7 (حرجة)
الأسبوع 3-4  |████████████████████|  الأولوية 8-14 (عالية)
الأسبوع 5-6  |████████████████████|  الأولوية 15-25 (متوسطة)
الأسبوع 7-8  |████████████████████|  الأولوية 26-35 (تحسينات)
```

| المرحلة | المدة | الأولويات | الحالة |
|---------|-------|-----------|--------|
| الأولى - حرجة | 10 أيام | 7 أولويات | 🔴 لم تبدأ |
| الثانية - عالية | 10 أيام | 7 أولويات | 🟠 لم تبدأ |
| الثالثة - متوسطة | 10 أيام | 11 أولوية | 🟡 لم تبدأ |
| الرابعة - تحسينات | 10 أيام | 10 أولويات | 🟢 لم تبدأ |

**إجمالي المدة المقدرة: 8 أسابيع (شهران)**

---

## 7. مخاطر الخطة

| الخطر | التأثير | الاحتمال | خطة التخفيف |
|-------|---------|----------|-------------|
| تغيير المعرفات من int إلى String يكسر البيانات الحالية | عالي | متوسط | عمل migration شامل مع backup |
| إعادة هيكلة المحاسبة تسبب أخطاء في الترحيل | عالي | عالي | اختبارات شاملة لكل سيناريو |
| إنشاء Mappers يضاعف كمية الكود | متوسط | عالي | استخدام code generation |
| تقدير الوقت غير دقيق (المشروع كبير) | متوسط | عالي | تقسيم المهام إلى sub-tasks أصغر |
| عدم وجود اختبارات حالية يجعل الـ regression risk عالياً | عالي | عالي | إضافة اختبارات قبل أي تغيير |

---

*هذه الخطة مبنية على تقرير التدقيق الجنائي الشامل (COMPREHENSIVE_FORENSIC_AUDIT_REPORT.md)*

*آخر تحديث: 2026-07-26*
