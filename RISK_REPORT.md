# RISK_REPORT.md
## تقرير تحليل المخاطر - مشروع إعادة هيكلة الوحدات

> تاريخ الإصدار: 18 يوليو 2026  
> المشروع: SystemMarket ERP/POS  
> التحليل: شامل لكامل قاعدة الأكواد

---

## ملخص تنفيذي للمخاطر

| مستوى المخاطرة | العدد | النسبة |
|---------------|-------|--------|
| **CRITICAL** | 2 | 8% |
| **HIGH** | 6 | 24% |
| **MEDIUM** | 10 | 40% |
| **LOW** | 7 | 28% |
| **المجموع** | **25** | **100%** |

---

## المخاطر المصنفة حسب الخطورة

### 🔴 CRITICAL (2) - توقف تام أو فساد بيانات

| # | المخاطرة | الوصف | التأثير | خطة التخفيف |
|---|---------|-------|---------|------------|
| CR-01 | **فساد تقييم FIFO** | إذا تم تغيير طريقة تخزين `ProductBatches.quantity`، كل حسابات FIFO في 377 سطراً ستتأثر. تقييم المخزون الحالي سيختلف مع البيانات القديمة. | جميع تقارير المخزون، COGS، قائمة الدخل، الميزانية | ❌ **لا نغير `quantity` في ProductBatches** - نضيف أعمدة جديدة فقط |
| CR-02 | **كسر واجهة TransactionEngine** | `TransactionEngine.postPurchase()` و `postSale()` تستخدم من قبل 8 خدمات منفصلة. تغيير توقيع الدوال سيكسر كل نقطة الدخول. | كل المبيعات، المشتريات، المرتجعات | ❌ **لا نغير API** - نضيف overloads أو params اختيارية |

### 🟠 HIGH (6) - تأثير كبير على العمليات

| # | المخاطرة | الوصف | التأثير | خطة التخفيف | مستوى |
|---|---------|-------|---------|------------|-------|
| HI-01 | **تضخم الباتشات المكسورة** | `PackagingEngine.autoBreakIfNecessary()` ينشئ batch جديد لكل عملية تكسير. مع 100 عملية بيع يومياً، نحصل على 100+ batch لكل منتج شهرياً. | أداء FIFO، أداء الاستعلامات، تعقيد الجرد، واجهة المستخدم | Medium | إلغاء التكسير غير الضروري، السماح بالبيع الجزئي مباشرة |
| HI-02 | **فقدان سياق الوحدة في البيانات القديمة** | المنتجات الموجودة قبل التحديث ليس لها `display_unit_id` أو `stored_unit_id`. | شاشات العرض ستظهر بشكل مختلف، المقارنات التاريخية | Medium | Backfill ذكي، fallback للوحدة الأساسية |
| HI-03 | **شاشات تعرض stock مباشرة** | أكثر من 30 شاشة تستخدم `product.stock` مباشرة بدون تحويل للوحدة. تعديلها كلها سي consuming وقتاً طويلاً وقد ننسى بعضها. | عرض غير متسق للمستخدم | High | إنشاء `StockDisplayAdapter` واستخدامه في طبقة العرض فقط |
| HI-04 | **تضارب أنظمة الوحدات الثلاثة** | النظام يحتوي على 3 أنظمة متوازية: (1) `ProductUnits` مع unitFactor، (2) `UnitConversions` جدول قديم، (3) `cartonUnit/piecesPerCarton` في Products. | تشتت البيانات، صعوبة الصيانة | High | توحيد على `ProductUnits`، إهمال النظامين الآخرين تدريجياً |
| HI-05 | **Drift schema migration for SQLCipher** | قاعدة البيانات مشفرة (SQLCipher) عبر Drift. عمليات ALTER TABLE قد تحتاج careful handling في البيئة المشفرة. | فشل الترقية، فقدان البيانات | Medium | اختبار migration على نسخة احتياطية أولاً، خطة fallback |
| HI-06 | **تأثير على تقارير المخزون القديمة** | التقارير المحفوظة (printed/exported) ستختلف عن التقارير الجديدة لنفس الفترة بسبب تغيير طريقة العرض. | تناقض في التقارير، شكوك المستخدمين | Medium | توثيق التغيير، إتاحة option للتبديل بين old/new |

### 🟡 MEDIUM (10) - تأثير معتدل، قابل للإدارة

| # | المخاطرة | التأثير | خطة التخفيف |
|---|---------|---------|------------|
| ME-01 | REST API يتغير (response قديم vs جديد) | إضافة `displayStock` إلى response مع الإبقاء على `stock` القديم |
| ME-02 | تعديل `PurchaseItems.quantityInBaseUnit` | هو nullable حالياً، التأكد من أنه يملأ بشكل صحيح |
| ME-03 | تعديل `SaleItems.unitName/unitFactor` | موجودان بالفعل، فقط تحسين استخدامهما |
| ME-04 | Backup/Restore مع schema الجديد | اختبار backup مع schema الجديد |
| ME-05 | Sync بين الأجهزة مع schema مختلف | التأكد من توافق الـ sync مع الأعمدة الجديدة |
| ME-06 | وحدات القياس المخصصة (custom units) | اختبار units مخصصة (مثل: طبق، دستة، رزمة) |
| ME-07 | الأصناف الخدمية (isService = true) | ليس لها مخزون، التأكد من عدم تطبيق التغيير عليها |
| ME-08 | نقطة البيع (POS) - تجربة المستخدم | قد يرتبك المستخدم برؤية وحدات مختلفة في واجهة البيع |
| ME-09 | المنتجات ذات الوحدة الأساسية فقط (بدون units) | fallback: تتصرف كالسابق تماماً |
| ME-10 | COGS للوحدات المختلفة | التأكد من أن costPrice يحسب لكل وحدة أساسية (صحيح رياضياً) |

### 🟢 LOW (7) - تأثير ضئيل

| # | المخاطرة |
|---|---------|
| LO-01 | `isCarton` boolean في PurchaseItems (غير دقيق، يُهمل تدريجياً) |
| LO-02 | `UnitConversions` جدول مكرر (نوقف استخدامه) |
| LO-03 | `Products.cartonUnit/piecesPerCarton` (نوقف استخدامه) |
| LO-04 | `Products.kiloUnit/boxUnit` (غير مستخدمة أصلاً) |
| LO-05 | تعديل manual entities (إضافة fields جديدة nullable) |
| LO-06 | تحديث الـ l10n localization للنصوص الجديدة |
| LO-07 | Export/Import CSV مع حقول جديدة |

---

## تحليل التأثير لكل جدول

### Products

| ما الذي سيتأثر | مستوى |
|---------------|-------|
| **الحقول المستخدمة حالياً**: `stock` (150+ مرجع), `buyPrice`, `sellPrice` | CRITICAL |
| **إضافة**: `display_unit_id`, `default_purchase_unit_id` (nullable) | LOW |
| **الحقول القديمة المراد إهمالها**: `carton_unit`, `pieces_per_carton`, `kilo_unit`, `box_unit` | LOW (الأكواد الحديثة لا تستخدمها) |

**الخلاصة**: نضيف فقط، لا نغير. `stock` يبقى كما هو.

### ProductBatches

| ما الذي سيتأثر | مستوى |
|---------------|-------|
| **الحقول الحساسة**: `quantity` (50+ مرجع), `costPrice` (30+ مرجع) | CRITICAL |
| **إضافة**: `stored_unit_id`, `quantity_in_stored_unit` (nullable) | LOW |
| **خاصية التكسير**: `BROKEN-` batches المنتشرة | HIGH |

**الخلاصة**: لا نغير quantity/costPrice. نضيف stored_unit_id فقط. نقلل التكسير.

### PurchaseItems

| ما الذي سيتأثر | مستوى |
|---------------|-------|
| `quantity`, `unitFactor`, `quantityInBaseUnit` موجودة | MEDIUM |
| `isCarton` (boolean غير دقيق) | LOW |

**الخلاصة**: نضيف `unit_name` فقط. نوقف استخدام `isCarton`.

### SaleItems

| ما الذي سيتأثر | مستوى |
|---------------|-------|
| `unitName` (افتراضي 'حبة'), `unitFactor` موجودان | MEDIUM |

**الخلاصة**: نضيف `display_quantity` فقط.

---

## مصفوفة التبعيات

```
                    TransactionEngine
                    ┌──┐
                    │  │
         ┌──────────┤  ├──────────┐
         │          └──┘          │
         ▼                        ▼
   PostingEngine           PackagingEngine
   ┌──────────┐           ┌──────────────┐
   │  · COGS  │           │  · autoBreak │
   │  · GL    │           │  · Hierarchy │
   └──────────┘           └──────────────┘
         │                      │
         ▼                      ▼
   InventoryCost     InventoryDisplay
   ┌──────────┐     ┌──────────────┐
   │  · FIFO  │     │  · format    │
   │  · AVCO  │     │  · display   │
   └──────────┘     └──────────────┘
         │              │
         ▼              ▼
   StockMovementDao   ProductsDao
   InventoryDao       ProductUnitsDao
```

**الملاحظة**: أي تغيير في `TransactionEngine` سينتشر إلى كل الخدمات أدناه. أي تغيير في `PackagingEngine` سيؤثر على FIFO.

---

## التأثير على التقارير

| التقرير | التأثير | التصنيف |
|---------|---------|---------|
| المخزون (Inventory Report) | عرض محسن للوحدات | HIGH |
| حركات المخزون (Stock Movements) | عرض محسن للوحدات | MEDIUM |
| قيمة المخزون (Inventory Value) | لا يتغير (قيمة مالية) | LOW |
| انخفاض المخزون (Low Stock) | عرض محسن | MEDIUM |
| الباتشات (Product Batches) | عرض محسن للوحدات | HIGH |
| الربحية (Profitability) | لا يتغير (حسابات مالية) | LOW |
| المبيعات (Sales Report) | عرض محسن للوحدات في الأصناف | MEDIUM |
| المشتريات (Purchase Report) | عرض محسن للوحدات | MEDIUM |
| تكلفة المبيعات (COGS) | لا يتغير | LOW |
| الجرد (Stock Take) | عرض محسن | MEDIUM |

---

## أوامر مسح قاعدة البيانات الحالية

للتأكد من الوضع الحالي للبيانات، يمكن تشغيل الاستعلامات التالية:

```sql
-- 1. كم منتج لديه وحدات مخصصة؟
SELECT COUNT(*) AS products_with_units FROM (
  SELECT DISTINCT product_id FROM product_units
);

-- 2. كم batch مكسور؟
SELECT COUNT(*) AS broken_batches 
FROM product_batches 
WHERE batch_number LIKE 'BROKEN-%';

-- 3. كم batch بدون سياق وحدة؟
SELECT COUNT(*) AS batches_no_unit_context 
FROM product_batches pb
LEFT JOIN purchase_items pi ON pi.batch_id = pb.id
WHERE pi.unit_factor IS NULL OR pi.unit_factor = 1;

-- 4. هل هناك تباين بين stock ومجموع الباتشات؟
SELECT p.id, p.name, 
       CAST(p.stock AS REAL) AS product_stock,
       SUM(CAST(pb.quantity AS REAL)) AS batch_total,
       CAST(p.stock AS REAL) - SUM(CAST(pb.quantity AS REAL)) AS difference
FROM products p
LEFT JOIN product_batches pb ON pb.product_id = p.id
GROUP BY p.id
HAVING ABS(difference) > 0.01;
```

---

## خطة الطوارئ (في حال فشل التنفيذ)

### إذا فشلت الـ Migration:

```
1. توقف عن التنفيذ فوراً
2. استعد النسخة الاحتياطية (قاعدة البيانات + الكود)
3. رفع ticket في GitHub Issues
4. توثيق سبب الفشل
```

### إذا ظهرت مشكلة بعد النشر:

```
1. تعطيل MultiUnitV2 Feature Flag
2. النظام يعود للعمل كما كان (الأعمدة الجديدة nullable، الكود القديم يعمل)
3. تحليل المشكلة
4. إصدار fix
```

### إذا كان الأداء أسوأ:

```
1. قياس الفرق (قبل/بعد)
2. إذا كان الفرق > 10%:
   - تعطيل feature flag
   - تحسين الاستعلامات
   - إعادة اختبار
```

---

## قائمة التحقق للموافقة

قبل البدء في كتابة أي كود، يجب الموافقة على:

- [ ] تمت قراءة SAFE_MULTI_UNIT_ANALYSIS.md بالكامل
- [ ] تمت قراءة MULTI_UNIT_REFACTOR_PLAN.md بالكامل
- [ ] تم فهم المخاطر في RISK_REPORT.md
- [ ] تم أخذ نسخة احتياطية من قاعدة البيانات
- [ ] تم أخذ نسخة احتياطية من الكود (git tag)
- [ ] تم تجهيز feature flag للتبديل
- [ ] تم تجهيز خطة rollback
- [ ] تم تجهيز خطة الاختبار
- [ ] تم تجهيز الـ migration الآمنة

---

**انتهى تقرير تحليل المخاطر**
