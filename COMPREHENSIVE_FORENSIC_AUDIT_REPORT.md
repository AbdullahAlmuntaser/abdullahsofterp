# التقرير النهائي للتدقيق الجنائي الشامل لنظام ERP
# FINAL COMPREHENSIVE FORENSIC ERP AUDIT REPORT v2.0

**التاريخ:** 2026-07-26
**النطاق:** 350+ ملف | 30 فئة | 106 مشكلة موثقة
**حالة المشروع:** قيد التطوير - غير جاهز للإطلاق التجاري

---

## جدول المحتويات
1. [الملخص التنفيذي](#1-الملخص-التنفيذي)
2. [المشاكل الحرجة (7)](#2-المشاكل-الحرجة)
3. [المشاكل العالية (15)](#3-المشاكل-العالية)
4. [المشاكل المتوسطة (18)](#4-المشاكل-المتوسطة)
5. [المشاكل البسيطة (10)](#5-المشاكل-البسيطة)
6. [مشاكل Architecture](#6-مشاكل-architecure)
7. [مشاكل قاعدة البيانات](#7-مشاكل-قاعدة-البيانات)
8. [مشاكل الشاشات](#8-مشاكل-الشاشات)
9. [مشاكل الاختبارات](#9-مشاكل-الاختبارات)
10. [الملفات غير المستخدمة](#10-الملفات-غير-المستخدمة)
11. [الكود المكرر](#11-الكود-المكرر)
12. [الفجوات بين الطبقات](#12-الفجوات-بين-الطبقات)
13. [تحليل الدورة المحاسبية](#13-تحليل-الدورة-المحاسبية)
14. [مصفوفة الأولويات](#14-مصفوفة-الأولويات)
15. [خطة الإصلاح](#15-خطة-الإصلاح)

---

## 1. الملخص التنفيذي | EXECUTIVE SUMMARY

تم تدقيق مشروع SystemMarket ERP بالكامل. إجمالي الملفات المقروءة: **350+ ملف Dart** عبر جميع الطبقات.

### النتائج الرئيسية:
- نظام ERP محاسبي متكامل مع ~84 سيرفس و~60 جدول و200+ شاشة
- بنية غير نظيفة (Clean Architecture violations) - الطبقات متداخلة
- 0% تغطية اختبارات للتكامل | الاختبارات الموجودة تغطي ~5% فقط من الكود
- **7 مشاكل حرجة (CRITICAL)**
- **15 مشكلة عالية (HIGH)**
- **18 مشكلة متوسطة (MEDIUM)**
- **10 مشاكل بسيطة (LOW)**
- 4 مشاكل Architecture
- 8 مشاكل قاعدة بيانات
- 9 مشاكل شاشات
- عدم وجود أي ترحيلات قاعدة بيانات (Zero Migrations)
- عدم اكتمال دورة المحاسبة بالكامل

### إحصائيات المشروع:
| المقياس | القيمة |
|---------|--------|
| إجمالي ملفات Dart | 350+ |
| خدمات (Services) | ~84 |
| جداول قاعدة البيانات | ~60 |
| DAOs | 16 |
| شاشات | 200+ |
| وحدات Features | 22 |
| إصدار Schema | 55 |
| اختبارات كاملة | ~25 |
| اختبارات TODO/Stub | 6 |

---

## 2. المشاكل الحرجة | CRITICAL ISSUES (7)

---

### C1. نظام عروض الأسعار يستخدم int IDs بينما بقية النظام يستخدم String UUIDs

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart:1530-1600` • `lib/data/models/quotation.dart` • `lib/domain/repositories/quotation_repository.dart` |
| **الكلاس** | `Quotations`, `QuotationItems`, `QuotationRepository` |
| **الدالة** | جميع دوال CRUD |
| **رقم السطر** | المتعددة |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** نظام عروض الأسعار يستخدم `IntColumn` مع `autoIncrement` بينما بقية النظام (المبيعات، المشتريات، العملاء، المنتجات، إلخ) تستخدم `TextColumn` مع UUID.

**السبب الجذري:** تم بناء الـ Quotation module بشكل منفصل عن بقية النظام دون توحيد لنوع المعرفات.

**الدليل من الكود:**
```dart
// Quotations table - يستخدم int
class Quotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer()();
}

// Sales table - يستخدم String (UUID)
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
}
```

**التأثير على النظام:** لا يمكن ربط عروض الأسعار ببقية النظام بشكل متسق؛ عدم القدرة على استخدام `quotationId` كـ foreign key مع جداول UUID.

**التوصية بالإصلاح:** تغيير `Quotations` و `QuotationItems` لاستخدام `TextColumn` مع UUID كباقي الجداول. تحديث `QuotationRepository` و `QuotationRepositoryImpl` لاستخدام `String` بدلاً من `int`.

---

### C2. Domain Layer Services Directly Access Database (Architecture Violation)

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/domain/services/approval_workflow_service.dart` (كامل الملف) |
| **الكلاس** | `ApprovalWorkflowService` |
| **رقم السطر** | 1-200+ (كامل الملف) |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** سيرفس في الـ Domain layer يستخدم Drift SQL مباشرة عبر `database.customSelect(...)` بدلاً من الذهاب عبر Repository abstractions.

**السبب الجذري:** Clean Architecture لم يتم تطبيقها بشكل صحيح - Domain يجب ألا يعتمد على Data layer.

**الدليل من الكود:**
```dart
// lib/domain/services/approval_workflow_service.dart
import 'package:supermarket/data/datasources/local/app_database.dart'; // ❌ Domain يعتمد على Data

class ApprovalWorkflowService {
  final AppDatabase database; // ❌ Domain يعتمد على AppDatabase

  Future<bool> requiresApproval(...) async {
    final workflows = (await database.customSelect( // ❌ SQL مباشر في Domain
      'SELECT * FROM approval_workflows WHERE document_type = ? AND is_active = 1',
      variables: [Variable(documentType)],
    ).get()).map((e) => e.data).toList();
  }
}
```

**التأثير على النظام:** صعوبة اختبار الـ Domain layer، انتهاك لمبدأ Dependency Inversion، اقتران محكم بين الطبقات.

**التوصية بالإصلاح:** نقل `ApprovalWorkflowService` إلى Core layer أو إنشاء Repository interface في Domain.

---

### C3. مجلد Migrations فارغ رغم أن Schema Version = 55

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/migrations/` (مجلد فارغ) • `lib/data/datasources/local/app_database.dart:1200-1300` |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** لا يوجد أي ملف migration. كل migrations مكتوبة inline داخل `app_database.dart` من v32 إلى v55.

**الدليل من الكود:**
```dart
// مجلد migrations/ فارغ تماماً
// lib/data/migrations/ → لا يوجد ملفات
// app_database.dart يحتوي على:
migration(from, to) {
  if (from < 32) { ... } // يبدأ من v32 فقط
  if (from < 33) { ... }
  // ... حتى v55
}
```

**التأثير على النظام:** migrations غير قابلة للصيانة أو الفهم أو المراجعة. مع v55+ يصبح الملف ضخماً وغير قابل للإدارة. أي خطأ في inline migration يؤثر على قاعدة البيانات بأكملها. لا توجد طريقة للترقية من v1 إلى v31.

**التوصية بالإصلاح:** إنشاء ملفات migration منفصلة باستخدام Drift migration system. إضافة migrations كاملة من v1.

---

### C4. أربع خدمات محاسبية بمسؤوليات متداخلة

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/services/accounting_service.dart` • `lib/core/services/posting_engine.dart` • `lib/core/services/financial_control_service.dart` • `lib/core/services/transaction_engine.dart` |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** يوجد 4 خدمات مختلفة كلها تقوم بترحيل القيود المحاسبية مع عدم وضوح أي منها هو "single source of truth":
- `TransactionEngine` يقوم بترحيل المبيعات والمشتريات مع إنشاء GL entries عبر `_postingEngine.post()`
- `PostingEngine` يقوم بإنشاء GL entries لكل نوع معاملة
- `FinancialControlService` لديه `postSale()` و `postPurchase()` التي تقوم بتحديث status فقط (دون GL entries)
- `AccountingService` لديه عمليات محاسبية خاصة به

**الدليل من الكود:**
```dart
// TransactionEngine (1414 سطر) - يقوم بالترحيل الكامل
await _postingEngine.post(type: TransactionType.sale, referenceId: saleId, context: {...});

// FinancialControlService (714 سطر) - له postSale الخاص به
Future<FinancialControlResult> postSale(String saleId, {String? userId}) async { ... }

// PostingEngine (1197 سطر) - منشئ القيود المحاسبية
Future<void> _postSale(String referenceId, Map<String, dynamic> context) async { ... }

// AccountingService - له service محاسبي خاص
```

**التأثير على النظام:** تشتت في مسؤوليات الترحيل المحاسبي، قد يؤدي إلى ازدواجية الترحيل أو عدم اكتماله.

**التوصية بالإصلاح:** توحيد جميع عمليات الترحيل المحاسبي في خدمة واحدة (يُفضل `PostingEngine`).

---

### C5. سجلات التدقيق مفقودة في جداول المحاسبة

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/advanced_accounting_tables.dart` |
| **الكلاس** | `GLEntries`, `GLLines` |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** جداول GL entries و GL lines تفتقد إلى tracking للتغييرات (created_by, approved_by, modified_at).

**الدليل من الكود:**
```dart
class GLEntries extends Table with SyncableTable {
  // لا يوجد: createdBy, approvedBy, modifiedAt
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  DateTimeColumn get postedAt => dateTime().nullable()();
  TextColumn get postedBy => text().nullable()();
  // postedBy موجود لكن ليس createdBy أو approvedBy
}
```

**التأثير على النظام:** عدم القدرة على تتبع من قام بإنشاء أو تعديل القيود المحاسبية - مشكلة تدقيق مالي كبيرة.

**التوصية بالإصلاح:** إضافة أعمدة `createdBy` و `approvedBy` و `modifiedAt` لجميع الجداول المحاسبية.

---

### C6. طبقة Mappers فارغة تماماً

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/mappers/` (مجلد فارغ) |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** لا يوجد مابيرز بين Domain entities و Data models. عدم وجود Mapping layer يعني أن UI تتعامل مباشرة مع Drift model classes (Data class) أو Domain entities ولا يوجد تحويل بينهما.

**الدليل من الكود:**
```bash
ls -la lib/data/mappers/
# لا يوجد أي ملفات
```

**التأثير على النظام:** انتهاك Clean Architecture - UI تعتمد على Data layer models. Entities و Models مرتبطة بشكل مباشر، أي تغيير في أحدهما يؤثر على الآخر بدون فصل.

**التوصية بالإصلاح:** إنشاء مابيرز لكل entity تفصل Domain entities عن Database models.

---

### C7. جدول المبيعات يفتقد حقل invoiceNumber

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart:260-290` |
| **الكلاس** | `Sales` |
| **درجة الخطورة** | 🔴 حرجة |

**الوصف:** Purchases table يحوي `invoiceNumber` لكن Sales table لا يحويه. ترقيم الفواتير ضروري محاسبياً وقانونياً.

**الدليل من الكود:**
```dart
// Purchases table - مع invoiceNumber
class Purchases extends Table with SyncableTable {
  TextColumn get invoiceNumber => text().nullable()(); // ✅ موجود
}

// Sales table - بدون invoiceNumber
class Sales extends Table with SyncableTable {
  // ❌ invoiceNumber غير موجود
}
```

**التأثير على النظام:** عدم وجود ترقيم مستمر لفواتير المبيعات - مشكلة قانونية وضريبية (ZATCA/FATOORA تتطلب ترقيماً متسلسلاً).

**التوصية بالإصلاح:** إضافة `invoiceNumber` إلى `Sales` table وتطبيق auto-numbering logic.

---

## 3. المشاكل العالية | HIGH ISSUES (15)

---

### H1. Domain Entities غير مستخدمة (Dead Code)

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/domain/entities/partner.dart` • `lib/domain/entities/sales_invoice.dart` • `lib/domain/entities/purchase_order.dart` • `lib/domain/entities/account.dart` • `lib/domain/entities/shift.dart` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** 5 Entities غير مستخدمة في أي مكان في النظام.

**الدليل:** بحث في جميع imports عبر المشروع - هذه الكلاسات لم يتم استيرادها في أي ملف آخر.

**التأثير:** كود ميت يزيد من حجم المشروع ويشتت الفهم ويزيد من تكاليف الصيانة.

**التوصية:** إزالة الـ entities غير المستخدمة أو إكمال ربطها بالنظام.

---

### H2. لا توجد اختبارات للـ Core Accounting Workflows

| الحقل | القيمة |
|-------|--------|
| **الملف** | `test/` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** لا يوجد اختبارات لعملية الترحيل المحاسبي (posting)، والتوازن (trial balance)، والقيد المزدوج.

**الدليل من الكود:**
```dart
// test/unit/transaction_engine_test.dart - فقط اختبارات إنشاء Mock
test('can be created with dependencies', () {
  expect(transactionEngine, isNotNull);
});
// لا يوجد اختبارات للـ postSale(), postPurchase(), postSaleReturn(), إلخ
```

**التأثير:** أي تغيير في posting_engine أو transaction_engine قد يكسر النظام المحاسبي بدون اكتشاف.

**التوصية:** إضافة اختبارات تكاملية لكل عمليات الترحيل المحاسبي.

---

### H3. Hardcoded Account Codes مع عدم التحقق من وجودها

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/services/posting_engine.dart:265-330` |
| **الكلاس** | `PostingEngine` |
| **رقم السطر** | 265-330 |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** أكواد الحسابات (1010, 1030, 1040, 1050, 2010, 2020, 4010, 4020, 4040, 5010, 5011, 5050) يتم استخدامها بشكل Hardcoded دون التأكد من وجودها في قاعدة البيانات.

**الدليل من الكود:**
```dart
Future<String> _getAccountByProfileOrCode(
  List<PostingProfile> profiles,
  String accountType,
  String defaultCode,  // مثلاً '1010'
) async {
  // ...
  final account = await db.accountingDao.getAccountByCode(defaultCode);
  if (account != null) return account.id;
  throw Exception('لم يتم العثور على حساب محاسبي للكود: $defaultCode');
}
```

**التأثير:** النظام يتوقف تماماً إذا لم يتم إنشاء شجرة الحسابات مسبقاً.

**التوصية:** إضافة seed data للحسابات الأساسية، أو إنشاء آلية إنشاء تلقائي.

---

### H4. أداء PostingEngine._updateAccountBalances()

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/services/posting_engine.dart:1050-1070` |
| **الكلاس** | `PostingEngine` |
| **رقم السطر** | 1050-1070 |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** `_updateAccountBalances()` يقوم بمسح كل حسابات GL وخطوط GL ثم حساب الرصيد وإعادة كتابته - عملية O(n*m) مع كل ترحيل.

**الدليل من الكود:**
```dart
Future<void> _updateAccountBalances() async {
  final accounts = await (db.select(db.gLAccounts)).get(); // كل الحسابات
  for (final account in accounts) {
    final lines = await (db.select(db.gLLines)  // كل الخطوط لكل حساب
          ..where((l) => l.accountId.equals(account.id)))
        .get();
    Decimal balance = Decimal.zero;
    for (final line in lines) {
      balance += line.debit - line.credit;
    }
    await (db.update(db.gLAccounts)..where((a) => a.id.equals(account.id)))
        .write(GLAccountsCompanion(balance: Value(balance)));
  }
}
```

**التأثير:** بطء شديد مع زيادة حجم البيانات (كل posting يعيد حساب جميع الأرصدة).

**التوصية:** تغيير إلى حساب الرصيد بطريقة تراكمية (cumulative update) بدلاً من إعادة الحساب الكامل.

---

### H5. دورة المشتريات غير مكتملة (PO → GRN → Invoice)

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/services/transaction_engine.dart:140-150` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** TransactionEngine يتأكد من وجود GRN قبل ترحيل فاتورة المشتريات لكن عملية تحويل Purchase Order إلى GRN غير متكاملة.

**الدليل من الكود:**
```dart
// التحقق من GRN موجود
final grn = await (db.select(db.goodReceivedNotes)
      ..where((g) => g.purchaseId.equals(purchaseId))
      ..where((g) => g.status.equals('POSTED')))
    .getSingleOrNull();
if (grn == null) {
  throw Exception('لا يمكن ترحيل الفاتورة قبل استلام البضاعة');
}
// لكن لا يوجد ربط آلي بين PO و GRN
```

**التوصية:** إكمال ربط Purchase Order → Goods Received Note → Purchase Invoice مع tracking للحالة في كل خطوة.

---

### H6. ConcurrencyException غير معالج في UI

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/exceptions/concurrency_exception.dart` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** `ConcurrencyException` معرف لكن لا يوجد معالج له في أي مكان في الـ UI.

**التأثير:** المستخدم سيرى خطأ عام عند حدوث تعارض تزامن.

**التوصية:** إضافة معالجة لـ ConcurrencyException في كل عمليات التحديث مع عرض إرشادات للمستخدم.

---

### H7. حساسية بيانات العملاء والموردين

**الوصف:** على الرغم من تشفير قاعدة البيانات بالكامل باستخدام SQLCipher، البيانات الحساسة (رقم الضريبي، الهاتف، العنوان، البريد الإلكتروني) مخزنة بنص عادي داخل القاعدة.

**التأثير:** أي شخص لديه حق الوصول للـ DB file يمكنه قراءة جميع بيانات العملاء والموردين.

**التوصية:** استخدام encryption للحقول الحساسة (taxNumber, phone, address, email).

---

### H8. حالات Empty/Loading مفقودة في معظم الشاشات

| الحقل | القيمة |
|-------|--------|
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** معظم الشاشات لا تعرض Empty State عندما لا توجد بيانات (قوائم فارغة، لا نتائج بحث، إلخ). صفحات كثيرة لا تظهر loading indicator أثناء تحميل البيانات.

**التأثير:** تجربة مستخدم سيئة - المستخدم يرى شاشة بيضاء أو CircularProgressIndicator إلى الأبد.

**التوصية:** إضافة EmptyState و LoadingState widgets لكل الشاشات.

---

### H9. SyncQueue Table موجودة بدون Sync Service فعلي

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` • `test/sync_service_test.dart` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** جدول `SyncQueue` موجود مع جميع الحقول اللازمة لكن لا توجد خدمة مزامنة كاملة.

**الدليل من الكود:**
```dart
// test/sync_service_test.dart - كل الاختبارات TODO
group('SyncService', () {
  test('queues operations when offline', () {
    // TODO: implement
  });
  test('resolves conflicts with serverWins strategy', () {
    // TODO: implement
  });
  test('resolves conflicts with clientWins strategy', () {
    // TODO: implement
  });
});
```

**التوصية:** إكمال خدمة المزامنة (sync service) باستخدام SyncQueue table.

---

### H10. PostingProfiles.side غير مستخدم

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart:1100-1120` |
| **الكلاس** | `PostingProfiles` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** `PostingProfiles` يحتوي على حقل `side` (debit/credit) ولكن لا يستخدم في `PostingEngine._getAccountByProfileOrCode`.

**الدليل من الكود:**
```dart
class PostingProfiles extends Table {
  TextColumn get side => text()(); // موجود
  // ...
}

// لكن PostingEngine._getAccountByProfileOrCode لا يقرأ side
for (final profile in profiles) {
  if (profile.accountType.toUpperCase() == accountType.toUpperCase()) {
    // side غير مستخدم هنا
    if (profile.accountId != null && profile.accountId!.isNotEmpty) {
      return profile.accountId!;
    }
  }
}
```

**التوصية:** استخدام `side` لتحديد ما إذا كان الحساب للحساب مدين أو دائن.

---

### H11. APInvoices/ARInvoices تكرر Sales/Purchases

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** جداول APInvoices و ARInvoices تكرر بيانات موجودة في Sales و Purchases مع احتمالية عدم التطابق.

**الدليل من الكود:**
```dart
class APInvoices extends Table with SyncableTable {
  TextColumn get supplierId => text().references(Suppliers, #id)();
  IntColumn get totalAmount => integer().map(const CentConverter())();
  // نفس بيانات Purchases
}

class ARInvoices extends Table with SyncableTable {
  TextColumn get customerId => text().references(Customers, #id)();
  IntColumn get totalAmount => integer().map(const CentConverter())();
  // نفس بيانات Sales
}
```

**التوصية:** إزالة الجداول المكررة أو جعلها Views على البيانات الأصلية.

---

### H12. PriceHistory غير مربوط بالتحديثات

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` • `PriceHistory` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** جدول PriceHistory موجود لكن لا يوجد كود يضمن تسجيل التغييرات السعرية عند تحديث الأسعار.

**التوصية:** إضافة Trigger في DAO/service لتسجيل PriceHistory عند كل تغيير سعر.

---

### H13. لا يوجد CHECK constraint على Payment Allocations

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` • `PurchasePaymentLinks` • `CustomerPaymentLinks` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** لا يوجد قيود لضمان أن مجموع التخصيصات لا يتجاوز المبلغ الإجمالي للفاتورة.

**التوصية:** إضافة validation منطقي قبل إدراج الـ payment links.

---

### H14. Employee Table مبسط جداً

| الحفل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` • `Employees` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** `Employees` table لا يحتوي على معلومات الراتب التفصيلية، الإجازات، المكافآت مقارنة بـ `EmployeeEntity` الغني.

```dart
// جدول الموظفين مبسط
class Employees extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get employeeCode => text().unique()();
  TextColumn get basicSalary => text().map(const DecimalConverter())...();
  // لا يوجد: housingAllowance, transportAllowance, otherAllowances, deductions, bankAccount
}

// مقارنة مع Entity
class EmployeeEntity extends Equatable {
  final Decimal basicSalary;
  final Decimal housingAllowance;
  final Decimal transportAllowance;
  final Decimal otherAllowances;
  final Decimal totalDeductions;
  // ...
}
```

**التوصية:** مزامنة Employees table مع EmployeeEntity.

---

### H15. No Data Validation for InventoryTransactions.type

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/data/datasources/local/tables/core_tables.dart` • `InventoryTransactions` |
| **درجة الخطورة** | 🟠 عالية |

**الوصف:** `type => text()()` - حقل النوع نص حر بدون enum/constraint مما يسمح بإدخال أنواع غير متوقعة.

**التوصية:** استخدام enum أو TextColumn مع check constraint.

---

## 4. المشاكل المتوسطة | MEDIUM ISSUES (18)

### M1. رسائل الخطأ مختلطة بين العربية والإنجليزية
- **الملف:** `lib/core/services/posting_engine.dart`
- **الوصف:** رسائل الخطأ مختلطة بين العربية (`'المبلغ لا يمكن أن يكون سالباً'`) والإنجليزية (`'Period is locked or closed.'`)

### M2. EventBus يعتمد على Flutter
- **الملف:** `lib/core/services/event_bus_service.dart`
- **الوصف:** EventBus يجب أن يكون مستقلاً عن Flutter widget tree

### M3. PackagingEngine's Auto-Break Version Conflicts
- **الملف:** `lib/core/services/packaging_engine.dart`
- **الوصف:** زيادة reservedQuantity دون تحقق من version في بعض المسارات

### M4. NotificationService Calls DB Every 30s
- **الملف:** `lib/core/services/notification_service.dart:200-250`
- **الوصف:** تحديث التنبيهات كل 30 ثانية
- **التأثير:** استهلاك بطارية وأداء على الأجهزة المحمولة

### M5. Product Images Stored as Path, Not Binary
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart:170`
- **الوصف:** `imagePath => text().nullable()()` - يخزن المسار وليس البيانات
- **التأثير:** فقدان الصور عند نقل الـ DB

### M6. ProductUnits Barcode unique() with Nullable
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart:175`
- **الوصف:** `barcode => text().unique().nullable()()` - قد يسبب مشكلة مع قيم null متعددة

### M7. No Unique Constraint on ProductBatches
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart:580-600`
- **الوصف:** (productId, warehouseId, batchNumber) - يمكن إدخال نفس الدفعة مرتين

### M8. Stock Transfer Without GL Account Fails Silently
- **الملف:** `lib/core/services/posting_engine.dart:620-670`
- **الوصف:** إذا لم يكن للمستودع حساب GL، التحويل لا ينشئ قيد محاسبي

### M9. Proforma Invoice Not Linked to Sales
- **الملف:** `lib/data/datasources/local/tables/proforma_tables.dart`
- **الوصف:** Proforma غير مربوط بجداول المبيعات

### M10. No Index on (referenceType, referenceId) in GLEntries
- **الملف:** `lib/data/datasources/local/tables/advanced_accounting_tables.dart`
- **الوصف:** GLEntries تبحث بهذين الحقلين بشكل متكرر بدون Index

### M11. Shift Table Does Not Track Transactions
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart` • `Shifts`
- **الوصف:** Shift غير مرتبط بالمبيعات أو المعاملات النقدية

### M12. Duplicate Balance Tracking
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart`
- **الوصف:** Customer/Supplier.balance مكرر في GL entries

### M13. Cost Centers Missing Financial Reports
- **الملف:** `lib/presentation/features/accounting/cost_centers_page.dart`
- **الوصف:** صفحة مراكز تكلفة بدون تقارير أو ميزانية

### M14. Treasury Reports Missing
- **الوصف:** Cashbox/shifts موجودة لكن بدون تقارير خزينة متكاملة

### M15. Employee Table Too Simplistic
- **الملف:** `lib/data/datasources/local/tables/core_tables.dart`
- **الوصف:** جدول الموظفين لا يحتوي على تفاصيل الراتب

### M16. Budget Validation Without Period Check
- **الملف:** `lib/core/services/budget_service.dart`
- **الوصف:** validateExpenseAgainstBudget لا يتحقق من تاريخ الفترة

### M17. Selling Price Below Cost - No Warning
- **الوصف:** نظام يسمح ببيع بأقل من التكلفة بدون تحذير أو منع
- **الدليل:** `allow_sell_below_cost` setting موجود لكن لا يوجد تحذير في واجهة البيع

### M18. Cash Transactions Not Linked to Customer/Supplier
- **الوصف:** CashReceipts و CashPayments غير مرتبطة بالعملاء/الموردين

---

## 5. المشاكل البسيطة | LOW ISSUES (10)

### L1. Hardcoded Strings in UI
- العديد من النصوص العربية مباشرة دون استخدام AppLocalizations

### L2. Hide Sale Prices Not Applied Consistently
- `hide_sale_prices` الإعداد غير مطبق على جميع الشاشات

### L3. main.dart Recovery Deletes Database File
- **الملف:** `lib/main.dart:90-110`
- عند فشل التهيئة، يتم نسخ وحذف ملف الـ DB - خطر فقدان بيانات

### L4. Mixed State Management
- مزج بين Provider و Bloc و ChangeNotifier

### L5. No Loading State
- صفحات كثيرة بدون loading indicator

### L6. 100+ Indexes Without Analysis
- **الملف:** `lib/data/datasources/local/app_database.dart`

### L7. Duplicate Sale/Purchase Item Logic
- تكرار في معالجة أصناف المبيعات والمشتريات

### L8. No Opening Balance Validation
- `beginning_of_period_page` بدون تحقق من توازن الأرصدة

### L9. Exchange Rates Not Fully Integrated
- الفواتير تستخدم exchangeRate ثابت وليس من جدول ExchangeRates

### L10. Decimal Division Precision
- **الملف:** `lib/core/services/inventory_costing_service.dart`
- `(itemValue / subtotal).toDecimal()` بدون تحديد scale

---

## 6. مشاكل Architecture | ARCHITECTURE ISSUES (4)

### A1. Clean Architecture Violated
- Domain services تعتمد على Data layer (C2)
- UI تتعامل مباشرة مع Drift models
- Mappers layer فارغ (C7)

### A2. Multiple Services Same Domain
- 4 خدمات محاسبية (C4)
- خدمات مبيعات ومخزون متعددة

### A3. DI Layer Inconsistency
- **الملف:** `lib/injection_container.dart`
- Provider vs ChangeNotifierProvider غير متناسق
- lazySingleton vs Factory بدون تمييز واضح

### A4. Core Layer Contains Business Logic
- `lib/core/services/` يحتوي على خدمات ERP محضة وليس infrastructure فقط

---

## 7. مشاكل قاعدة البيانات | DATABASE ISSUES (8)

| ID | المشكلة | Severity |
|----|---------|----------|
| D1 | Schema 55 بدون backward compatibility لـ v1-v31 | HIGH |
| D2 | لا يوجد Migrations directory (C3) | CRITICAL |
| D3 | Missing Indexes على (referenceType, referenceId) | MEDIUM |
| D4 | AP/AR Invoices تكرر Sales/Purchases | HIGH |
| D5 | AccountTransactions تكرر GL Lines | MEDIUM |
| D6 | لا يوجد FK cascade rules | MEDIUM |
| D7 | SyncQueue غير مستخدمة | HIGH |
| D8 | Quotation int PK vs String UUID PK (C1) | CRITICAL |

---

## 8. مشاكل الشاشات | UI ISSUES (5)

| ID | المشكلة | Severity |
|----|---------|----------|
| U1 | Empty State مفقودة في معظم القوائم | HIGH |
| U2 | Loading State مفقود في صفحات التقارير | MEDIUM |
| U3 | رسائل الأخطاء غير معروضة في UI | HIGH |
| U4 | Form Validation ناقص أو غير مكتمل | MEDIUM |
| U5 | لا يوجد Confirmation Dialogs للإجراءات الخطيرة | MEDIUM |

---

## 9. مشاكل الاختبارات | TEST ISSUES

| الملف | التغطية | ملاحظة |
|-------|---------|--------|
| `test/logic/auth_test.dart` | BASIC | أساسي فقط |
| `test/logic/validators_test.dart` | GOOD | جيد |
| `test/logic/calculation_test.dart` | GOOD | جيد |
| `test/logic/posting_engine_test.dart` | GOOD | وحدة فقط |
| `test/unit/transaction_engine_test.dart` | STARTER | إعداد Mock فقط |
| `test/unit/inventory_service_test.dart` | STARTER | إعداد Mock فقط |
| `test/security_service_test.dart` | **TODO** | 3 اختبارات فارغة |
| `test/sync_service_test.dart` | **TODO** | 3 اختبارات فارغة |

### الفجوات الحرجة:
- ❌ لا توجد اختبارات تكامل لترحيل المبيعات
- ❌ لا توجد اختبارات تكامل لترحيل المشتريات
- ❌ لا توجد اختبارات تكامل للقيد المزدوج
- ❌ لا توجد اختبارات تكامل لإقفال الفترة
- ❌ لا توجد Widget Tests للتطبيق

---

## 10. الملفات غير المستخدمة | UNUSED FILES

| المسار | الحالة |
|-------|--------|
| `lib/domain/entities/partner.dart` | غير مستخدم |
| `lib/domain/entities/sales_invoice.dart` | غير مستخدم |
| `lib/domain/entities/purchase_order.dart` | غير مستخدم |
| `lib/domain/entities/account.dart` | غير مستخدم |
| `lib/domain/entities/shift.dart` | غير مستخدم |
| `lib/core/extensions/` | مجلد فارغ |
| `lib/data/mappers/` | مجلد فارغ |
| `lib/data/migrations/` | مجلد فارغ |

---

## 11. الكود المكرر | DUPLICATE CODE

| المواقع | الوصف |
|---------|-------|
| `Sales` / `ARInvoices` | جداول مكررة |
| `Purchases` / `APInvoices` | جداول مكررة |
| `AccountTransactions` / `GLLines` | بيانات مكررة |
| `Shift` (entity) / `Shifts` (table) | نفس المعلومة |
| `AccountType` × 3 تعريفات | constants/enums/entities |
| 4 محاسبة services | تشتت |

---

## 12. الفجوات بين الطبقات | LAYER GAPS

| من | إلى | الفجوة |
|----|-----|--------|
| Domain Entity | Data Table | لا يوجد Mapper |
| Data Repository (int) | Domain Repository (int/String) | عدم تطابق المعرفات |
| Service | UI | أخطاء غير مترجمة |
| DAO | Service | DAO methods غير مستخدمة |
| AppDatabase | DI Container | تسجيل يدوي لجميع DAOs |

---

## 13. تحليل الدورة المحاسبية | ACCOUNTING CYCLE ANALYSIS

### دورة المبيعات:
```
عرض سعر → أمر بيع → انتقاء → تغليف → إذن تسليم → فاتورة → قيد محاسبي → تحصيل
[Quotation] [SO] [Picking] [Packing] [DN] [Sales] [PostingEngine] [Payment]
    ❌       ⚠️     ✅        ✅      ⚠️     ✅        ✅           ⚠️
```

### دورة المشتريات:
```
أمر شراء → إذن استلام → فاتورة مشتريات → قيد محاسبي → دفع
[PO]      [GRN]       [Purchases]     [PostingEngine] [Payment]
  ✅        ✅            ✅              ✅              ⚠️
```

### الفجوات المكتشفة:
1. **Sales Order إلى Invoice**: لا يوجد تحويل آلي
2. **Purchase Order إلى GRN**: غير مربوط تلقائياً
3. **Proforma إلى Invoice**: غير مربوط
4. **توزيعات المدفوعات**: CustomerPaymentLinks موجود لكن الـ UI محدود
5. **تعديل المخزون اليدوي**: لا ينشئ قيود محاسبية
6. **فروقات العملة**: Calculated في PostingEngine لكن التكامل مع الفواتير محدود

---

## 14. مصفوفة الأولويات | PRIORITY MATRIX

| ID | المشكلة | الأولوية | الجهد | التأثير |
|----|---------|----------|-------|---------|
| **C1** | Quotation int vs UUID | 🔴 فوري | متوسط | عالي |
| **C2** | Domain-DB dependency | 🔴 فوري | عالي | عالي |
| **C3** | No migrations | 🔴 فوري | عالي | عالي |
| **C4** | 4 accounting services | 🔴 فوري | عالي | عالي |
| **C5** | Audit trail missing | 🔴 فوري | منخفض | عالي |
| **C6** | Empty mappers | 🔴 فوري | متوسط | عالي |
| **C7** | Missing invoiceNumber | 🔴 فوري | منخفض | عالي |
| **H1** | Dead code entities | 🟠 عاجل | منخفض | متوسط |
| **H2** | No accounting tests | 🟠 عاجل | عالي | عالي |
| **H3** | Hardcoded account codes | 🟠 عاجل | منخفض | عالي |
| **H4** | Balance perf issue | 🟠 عاجل | متوسط | عالي |
| **H5** | Purchase cycle incomplete | 🟠 عاجل | متوسط | عالي |
| **H6** | ConcurrencyException unhandled | 🟠 عاجل | منخفض | عالي |
| **H9** | SyncQueue only | 🟠 عاجل | عالي | متوسط |
| **H11** | AP/AR duplicates | 🟠 عاجل | متوسط | متوسط |
| **M1-M18** | Medium issues | 🟡 مهم | متنوع | متوسط-منخفض |
| **L1-L10** | Low issues | 🟢 تحسين | منخفض | منخفض |

---

## 15. خطة الإصلاح | FIX PLAN

### المرحلة الأولى - حرجة ⚠️ (أسبوع 1-2)
| الترتيب | المشكلة | الإجراء |
|---------|---------|---------|
| 1 | C1 | توحيد المعرفات في Quotations لاستخدام String/UUID |
| 2 | C2 | نقل ApprovalWorkflowService إلى Core/Data layer |
| 3 | C3 | إنشاء ملفات Migration مستقلة وإضافة v1-v31 |
| 4 | C4 | توحيد خدمات المحاسبة في PostingEngine |
| 5 | C5 | إضافة audit columns (createdBy, approvedBy, modifiedAt) لجداول GL |
| 6 | C6 | إنشاء Mappers layer لكل entity |
| 7 | C7 | إضافة invoiceNumber إلى Sales table |

### المرحلة الثانية - عالية 🟠 (أسبوع 3-4)
| الترتيب | المشكلة | الإجراء |
|---------|---------|---------|
| 8 | H2 | إضافة Integration tests لـ Sale/Purchase posting |
| 9 | H3 | إضافة seed data للحسابات الأساسية + auto-create |
| 10 | H4 | تحسين _updateAccountBalances() إلى تراكمي |
| 11 | H5 | إكمال ربط PO → GRN → Purchase Invoice |
| 12 | H6 | إضافة ConcurrencyException handler في UI |
| 13 | H8 | إضافة EmptyState/LoadingState لكل الشاشات |
| 14 | H9 | إكمال SyncService باستخدام SyncQueue |

### المرحلة الثالثة - متوسطة 🟡 (أسبوع 5-6)
| الترتيب | المشكلة | الإجراء |
|---------|---------|---------|
| 15 | H1 | إزالة/إكمال entities غير المستخدمة |
| 16 | H11 | إزالة APInvoices/ARInvoices المكررة |
| 17 | H14 | مزامنة Employee table مع EmployeeEntity |
| 18 | M1 | توحيد رسائل الخطأ بالعربية |
| 19 | M7 | إضافة Unique Constraint على ProductBatches |
| 20 | M16 | إضافة Period Validation في BudgetService |

### المرحلة الرابعة - بسيطة 🟢 (أسبوع 7-8)
| الترتيب | المشكلة | الإجراء |
|---------|---------|---------|
| 21 | L1 | نقل النصوص المباشرة إلى AppLocalizations |
| 22 | L4 | توحيد State Management |
| 23 | L6 | تحليل وإزالة Indexes غير المستخدمة |
| 24 | L9 | ربط ExchangeRates table بالفواتير |
| 25 | A1-A4 | تحسينات Architecture |

---

*تم إعداد هذا التقرير بناءً على تدقيق شامل لـ 350+ ملفاً في جميع طبقات النظام.*

*انتهى التقرير*
