# IMPLEMENTATION_PLAN.md
## خطة التنفيذ التفصيلية - 6 Patches

> الإصدار: v1.0 | 18 يوليو 2026 | المدة المقدرة: 14-20 يوم عمل

---

## 1. الجدول الزمني

```
الأسبوع 1: PATCH-01 (يوم 1) → PATCH-02 (أيام 2-4)
الأسبوع 2: PATCH-03 (أيام 5-7) → PATCH-04 (أيام 8-11)
الأسبوع 3: PATCH-05 (يوم 12) → PATCH-06 (أيام 13-15) → احتياطي (أيام 16-20)
```

| Patch | المدة | أيام | مستوى | التبعية |
|-------|-------|------|-------|---------|
| PATCH-01 | 1 يوم | 1 | 🔴 HIGH | لا شيء |
| PATCH-02 | 2-3 أيام | 2-4 | 🔴 HIGH | PATCH-01 ✅ |
| PATCH-03 | 3-5 أيام | 5-7 | 🟡 MEDIUM | PATCH-02 ✅ |
| PATCH-04 | 5-7 أيام | 8-11 | 🟡 MEDIUM | PATCH-03 ✅ |
| PATCH-05 | 1 يوم | 12 | 🟢 LOW | لا تبعية مباشرة |
| PATCH-06 | 2-3 أيام | 13-15 | 🟡 MEDIUM | PATCH-01..05 ✅ |

### مسار التنفيذ الحرج (Critical Path)

```
PATCH-01 → PATCH-02 → PATCH-03 → PATCH-04 → PATCH-06 = 14-19 يوم
                                    ↗
                              PATCH-05 (يمكن تنفيذه بالتوازي مع PATCH-03/04)
```

- المسار الحرج = PATCH-01 → PATCH-02 → PATCH-03 → PATCH-04 → PATCH-06
- PATCH-05 مستقل ويمكن دمجه في أي وقت بعد PATCH-02
- PATCH-06 هو الاختبار النهائي ويعتمد على كل الـ patches السابقة

---

## 2. Feature Flag System

### 2.1 التصميم

```dart
// lib/core/config/feature_flags.dart
class MultiUnitV2FeatureFlag {
  static const String _key = 'multi_unit_v2';

  /// هل الميزة مفعلة؟
  static bool get isEnabled =>
      AppConfigService.getBool(_key, defaultValue: false);

  /// تفعيل/تعطيل (بدون إعادة تشغيل)
  static Future<void> setEnabled(bool value) =>
      AppConfigService.setBool(_key, value);

  /// القيمة الافتراضية: false (معطل) لحين اكتمال PATCH-04
  static const bool defaultValue = false;
}
```

### 2.2 خريطة تفعيل الـ Feature Flag

| Patch | feature flag | ملاحظة |
|-------|-------------|--------|
| PATCH-01 | **لا يحتاج flag** — إصلاح bug في autoBreak | دائماً مفعل |
| PATCH-02 | `multi_unit_v2` لاستخدام reservedQuantity | OFF افتراضياً |
| PATCH-03 | `multi_unit_v2` لاستخدام storedUnitId + adapter | OFF افتراضياً |
| PATCH-04 | `multi_unit_v2` لتفعيل العرض الجديد في الشاشات | OFF افتراضياً |
| PATCH-05 | **لا يحتاج flag** — إزالة كود قديم غير مستخدم | دائماً مفعل |
| PATCH-06 | يختبر مع flag = ON | يُفعل في بيئة الاختبار فقط |

### 2.3 متى يتم التفعيل النهائي؟

```
بعد اجتياز PATCH-06 لكل سيناريوهات الاختبار → تفعيل flag في الإنتاج
→ مراقبة لمدة 48 ساعة → جعل ON هو الإفتراضي
→ بعد شهر: إزالة الكود القديم المرتبط بـ flag == OFF
```

---

## 3. خريطة التبعيات بين الـ Patches

```
PATCH-01 (costPrice fix)
  │
  │  يجب أن يُطبق أولاً لأن reservedQuantity في PATCH-02
  │  تعتمد على أن autoBreak ينتج costPrice صحيح
  │
  ▼
PATCH-02 (reservedQuantity)
  │
  │  يجب أن يُطبق قبل PATCH-03 لأن storedUnitId
  │  يحتاج إلى ربط الباتش بالوحدة قبل الحجز
  │
  ▼
PATCH-03 (storedUnitId + adapter)
  │
  │  adapter يجب أن يكون جاهزاً قبل تعديل الشاشات
  │
  ▼
PATCH-04 (39 screen updates)
  │
  │  جميع الشاشات تحتاج adapter + storedUnitId
  │
  ▼
PATCH-06 (testing + cleanup)
  ▲
  │
PATCH-05 (deprecation - يمكن أن يكون متوازياً)
```

### استثناءات التبعية:

- **PATCH-05 مستقل**: يمكن تطبيقه في أي وقت بعد PATCH-02
- **rollback آمِن**: كل patch له commit منفصل للتراجع

---

## 4. تفصيل كل Patch

### 4.1 PATCH-01: إصلاح costPrice في autoBreak

**المدة**: يوم واحد | **الخطورة**: 🔴 HIGH | **التبعية**: لا شيء

#### الملفات

| الملف | التعديل |
|-------|---------|
| `lib/core/services/packaging_engine.dart` | 3 أسطر (قبل/بعد) |

#### التغيير

```
قبل: costPrice = (batch.costPrice / packageSize) * actualDeduction
بعد: costPrice = batch.costPrice
```

#### الاختبار

```dart
test('PATCH-01: costPrice في BROKEN batch يساوي costPrice الأصلي', () async {
  // شراء batch بـ costPrice=10.0
  // packageSize=60, actualDeduction=5
  // التحقق: brokenBatch.costPrice == 10.0
});
```

#### خطة التراجع

```
git revert PATCH-01-commit
```

---

### 4.2 PATCH-02: إضافة reservedQuantity إلى ProductBatches

**المدة**: 2-3 أيام | **الخطورة**: 🔴 HIGH | **التبعية**: PATCH-01 ✅

#### Steps

```
اليوم 1:
  □ إضافة العمود reservedQuantity إلى ProductBatches (app_database.dart)
  □ إضافة الحقل إلى manual/entities.dart
  □ تعديل manual/schemas.dart
  □ توليد الكود (build_runner)

اليوم 2-3:
  □ تعديل transaction_engine.dart (postSale → reservedQuantity بدلاً من autoBreak)
  □ تعديل packaging_engine.dart (availableQuantity = quantity - reservedQuantity)
  □ تعديل inventory_costing_service.dart (FIFO مع reservedQuantity)
  □ تعديل products_dao.dart
  □ تعديل inventory_dao.dart
```

#### الملفات

| الملف | التعديل | الأسطر التقريبية |
|-------|---------|-----------------|
| `lib/data/datasources/local/app_database.dart` | إضافة عمود `reservedQuantity` | +3 |
| `lib/data/datasources/local/manual/schemas.dart` | إضافة عمود DDL | +1 |
| `lib/data/datasources/local/manual/entities.dart` | إضافة field + fromMap | +3 |
| `lib/data/datasources/local/app_database.g.dart` | إعادة توليد | (تلقائي) |
| `lib/core/services/transaction_engine.dart` | تعديل postSale | +30 |
| `lib/core/services/packaging_engine.dart` | تعديل availableQuantity | +2 |
| `lib/core/services/inventory_costing_service.dart` | تعديل FIFO | +5 |
| `lib/data/datasources/local/daos/products_dao.dart` | دوال reservedQuantity | +10 |
| `lib/data/datasources/local/manual/daos/inventory_dao.dart` | دعم reservedQuantity | +5 |

#### سيناريو الاختبار

```
1. شراء 10 Cartons (120 Pieces) → batch.quantity = 120
2. بيع 5 قطع → reservedQuantity = 5, quantity = 120 (لم يتغير)
3. no BROKEN batch created ❌ ← هذا هو المطلوب
4. post → quantity = 115, reservedQuantity = 0
5. sum(batch.quantity) == product.stock ✅
```

#### خطة التراجع

```
1. تعطيل feature flag (multi_unit_v2 = false)
   → postSale يعود لاستخدام autoBreak القديم
2. git revert PATCH-02-commit
3. الأعمدة الجديدة تبقى في DB (nullable → لا تؤثر)
```

---

### 4.3 PATCH-03: إضافة storedUnitId + StockDisplayAdapter

**المدة**: 3-5 أيام | **الخطورة**: 🟡 MEDIUM | **التبعية**: PATCH-02 ✅

#### Steps

```
اليوم 1-2:
  □ إضافة storedUnitId, quantityInStoredUnit إلى ProductBatches (app_database.dart)
  □ إضافة الحقول إلى manual/entities.dart و schemas.dart
  □ إنشاء StockDisplayAdapter (ملف جديد)

اليوم 3-4:
  □ تعديل transaction_engine.dart (postPurchase → تخزين سياق الوحدة)
  □ تعديل grn_service.dart (تمرير سياق الوحدة)
  □ تعديل packaging_engine.dart (الحفاظ على storedUnitId عند التكسير)
  □ تعديل inventory_display_service.dart (استخدام adapter)

اليوم 5:
  □ اختبار adapter
```

#### الملفات

| الملف | التعديل | الأسطر التقريبية |
|-------|---------|-----------------|
| `lib/core/utils/stock_display_adapter.dart` | **ملف جديد** | +120 |
| `lib/data/datasources/local/app_database.dart` | إضافة storedUnitId, quantityInStoredUnit | +6 |
| `lib/data/datasources/local/manual/schemas.dart` | إضافة DDL | +2 |
| `lib/data/datasources/local/manual/entities.dart` | إضافة fields | +4 |
| `lib/core/services/transaction_engine.dart` | تعديل postPurchase | +15 |
| `lib/core/services/grn_service.dart` | تمرير storedUnitId | +3 |
| `lib/core/services/packaging_engine.dart` | الحفاظ على storedUnitId | +5 |
| `lib/core/services/inventory_display_service.dart` | استخدام adapter | +5 |

#### التصميم

```dart
// StockDisplayAdapter.formatBatchDisplay:
// - إذا storedUnitId != NULL → format باستخدام storedUnitId
// - إذا storedUnitId == NULL → عرض "X حبة" (fallback)

// StockDisplayAdapter.formatProductStock:
// - استخدام displayUnitId من Products (إن وجد)
// - البحث عن أفضل وحدة تناسب الكمية
// - fallback: عرض pieces
```

#### خطة التراجع

```
1. تعطيل feature flag → adapter لا يُستخدم
2. inventory_display_service يعود للسلوك القديم
3. git revert PATCH-03-commit
4. الأعمدة الجديدة تبقى nullable في DB
```

---

### 4.4 PATCH-04: تحسين عرض الكميات في 39 شاشة

**المدة**: 5-7 أيام | **الخطورة**: 🟡 MEDIUM | **التبعية**: PATCH-03 ✅

#### Steps

```
اليوم 1-2: HIGH priority screens (15 ملفاً)
  □ pos_product_card.dart, pos_bloc.dart, cart_widget.dart
  □ sales_invoice_page.dart, stock_take_page.dart
  □ low_stock_alert_page.dart, smart_stock_widget.dart
  □ product_card.dart, notification_service.dart
  □ inventory_report_service.dart, beginning_of_period_page.dart
  □ purchase_provider.dart (validation only)

اليوم 3-4: MEDIUM priority screens (15 ملفاً)
  □ low_stock_products_page.dart, purchase_item_row.dart
  □ purchase_details_page.dart, item_movement_detail_page.dart
  □ inventory_value_report.dart, low_stock_report.dart
  □ product_batches_report.dart, inventory_transactions_report.dart
  □ sales_item_row.dart, sale_details_bottom_sheet.dart
  □ sales_orders_page.dart, add_sales_order_page.dart
  □ sales_order_detail_page.dart, dashboard_service.dart
  □ chart_service.dart

اليوم 5: LOW priority screens (9 ملفاً)
  □ report_engine_service.dart, export_service.dart
  □ rest_api_service.dart, data_import_service.dart
  □ erp_data_service.dart, profitability_service.dart
  □ dashbaord_page.dart, home_page.dart, products_page.dart
```

#### نمط التعديل

```dart
// قبل
Text(product.stock.toString())

// بعد:
FutureBuilder(
  future: adapter.formatProductStock(product),
  builder: (ctx, snap) => Text(snap.data ?? product.stock.toString()),
)
```

**ملاحظة مهمة**: يُستخدم `feature_flag` لاختيار old/new:

```dart
// في حالة OFF → السلوك القديم مباشرة (product.stock.toString())
// في حالة ON → StockDisplayAdapter.formatProductStock(product)
```

#### خطة التراجع

```
1. تعطيل feature flag → كل الشاشات تعود للسلوك القديم فوراً
2. بدون تغيير الكود
3. يمكن التفعيل/التعطيل في أي وقت
```

---

### 4.5 PATCH-05: إهمال الأنظمة القديمة

**المدة**: يوم واحد | **الخطورة**: 🟢 LOW | **التبعية**: لا تبعية مباشرة

#### الملفات

| الملف | التعديل |
|-------|---------|
| `lib/core/utils/erp_logic.dart` | إزالة useIsCarton/piecesPerCarton |
| `lib/presentation/features/purchases/purchase_provider.dart` | إزالة isCarton |
| `lib/presentation/features/purchases/add_purchase_page.dart` | استخدام ProductUnits |
| `lib/core/services/unit_conversion_service.dart` | إضافة convertProductUnits |
| `lib/core/services/auto_break_service.dart` | استخدام ProductUnits فقط |

#### ما سيبقى (ولن يُستخدم)

```
□ Products.cartonUnit
□ Products.piecesPerCarton
□ PurchaseItems.isCarton
□ UnitConversions table
```

#### خطة التراجع

```
git revert PATCH-05-commit (بسيط، لا تأثير على البيانات)
```

---

### 4.6 PATCH-06: اختبار شامل + تنظيف BROKEN batches

**المدة**: 2-3 أيام | **الخطورة**: 🟡 MEDIUM | **التبعية**: PATCH-01..05 ✅

#### Steps

```
اليوم 1: Unit Tests
  □ test/unit/reserved_quantity_test.dart (10 test cases)
  □ test/unit/stock_display_adapter_test.dart (8 test cases)
  □ test/unit/packaging_engine_cost_test.dart (3 test cases)

اليوم 2: Integration Tests
  □ test/integration/multi_unit_flow_test.dart (السيناريو الكامل)
  □ test/integration/fifo_with_reserved_test.dart
  □ test/integration/cogs_accuracy_test.dart

اليوم 3: تنظيف + Performance
  □ تشغيل BROKEN batch cleanup SQL
  □ قياس أداء FIFO (قبل/بعد)
  □ توثيق النتائج
```

#### سيناريو الاختبار الشامل

```
1. شراء 10 Cartons (factor=12) ← stock=120, batch.qty=120, storedUnitId=carton, qtyInStoredUnit=10
2. بيع 5 Pieces ← reservedQuantity=5, COGS=50
3. بيع 3 Pieces ← reservedQuantity=8
4. بيع 1 Carton (12 Pieces) ← reservedQuantity=20
5. بيع 7 Pieces ← reservedQuantity=27
6. Post (ترحيل) ← batch.qty=93, reservedQuantity=0, COGS=270
7. مرتجع 1 Carton ← batch.qty=105
8. جرد ← sum(batch.qty) == product.stock ✅
9. FIFO ← ترتيب صحيح حسب expiryDate ASC, createdAt ASC
10. عرض ← StockDisplayAdapter.formatProductStock → "7 كرتون + 9 حبة"
```

#### Script تنظيف BROKEN batches

```sql
-- الخطوة 1: إعادة الكميات
UPDATE product_batches AS original
SET quantity = CAST(original.quantity AS REAL) + (
  SELECT COALESCE(SUM(CAST(broken.quantity AS REAL)), 0)
  FROM product_batches AS broken
  WHERE broken.batch_number LIKE 'BROKEN-' || original.batch_number || '-%'
    AND broken.product_id = original.product_id
    AND broken.warehouse_id = original.warehouse_id
)
WHERE original.batch_number NOT LIKE 'BROKEN-%';

-- الخطوة 2: حذف BROKEN
DELETE FROM product_batches
WHERE batch_number LIKE 'BROKEN-%';

-- الخطوة 3: التحقق
SELECT p.id, p.name,
       CAST(p.stock AS REAL) AS product_stock,
       SUM(CAST(pb.quantity AS REAL)) AS batch_total,
       CAST(p.stock AS REAL) - SUM(CAST(pb.quantity AS REAL)) AS diff
FROM products p
LEFT JOIN product_batches pb ON pb.product_id = p.id
GROUP BY p.id
HAVING ABS(diff) > 0.01;
```

#### خطة التراجع

```
1. BROKEN batches: إذا حُذفت → استعد من النسخة الاحتياطية
2. الاختبارات: مجرد ملفات → git revert
3. تأكد من أخذ نسخة احتياطية قبل التنظيف
```

---

## 5. مصفوفة التأثير على التقارير

| التقرير | PATCH-01 | PATCH-02 | PATCH-03 | PATCH-04 | PATCH-05 | PATCH-06 |
|---------|----------|----------|----------|----------|----------|----------|
| FIFO Costing | ✔️ (cost صحيح) | ✔️ (available) | - | - | - | ✔️ (نظيف) |
| COGS | ✔️ | ✔️ | - | - | - | ✔️ |
| المخزون (Inventory) | - | - | ✔️ (context) | ✔️ (عرض) | - | ✔️ |
| حركات المخزون | - | - | ✔️ | ✔️ | - | ✔️ |
| قيمة المخزون | ✔️ | ✔️ | - | - | - | - |
| انخفاض المخزون | - | - | - | ✔️ | - | - |
| الباتشات | - | ✔️ | ✔️ | ✔️ | - | ✔️ (تقل) |
| الربحية | ✔️ | ✔️ | - | - | - | - |
| المبيعات | - | ✔️ | - | ✔️ | - | - |
| المشتريات | - | - | ✔️ | ✔️ | ✔️ | - |
| الجرد (Stock Take) | - | ✔️ | - | ✔️ | - | ✔️ |

---

## 6. خطة Rollback لكل سيناريو

| السيناريو | الإجراء | الوقت المستغرق | المخاطرة |
|-----------|---------|---------------|----------|
| خطأ في PATCH-01 | `git revert` | 5 دقائق | 🟢 LOW |
| خطأ في PATCH-02 (قبل التفعيل) | `git revert` | 10 دقائق | 🟢 LOW |
| خطأ في PATCH-02 (بعد التفعيل) | تعطيل flag → `git revert` | 5 دقائق | 🟢 LOW |
| خطأ في PATCH-03 | تعطيل flag → `git revert` | 5 دقائق | 🟢 LOW |
| خطأ في PATCH-04 | تعطيل flag فقط | دقيقة واحدة | 🟢 LOW |
| خطأ في PATCH-05 | `git revert` | 5 دقائق | 🟢 LOW |
| خطأ في PATCH-06 | استعادة DB backup | 30 دقيقة | 🟡 MEDIUM |
| فشل migration | تجاهل الأعمدة الجديدة (nullable) | فوري | 🟢 LOW |
| تلف بيانات | استعادة backup كامل | ساعة | 🔴 HIGH |

### قاعدة ذهبية للـ Rollback

> **إذا ظهر خطأ في أي Patch، أوقف التنفيذ فوراً، ارجع خطوة، وحلل المشكلة قبل المتابعة.**

---

## 7. قائمة التحقق النهائية قبل البدء

- [ ] جميع التقارير الثمانية كاملة ومقروءة
  - [ ] SAFE_MULTI_UNIT_ANALYSIS.md ✅
  - [ ] MULTI_UNIT_REFACTOR_PLAN.md ✅
  - [ ] RISK_REPORT.md ✅
  - [ ] DEPENDENCY_MAP.md ✅
  - [ ] FIFO_REVIEW.md ✅
  - [ ] ERP_ARCHITECT_REVIEW.md ✅
  - [ ] IMPLEMENTATION_PLAN.md ✅ (هذا الملف)
  - [ ] PATCH_PLAN.md ✅
- [ ] تم أخذ نسخة احتياطية من قاعدة البيانات
- [ ] تم أخذ نسخة احتياطية من الكود (git tag)
- [ ] feature flag جاهز (multi_unit_v2 = false)
- [ ] فريق التطوير على علم بالخطة
- [ ] بيئة اختبار منفصلة عن الإنتاج
- [ ] أدوات القياس جاهزة (قبل/بعد)
- [ ] خطة التواصل مع المستخدمين جاهزة

---

## 8. مؤشرات النجاح (KPIs)

| المقياس | القيمة الحالية | الهدف بعد PATCH-06 |
|---------|---------------|-------------------|
| عدد BROKEN batches | ? | 0 |
| وقت استعلام FIFO | ? | أسرع بنسبة 60% |
| شاشات تعرض stock بشكل مباشر | 39 | 0 (كلها عبر adapter) |
| costPrice bug في autoBreak | موجود | مُصلح |
| سياق الوحدة في الباتشات | 0% | 100% للجدد |
| الفرق بين stock ومجموع الباتشات | ? | 0 |
| نسبة نجاح اختبارات الانحدار | 100% | 100% ✅ |

---

*انتهى IMPLEMENTATION_PLAN.md — جميع التقارير الثمانية مكتملة. في انتظار الموافقة لبدء PATCH-01.*
