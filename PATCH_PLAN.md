# PATCH_PLAN.md
## خطة التصحيحات التدريجية - وصف تفصيلي لكل Patch

> الإصدار: v1.0 | 18 يوليو 2026 | الهندسة: Hybrid Model (OPTION C)

---

## هيكل الـ Patches

```
PATCH-01: إصلاح costPrice في autoBreak ← {packaging_engine.dart}
PATCH-02: إضافة reservedQuantity إلى ProductBatches ← {DB + transaction_engine.dart}
PATCH-03: إضافة storedUnitId + StockDisplayAdapter ← {DB + adapter}
PATCH-04: تحسين عرض الكميات في الشاشات ← {39 شاشة}
PATCH-05: إهمال الأنظمة القديمة ← {services}
PATCH-06: التنظيف والاختبار النهائي ← {tests + scripts}
```

---

## PATCH-01: إصلاح costPrice في autoBreak

### الخطورة: 🔴 HIGH

### الوصف

إصلاح خطأ حسابي في `PackagingEngine._breakOnePackage()` حيث يتم حساب `costPrice` للـ BROKEN batch بشكل خاطئ عندما لا تتساوى `packageSize` مع `actualDeduction`.

### الملفات المتأثرة

| الملف | نوع التعديل |
|-------|------------|
| `lib/core/services/packaging_engine.dart` | تعديل |

### الكود قبل

```dart
// packaging_engine.dart:94-147
Future<BreakResult> _breakOnePackage({
  required ProductBatch batch,
  required Decimal packageSize,
  required String productId,
  required String warehouseId,
}) async {
  final actualDeduction =
      packageSize < batch.quantity ? packageSize : batch.quantity;
      
  // ❌ خطأ: costPrice يحسب بقسمة packageSize ثم ضرب actualDeduction
  final costPerUnit = (batch.costPrice * packageSize / packageSize)
      .toDecimal(scaleOnInfinitePrecision: 4);

  await (db.update(db.productBatches)..where((b) => b.id.equals(batch.id)))
      .write(ProductBatchesCompanion(
    quantity: Value(batch.quantity - actualDeduction),
  ));

  final newBatchId = const Uuid().v4();
  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: Value(newBatchId),
        productId: productId,
        warehouseId: warehouseId,
        batchNumber:
            'BROKEN-${batch.batchNumber}-${DateTime.now().millisecondsSinceEpoch}',
        quantity: Value(actualDeduction),
        initialQuantity: Value(actualDeduction),
        // ❌ costPrice خاطئ:
        costPrice: Value((batch.costPrice / packageSize)
                .toDecimal(scaleOnInfinitePrecision: 4) *
            actualDeduction),
        expiryDate: Value(batch.expiryDate),
      ));
  ...
}
```

### الكود بعد

```dart
// packaging_engine.dart:94-147 (معدّل)
Future<BreakResult> _breakOnePackage({
  required ProductBatch batch,
  required Decimal packageSize,
  required String productId,
  required String warehouseId,
}) async {
  final actualDeduction =
      packageSize < batch.quantity ? packageSize : batch.quantity;
      
  // ✅ صحيح: costPerUnit = سعر القطعة في الباتش الأصلي
  final costPerUnit = batch.costPrice;

  await (db.update(db.productBatches)..where((b) => b.id.equals(batch.id)))
      .write(ProductBatchesCompanion(
    quantity: Value(batch.quantity - actualDeduction),
  ));

  final newBatchId = const Uuid().v4();
  await db.into(db.productBatches).insert(ProductBatchesCompanion.insert(
        id: Value(newBatchId),
        productId: productId,
        warehouseId: warehouseId,
        batchNumber:
            'BROKEN-${batch.batchNumber}-${DateTime.now().millisecondsSinceEpoch}',
        quantity: Value(actualDeduction),
        initialQuantity: Value(actualDeduction),
        // ✅ صحيح: نفس costPrice للباتش الأصلي (تكلفة القطعة لا تتغير)
        costPrice: Value(batch.costPrice),
        expiryDate: Value(batch.expiryDate),
      ));
  ...
}
```

### سبب التعديل

`(batch.costPrice / packageSize) * actualDeduction` يعطي تكلفة القطعة الواحدة فقط عندما `packageSize == actualDeduction`. في حالة `packageSize > actualDeduction`، التكلفة المحسوبة أقل من الحقيقة.

مثال: batch.costPrice=10.0, packageSize=60, actualDeduction=5
- قبل: `(10.0 / 60) * 5 = 0.833` ← **خطأ**
- بعد: `10.0` ← **صحيح**

### التأثير على البيانات القديمة

- BROKEN batches الموجودة حالياً تحتوي على costPrice خاطئ
- لا نعدلها (لن نغير البيانات القديمة)
- الفرق صغير لأن معظم التكسيرات تكون packageSize == actualDeduction
- التصحيح سيطبق على التكسيرات الجديدة فقط

### اختبارات التحقق

```dart
test('costPrice في BROKEN batch يساوي costPrice الباتش الأصلي', () async {
  // شراء
  // بيع جزئي يسبب تكسير
  // التحقق: BROKEN batch.costPrice == original batch.costPrice
});
```

---

## PATCH-02: إضافة reservedQuantity إلى ProductBatches

### الخطورة: 🔴 HIGH

### الوصف

إضافة مفهوم "الكمية المحجوزة" إلى ProductBatches للسماح بالبيع الجزئي من الباتش دون إنشاء BROKEN batch جديد.

### الملفات المتأثرة

| الملف | التعديل |
|-------|---------|
| `lib/data/datasources/local/app_database.dart` | إضافة عمود `reservedQuantity` إلى ProductBatches |
| `lib/data/datasources/local/manual/schemas.dart` | إضافة عمود في الـ DDL اليدوي |
| `lib/data/datasources/local/manual/entities.dart` | إضافة حقل `reservedQuantity` |
| `lib/data/datasources/local/app_database.g.dart` | إعادة توليد (build_runner) |
| `lib/core/services/transaction_engine.dart` | تعديل postSale لاستخدام reservedQuantity |
| `lib/core/services/packaging_engine.dart` | تعديل autoBreak لقراءة availableQuantity |
| `lib/core/services/inventory_costing_service.dart` | استخدام availableQuantity في FIFO |
| `lib/data/datasources/local/daos/products_dao.dart` | دعم reservedQuantity |
| `lib/data/datasources/local/manual/daos/inventory_dao.dart` | دعم reservedQuantity |

### 1. تعديل app_database.dart

```dart
// ProductBatches table - إضافة حقل جديد
@DataClassName('ProductBatch')
class ProductBatches extends Table with SyncableTable {
  // ... الحقول الحالية (لا تغيير)
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get batchNumber => text()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get initialQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get costPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  
  // ✅ إضافة جديدة - كمية محجوزة (لم يتم ترحيلها بعد)
  TextColumn get reservedQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}
```

### 2. تعديل manual/entities.dart

```dart
class ProductBatch {
  // ... الحقول الحالية
  final Decimal quantity;
  final Decimal initialQuantity;
  final Decimal costPrice;
  
  // ✅ حقل جديد
  final Decimal reservedQuantity;
  
  ProductBatch.fromMap(Map<String, dynamic> m) :
    // ... الحقول الحالية
    quantity = _d(m['quantity']),
    initialQuantity = _d(m['initial_quantity']),
    costPrice = _d(m['cost_price']),
    // ✅ حقل جديد مع fallback للبيانات القديمة
    reservedQuantity = _d(m['reserved_quantity']);
}
```

### 3. تعديل transaction_engine.dart (الجزء الأهم)

```dart
// في postSale - عند بيع الأصناف
// بدلاً من autoBreak + خصم مباشر، نستخدم reservedQuantity:

// 1. التحقق من المخزون المتاح (مع مراعاة المحجوز)
for (var item in items) {
  Decimal remainingToDeduct = item.quantity * item.unitFactor;
  
  // التحقق من المخزون المتاح (quantity - reservedQuantity)
  final batches = await getBatchesWithAvailable(item.productId, sale.warehouseId);
  final totalAvailable = batches.fold<Decimal>(
    Decimal.zero, 
    (sum, b) => sum + (b.quantity - b.reservedQuantity)
  );
  
  if (totalAvailable < remainingToDeduct) {
    // نحاول تكسير العبوات
    await packagingEngine.autoBreakIfNecessary(...);
    // نعيد التحقق
  }
  
  // 2. حجز الكمية (بدلاً من الخصم المباشر)
  // reservedQuantity تزداد، quantity لم تتغير
  for (var batch in batches) {
    if (remainingToDeduct <= Decimal.zero) break;
    final available = batch.quantity - batch.reservedQuantity;
    final deduct = min(available, remainingToDeduct);
    
    await (db.update(db.productBatches)
      ..where((b) => b.id.equals(batch.id)))
      .write(ProductBatchesCompanion(
        reservedQuantity: Value(batch.reservedQuantity + deduct),
      ));
    
    remainingToDeduct -= deduct;
    saleCogs += deduct * batch.costPrice;
  }
}

// عند الترحيل الفعلي (end of transaction):
// تحويل reservedQuantity → خصم من quantity
for (var batch in affectedBatches) {
  await (db.update(db.productBatches)
    ..where((b) => b.id.equals(batch.id)))
    .write(ProductBatchesCompanion(
      quantity: Value(batch.quantity - batch.reservedQuantity),
      reservedQuantity: Value(Decimal.zero),
    ));
}
```

### 4. تعديل inventory_costing_service.dart

```dart
// getBatchesForSale: استخدام availableQuantity
Future<List<BatchWithCost>> getBatchesForSale(
    String productId, Decimal quantity) async {
  final batches = await (_db.select(_db.productBatches)).get();
  
  // استخدام (quantity - reservedQuantity) بدلاً من quantity فقط
  final productBatches = batches
      .where((b) => b.productId == productId && 
             (b.quantity - b.reservedQuantity) > Decimal.zero)
      .toList();
  
  // ... باقي FIFO (نفس الترتيب)
  for (var batch in sortedBatches) {
    final available = batch.quantity - batch.reservedQuantity;
    if (available <= Decimal.zero) continue;
    
    final deduct = remaining > available ? available : remaining;
    result.add(BatchWithCost(
      batch: batch,
      remainingQuantity: deduct,
      costPerUnit: batch.costPrice,
    ));
    remaining -= deduct;
  }
}
```

### سبب التعديل

إلغاء الحاجة لإنشاء BROKEN batches عند البيع الجزئي. الكمية المحجوزة تُخصم فعلياً فقط عند الترحيل (post).

### التأثير على البيانات القديمة

- الأعمدة الجديدة nullable → البيانات القديمة تعمل
- BROKEN batches القديمة تبقى كما هي

### اختبارات التحقق

```dart
test('reservedQuantity يسمح بالبيع الجزئي بدون تكسير', () async {
  // شراء 10 Cartons (120 قطعة)
  // بيع 5 قطع → reservedQuantity = 5, quantity = 120
  // بيع 3 قطع → reservedQuantity = 8, quantity = 120
  // post → quantity = 112, reservedQuantity = 0
  // sum(batches) == product.stock ✅
});

test('availableQuantity = quantity - reservedQuantity', () async {
  // ...
});

test('FIFO مع reservedQuantity: الباتشات المحجوزة لا تُستهلك مرتين', () async {
  // ...
});
```

---

## PATCH-03: إضافة storedUnitId + StockDisplayAdapter

### الخطورة: 🟡 MEDIUM

### الوصف

إضافة سياق الوحدة (unit of measure context) إلى ProductBatches للحفاظ على معلومات وحدة التخزين الأصلية، وإنشاء طبقة عرض ذكية للكميات.

### الملفات المتأثرة

| الملف | التعديل |
|-------|---------|
| `lib/data/datasources/local/app_database.dart` | إضافة storedUnitId, quantityInStoredUnit |
| `lib/data/datasources/local/manual/schemas.dart` | إضافة الأعمدة |
| `lib/data/datasources/local/manual/entities.dart` | إضافة الحقول |
| **`lib/core/utils/stock_display_adapter.dart`** | **ملف جديد** |
| `lib/core/services/transaction_engine.dart` | تسجيل سياق الوحدة في postPurchase |
| `lib/core/services/grn_service.dart` | تسجيل سياق الوحدة |
| `lib/core/services/packaging_engine.dart` | الحفاظ على سياق الوحدة عند التكسير |
| `lib/core/services/inventory_display_service.dart` | استخدام adapter |
| `lib/data/datasources/local/daos/products_dao.dart` | دوال جديدة للعرض |

### 1. الملف الجديد: stock_display_adapter.dart

```dart
// lib/core/utils/stock_display_adapter.dart

import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

/// محول عرض المخزون - يحول الكميات المخزنة بالوحدة الأساسية
/// إلى نصوص مفهومة للعرض (مثل "7 كرتون + 9 حبة")
class StockDisplayAdapter {
  final AppDatabase _db;
  
  StockDisplayAdapter(this._db);

  /// تنسيق كمية batch للعرض
  /// 
  /// [batch] الباتش المراد عرضه
  /// [productUnits] قائمة الوحدات (اختياري - إذا كانت محملة مسبقاً)
  Future<String> formatBatchDisplay(
    ProductBatch batch, {
    List<ProductUnit>? productUnits,
  }) async {
    if (batch.storedUnitId == null || batch.quantityInStoredUnit == null) {
      return '${batch.quantity.toStringAsFixed(0)} حبة';
    }

    final units = productUnits ?? await _getProductUnits(batch.productId);
    final storedUnit = units.where((u) => u.id == batch.storedUnitId).firstOrNull;
    if (storedUnit == null) {
      return '${batch.quantity.toStringAsFixed(0)} حبة';
    }

    final storedQty = batch.quantityInStoredUnit!;
    final wholeUnits = storedQty.truncate();
    final remainder = ((storedQty - wholeUnits) * storedUnit.unitFactor)
        .toDecimal(scaleOnInfinitePrecision: 0);

    if (remainder > Decimal.zero) {
      return '${wholeUnits.toStringAsFixed(0)} ${storedUnit.unitName} + ${remainder.toStringAsFixed(0)} حبة';
    }
    return '${wholeUnits.toStringAsFixed(0)} ${storedUnit.unitName}';
  }

  /// تنسيق إجمالي المخزون (product.stock) للعرض
  Future<String> formatProductStock(
    Product product, {
    String? preferredUnitId,
    List<ProductUnit>? productUnits,
  }) async {
    if (product.stock <= Decimal.zero) {
      return '0 حبة';
    }

    final units = productUnits ?? await _getProductUnits(product.id);
    if (units.isEmpty) {
      return '${product.stock.toStringAsFixed(0)} ${product.unit}';
    }

    // استخدم الوحدة المفضلة (أو أكبر وحدة تناسب الكمية)
    final bestUnit = _findBestUnit(units, product.stock, preferredUnitId);
    if (bestUnit == null) {
      return '${product.stock.toStringAsFixed(0)} حبة';
    }

    final unitQty = (product.stock / bestUnit.unitFactor)
        .toDecimal(scaleOnInfinitePrecision: 1);
    final wholeUnits = unitQty.truncate();
    final remainder = ((unitQty - wholeUnits) * bestUnit.unitFactor)
        .toDecimal(scaleOnInfinitePrecision: 0);

    if (remainder > Decimal.zero) {
      return '${wholeUnits} ${bestUnit.unitName} + ${remainder} حبة';
    }
    return '${wholeUnits} ${bestUnit.unitName}';
  }

  /// البحث عن أفضل وحدة للعرض
  ProductUnit? _findBestUnit(
    List<ProductUnit> units, 
    Decimal baseQty, 
    String? preferredUnitId
  ) {
    // الوحدة المفضلة لها الأولوية
    if (preferredUnitId != null) {
      final preferred = units.where((u) => u.id == preferredUnitId).firstOrNull;
      if (preferred != null && preferred.unitFactor <= baseQty) return preferred;
    }

    // أكبر وحدة تناسب الكمية
    ProductUnit? best;
    for (var unit in units) {
      if (unit.unitFactor > Decimal.one && unit.unitFactor <= baseQty) {
        if (best == null || unit.unitFactor > best.unitFactor) {
          best = unit;
        }
      }
    }
    return best;
  }

  Future<List<ProductUnit>> _getProductUnits(String productId) async {
    return (_db.select(_db.productUnits)
          ..where((u) => u.productId.equals(productId))
          ..orderBy([(u) => OrderingTerm(
            expression: u.unitFactor, mode: OrderingMode.asc)]))
        .get();
  }
}
```

### 2. تعديل transaction_engine.dart (postPurchase)

```dart
// في postPurchase، بعد إنشاء الباتش:
// تسجيل سياق الوحدة

for (var item in items) {
  Decimal qtyInBaseUnit = item.quantity * item.unitFactor;
  
  final batchId = const Uuid().v4();
  
  // تحديد storedUnitId
  String? storedUnitId;
  if (item.unitId != null && item.unitId!.isNotEmpty) {
    storedUnitId = item.unitId;
  } else if (item.unitFactor > Decimal.one) {
    // البحث عن ProductUnit المطابق
    final productUnits = await productUnitsDao.getUnitsForProduct(item.productId);
    final matchingUnit = productUnits.where(
      (u) => (u.unitFactor - item.unitFactor).abs() < Decimal.parse('0.001')
    ).firstOrNull;
    storedUnitId = matchingUnit?.id;
  }
  
  await db.into(db.productBatches).insert(
    ProductBatchesCompanion.insert(
      id: Value(batchId),
      productId: item.productId,
      warehouseId: purchase.warehouseId ?? '',
      batchNumber: ...,
      quantity: Value(qtyInBaseUnit),
      initialQuantity: Value(qtyInBaseUnit),
      costPrice: Value((finalUnitCost / item.unitFactor).toDecimal()),
      // ✅ جديد
      storedUnitId: Value(storedUnitId),
      quantityInStoredUnit: Value(item.quantity),
    ),
  );
}
```

### سبب التعديل

بدون `storedUnitId` و `quantityInStoredUnit`، كل batch يظهر كعدد من القطع دون سياق. هذا يمنع النظام من عرض "7 Cartons + 9 Pieces" بشكل صحيح.

### التأثير على البيانات القديمة

- البيانات القديمة: storedUnitId = NULL, quantityInStoredUnit = NULL
- StockDisplayAdapter يتعامل مع NULL بشكل طبيعي (يعرض "X حبة")

---

## PATCH-04: تحسين عرض الكميات في الشاشات

### الخطورة: 🟡 MEDIUM

### الوصف

استبدال `product.stock.toString()` المباشر في جميع الشاشات بـ StockDisplayAdapter.formatProductStock().

### الملفات المتأثرة (39 ملفاً)

**المجموعة 1 - HIGH (15 ملفاً):**

| الملف | السطر | قبل | بعد |
|-------|-------|-----|-----|
| `pos_product_card.dart` | 70 | `product.stock.toString()` | `adapter.formatProductStock(product)` |
| `pos_bloc.dart` | 492 | `product.stock <= Decimal.zero` | يبقى كما هو (logic) |
| `pos_bloc.dart` | 563 | `product.stock.toString()` | `adapter.formatProductStock(product)` |
| `cart_widget.dart` | (متعدد) | `product.stock` | `adapter.formatProductStock(product)` |
| `sales_invoice_page.dart` | (متعدد) | `item.quantity` | `adapter.formatBatchDisplay(batch)` |
| `stock_take_page.dart` | 585 | `product.stock` | `adapter.formatProductStock(product)` |
| `stock_take_page.dart` | 587 | `actual - product.stock` | يبقى كما هو (logic) |
| `low_stock_alert_page.dart` | (متعدد) | `product.stock` | `adapter.formatProductStock(product)` |
| `smart_stock_widget.dart` | 28 | `Quantity(product.stock)` | `adapter.formatProductStock(product)` |
| `product_card.dart` | 51 | `product.stock` | `adapter.formatProductStock(product)` |
| `inventory_report_service.dart` | (متعدد) | batch.quantity | `adapter.formatBatchDisplay(batch)` |
| `notification_service.dart` | 152 | `product.stock` | `adapter.formatProductStock(product)` |
| `beginning_of_period_page.dart` | 67 | `product.stock.toString()` | `adapter.formatProductStock(product)` |
| `purchase_provider.dart` | 184 | `product.stock` | يبقى كما هو (validation) |
| `notification_service.dart` | 201 | `batch.quantity` | `adapter.formatBatchDisplay(batch)` |

**المجموعة 2 - MEDIUM (15 ملفاً):**

`low_stock_products_page.dart`, `purchase_item_row.dart`, `purchase_details_page.dart`, 
`item_movement_detail_page.dart`, `inventory_value_report.dart`, `low_stock_report.dart`,
`product_batches_report.dart`, `inventory_transactions_report.dart`, `sales_item_row.dart`,
`sale_details_bottom_sheet.dart`, `sales_orders_page.dart`, `add_sales_order_page.dart`,
`sales_order_detail_page.dart`, `dashboard_service.dart`, `chart_service.dart`

**المجموعة 3 - LOW (9 ملفاً):**

`report_engine_service.dart`, `export_service.dart`, `rest_api_service.dart`,
`data_import_service.dart`, `erp_data_service.dart`, `profitability_service.dart`,
`dashbaord_page.dart`, `home_page.dart`, `products_page.dart`

### مثال تعديل

**قبل** (pos_product_card.dart):
```dart
future: packagingEngine.formatInventoryBalance(product.id, product.stock),
```

**بعد**:
```dart
future: StockDisplayAdapter(db).formatProductStock(product),
```

### سبب التعديل

عرض الكميات بشكل مفهوم للمستخدم بدلاً من الأرقام المجردة.

---

## PATCH-05: إهمال الأنظمة القديمة

### الخطورة: 🟢 LOW

### الوصف

إيقاف استخدام الأنظمة القديمة للوحدات وتوحيدها على ProductUnits.

### الملفات المتأثرة

| الملف | التعديل |
|-------|---------|
| `lib/core/utils/erp_logic.dart` | إزالة useIsCarton/piecesPerCarton |
| `lib/presentation/features/purchases/purchase_provider.dart` | إزالة isCarton |
| `lib/presentation/features/purchases/add_purchase_page.dart` | استخدام ProductUnits بدلاً من isCarton |
| `lib/core/services/unit_conversion_service.dart` | إضافة دالة convertProductUnits |
| `lib/core/services/auto_break_service.dart` | استخدام ProductUnits فقط |

### سبب التعديل

3 أنظمة متوازية للوحدات يسبب ارتباكاً. التوحيد على ProductUnits يبسط الصيانة.

### التأثير

- `UnitConversions` جدول = يبقى ولا يُستخدم
- `Products.cartonUnit` = يبقى ولا يُستخدم  
- `Products.piecesPerCarton` = يبقى ولا يُستخدم
- `PurchaseItems.isCarton` = يبقى ولا يُستخدم

---

## PATCH-06: التنظيف والاختبار النهائي

### الخطورة: 🟡 MEDIUM

### الوصف

اختبار شامل + تنظيف BROKEN batches القديمة.

### ملفات الاختبار الجديدة

| الملف | الغرض |
|-------|-------|
| `test/unit/reserved_quantity_test.dart` | اختبار reservedQuantity |
| `test/unit/stock_display_adapter_test.dart` | اختبار adapter |
| `test/unit/packaging_engine_cost_test.dart` | اختبار costPrice |
| `test/integration/multi_unit_flow_test.dart` | اختبار شامل للوحدات |

### سيناريو الاختبار الشامل

```dart
test('السيناريو الكامل للوحدات المتعددة', () async {
  // 1. شراء 10 Cartons (factor=12) بـ 1200 (10.0 للقطعة)
  //    التحقق: product.stock == 120
  //    batch.quantity == 120
  //    batch.storedUnitId != null
  //    batch.quantityInStoredUnit == 10
  
  // 2. بيع 5 Pieces
  //    التحقق: reservedQuantity == 5, batch.quantity == 120
  //    COGS == 50
  
  // 3. بيع 3 Pieces
  //    التحقق: reservedQuantity == 8, batch.quantity == 120
  
  // 4. بيع 1 Carton (12 Pieces)  
  //    التحقق: reservedQuantity == 20, batch.quantity == 120
  
  // 5. بيع 7 Pieces
  //    التحقق: reservedQuantity == 27, batch.quantity == 120
  
  // 6. Post (ترحيل الفاتورة)
  //    التحقق: batch.quantity == 93, reservedQuantity == 0
  //    product.stock == 93
  //    COGS == 27 × 10 = 270
  
  // 7. مرتجع 1 Carton
  //    التحقق: batch.quantity == 105
  
  // 8. جرد
  //    sum(batch.quantity) == product.stock ✅
  
  // 9. التحقق من FIFO
  //    batches تستهلك حسب createdAt (الأقدم أولاً)
  
  // 10. التحقق من العرض
  //     StockDisplayAdapter.formatProductStock → "7 كرتون + 9 حبة"
});
```

### Script تنظيف BROKEN batches

```sql
-- 1. إعادة الكميات من BROKEN batches إلى الباتشات الأصلية
UPDATE product_batches AS original
SET quantity = CAST(original.quantity AS REAL) + (
  SELECT COALESCE(SUM(CAST(broken.quantity AS REAL)), 0)
  FROM product_batches AS broken
  WHERE broken.batch_number LIKE 'BROKEN-' || original.batch_number || '-%'
    AND broken.product_id = original.product_id
    AND broken.warehouse_id = original.warehouse_id
)
WHERE original.batch_number NOT LIKE 'BROKEN-%';

-- 2. حذف BROKEN batches
DELETE FROM product_batches
WHERE batch_number LIKE 'BROKEN-%';

-- 3. التحقق من صحة البيانات
-- product.stock == SUM(batch.quantity) لكل منتج
```

---

## ملخص تنفيذ الأوامر

```
PATCH-01: git commit -m "fix(core): إصلاح costPrice في packaging engine"
PATCH-02: git commit -m "feat(core): إضافة reservedQuantity إلى ProductBatches"
PATCH-03: git commit -m "feat(core): إضافة storedUnitId + StockDisplayAdapter"
PATCH-04: git commit -m "feat(ui): تحسين عرض الكميات في جميع الشاشات"
PATCH-05: git commit -m "refactor(core): إهمال أنظمة الوحدات القديمة"
PATCH-06: git commit -m "test: اختبار شامل + تنظيف BROKEN batches"
```

**ملاحظة**: كل commit قابل للتراجع بشكل مستقل. الأعمدة الجديدة nullable. البيانات القديمة محفوظة.
