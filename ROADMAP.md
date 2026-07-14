# خطة العمل التنفيذية - SystemMarket Roadmap

**تاريخ البدء**: 14 يوليو 2026  
**الهدف تحويل النظام إلى نظام محاسبي متكامل وقوي  

---

## 🔴 المرحلة الأولى: إصلاحات حرجة (فوري)

### المخزون والتقييم
- [x] 1.1 إصلاح `getBatchesForSale()` AVCO path - يعيد كل الدُفعات بدل الكمية المطلوبة (`inventory_costing_service.dart:210-217`)
- [x] 1.2 إصلاح طرق تقييم FIFO/AVCO/LIFO (FIFO يقيم بأحدث التكاليف، LIFO بأقدمها، AVCO average) (`inventory_costing_service.dart:146-194`)
- [ ] ~~1.3 إضافة optimistic locking للمخزون~~ (مؤجل - التطبيق محلي أحادي المستخدم، SQLite transaction تكفي)

### محرك المعاملات
- [x] ~~1.4 إصلاح `postSale()` status check~~ (ليس خطأ - `DocumentStatusConverter` يخزن كـ `int` والمقارنة صحيحة)
- [x] 1.5 إصلاح `getOutstandingSales()` / `getOutstandingPurchases()` - استخدام `customerPaymentLinks` / `purchasePaymentLinks` بدل `accountTransactions` (`transaction_engine.dart:1029-1035`)

### المحاسبة والتقارير
- [x] 1.6 إصلاح حساب الزكاة - حساب الرصيد من GL Lines بدل `account.balance` الميت (`zakat_service.dart`)
- [x] 1.7 إصلاح عمود `balance` الميت - إضافة `_updateAccountBalances()` في `posting_engine.dart` لتحديث الأرصدة بعد كل ترحيل

### التصنيع
- [x] 1.8 إصلاح `completeProductionOrder()` - يخصم المواد الخام من `productBatches` وينشئ batch للمنتج النهائي مع التكلفة (`production_service.dart`)

### النسخ الاحتياطي
- [x] 1.9 إصلاح `DriveBackupService` - تهيئة `_driveApi` من authenticated client (`drive_backup_service.dart`)
- [x] 1.10 إصلاح `downloadCloudBackup()` - استخدام `files.get_()` مع `downloadOptions` بدل type cast الخاطئ (`drive_backup_service.dart`)
- [ ] ~~1.11 إضافة تقرير تقدم الرفع/التحميل للمستخدم~~ (مؤجل - تحسين واجهة، ليس critical)

---

## 🟡 المرحلة الثانية: إصلاحات عالية ()

### قاعدة البيانات
- [x] 2.1 توحيد DAO المحاسبي (Manual vs Drift) - استبدال `CAST AS REAL` بحسابات Dart باستخدام `Decimal` في manual DAOs المالية والمحاسبية (`accounting_dao.dart`, `inventory_dao.dart`, `financial_dao.dart`, `sales_dao.dart`)
- [x] 2.2 إضافة Foreign Key Constraints على مستوى قاعدة البيانات (موجودة بالفعل في Drift `.references()` و manual `REFERENCES` + `PRAGMA foreign_keys = ON`)

### الأمان والمصادقة
- [x] 2.3 إصلاح `AuthProvider.login()` - يفوض إلى `SecurityService.login()` مع قفل الحساب، الجلسات، ترحيل SHA → BCrypt (`auth_provider.dart`, `injection_container.dart`)
- [x] 2.4 إضافة Cache للأذونات مع TTL (حاليًا يضرب DB مع كل عملية تحقق) (`advanced_permission_service.dart`)
- [x] 2.5 إضافة Audit Trail لتغيير الصلاحيات (`permission_service.dart` → `advanced_permission_service.dart`)

### الموافقات (Approval Workflow)
- [x] 2.6 استبدال JSON blob في `AppConfigService` بقاعدة بيانات (يستخدم جدول `approval_requests` + `approval_history` عبر raw SQL مع Drift) (`approval_workflow_service.dart`)
- [x] 2.7 دمج التطبيقات (core + domain) في خدمة واحدة تستخدم `approval_requests` DB table (`core_module.dart`)
- [x] 2.8 إضافة تحقق تلقائي من صلاحية المُوافق (`canApprove()` يراجع role) (`approval_workflow_service.dart`)
- [x] 2.9 إضافة تأكيد تلقائي للمعاملة بعد الموافقة (`onApproved()` مع callback) (`approval_workflow_service.dart`)

### المحاسبة
- [x] 2.10 إصلاح `_createReverseEntry()` - إزالة الفallback الخاطئ، الآن يرمي خطأً واضحًا يطلب إلغاءً يدويًا (`financial_control_service.dart`)
- [x] 2.11 تصحيح `FinancialReportService` - إضافة `isHeader` filter لمنع ازدواج الحسابات في الميزانية (`financial_report_service.dart`)
- [x] 2.12 إزالة أو تحديث `_recordAccountTransaction()` - تحويل `UnifiedStatementService` لقراءة من `glLines`+`glEntries` مباشرة بدل `accountTransactions` (يبقى الجدول للتسوية البنكية)

### الطباعة
- [x] 2.13 تنفيذ اتصال فعلي للطابعة الحرارية (Network: TCP Socket على port 9100) (`thermal_printer_service.dart`)
- [x] 2.14 إضافة `getAvailableDevices()` حقيقي مع دعم Network (Bluetooth/USB يتطلب إضافة flutter_bluetooth_serial)

### الترجمة
- [ ] 2.15 تحويل جميع النصوص العربية hardcoded إلى `AppLocalizations.of(context)` (~30%+ من الواجهة)
- [ ] 2.16 ترجمة رسائل الخطأ في الـ validators (حاليًا عربي hardcoded)
- [ ] 2.17 إضافة اختبارات الترجمة (تحميل السلاسل `AppLocalizations`)

### المزامنة والتكامل
- [x] 2.18 تنفيذ `_pushToServer()` / `_pullFromServer()` في `SyncService` (HTTP POST/GET حقيقي + تكوين server URL + Auth token) (`sync_service.dart`)
- [x] 2.19 تنفيذ Conflict Resolution حقيقي (serverWins: سحب من السرفر, clientWins: دفع إلى السرفر, lastWriteWins: مقارنة version, manual: تعليم كفشل)
- [x] 2.20 تنفيذ E-commerce Integration الفعلي (WooCommerce REST API v3: orders, products, inventory, stats مع Auth Basic) (`ecommerce_integration_service.dart`)

### استيراد/تصدير البيانات
- [x] 2.21 إضافة تحذير XLSX (يرفض .xlsx مع رسالة واضحة لحين إضافة parser) (`data_import_service.dart`)
- [x] 2.22 جعل `importFromCsv()` يحفظ في قاعدة البيانات فعليًا عبر Drift (`data_import_service.dart`)
- [x] 2.23 إضافة التحقق من الترميزات (UTF-8 BOM strip + Windows-1252 fallback) (`data_import_service.dart`)
- [x] 2.24 إصلاح `_parseCsvLine` ليعالج `""` داخل quoted fields (`data_import_service.dart`)
- [x] 2.25 إصلاح `exportSales` لاستخدام `from`/`to` فعليًا (`export_service.dart`)
- [x] 2.26 إضافة `.xlsx` حقيقي للتصدير (باستخدام `excel` package) (`export_service.dart`)

### الاختبارات
- [ ] 2.27 إصلاح `pos_page_test.dart` ليختبر الـ `PosPage` الحقيقي (حاليًا يختبر `SimplePosView` وهمي)
- [ ] 2.28 إضافة Unit tests لـ `SecurityService` (lockout, session, password migration)
- [ ] 2.29 إضافة Unit tests لـ `SyncService` (queue operations, conflict resolution)
- [ ] 2.30 إضافة Integration tests للـ backup/restore workflow
- [ ] 2.31 إضافة tests لـ `ThermalPrinterService` (مقارنة byte output)
- [ ] 2.32 إضافة tests لـ `ReportEngineService` (صحة بيانات التقارير)

---

## المرحلة الثالثة: تحسينات متوسطة ي)

### تجربة المستخدم (UI/UX)
- [ ] 3.1 إضافة `Semantics` لجميع العناصر التفاعلية (screen reader support)
- [ ] 3.2 إضافة keyboard navigation + `FocusTraversalGroup`
- [ ] 3.3 إضافة `MediaQuery` لتكييف الخطوط والأحجام للموبايل/ديسكتوب
- [ ] 3.4 تفعيل `SkeletonLoader` في الصفحات الرئيسية (Dashboard, Products, Reports)
- [ ] 3.5 إضافة Error Boundary شامل على مستوى التطبيق
- [ ] 3.6 إضافة `prefer-reduced-motion` لـ shimmer animations
- [ ] 3.7 إضافة قائمة مركزة للأخطاء في النماذج (بدل SnackBars فقط)

### المخزون والتقييم
- [ ] 3.8 تحويل `_calculateFifoValuation/Avco/Lifo` إلى خوارزميات حقيقية (حاليًا جميعها Average)
- [ ] 3.9 دفع فلاتر `inventory_costing_service` إلى SQL بدل in-memory (N+1 + أداء)
- [ ] 3.10 إضافة pagination لطلبات قاعدة البيانات الكبيرة

### العروض والولاء
- [ ] 3.11 إضافة `PromotionsService` مخصص مع محرك خصم متكامل مع `TransactionEngine.postSale()`
- [ ] 3.12 تكامل `LoyaltyService` مع المبيعات (auto-award على `postSale()`)
- [ ] 3.13 إضافة expiry logic للنقاط + Tiers (bronze/silver/gold)
- [ ] 3.14 إصلاح `adjustPoints()` - إضافة تحقق أن الخصم ضمن الرصيد

### التقارير
- [ ] 3.15 إضافة تقارير PDF إضافية (قائمة دخل، ميزانية عمومية، تدفقات نقدية)
- [ ] 3.16 إضافة معاينة PDF قبل الطباعة
- [ ] 3.17 إصلاح N+1 query في `getProfitMarginReport` (`report_engine_service.dart`)
- [ ] 3.18 إضافة AR/AP Aging Report (30/60/90+ يوم)

### التصنيع
- [ ] 3.19 دمج `BomService` و `ProductionService` في محرك تصنيع واحد
- [ ] 3.20 نقل التحقق من المخزون داخل المعاملة في `BomService.assemble()` (منع race condition)
- [ ] 3.21 إضافة تكاليف overhead والـ scrap/yield loss

### التكامل الداخلي
- [ ] 3.22 إضافة REST API للتواصل مع تطبيقات خارجية
- [ ] 3.23 دعم السحابة الإلكترونية للتخزين (AWS S3, Firebase Storage)
- [ ] 3.24 إضافة Webhook receiver للتكامل مع الأنظمة الخارجية

---

## 🔵 المرحلة الرابعة: تحسينات مستقبلية

### إدارة المستخدمين
- [ ] 4.1 إضافة أدوار مرنة قابلة للتخصيص (بدل Admin/Manager/Cashier فقط)
- [ ] 4.2 إضافة CSRF tokens للعمليات الحساسة
- [ ] 4.3 إضافة rate limiting شامل (ليس فقط تسجيل الدخول)

### اللغات
- العربيه والانجليزيه
### تطبيقات الموبايل
- [ ] 4.7 إنشاء تطبيق موبايل للمندوبين (عرض المنتجات، إنشاء طلبات، تتبع)
- [ ] 4.8 إنشاء تطبيق موبايل للعملاء (عروض، فواتير، ولاء، إشعارات)
- [ ] 4.9 إضافة Firebase Cloud Messaging للإشعارات

### بوابات الدفع
- [ ] 4.10 تكامل مع Mada (مدى)
- [ ] 4.11 تكامل مع Visa/Mastercard
- [ ] 4.12 تكامل مع Apple Pay / Google Pay
- [ ] 4.13 تكامل مع STC Pay

### الاتصالات الفورية
- [ ] 4.14 إضافة WebSocket للتواصل الفوري مع الفروع
- [ ] 4.15 إضافة WhatsApp Business API للتواصل مع العملاء
- [ ] 4.16 إضافة SMS Gateway للإشعارات

### التكاملات الحكومية
- [ ] 4.17 تكامل مع ZATCA للفواتير الإلكترونية (XML + API submission)
- [ ] 4.18 تكامل مع هيئة الزكاة والضريبة والجمارك
- [ ] 4.19 دعم التوثيق الإلكتروني和政府ي

### التحليلات
- [ ] 4.20 إضافة AI-based forecasting للمبيعات والمخزون
- [ ] 4.21 إضافة تحليل سلوك العملاء
- [ ] 4.22 إضافة Business Intelligence Dashboard متقدم

---

## ملخص التقدم

| المرحلة | العدد الكلي | تم | متبقي | ملاحظات |
|---------|-------------|-----|--------|----------|
| 🔴 المرحلة الأولى: حرجة | 11 | 8 | 1 | 1.3 مؤجل, 1.4 ليس خطأ, 1.11 مؤجل |
| 🟡 المرحلة الثانية: عالية | 32 | 23 | 9 | 2.1-2.14, 2.18-2.26 تم |
| 🟢 المرحلة الثالثة: متوسطة | 24 | 0 | 24 | - |
| 🔵 المرحلة الرابعة: مستقبلية | 22 | 0 | 22 | - |
| **المجموع** | **89** | **21** | **68** | |

---

**ملاحظة**: عند إنجاز أي مهمة، غيّر `[ ]` إلى `[x]` وأضف تاريخ الإنجاز إن أمكن.
