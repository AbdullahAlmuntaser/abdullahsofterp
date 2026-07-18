# MULTI_UNIT_REFACTOR_PLAN.md
## خطة إعادة هيكلة نظام الوحدات المتعددة في المخزون

> الإصدار: v1.0 (اقتراح - لم ينفذ بعد)  
> يعتمد على تحليل SAFE_MULTI_UNIT_ANALYSIS.md

---

## 1. الحل المقترح: "وحدة تخزين مع سياق وحدة"

### 1.1 الفلسفة الأساسية

**بدلاً من** تخزين 10 Cartons ← تحويل إلى 120 Pieces ← تخزين كـ 120

**نقترح**: تخزين الكمية مع سياق الوحدة، بحيث يحتفظ النظام بـ:
```
{
  "baseQuantity": 120,        // الكمية بالوحدة الأساسية (للحسابات)
  "displayQuantity": 10,      // الكمية بوحدة التخزين
  "unitName": "كرتون",        // وحدة التخزين
  "unitFactor": 12            // عامل التحويل
}
```

### 1.2 مبدأ "الكتابة مرة، القراءة مرات"

- **التخزين الفعلي**: كل الكميات تبقى بالوحدة الأساسية (للتوافق مع العمليات الحسابية)
- **طبقة العرض**: نظام يعرض الكميات بوحدة التخزين الأصلية
- **طبقة API**: تُرسل الكميات بسياق الوحدة

### 1.3 مفهوم "Preferred Display Unit" لكل منتج

نضيف حقل `display_unit_id` في `Products` لتحديد الوحدة المفضلة للعرض:

```dart
// Products table - إضافة
TextColumn get displayUnitId => text().nullable()(); // معرف الوحدة المفضلة للعرض
```

NS:

```dart
// ProductBatches table - إضافة 
TextColumn get storedUnitId => text().nullable()(); // بأي وحدة تم شراء/تخزين هذه الدفعة
```

### 1.4 حل مشكلة Broken Batches

**بدلاً من** تكسير الباتش عند البيع بالتجزئة:

1. نضيف حقل `reserved_quantity` في `ProductBatches` للكمية المحجوزة
2. نسمح بالبيع الجزئي من الباتش بدون تكسير
3. نستخدم الـ `unitFactor` لحساب التكلفة مباشرة
4. نلغي `PackagingEngine.autoBreakIfNecessary()` أو نقلل استخدامه

---

## 2. الجداول التي تحتاج تعديل

### 2.1 Products - إضافات طفيفة فقط

| الحقل الجديد | النوع | الغرض |
|-------------|------|-------|
| `display_unit_id` | TEXT FK→ProductUnits(id) NULLABLE | معرف وحدة العرض المفضلة (في UI) |
| `default_purchase_unit_id` | TEXT FK→ProductUnits(id) NULLABLE | معرف وحدة الشراء الافتراضية |

**المبدأ**: لا نحذف أي عمود ولا نغير اسم `stock`.

### 2.2 ProductBatches - إضافة سياق الوحدة

| الحقل الجديد | النوع | الغرض |
|-------------|------|-------|
| `stored_unit_id` | TEXT FK→ProductUnits(id) NULLABLE | بأي وحدة تم إدخال هذه الدفعة |
| `quantity_in_stored_unit` | TEXT(Decimal) NULLABLE | الكمية بوحدة التخزين الأصلية |

**المبدأ**: `quantity` يبقى بالوحدة الأساسية للتوافق مع الحسابات الحالية.

### 2.3 PurchaseItems - تحسين الحقل الموجود

`quantityInBaseUnit` موجود بالفعل، نضيف:
- `unit_name` لتخزين اسم الوحدة مباشرة (نقلاً من الفاتورة)

### 2.4 SaleItems - تحسين

السجلات الحالية تحوي `unitName` و `unitFactor` وهذا جيد. نحتاج فقط:
- `display_quantity` لتخزين الكمية الظاهرة (للعرض فقط)

---

## 3. هل نحتاج Migration؟

### 3.1 نعم، نحتاج Migration آمنة

نحتاج إلى migration لإضافة الأعمدة الجديدة فقط. لا تعديل على الأعمدة الموجودة.

**نوع migration**: `ADD COLUMN` فقط (Drift schema migration)

### 3.2 خطوات الـ Migration

1. **Schema v1 → v2**: إضافة الأعمدة الجديدة (nullable)
   - `products.display_unit_id`
   - `products.default_purchase_unit_id`  
   - `product_batches.stored_unit_id`
   - `product_batches.quantity_in_stored_unit`

2. **Backfill البيانات**:
   - لكل `ProductBatch`، نحاول تحديد وحدة التخزين بناءً على:
     - batch_number (مثل PUR-xxx)
     - PurchaseItems المرتبطة
   - إذا لم نستطع، نترك `stored_unit_id = NULL`

---

## 4. كيف نحافظ على البيانات القديمة

### 4.1 مبدأ الحفاظ التام

1. **لا نحذف أي عمود موجود** - كل الأعمدة الحالية تبقى كما هي
2. **لا نغير سلوك الحقول الموجودة** - `stock` يبقى بالوحدة الأساسية
3. **نضيف فقط** - كل التغييرات هي ADD فقط

### 4.2 طبقة التوافق العكسي (Backward Compatibility Layer)

```dart
class StockDisplayAdapter {
  /// القديم: product.stock
  /// الجديد: StockDisplayAdapter.getDisplayStock(product)
  
  static Decimal getDisplayQuantity(Product product,  
      {List<ProductUnit>? units}) {
    // إذا كان للمنتج وحدة عرض مفضلة، نحول
    // وإلا نرجع product.stock كما هو
  }
}
```

### 4.3 التوافق مع الـ API

```dart
// REST API يرسل old + new معاً
{
  "stock": "120",           // قديم - دائماً بالوحدة الأساسية
  "displayStock": "10",     // جديد - بوحدة التخزين
  "displayUnit": "كرتون",   // جديد
  "displayUnitFactor": "12" // جديد
}
```

---

## 5. خطة Rollback

### 5.1 استراتيجية Rollback

1. **التراجع عن الـ Migration**: `ALTER TABLE ... DROP COLUMN` غير مدعوم في SQLite
   - بديل: تجاهل الأعمدة الجديدة (هي nullable أصلاً)
   - الكود القديم سيرى `NULL` في الأعمدة الجديدة ويتصرف كالسابق

2. **التراجع عن الكود**: استخدام feature flags للتبديل بين old/new

### 5.2 شروط التفعيل الآمن

```dart
class MultiUnitFeatureFlag {
  static bool get isEnabled => 
    AppConfigService.getBool('multi_unit_v2', defaultValue: false);
  
  // يمكن التبديل في أي وقت
  static Future<void> setEnabled(bool value) => 
    AppConfigService.setBool('multi_unit_v2', value);
}
```

---

## 6. كيفية المحافظة على المكونات الحساسة

### 6.1 الفواتير القديمة

- **لا نعدل الفواتير القديمة أبداً**
- الفواتير الحالية تحتوي على `quantity` بالوحدة الأساسية و `unitFactor` + `unitName`
- هذه تكفي لإعادة بناء سياق الوحدة
- لأي فاتورة قديمة بدون unitName، نستخدم `'حبة'` كافتراضي

### 6.2 القيود المحاسبية (GL)

- القيود المحاسبية لا تحتوي على كميات (فقط مبالغ مالية)
- **لا تتأثر** بالتغيير على الإطلاق
- `COGS` يُحسب من الكميات بالوحدة الأساسية × costPrice → لم يتغير

### 6.3 COGS

- COGS يُحسب كـ `deducted_quantity × costPrice` (كلها بالوحدة الأساسية)
- لا يتغير منطق الحساب
- القيد المحاسبي للـ COGS يبقى كما هو

### 6.4 FIFO

- FIFO يعمل على `ProductBatches` حسب `createdAt` و `expiryDate`
- لا يتغير الترتيب
- الباتشات المكسورة ستقل (لأننا نمنع auto-break غير الضروري)
- تحسين لـ FIFO بدلاً من تعطيله

### 6.5 التقارير

- التقارير المالية (قائمة الدخل، الميزانية) لا تتأثر
- تقارير المخزون ستظهر بوحدات أفضل للمستخدم
- التقارير القديمة: البيانات التاريخية محفوظة بالفعل

---

## 7. خطة التنفيذ التدريجي

### المرحلة الأولى: طبقة العرض فقط (الأسهل والأكثر أماناً)
مدى التأثير: LOW  
المدة: 2-3 أيام

1. إنشاء `StockDisplayAdapter` 
2. تعديل `InventoryDisplayService` لدعم display_unit
3. تعديل `formatForDisplay` و `formatInventoryBalance`
4. إظهار الكميات بشكل أفضل في الشاشات

### المرحلة الثانية: طبقة التخزين مع سياق الوحدة  
مدى التأثير: MEDIUM  
المدة: 3-5 أيام

1. إضافة الأعمدة الجديدة عبر Migration
2. تعديل `TransactionEngine.postPurchase()` لتخزين سياق الوحدة في الباتش
3. تعديل `TransactionEngine.postSale()` لتخزين سياق البيع
4. Backfill البيانات الموجودة

### المرحلة الثالثة: إلغاء التكسير غير الضروري  
مدى التأثير: HIGH  
المدة: 5-7 أيام

1. تعديل `PackagingEngine.autoBreakIfNecessary()` ليكون أكثر ذكاءً
2. إضافة `reserved_quantity` إلى ProductBatches
3. تعديل FIFO لدعم البيع الجزئي بدون تكسير
4. تنظيف الباتشات المكسورة القديمة

### المرحلة الرابعة: التحسينات النهائية  
مدى التأثير: MEDIUM  
المدة: 2-3 أيام

1. تحسين أداء FIFO
2. تحسين أداء تقارير المخزون
3. اختبار شامل لجميع السيناريوهات
4. توثيق التغييرات

---

## 8. قائمة الملفات التي ستحتاج تعديل

### 8.1 Core/Infrastructure (16 ملف)

| الملف | التعديل المقترح |
|-------|----------------|
| `app_database.dart` | إضافة أعمدة جديدة (Products, ProductBatches) |
| `injection_container.dart` | إضافة StockDisplayAdapter |
| `core/di/inventory_module.dart` | ربط الخدمات الجديدة |
| `manual/schemas.dart` | تعديل CREATE TABLE statements |
| `manual/entities.dart` | إضافة حقول جديدة للـ entities |
| `app_database.g.dart` | إعادة توليد (build_runner) |
| `products_dao.dart` | دعم الحقول الجديدة |
| `product_units_dao.dart` | (لا تغيير) |
| `inventory_dao.dart` (manual) | دعم batch.storedUnitId |
| `stock_movement_dao.dart` | (لا تغيير) |
| `accounting_dao.dart` | (لا تغيير) |
| `sales_dao.dart` | (لا تغيير) |
| `purchases_dao.dart` | (لا تغيير) |
| `converters/decimal_converter.dart` | (لا تغيير) |

### 8.2 Services (15 ملف)

| الملف | التعديل المقترح |
|-------|----------------|
| **`transaction_engine.dart`** | **الأهم** - تعديل postPurchase لربط الباتش بالوحدة، تعديل postSale |
| **`packaging_engine.dart`** | **الأهم** - تحسين autoBreak أو إلغاؤه |
| `inventory_display_service.dart` | دعم display_unit_id |
| `auto_break_service.dart` | تقليل التكسير غير الضروري |
| `unit_conversion_service.dart` | إضافة دوال تحويل مع display |
| `inventory_service.dart` | ربط adapter الجديد |
| `stock_operation_service.dart` | دعم display stock |
| `inventory_costing_service.dart` | (لا تغيير جوهري) |
| `inventory_audit_service.dart` | (لا تغيير) |
| `inventory_report_service.dart` | عرض أفضل للوحدات |
| `inventory_reservation_service.dart` | دعم الحجز بالوحدات |
| `grn_service.dart` | تسجيل سياق الوحدة في الباتش |
| `purchase_service.dart` | تمرير سياق الوحدة |
| `sales_service.dart` | (لا تغيير) |
| `return_service.dart` | استخدام display quantity في العرض |
| `report_engine_service.dart` | (لا تغيير) |
| ChartService | (لا تغيير) |
| DashboardService | (لا تغيير) |

### 8.3 Presentation/Screens (28+ ملف)

هذه الملفات تحتاج تعديل فقط لاستخدام `StockDisplayAdapter` بدلاً من `product.stock` مباشرة

| الملف | نوع التعديل |
|-------|------------|
| `pos_product_card.dart` | استخدام adapter للعرض |
| `pos_bloc.dart` | استخدام adapter للمقارنة |
| `cart_widget.dart` | عرض بالوحدة المناسبة |
| `sales_invoice_page.dart` | عرض بالوحدة المناسبة |
| `sales_item_row.dart` | عرض بالوحدة المناسبة |
| `sale_details_bottom_sheet.dart` | عرض بالوحدة المناسبة |
| `add_purchase_page.dart` | عرض بالوحدة المناسبة |
| `purchase_item_row.dart` | عرض بالوحدة المناسبة |
| `purchase_details_page.dart` | عرض بالوحدة المناسبة |
| `stock_take_page.dart` | عرض بالوحدة المناسبة |
| `low_stock_alert_page.dart` | عرض محسن |
| `item_movement_detail_page.dart` | عرض محسن |
| `smart_stock_widget.dart` | عرض محسن |
| `product_card.dart` | عرض محسن |
| `products_page.dart` | عرض محسن |
| `inventory_reports_screen.dart` | عرض محسن |
| `inventory_value_report.dart` | عرض محسن |
| `low_stock_report.dart` | عرض محسن |
| `product_batches_report.dart` | عرض محسن |
| `inventory_transactions_report.dart` | عرض محسن |
| `notification_service.dart` | استخدام adapter للإشعارات |
| `purchase_provider.dart` | تحديث المقارنات |
| `sales_provider.dart` | تحديث المقارنات |
| `beginning_of_period_page.dart` | عرض محسن |
| `home_page.dart` / `dashbaord_page.dart` | عرض محسن |
| `sales_orders_page.dart` | عرض محسن |
| `add_sales_order_page.dart` | عرض محسن |
| `sales_order_detail_page.dart` | عرض محسن |

---

## 9. المبادئ الصارمة للتنفيذ

### 9.1 ممنوع (القواعد الحمراء)

| # | القاعدة | السبب |
|---|--------|-------|
| ❌ | حذف أي عمود موجود | كسر التوافق مع البيانات القديمة |
| ❌ | تغيير اسم `stock` | 150+ مرجع في الكود |
| ❌ | تغيير اسم `quantity` في ProductBatches | 50+ مرجع |
| ❌ | تغيير API المستخدمة في الشاشات بدون adapter | كسر واجهة المستخدم |
| ❌ | تعديل الفواتير القديمة | مساس بالبيانات المحاسبية |
| ❌ | تعديل القيود المحاسبية | المساس بالدفاتر |
| ❌ | تعديل طريقة حساب COGS | حسابات حساسة |
| ❌ | تعديل حساب FIFO مباشرة | تقييم المخزون |
| ❌ | تعديل `TransactionEngine` API الواجهة | نقطة دخول واحدة |
| ❌ | تعديل `PostingEngine` | 10+ خدمة تستخدمه |

### 9.2 مسموح مع الحذر

| # | القاعدة | الشرط |
|---|--------|-------|
| ✅ | إضافة أعمدة جديدة (nullable) | بدون تعديل الحالي |
| ✅ | تعديل `formatForDisplay` | فقط تحسين العرض |
| ✅ | تعديل `formatInventoryBalance` | فقط تحسين العرض |
| ✅ | إضافة `StockDisplayAdapter` | بدون تغيير API القديم |
| ✅ | تعديل `packaging_engine.autoBreak` | مع feature flag |
| ✅ | إضافة دوال جديدة لـ `UnitConversionService` | بدون حذف القديمة |

---

## 10. خطة الاختبار

### 10.1 السيناريوهات المطلوب اختبارها

```
1.  شراء 10 Cartons (عامل 12) → 
    النظام يخزن 120 في stock, ويخزن unit=carton, qty=10 في batch
    
2.  بيع جملة 3 Cartons →
    خصم 36 من stock، عرض 3 Cartons في الفاتورة
    
3.  بيع تجزئة 1 Carton →
    خصم 12 من stock، عرض 1 Carton
    
4.  بيع بالحبة 5 Pieces →
    خصم 5 من stock (من batch موجود، بدون تكسير)
    
5.  مرتجع مبيعات 1 Carton →
    إرجاع 12 إلى stock و batch
    
6.  تحويل مخزون بين مستودعين →
    الحفاظ على سياق الوحدة
    
7.  جرد (stock take) →
    عرض كميات بالوحدات المناسبة
    
8.  إعادة حساب COGS →
    COGS صحيح = (الكمية الأساسية × costPrice)
    
9.  طباعة فاتورة →
    عرض Cartons + Pieces
    
10. FIFO →
    الباتشات القديمة تستهلك أولاً
    
11. الترقية من البيانات القديمة →
    البيانات بدون سياق وحدة تعمل
    
12. التعطيل المؤقت (feature flag off) →
    النظام يعمل كالسابق تماماً
```

### 10.2 أنواع الاختبارات المطلوبة

1. **Unit Tests**: لكل service و adapter
2. **Widget Tests**: للشاشات المعدلة
3. **Integration Tests**: لسيناريوهات البيع والشراء
4. **Regression Tests**: للتأكد من عدم كسر أي وظيفة حالية
5. **Performance Tests**: قياس سرعة FIFO مع/بدون الباتشات المكسورة
