# FIFO_REVIEW.md
## مراجعة شاملة لنظام FIFO والتسعير في المخزون

> تاريخ: 18 يوليو 2026 | المشروع: SystemMarket ERP/POS

---

## 1. كيف يعمل FIFO حالياً؟

### 1.1 مسار FIFO في البيع

```
بيع ← sale.warehouseId موجود؟
    ├── نعم: تحقق من warehouseStock عبر productsDao.getWarehouseStock()
    │         (مجموع كميات الباتشات في المستودع)
    │
    ├── لا: تحقق من product.stock
    │
    ثم:
    │
    ├── استدعاء packagingEngine.autoBreakIfNecessary()
    │   (يكسر الباتشات إذا كان المخزون لا يكفي بالقطع)
    │
    ├── إذا كان costingService موجود:
    │   └── costingService.getBatchesForSale(productId, quantity)
    │       │
    │       ├── يقرأ valuationMethod من product
    │       ├── FIFO: يفرز حسب (expiryDate NULL آخراً) ثم (expiryDate ASC) ثم (createdAt ASC)
    │       ├── LIFO: يفرز حسب (createdAt DESC)
    │       └── AVCO: متوسط التكلفة، ثم يفرز FIFO للاستهلاك
    │
    └── إذا لم يكن costingService موجود (fallback):
        └── FIFO مباشر في transaction_engine.dart:380-431
            └── يفرز حسب (expiryDate NULL آخراً) ثم (expiryDate ASC) ثم (createdAt ASC)
```

### 1.2 ترتيب FIFO الحالي

```dart
// من inventory_costing_service.dart:284-293
sortedBatches = List<ProductBatch>.from(productBatches)
  ..sort((a, b) {
    if (a.expiryDate == null && b.expiryDate == null) {
      return a.createdAt.compareTo(b.createdAt);       // ← تاريخ الإنشاء!
    }
    if (a.expiryDate == null) return 1;                 // بدون تاريخ ← آخراً
    if (b.expiryDate == null) return -1;
    return a.expiryDate!.compareTo(b.expiryDate!);      // تاريخ الانتهاء أولاً
  });

// من transaction_engine.dart:387-397 (fallback)
final batches = await (batchQuery
  ..orderBy([
    (b) => OrderingTerm(expression: b.expiryDate.isNull(), mode: OrderingMode.asc),
    (b) => OrderingTerm(expression: b.expiryDate, mode: OrderingMode.asc),
    (b) => OrderingTerm(expression: b.createdAt, mode: OrderingMode.asc),
  ]))
  .get();
```

---

## 2. تحليل سيناريو شراء وبيع

### 2.1 السيناريو الكامل

**المنتج**: صنف X  
**الوحدة الأساسية**: Piece  
**ProductUnits**: Carton (factor=12)

#### الخطوة 1: شراء 10 Cartons

```
PurchaseItems: quantity=10, unitFactor=12, quantityInBaseUnit=120

ProductBatches:
  BATCH-001:
    productId = X
    warehouseId = W1
    batchNumber = 'PUR-001'
    expiryDate = null (أو تاريخ محدد)
    quantity = 120       (10 × 12)
    initialQuantity = 120
    costPrice = 10.0     (تكلفة القطعة الواحدة)
    createdAt = T1

Products:
  stock = 120
  buyPrice = 10.0
```

#### الخطوة 2: بيع 5 Pieces

```
autoBreakIfNecessary: المخزون 120 ≥ 5 → لا داعي للتكسير

getBatchesForSale:
  BATCH-001: quantity=120, deduct=5, costPerUnit=10.0

ProductBatches:
  BATCH-001: quantity = 115

Products:
  stock = 115

COGS = 5 × 10.0 = 50.0
```

#### الخطوة 3: بيع 3 Pieces

```
autoBreakIfNecessary: المخزون 115 ≥ 3 → لا داعي للتكسير

getBatchesForSale:
  BATCH-001: quantity=115, deduct=3, costPerUnit=10.0

ProductBatches:
  BATCH-001: quantity = 112

Products:
  stock = 112

COGS = 3 × 10.0 = 30.0
```

#### الخطوة 4: بيع 1 Carton (12 Pieces)

```
autoBreakIfNecessary: المخزون 112 ≥ 12 → لا داعي للتكسير
  (ملاحظة: autoBreak يتحقق من availableBaseQty >= requiredQtyInBase)

getBatchesForSale:
  BATCH-001: quantity=112, deduct=12, costPerUnit=10.0

ProductBatches:
  BATCH-001: quantity = 100

Products:
  stock = 100

COGS = 12 × 10.0 = 120.0
```

#### الخطوة 5: بيع 7 Pieces

```
autoBreakIfNecessary: المخزون 100 ≥ 7 → لا داعي للتكسير

getBatchesForSale:
  BATCH-001: quantity=100, deduct=7, costPerUnit=10.0

ProductBatches:
  BATCH-001: quantity = 93

Products:
  stock = 93

COGS = 7 × 10.0 = 70.0
```

### 2.2 النتيجة النهائية

```
Products.stock = 93 Pieces
Batch.quantity = 93 Pieces

الحالة الفعلية (لا يمكن تمثيلها):
  7 Cartons × 12 = 84
  + 9 Pieces
  = 93 Pieces
  
لكن النظام يظهر: 93 Pieces
لا يمكن تمثيل: 7 Cartons + 9 Pieces
```

**الجواب**: **لا**، النظام الحالي لا يستطيع تمثيل 7 Cartons + 9 Pieces بدون Broken Batch. لأن التخزين يتم فقط بالوحدة الأساسية.

### 2.3 متى يتم تفعيل autoBreak؟

```dart
// packaging_engine.dart:37-91
Future<List<BreakResult>> autoBreakIfNecessary({
  required String productId,
  required String warehouseId,
  required Decimal requiredQtyInBase,
}) async {
  // فقط إذا كان المخزون < الكمية المطلوبة
  final availableBaseQty = await _getAvailableQuantity(productId, warehouseId);
  if (availableBaseQty >= requiredQtyInBase) return results;  // ← لا تكسير
  
  // وإلا: اكسر من العبوات الكبيرة
  ...
}
```

**مهم**: `autoBreak` يُفعل **فقط** إذا كان المخزون المتوفر أقل من الكمية المطلوبة. في السيناريو أعلاه، المخزون 120 ≥ الكمية المطلوبة 5/3/12/7 دائماً، لذا لا يحدث تكسير.

متى يحدث التكسير؟ عندما يكون:
- المخزون بالقطع لا يكفي، لكن توجد عبوات مغلقة (كراتين) يمكن تكسيرها
- مثال: المخزون 5 قطع، والمطلوب 10 قطع. يوجد كرتون (12 قطعة). يتم تكسير الكرتون.

---

## 3. تحليل BROKEN Batches في FIFO

### 3.1 هل BROKEN batches تدخل في FIFO؟

**نعم.** `getBatchesForSale()` يجلب **كل** الباتشات للمنتج، بما فيها BROKEN-*:

```dart
// inventory_costing_service.dart:231-235
final batches = await (_db.select(_db.productBatches)).get();
final productBatches = batches
  .where((b) => b.productId == productId && b.quantity > Decimal.zero)
  .toList();
```

لا يوجد filter يستبعد BROKEN batches.

### 3.2 هل createdAt يغير ترتيب الاستهلاك؟

**نعم، بشكل خطير.** 

عند تكسير batch:

```dart
// packaging_engine.dart:110-123
final newBatchId = const Uuid().v4();
await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
  id: Value(newBatchId),
  ...
  batchNumber: 'BROKEN-${batch.batchNumber}-${DateTime.now().millisecondsSinceEpoch}',
  quantity: Value(actualDeduction),
  costPrice: Value((batch.costPrice / packageSize) * actualDeduction),
  ...
));
```

**المشكلة**: `createdAt` للـ BROKEN batch = وقت التكسير (T2) وهو أحدث بكثير من الباتش الأصلي (T1).

في FIFO، عندما يكون للباتشين نفس expiryDate (كلاهما null مثلاً)، يتم الترتيب حسب createdAt:

```
FIFO Order بعد التكسير:
  1. BATCH-001 (الأقدم - createdAt = T1)
  2. BROKEN-BATCH-001-{timestamp} (الأحدث - createdAt = T2)
```

هذا صحيح! **BROKEN batch يظهر بعد الباتش الأصلي** لأنه أحدث. إذا كان لدينا batch واحد فقط، ترتيب FIFO صحيح.

### 3.3 متى يصبح FIFO خاطئاً؟

**السيناريو الخطير:**

1. شراء 10 Cartons (120 قطعة) ← BATCH-001 (T1)
2. شراء 5 Cartons (60 قطعة) ← BATCH-002 (T2)
3. بيع 100 قطعة ← تستهلك من BATCH-001 (FIFO صحيح)
4. الآن BATCH-001: 20 قطعة، BATCH-002: 60 قطعة
5. بيع 50 قطعة ← autoBreak يجد أن 20 قطعة فقط في BATCH-001
6. autoBreak يكسر BATCH-002 (60 قطعة) ← ينشئ BROKEN-BATCH-002 (T3)
7. **الآن FIFO يرى**:
   - BATCH-001: 20 قطعة (T1 - أقدم)
   - BATCH-002: 0 قطعة (مستهلك)
   - **BROKEN-BATCH-002: 10 قطعة (T3 - أحدث)**

**الترتيب صحيح!** BROKEN batch يأتي بعد BATCH-001 لأنه أحدث.

### 3.4 المشكلة الحقيقية: التقييم وليس الترتيب

BROKEN batch له `costPrice` مختلف:

```dart
// packaging_engine.dart:119
costPrice: Value((batch.costPrice / packageSize).toDecimal() * actualDeduction),
```

في المثال أعلاه:
- BATCH-002: costPrice = 8.0 (تكلفة القطعة)
- packageSize = 60 (الكمية المطلوب تكسيرها)
- BROKEN-BATCH-002: costPrice = (8.0 / 60) × 10 = 1.333

إذا قمنا بعملية بيع (10 قطع) بعد التكسير، سيتم استهلاك BATCH-001 أولاً (costPrice = 10.0)، ثم BROKEN-BATCH-002 (costPrice = 1.333).

**هل هذا صحيح؟** BATCH-002 كان سعره 8.0، لكن BROKEN منه أصبح سعره 1.333. هذا فرق كبير!

**التحليل**: 
- BROKEN-BATCH-002: `(8.0 / 60) × 10 = 1.333` لكل قطعة... 
- خطأ! يجب أن يكون `8.0` لكل قطعة (نفس سعر الباتش الأصلي).

**صيغة التكلفة الخاطئة:**

```dart
costPrice: Value(
  (batch.costPrice / packageSize)
    .toDecimal(scaleOnInfinitePrecision: 4) * 
  actualDeduction
),
```

حيث `actualDeduction` هي الكمية المقتطعة و `packageSize` هو حجم التكسير.

إذا كانت `packageSize = 60` و `actualDeduction = 10`:
- `(8.0 / 60) * 10 = 1.333` ← **خطأ!**

يجب أن تكون `8.0` (سعر القطعة كما هو).

**هذا خطأ محاسبي محتمل!**

### 3.5 تحليل الصيغة

لنفترض:
- لدينا كرتون (12 قطعة) بتكلفة 120.0 (10.0 للقطعة)
- packageSize = 12 (نكسر الكرتون كله)
- actualDeduction = 12

الحساب الحالي: `(10.0 / 12) × 12 = 10.0` ← صحيح!

لكن إذا كان:
- packageSize = 60 (نصف الكمية)
- actualDeduction = 5

الحساب الحالي: `(10.0 / 60) × 5 = 0.833` ← **خطأ!**

يجب: `10.0` (سعر القطعة ثابت).

**استنتاج**: الصيغة الحالية تعطي نتائج صحيحة فقط عندما `packageSize == actualDeduction`. في الحالات الأخرى، تحسب costPrice خطأً للـ BROKEN batch.

---

## 4. هل يمكن أن يحدث فساد محاسبي؟

### 4.1 سيناريو الفساد المحاسبي

1. شراء 5 Cartons (60 قطعة) بـ 600 (10.0 لكل قطعة)
2. بيع 10 قطع ← من الـ batch (COGS = 100)
3. autoBreak بسبب نقص بالقطع: يكسر 3 Cartons = 36 قطعة
4. BROKEN batch: costPrice = `(10.0 / 36) × 36 = 10.0` ← صحيح (لأن packageSize == actualDeduction)
5. بيع 20 قطعة: 10 من الباتش الأصلي + 10 من BROKEN ← COGS = (10 × 10.0) + (10 × 10.0) = 200.0

**في هذا السيناريو**: COGS صحيح لأن `packageSize == actualDeduction`.

### 4.2 سيناريو الفساد الفعلي

1. شراء 2 Cartons (24 قطعة) بـ 240 (10.0 للقطعة)
2. بيع 5 قطع ← batch = 19
3. بيع 7 قطع ← batch = 12
4. بيع 15 قطعة ← batch = 12، المطلوب 15
5. autoBreak: packageSize = 12, actualDeduction = 12
6. BROKEN batch costPrice = `(10.0 / 12) × 12 = 10.0` ← صحيح

**ما زال صحيحاً** لأن `packageSize == actualDeduction`.

لكن إذا:

1. شراء 5 Cartons (60 قطعة) بـ 480 (8.0 للقطعة)
2. بيع 10 قطع ← batch = 50
3. بيع 20 قطعة ← batch = 30
4. المطلوب 35 قطعة. الباتش 30.
5. autoBreak: الباتش التالي (BATCH-002, 60 قطعة, costPrice=9.0) cuan packageSize=60, actualDeduction=5
6. BROKEN batch costPrice = `(9.0 / 60) × 5 = 0.75` لكل قطعة ← **خطأ!**

الآن عند بيع 5 قطع من BROKEN: COGS = 5 × 0.75 = 3.75
الصحيح: COGS = 5 × 9.0 = 45.0

**الفرق = 41.25 → فساد محاسبي!**

### 4.3 ملخص أخطاء FIFO الحالية

| # | المشكلة | خطورة |
|---|--------|-------|
| 1 | BROKEN batches تُستهلك بعد الباتش الأصلي (FIFO ترتيب صحيح) | ✅ لا مشكلة |
| 2 | **costPrice للـ BROKEN batch محسوب بشكل خاطئ** (عند packageSize != actualDeduction) | **HIGH** |
| 3 | كثرة BROKEN batches تبطئ استعلامات FIFO | MEDIUM |
| 4 | BROKEN batches تظهر في التقارير مما يربك المستخدم | MEDIUM |
| 5 | الجرد يصبح مستحيلاً مع 100+ BROKEN batch | HIGH |
| 6 | الباتش المكسور لا يحتفظ بتاريخ الانتهاء الصحيح | LOW (ينسخ من الأصلي) |

---

## 5. تأثير autoBreak على COGS

### 5.1 متى يتصل autoBreak؟

في `transaction_engine.dart:334-339`:
```dart
// Auto-break packaging if necessary
await packagingEngine.autoBreakIfNecessary(
  productId: item.productId,
  warehouseId: sale.warehouseId ?? '',
  requiredQtyInBase: remainingToDeduct,
);
```

يتم استدعاؤه **قبل** خصم الكمية من الباتشات. هذا صحيح - نكسر أولاً ثم نخصم.

### 5.2 تدفق COGS مع autoBreak

```
autoBreak ← ينشئ BROKEN batches (ربما بتكلفة خاطئة)
    ↓
getBatchesForSale ← يقرأ الباتشات (بما فيها BROKEN)  
    ↓
يخصم من الباتشات بالترتيب (FIFO)
    ↓
saleCogs += deducted × costPerUnit  ← تكلفة خاطئة إذا BROKEN costPrice خطأ
    ↓
PostingEngine يسجل COGS في GL
```

### 5.3 التأثير على القيود المحاسبية

COGS يُسجل كقيد محاسبي:
```
COGS Account (5010)   100 Dr
Inventory Account (1040)  100 Cr
```

إذا كان COGS محسوباً بشكل خاطئ، القيد المحاسبي سيكون خاطئاً أيضاً.

---

## 6. مقارنة FIFO مع AVCO مع BROKEN batches

### 6.1 مع FIFO

- BROKEN batches تستهلك بعد الأصلية (ترتيب صحيح)
- costPrice للـ BROKEN قد يكون خاطئاً (حسب packageSize)

### 6.2 مع AVCO

- AVCO يحسب متوسط جميع الباتشات
- BROKEN batch بسعر مختلف سيؤثر على المتوسط

```dart
// packaging_engine.dart:173-181
Future<void> _postPackagingBreakGL(List<BreakResult> results, String productId) async {
  if (costingService != null) {
    final method = await costingService!.getProductValuationMethod(productId);
    if (method == InventoryValuationMethod.avco) {
      await costingService!.calculateAverageCost(productId);
    }
  }
}
```

النظام يحاول إعادة حساب AVCO بعد التكسير. لكن إذا كان costPrice للـ BROKEN batch خاطئاً، AVCO سيكون خاطئاً أيضاً.

---

## 7. التوصيات النهائية لـ FIFO

| # | التوصية | الأولوية |
|---|--------|---------|
| 1 | **إصلاح costPrice في PackagingEngine**: جعل سعر القطعة ثابتاً = `batch.costPrice` وليس `(batch.costPrice / packageSize) * actualDeduction` | **HIGH** |
| 2 | **تقليل autoBreak**: لا نكسر إلا إذا كان ضرورياً (المخزون أقل من المطلوب) | **HIGH** |
| 3 | **إضافة reservedQuantity** إلى ProductBatches بدلاً من إنشاء BROKEN batches | **HIGH** |
| 4 | **فلترة BROKEN batches** من بعض استعلامات FIFO (مثلاً: exclude من getInventoryValuation) | MEDIUM |
| 5 | **إعادة حساب AVCO** بعد كل تعديل على الباتشات | MEDIUM |
| 6 | **إضافة فحص سلامة** للمطابقة بين `sum(batch.quantity)` و `product.stock` | MEDIUM |
