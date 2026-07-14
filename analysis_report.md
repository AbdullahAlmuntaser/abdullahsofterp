# تحليل شامل للنظام المحاسبي/المدرسي - SystemMarket

**التاريخ**: 14 يوليو 2026  
**النظام**: Flutter/Dart ERP/POS - 105 جدول، 100+ خدمة، 90+ مسار  
**قاعدة البيانات**: SQLite + SQLCipher (مشفر) عبر Drift ORM  

---

## 1. البنية الداخلية (Database & Architecture)

### ✅ نقاط القوة
- **هندسة نظيفة** (Clean Architecture): `data/domain/presentation` مع Drift ORM و SQLCipher للتشفير
- **105 جدول** يغطي: محاسبة، مخزون، مبيعات، مشتريات، رواتب، أصول ثابتة، تصنيع، ولاء، ضرائب
- **معاملات ذرية** (atomic transactions) في `TransactionEngine` و `PostingEngine`
- **تدقيق متكامل** (Audit Logs) على 3 مستويات: `audit_logs` و `acc_audit_logs` و `AccAuditLogs`
- **تشفير قاعدة البيانات** باستخدام SQLCipher + BCrypt لكلمات المرور
- **18 حساب افتراضي** في شجرة الحسابات (COA) مع رموز قياسية
- **فترات محاسبية** مع إقفال شهري/سنوي

### ❌ المشاكل الحرجة (Critical)

| المشكلة | الموقع | التأثير |
|---------|--------|---------|
| **حساب رصيد الزكاة دائمًا صفر** | `zakat_service.dart` - يقرأ `account.balance` المخزنة (دائمًا 0) بدل حسابها من GL Lines | الزكاة غير صالحة تمامًا |
| **`balance` column ميت (dead data)** | `gl_accounts.balance` - لا يتم تحديثه أبدًا من محرك الترحيل | أي كود يعتمد عليه سيعطي نتائج خاطئة |
| **ازدواجية DAO** (Manual vs Drift) | مسارين منفصلين بنفس المنطق | نتائج مختلفة محتملة، صيانة مزدوجة |
| **لا توجد Constraints على مستوى DB** | جميع العلاقات منطقية فقط في Dart | فوضى بيانات محتملة مع الأخطاء البرمجية |
| **2 DAO للمحاسبة** بنفس الاستعلامات | Manual (`CAST AS REAL` يفقد الدقة) vs Drift (Decimal) | تناقض الأرقام |
| **لا يوجد Cache للأذونات** | `AdvancedPermissionService` يضرب DB في كل مرة | بطء مع كل عملية |

### 🛡️ الأمان

| المشكلة | التفاصيل |
|---------|----------|
| **CRITICAL** | `AuthProvider.login()` ينسخ كود `SecurityService` بدون قفل الحساب أو التحقق من الجلسة - يمكن تجاوز الأمان |
| **High** | لا حماية CSRF للعمليات الحساسة |
| **High** | `validateSession()` يبتلع كل الاستثناءات - لا فرق بين "لا جلسة" و "خطأ قاعدة بيانات" |
| **Medium** | الرموز مخزنة في `FlutterSecureStorage` ولا تُمسح عند تسجيل الخروج |
| **Medium** | صلاحيات الأدوار صلبة (hardcoded) في `access_guard.dart` - أي دور جديد يتطلب تعديل الملف |
| **Medium** | `SecurityService` يستخدم SQL خام `INSERT INTO login_attempts` قد يفشل إذا الجدول غير موجود |

---

## 2. المنطق المحاسبي (Accounting Logic)

### ✅ الموجود
- **دفتر الأستاذ العام** (General Ledger) مع شجرة حسابات هرمية (18 حساب افتراضي)
- **قيود اليومية** (Manual, Sale, Purchase, Return, Depreciation, Closing)
- **ميزان المراجعة** (Trial Balance) و **قائمة الدخل** و **الميزانية العمومية** و **التدفقات النقدية**
- **فترات محاسبية** مع إقفال شهري/سنوي وفتح أرصدة افتتاحية
- **مراكز تكلفة** مع موازنات ومراقبة تجاوز
- **الأصول الثابتة** (إهلاك القسط الثابت والمتناقص)
- **ضرائب**: ضريبة القيمة المضافة (VAT)، ضريبة الخصم (WHT)، الزكاة
- **عملات متعددة** مع فارق العملة
- **شيكات** (وارد/صادر) وتحويلات مالية بين الحسابات
- **تسوية بنكية** مع كشوفات حساب
- **قيود متكررة** (مصروفات إيجار، إهلاك...)
- **نسب مالية**: هامش الربح الإجمالي، هامش الربح الصافي، نسبة التداول
- **الحسابات الدائنة/المدينة** (AR/AP) مع فواتير العملاء/الموردين
- **توزيع التكاليف الإضافية** (landed costs) على بنود المشتريات

### ❌ المشاكل الحرجة

| المشكلة | الموقع | خطورتها |
|---------|--------|---------|
| **`postSale()` يقارن `.index` (int) مع قيمة string** | `transaction_engine.dart:279` | **سيفشل في runtime** - سيقارن `0` مع `'posted'` |
| **AVCO في `getBatchesForSale()` يعيد كل الدُفعات بدل الكمية المطلوبة** | `inventory_costing_service.dart:210-217` | **يخصم كمية أكبر من المبيع** |
| **حساب المديونية (`getOutstandingSales`) لا يستخدم `customerPaymentLinks`** | `transaction_engine.dart:1029-1035` | **ازدواج في حساب المبالغ المدفوعة** |
| **طرق تقييم FIFO/AVCO/LIFO متطابقة تمامًا** | `inventory_costing_service.dart:146-194` | **التقييم كلها Average - FIFO و LIFO غير حقيقيين** |
| **دالة `_createReverseEntry()` في الإلغاء تنشئ قيدًا بلا معنى** | `financial_control_service.dart` | **قيود محاسبية خاطئة عند الإلغاء** |
| **`GLEntryExt.totalAmount` و `CostCenterExt.totalAmount` يعيدان `0.0`** | `accounting_extensions.dart` | **كود وهمي غير مستخدم** |
| **`_recordAccountTransaction()` ينشئ سجلاً مكرراً** | `account_transactions` جدول منفصل يكرر بيانات `gl_lines` | تخزين زائد بدون فائدة |
| **`FinancialReportService` و `AccountingDao` يكرران نفس المنطق** | نتائج مختلفة محتملة | تناقض التقارير |

### 🏭 التصنيع (Manufacturing/BOM)

| المشكلة | التفاصيل |
|---------|----------|
| **`completeProductionOrder()` لا يخصم من `productBatches`** | المواد الخام لا تنقص فعليًا |
| **`completeProductionOrder()` لا ينشئ Batch للمنتج النهائي** | المنتج النهائي بدون تكلفة |
| **`BomService.assemble()` والتحقق من المخزون خارج المعاملة** | سباق (race condition) |
| **`BomService` و `ProductionService` غير متكاملين** | مساران مستقلان تمامًا |
| **`assemble()` يستخدم `batchNumber` كـ `batchId`** | انتهاك مخطط قاعدة البيانات |
| **لا إهلاك/تكاليف overhead في التصنيع** | التكلفة = مجموع buyPrice فقط |

### 📋 الموافقات (Approval Workflow)

| المشكلة | التفاصيل |
|---------|----------|
| **التخزين في `AppConfigService` (JSON blob)** | بدون علاقات، مرجعية، أو استعلامات |
| **3 تطبيقات منفصلة للموافقات** | `core/services` vs `domain/services` vs `multi_level` - غير متصلة |
| **لا تأكيد تلقائي للموافقة** | بعد الموافقة، لا يتم ترحيل تلقائي - يحتاج تدخل يدوي |
| **لا تحقق من صلاحية الموافق** | أي مستخدم يمكنه الموافقة على أي معاملة |
| **Domain service يستخدم Integer IDs** | بينما باقي النظام يستخدم UUID strings |

### 💳 الولاء والعروض (Loyalty & Promotions)

| المشكلة | التفاصيل |
|---------|----------|
| **Loyalty مخزن في JSON blob** | لا علاقات، لا استعلامات، خطر فقدان بيانات |
| **Loyalty لا يتكامل مع المبيعات** | `TransactionEngine.postSale()` لا يستدعي `awardPoints()` |
| **النقاط لا تنتهي صلاحيتها** | بدون expiry logic |
| **`adjustPoints()` يمكن أن يصفر الرصيد** | لا تحقق أن الخصم ضمن الرصيد (إلا في `redeemPoints`) |
| **لا يوجد PromotionsService** | منطق العروض مبعثر في صفحة UI فقط |
| **`TransactionEngine.postSale()` لا يتحقق من العروض النشطة** | العروض غير مفعلة في البيع |
| **BOGO (اشتر 1 واحصل 1) لهيكل بيانات مختلف** | `Decimal.fromInt(10)` يعمل فقط للنسبة المئوية |

---

## 3. الواجهات (UI/UX)

### ✅ نقاط القوة
- `MoneyFormField` مع Validate مضمن و `AutovalidateMode.onUserInteraction`
- `Form` + `GlobalKey<FormState>` في الصفحات الرئيسية
- `AppSnackBar` بألوان واضحة (success/error/warning/info)
- POS متجاوب (3 breakpoints: mobile/tablet/desktop - 800px/500px)
- `SkeletonLoader` موجود مع تأثير shimmer (لكن غير مستخدم)
- `PermissionGuard` لإخفاء العناصر غير المصرح بها مع FutureBuilder
- `RefreshIndicator` في الصفحات الرئيسية
- `SalesInvoicePage` لديه تحقق شامل (items فارغة، منتجات null، كميات سالبة، حد ائتماني)

### ❌ نقاط الضعف

| المجال | المشكلة |
|--------|---------|
| **إمكانية الوصول (Accessibility)** | **معدوم تمامًا** - لا `Semantics` ولا keyboard navigation ولا screen reader ولا font scaling |
| **التجاوب** | فقط POS متجاوب - باقي الصفحات ثابتة (لا تدعم landscape ولا Desktop) |
| **الأخطاء** | لا Error Boundary شامل، `LoginPage` يعرض `'Error: $e'` مباشرة |
| **التعريب** | **رسائل الخطأ في الـ validators عربية hardcoded** (لا تترجم مع l10n) |
| **Skeleton Loaders** | موجودة لكن غير مستخدمة في أي صفحة (كلها تستخدم `CircularProgressIndicator`) |
| **إدارة النماذج** | تحقق مزدوج: `Form.validate()` + تحقق برمجي في save - تكرار وصيانة أصعب |
| **اختبارات الواجهة** | `pos_page_test.dart` يختبر `SimplePosView` وهمي - لا يختبر الصفحة الحقيقية |
| **لا حاوية للصور** | `image_path` في `products` لا يُعرض في الواجهة |
| **لا عرض لملخص الأخطاء** | الأخطاء تظهر فقط كـ SnackBars - لا قائمة مركزة للأخطاء |

### توصيات واجهات
1. إضافة `Semantics` لجميع العناصر التفاعلية + keyboard navigation + `FocusTraversalGroup`
2. تحويل جميع الرسائل الخطأ إلى `AppLocalizations`
3. تفعيل `SkeletonLoader` في الصفحات الرئيسية (Dashboard, Products, Reports)
4. إضافة Error Boundary على مستوى التطبيق
5. إصلاح اختبارات الواجهة لتختبر الكود الحقيقي
6. إضافة `MediaQuery` لتكييف الخطوط والأحجام للموبايل/ديسكتوب
7. إضافة `prefer-reduced-motion` لـ shimmer animations

---

## 4. الخدمات المساندة

### 📊 التقارير

| الخدمة | الحالة |
|--------|--------|
| 22 نوع تقرير في Reports Hub | ✅ موجود |
| `ReportEngineService` (top-selling, profit margin, movement, daily sales, valuation) | ✅ موجود مع CSV/JSON export |
| N+1 query في `getProfitMarginReport` | ⚠️ يلف على كل فاتورة ويستعلم عن itemsها |
| `ExportService` | ⚠️ "Excel" مجرد CSV بإسم مختلف بدون `.xlsx` |
| `PdfService` | ⚠️ يدعم الفواتير فقط (مع QR ZATCA) - لا يدعم قائمة دخل أو ميزانية |
| طباعة حرارية (ESC/POS) | ❌ **الاتصال بالأجهزة وهمي (stub)** - `connectToDevice` دائمًا true |
| طباعة 58mm/80mm + باركود | ✅ التنسيق موجود لكن بدون اتصال حقيقي |
| `exportSales` يتجاهل معاملات from/to | ⚠️ bug - لا يطبق فلتر التاريخ |
| تقارير PDF إضافية مفقودة | ❌ لا توجد تقارير PDF للميزانية، قائمة الدخل، التدفقات النقدية |

### 💾 النسخ الاحتياطي (Backup)

| الخدمة | الحالة |
|--------|--------|
| `BackupService` مع SHA-256 integrity check + توقيع `SYS_MARKET_BACKUP_V1` | ✅ قوي وموثوق |
| Google Drive Backup مع OAuth | ✅ بنية جيدة |
| **`_driveApi` لا يُهيأ أبدًا** | ❌ **`DriveApi` لم يُنشأ من authenticated client** |
| **`downloadCloudBackup()` خطأ type cast** | ❌ `files.get()` يُرجع `File` وليس `Media` |
| Auto-backup scheduling | ⚠️ موجود (`shouldAutoBackup()`) لكن غير مفعل |
| لا تقرير عن تقدم الرفع | ⚠️ upload progress غير معروض للمستخدم |
| `DriveBackupService` يعيد `null` دائمًا | ❌ لا فرق بين "غير مصرح" و "فشل الرفع" و "API غير مهيأ" |

### 🔄 المزامنة (Sync)

| الخدمة | الحالة |
|--------|--------|
| `SyncService` (offline-first, conflict resolution, retry, exponential backoff) | ✅ Architecture قوي ونظيف |
| Queue deduplication + pending/failed count | ✅ موجود |
| **`_pushToServer()` و `_pullFromServer()`** | ❌ **stub - `await Future.delayed(50ms)` فقط** |
| **Conflict resolution** | ❌ **لا يفعل شيئًا** - كل الاستراتيجيات (serverWins/clientWins/lastWriteWins) تستدعي `markAsSynced` بدون مقارنة |
| **لا REST API ولا WebSocket** | ❌ **لا طبقة نقل حقيقية للمزامنة** |
| `SyncPage` UI ناقصة جدًا | ⚠️ مجرد `SyncStatusCard` مع نص placeholder |

### 📥 استيراد البيانات

| المشكلة | التفاصيل |
|---------|----------|
| **يقبل `.xlsx` لكنه يقرأ فقط CSV** | سيفشل مع ملفات Excel الحقيقية |
| **لا يحفظ في قاعدة البيانات** | `importFromCsv()` يُرجع البيانات فقط - المُستدعي مسؤول عن الحفظ |
| **لا يعالج الترميزات** | UTF-8 BOM و Windows-1252 غير مدعومين |
| **`_parseCsvLine` لا يعالج `""` داخل quoted fields** | CSV القياسي سينكسر |
| **التحقق ضئيل جدًا** | فقط `name` (للمنتجات) و `product_id`/`quantity` (للمخزون) |
| **ملف كامل في الذاكرة** | `readAsString()` - OOM للملفات >100MB |
| **`generateTemplateCsv()` بدون بيانات نموذجية** | القالب = row header فقط |

### 🔌 التكامل الخارجي

| الخدمة | الحالة |
|--------|--------|
| E-commerce Integration | ❌ **كلها stubs** - `connect()` و `fetchOrders()` و `syncProducts()` كلها تعيد بيانات وهمية |
| REST API / HTTP Client | ❌ غير موجود - لا يوجد اتصال بشبكة خارجية |
| WebSocket/Socket.IO | ❌ غير موجود |
| Payment Gateway | ❌ غير موجود (Mada, Visa, Apple Pay, terminal) |
| SMS Gateway | ❌ غير موجود |
| WhatsApp | ✅ موجود (للإرسال عبر `share_plus`) |
| `mobile_scanner` للباركود | ✅ موجود في POS و SalesInvoice |

---

## 5. التكامل (Integration)

### 👥 إدارة المستخدمين
| الجانب | الحالة |
|--------|--------|
| الأدوار | 3 أدوار فقط (Admin/Manager/Cashier) - **محدود جدًا** |
| الصلاحيات | 80 صلاحية معرفة لكن معظمها غير مستخدم فعليًا |
| `AuthProvider` | ينسخ كود `SecurityService` - قفل الحساب غير مفعل عبر AuthProvider |
| Audit trail للصلاحيات | **غير موجود** - لا تتبع لتغييرات الصلاحيات |
| `AccessGuard` | صلبة (hardcoded) - أي مسار جديد يتطلب تعديل الملف |
| Cache الصلاحيات | غير موجود - ضرب DB مع كل عملية تحقق |

### 🌐 تعدد اللغات
| الجانب | الحالة |
|--------|--------|
| عدد المفاتيح | 445 مفتاح في AR/EN - جيد |
| **النصوص غير المترجمة** | **30%+ من الواجهة عربي hardcoded** (`'تعديل المنتج'`, `'إلغاء'`, `'نقطة البيع السريع'`, رسائل الخطأ) |
| Plurals | **غير موجود** - `{count} تغييرات` لا تستخدم ICU plurals |
| Gender-aware | **غير موجود** للعربية |
| لغات إضافية | عربي + إنجليزي فقط - لا فرنسي/أردو/فارسي |
| اختبارات الترجمة | **0%** - لا اختبار لتحميل السلاسل `AppLocalizations` |

### 📱 تطبيق موبايل
| الجانب | الحالة |
|--------|--------|
| نوع التطبيق | Flutter فقط - **لا يوجد REST API** لتطبيق موبايل خارجي أو Web |
| تطبيق للمندوبين | غير موجود |
| تطبيق للعملاء | غير موجود |
| Notifications (Firebase) | غير موجود |
| Offline-first | ✅ `SyncService` معمول له (لكن غير متصل) |

---

## 6. الاختبارات (Testing)

### 📋 ملفات الاختبار (33 ملف)

| المجال | عدد الملفات | التغطية | الحالة |
|--------|-------------|---------|--------|
| Unit Tests | 5 | `inventory_service`, `accounting_service`, `analytics_service`, `access_control`, `unit_conversion` | ✅ متنوعة |
| Widget Tests | 3 | POS (وهمي), Login, Dashboard | ⚠️ POS page test يختبر وهمي |
| Service Tests | 5 | pricing, costing, app_config, accounting, post_development | ✅ جيدة |
| Logic Tests | 5 | enums, validators, posting_engine, calculation, auth | ✅ Validators ممتازة |
| Integration Tests | 8 | accounting_cycle, accounting_posting, database_init, db_performance, sales_workflow, etc. | ✅ قوية |
| BLoC Tests | 2 | pos_bloc, pos_addproduct | ✅ موجودة |
| Smoke Test | 1 | smoke_test.dart | ✅ شامل |

### ❌ الفجوات

| المجال | التغطية | الحالة |
|--------|---------|--------|
| **Backup & Sync** | ❌ **0%** | لا يوجد اختبارات للنسخ الاحتياطي أو المزامنة |
| **Security Service** | ❌ **0%** | لا اختبار لقفل الحساب (lockout)، الجلسات، ترحيل SHA → BCrypt، صلاحيات متقدمة |
| **Reporting** | ❌ **0%** | لا اختبار `ReportEngineService` أو `PdfService` أو أي تقرير |
| **Localization** | ❌ **0%** | لا اختبار لتحميل السلاسل أو ARB files |
| **Printer** | ❌ **0%** | لا اختبار لتوليد الفاتورة الحرارية |
| **E-commerce** | ❌ **0%** | لا اختبار |
| **Loyalty/Promotions** | ❌ **0%** | لا اختبار |
| **Manufacturing** | ❌ **0%** | لا اختبار لـ `BomService` أو `ProductionService` |
| **Data Import** | ❌ **0%** | لا اختبار `DataImportService` |
| **Performance/Load** | ❌ | فقط `db_performance_test.dart` |
| **Accessibility** | ❌ **0%** | لا اختبار `Semantics` أو screen reader |
| **Security (XSS, injection, bypass)** | ❌ **0%** | لا اختبارات أمنية |
| **`pos_page_test.dart`** | ⚠️ | يختبر `SimplePosView` وهمي - لا يختبر الـ PosPage الحقيقي |

### توصيات الاختبارات
1. إصلاح `pos_page_test.dart` ليختبر `PosPage` الحقيقي
2. إضافة Unit tests لـ `SecurityService` (lockout, session, password migration)
3. إضافة Unit tests لـ `SyncService` (queue operations, conflict resolution)
4. إضافة Integration tests للـ backup/restore workflow
5. إضافة tests لـ `ThermalPrinterService` (مقارنة byte output)
6. إضافة tests لـ `ReportEngineService` (صحة البيانات)
7. إضافة localization tests لجميع `AppLocalizations`
8. استهداف >60% تغطية للخدمات الأساسية

---

## 7. ملخص التوصيات حسب الأولوية

### 🔴 حرج (فوري - يمنع التشغيل السليم)

| # | المشكلة | الملف |
|---|---------|-------|
| 1 | **إصلاح `getBatchesForSale()` AVCO path** - يعيد كل الدُفعات بدل الكمية المطلوبة | `inventory_costing_service.dart` |
| 2 | **إصلاح `postSale()` status check** - يقارن `.index` (int) مع string | `transaction_engine.dart` |
| 3 | **إصلاح `getOutstandingSales()`** - يستخدم جدول خطأ لحساب المدفوعات | `transaction_engine.dart` |
| 4 | **إصلاح Zakat Calculation** - يقرأ `account.balance` (صفر دائمًا) | `zakat_service.dart` |
| 5 | **إصلاح `DriveBackupService`** - `_driveApi` لا يُهيأ، تحميل السحابة بخطأ type | `drive_backup_service.dart` |
| 6 | **إصلاح `completeProductionOrder()`** - لا يخصم/ينشئ batches فعليًا | `production_service.dart` |

### 🟡 عالي (خلال أسبوع)

| # | المشكلة | الملف |
|---|---------|-------|
| 1 | **تنفيذ `_pushToServer()` / `_pullFromServer()`** في `SyncService` | `sync_service.dart` |
| 2 | **توحيد DAO المحاسبي** (Manual vs Drift) | `dao/accounting_dao.dart` |
| 3 | **إصلاح `AuthProvider.login()`** - يجب أن يفوض إلى `SecurityService` | `auth_provider.dart` |
| 4 | **استبدال JSON blob للموافقات** بقاعدة بيانات علائقية | `approval_workflow_service.dart` |
| 5 | **إضافة اتصال حقيقي للطابعة الحرارية** (Bluetooth/USB) | `thermal_printer_service.dart` |
| 6 | **تفعيل الترجمة لجميع النصوص العربية hardcoded** | جميع الصفحات |
| 7 | **تنفيذ E-commerce Integration** الفعلي أو إزالة الكود الوهمي | `ecommerce_integration_service.dart` |
| 8 | **إضافة XLSX parsing** في `DataImportService` | `data_import_service.dart` |
| 9 | **إصلاح POS page test** ليختبر الـ PosPage الحقيقي | `pos_page_test.dart` |
| 10 | **تصحيح حسابات `FinancialReportService`** - احتمال ازدواج في الميزانية | `financial_report_service.dart` |
| 11 | **إزالة/إصلاح `_createReverseEntry()`** - ينشئ قيدًا خاطئًا | `financial_control_service.dart` |

### 🟢 متوسط (شهري)

| # | المشكلة | الملف |
|---|---------|-------|
| 1 | إضافة `Semantics` للواجهة (إمكانية الوصول) | جميع الصفحات |
| 2 | تفعيل `SkeletonLoader` في الصفحات الرئيسية | dashboard, products, reports |
| 3 | دفع فلاتر `inventory_costing_service` إلى SQL بدل in-memory | `inventory_costing_service.dart` |
| 4 | إضافة pagination لطلبات قاعدة البيانات الكبيرة | DAOs المتعددة |
| 5 | تحويل `_calculateFifoValuation/Avco/Lifo` إلى خوارزميات حقيقية | `inventory_costing_service.dart` |
| 6 | إضافة PromotionsService مخصص مع محرك خصم | promotions module |
| 7 | إضافة optimistic locking للمخزون (منع over-selling) | `inventory_costing_service.dart` |
| 8 | إضافة تقارير PDF إضافية (قائمة دخل، ميزانية...) | `pdf_service.dart` |
| 9 | إضافة `.xlsx` حقيقي للتصدير | `export_service.dart` |
| 10 | تكامل Loyalty مع `TransactionEngine.postSale()` | `loyalty_service.dart` + `transaction_engine.dart` |
| 11 | إغلاق `balance` column أو تحديثه آليًا | `gl_accounts` table |
| 12 | إضافة audit trail لتغيير الصلاحيات | `permission_service.dart` |
| 13 | Cache للأذونات مع TTL | `advanced_permission_service.dart` |
| 14 | دمج `BomService` و `ProductionService` في محرك تصنيع واحد | manufacturing module |

### 🔵 منخفض (تحسينات مستقبلية)

| # | المشكلة |
|---|---------|
| 1 | إضافة المزيد من الأدوار المرنة (بدل 3 أدوار صلبة) |
| 2 | إضافة plurals و gender-aware للترجمة |
| 3 | إضافة فرنسي وأردو كلغات إضافية |
| 4 | إنشاء تطبيق موبايل للمندوبين والعملاء |
| 5 | تكامل مع بوابات الدفع (Mada, Visa, Apple Pay, STC Pay) |
| 6 | نظام إشعارات (Firebase Cloud Messaging) |
| 7 | إضافة CSRF tokens للعمليات الحساسة |
| 8 | WebSocket للتواصل الفوري مع الفروع |
| 9 | تكامل مع ZATCA للتقديم الإلكتروني للفواتير (XML/API) |
| 10 | دعم السحابة الإلكترونية للتخزين (AWS S3, Firebase Storage) |
| 11 | نظام إشعارات للعملاء (WhatsApp Business API) |
| 12 | إحصائيات متقدمة و AI-based forecasting |

---

## 8. الملفات الأساسية التي تحتاج تدخل

| الملف | الأولوية | عدد المشاكل |
|-------|----------|-------------|
| `lib/core/services/inventory_costing_service.dart` | 🔴 حرج | 6 (AVCO, FIFO/AVCO/LIFO متطابقة, N+1, no locking) |
| `lib/core/services/transaction_engine.dart` | 🔴 حرج | 5 (status check, outstanding balance, AVCO, shift) |
| `lib/core/services/posting_engine.dart` | 🔴 حرج | 2 (Zakat balance, exchange rate inconsistent) |
| `lib/core/services/financial_control_service.dart` | 🔴 حرج | 3 (reverse entry, void logic) |
| `lib/core/services/zakat_service.dart` | 🔴 حرج | 1 (balance = 0 دائمًا) |
| `lib/core/utils/drive_backup_service.dart` | 🔴 حرج | 3 (api not init, type cast, no progress) |
| `lib/core/services/production_service.dart` | 🔴 حرج | 4 (no batch deduct, no create, no cost, no GL) |
| `lib/core/services/sync_service.dart` | 🟡 عالي | 3 (stub push/pull, conflict resolution, transport) |
| `lib/core/services/ecommerce_integration_service.dart` | 🟡 عالي | جميع الدوال stubs |
| `lib/core/services/thermal_printer_service.dart` | 🟡 عالي | اتصال وهمي |
| `lib/core/services/data_import_service.dart` | 🟡 عالي | XLSX وهمي، لا حفظ، encoding |
| `lib/core/services/approval_workflow_service.dart` | 🟡 عالي | JSON blob, 3 implementations |
| `lib/core/auth/auth_provider.dart` | 🟡 عالي | duplicate SecurityService, no lockout |
| `lib/core/services/financial_report_service.dart` | 🟡 عالي | double-count risk, inconsistent with DAO |
| `lib/data/datasources/local/daos/accounting_dao.dart` | 🟡 عالي | Manual vs Drift, precision loss |
| `lib/core/services/loyalty_service.dart` | 🟢 متوسط | JSON blob, no sales integration, no tiers |
| `lib/presentation/features/promotions/promotions_page.dart` | 🟢 متوسط | no service, no sales integration |
| `lib/core/services/export_service.dart` | 🟢 متوسط | Excel = CSV, date filter ignored |
| `lib/core/services/pdf_service.dart` | 🟢 متوسط | invoices only, no preview |
| `lib/core/extensions/accounting_extensions.dart` | 🟢 متوسط | 2 دوال ترجع 0.0 |
| `lib/presentation/features/pos/pos_page.dart` | 🟢 متوسط | test يختبر وهمي |
| `lib/presentation/widgets/skeleton_loader.dart` | 🟢 متوسط | غير مستخدم في أي صفحة |

---

**انتهى التقرير** - إجمالي 9 أقسام، 50+ مشكلة موثقة مع الأولويات والمواقع
