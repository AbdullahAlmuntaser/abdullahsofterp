# DEPENDENCY_MAP.md
## خريطة التبعيات الكاملة لنظام المخزون

> إصدار: v1.0 | التاريخ: 18 يوليو 2026 | المشروع: SystemMarket ERP/POS

---

## 1. خريطة تبعيات `product.stock`

### 1.1 مسار القراءة (READ)

```
Products.stock
    ├── transaction_engine.dart:199,376,429,601,733      (WRITE)
    ├── stock_operation_service.dart:34,199-208           (READ/WRITE)
    ├── packaging_engine.dart:183-221                     (READ/UI)
    ├── return_service.dart:54-64,216-227                 (READ/WRITE)
    ├── grn_service.dart:103                              (WRITE)
    ├── delivery_notes_service.dart:119                   (WRITE)
    ├── credit_note_service.dart:114                      (WRITE)
    ├── production_service.dart: (متعدد)                  (WRITE)
    ├── reorder_service.dart:49,63                        (READ/CALC)
    ├── report_engine_service.dart:263-265                (READ)
    ├── chart_service.dart:47,73,125                      (READ)
    ├── export_service.dart:189,305                       (READ)
    ├── system_auditor.dart:22-23                         (READ)
    ├── inventory_reservation_service.dart:67             (READ)
    ├── notification_service.dart:152                     (READ/UI)
    ├── dashboard_service.dart:274                        (READ)
    ├── rest_api_service.dart:69,100,113                  (READ/WRITE)
    ├── data_import_service.dart: (متعدد)                 (WRITE)
    ├── pos_bloc.dart:492,563-568                         (READ/LO)
    ├── pos_product_card.dart:69-73,78                    (UI)
    ├── smart_stock_widget.dart:28                        (UI)
    ├── product_card.dart:51                              (UI)
    ├── low_stock_products_page.dart:36                   (UI)
    ├── low_stock_report.dart:54                          (UI)
    ├── stock_take_page.dart:585-587                      (WRITE)
    ├── beginning_of_period_page.dart:67,343-348          (READ/WRITE)
    ├── purchase_provider.dart:184,351,366                (READ/WRITE)
    ├── sales_invoice_page.dart: (متعدد)                  (READ)
    ├── sales_orders_page.dart:495                        (UI)
    ├── financial_control_service.dart:72                 (LO)
    ├── profitability_service.dart:53                     (CALC)
    ├── erp_data_service.dart:77                          (READ)
    ├── proforma_service.dart:26                          (CALC)
    ├── invoice_service.dart:158                          (UI)
    ├── thermal_printer_service.dart:151                  (UI)
    └── unit_conversion_service.dart: (ضمني)              (CALC)
```

**المجموع: 45 ملفاً يعتمدون على product.stock**

### 1.2 نقاط الكتابة (WRITE) - الأكثر خطورة

| # | الملف | السطر | السياق | التصنيف |
|---|-------|-------|--------|---------|
| 1 | `transaction_engine.dart` | 199 | `stock: Value(product.stock + qtyInBaseUnit)` (شراء) | **CRITICAL** |
| 2 | `transaction_engine.dart` | 376 | `stock: Value(product.stock - totalDeducted)` (بيع مع costing) | **CRITICAL** |
| 3 | `transaction_engine.dart` | 429 | `stock: Value(product.stock - totalDeducted)` (بيع بدون costing) | **CRITICAL** |
| 4 | `transaction_engine.dart` | 601 | `stock: Value(product.stock + returnQty)` (مرتجع بيع) | **CRITICAL** |
| 5 | `transaction_engine.dart` | 733 | `stock: Value(product.stock - item.quantity)` (مرتجع شراء) | **CRITICAL** |
| 6 | `stock_operation_service.dart` | 50 | `stock: Value(actualStockDecimal)` (جرد) | **HIGH** |
| 7 | `stock_operation_service.dart` | 208 | `stock: Value(newStock)` (خصم مباشر) | **HIGH** |
| 8 | `return_service.dart` | 62-64 | `stock: Value(product.stock + ...)` (مرتجع يدوي) | **HIGH** |
| 9 | `return_service.dart` | 224-226 | `stock: Value(product.stock - ...)` (مرتجع مشتريات يدوي) | **HIGH** |
| 10 | `grn_service.dart` | 103 | `stock: Value(product.stock + ...)` (استلام بضاعة) | **HIGH** |
| 11 | `delivery_notes_service.dart` | 119 | `stock: Value(product.stock - ...)` (توصيل) | **HIGH** |
| 12 | `credit_note_service.dart` | 114 | `stock: Value(product.stock + ...)` (إشعار دائن) | **HIGH** |
| 13 | `beginning_of_period_page.dart` | 348 | `stock: Value(newQty)` (بداية فترة) | **HIGH** |
| 14 | `financial_control_service.dart` | 349 | `stock: Value(...)` (رقابة مالية) | **MEDIUM** |

---

## 2. خريطة تبعيات `ProductBatches.quantity`

### 2.1 كل الملفات

```
ProductBatches.quantity
    ├── transaction_engine.dart:170,356,401-409,555-559,707-713    (WRITE)
    ├── stock_operation_service.dart:54-85                          (WRITE)
    ├── packaging_engine.dart:70-107, 157                           (WRITE/RD)
    ├── inventory_costing_service.dart:75-93,229-310,363-376        (READ/CALC)
    ├── products_dao.dart:56-68,367-378                             (READ)
    ├── inventory_dao.dart (manual):46-53,187-198                   (READ)
    ├── return_service.dart:69-87,231-253                           (WRITE)
    ├── stock_transfer_service.dart:47-108                          (WRITE)
    ├── production_service.dart:64-76                               (WRITE)
    ├── bom_service.dart:127,180                                    (WRITE)
    ├── manufacturing_service.dart:161-184,318                      (WRITE)
    ├── auto_break_service.dart:221-258                             (READ)
    ├── system_auditor.dart:22                                      (READ)
    ├── report_engine_service.dart: (ضمني)                          (READ)
    ├── notification_service.dart:192-201                           (READ/UI)
    ├── inventory_report_service.dart:51-89                         (READ)
    ├── rest_api_service.dart:157                                   (READ)
    ├── pos_bloc.dart: (ضمني)                                       (READ)
    └── stock_take_page.dart: (ضمني)                                (READ)
```

**المجموع: 20 ملفاً يعتمدون على batch.quantity**

### 2.2 نقاط الكتابة - الأكثر خطورة

| # | الملف | السطر | الوصف | خطورة |
|---|-------|-------|-------|-------|
| 1 | `transaction_engine.dart` | 170 | إضافة batch (شراء) | **CRITICAL** |
| 2 | `transaction_engine.dart` | 356-409 | خصم من batch (بيع) | **CRITICAL** |
| 3 | `transaction_engine.dart` | 555-559 | إضافة إلى batch (مرتجع) | **CRITICAL** |
| 4 | `transaction_engine.dart` | 707-713 | خصم من batch (مرتجع شراء) | **CRITICAL** |
| 5 | `packaging_engine.dart` | 107-123 | تكسير batch (إنشاء BROKEN) | **HIGH** |
| 6 | `stock_operation_service.dart` | 74-79, 91-101 | تعديل batch (جرد) | **HIGH** |

---

## 3. خريطة تبعيات `unitFactor`

### 3.1 كل الملفات

```
unitFactor (ProductUnits.unitFactor + SaleItems.unitFactor + PurchaseItems.unitFactor)
    ├── transaction_engine.dart:157,173,313                         (CALC)
    ├── packaging_engine.dart:32,54-56,65,73,203-214               (CALC/LO)
    ├── inventory_display_service.dart:86-88,121,175-203            (CALC/UI)
    ├── auto_break_service.dart:65,85-89,98,122                    (CALC/LO)
    ├── unit_conversion_service.dart:34,55,98                      (CALC)
    ├── pos_bloc.dart:474-475,513-514,533-534,563-568,592-659      (CALC/LO)
    ├── sales_invoice_page.dart:984-994                             (CALC)
    ├── purchase_provider.dart:244-245,594                          (WRITE)
    ├── grn_service.dart:70-71                                      (CALC)
    ├── proforma_service.dart:26,59-60                              (CALC)
    ├── financial_control_service.dart:349                          (CALC)
    ├── profitability_service.dart:53                               (CALC)
    ├── purchase_item_row.dart:250-252                              (CALC/UI)
    ├── cart_widget.dart:414-416,461-468,501-512                    (LO/UI)
    └── products_dao.dart: (ضمني)                                   (READ)
```

**المجموع: 15 ملفاً يعتمدون على unitFactor**

---

## 4. خريطة تبعيات `costPrice` / `buyPrice`

```
costPrice + buyPrice
    ├── transaction_engine.dart:173,200,593                         (WRITE/CALC)
    ├── packaging_engine.dart:102,119                               (CALC)
    ├── stock_operation_service.dart:84,90,101,105                  (CALC)
    ├── inventory_costing_service.dart:87,130,170,211,245,305       (CALC)
    ├── return_service.dart:86,242-253                              (CALC)
    ├── report_engine_service.dart:102,263                          (CALC)
    ├── chart_service.dart:125                                      (CALC)
    ├── dashboard_service.dart:274                                  (CALC)
    ├── purchase_provider.dart:193,492-512,592,616-621              (CALC/UI)
    ├── add_edit_product_dialog.dart:272-330                        (WRITE)
    ├── quick_product_add_dialog.dart:47-62                         (WRITE)
    ├── beginning_of_period_page.dart:70,343-348                    (WRITE)
    ├── data_import_service.dart:155-161                            (WRITE)
    ├── export_service.dart:42,189-195,305                          (READ)
    ├── rest_api_service.dart:66,100                                (READ/WRITE)
    ├── erp_data_service.dart:77                                    (READ)
    ├── profitability_service.dart:53                               (CALC)
    ├── production_service.dart:90                                  (CALC)
    ├── bom_service.dart:205                                        (CALC)
    └── manufacturing_service.dart:161,184,271,341                  (CALC)
```

**المجموع: 20 ملفاً يعتمدون على costPrice/buyPrice**

---

## 5. خريطة تبعيات المحركات (Engines)

### 5.1 TransactionEngine

```
TransactionEngine
    ├── يستخدمه:
    │   ├── purchase_service.dart:51               (شراء)
    │   ├── sales_service.dart:26                  (بيع)
    │   ├── sales_invoice_page.dart (ضمني)         (شاشة)
    │   └── test files (متعدد)                     (اختبارات)
    │
    ├── يعتمد على:
    │   ├── PostingEngine                          (قيود محاسبية)
    │   ├── PackagingEngine                        (تكسير العبوات)
    │   ├── InventoryCostingService                (تقييم FIFO)
    │   ├── AppConfigService                       (إعدادات)
    │   ├── AuditService                           (تدقيق)
    │   └── EventBusService                        (أحداث)
    │
    └── يعدل:
        ├── Products.stock                         (5 نقاط)
        ├── ProductBatches.quantity                (6 نقاط)
        ├── PurchaseItems.batchId                  (1 نقطة)
        ├── InventoryTransactions                  (3 نقاط)
        ├── GLEntries/GLLines                      (عبر PostingEngine)
        └── Suppliers/Customers.balance            (2 نقطة)
```

### 5.2 PackagingEngine

```
PackagingEngine
    ├── يستخدمه:
    │   ├── TransactionEngine (ضمن postSale)       (CRITICAL)
    │   ├── AutoBreakService                       (ثانوي)
    │   └── pos_product_card.dart                  (UI فقط)
    │
    ├── يعتمد على:
    │   ├── ProductUnits (unitFactor, unitName)    (قراءة)
    │   ├── ProductBatches (quantity, costPrice)   (قراءة/كتابة)
    │   └── InventoryCostingService (اختياري)      (AVCO)
    │
    └── يعدل:
        ├── ProductBatches.quantity                (نقص من المصدر)
        ├── ProductBatches (إضافة BROKEN batch)    (إنشاء جديد)
        └── InventoryTransactions (PACKAGE_BREAK)  (تسجيل)
```

### 5.3 InventoryCostingService

```
InventoryCostingService
    ├── يستخدمه:
    │   ├── TransactionEngine                      (FIFO للبيع)
    │   ├── PackagingEngine                        (AVCO بعد التكسير)
    │   ├── PurchaseService                        (تقييم)
    │   └── ERPDataService / تقارير                (قراءة)
    │
    ├── يعتمد على:
    │   ├── ProductBatches (quantity, costPrice, expiryDate, createdAt)
    │   ├── Products (valuationMethod)
    │   └── StockMovementDao
    │
    └── دواله الرئيسية:
        ├── getBatchesForSale()                    (FIFO/AVCO/LIFO)
        ├── calculateAverageCost()                 (AVCO)
        ├── calculateCogsForSale()                 (COGS)
        ├── getInventoryValuation()                (تقييم)
        └── deductFromInventory()                  (حركة)
```

---

## 6. خريطة تبعيات `quantityInBaseUnit`

```
quantityInBaseUnit (PurchaseItems)
    ├── add_purchase_page.dart:596                 (WRITE)
    ├── purchase_provider.dart: (ضمني)             (CALC)
    └── transaction_engine.dart:157                (CALC)
```

**ملاحظة**: هذا الحقل `nullable` حالياً وليس إلزامياً.

---

## 7. خريطة تبعيات `availableStock`

```
availableStock
    ├── packaging_engine.dart:149-160              (_getAvailableQuantity)
    ├── products_dao.dart:367-378                  (getWarehouseStock)
    └── inventory_dao.dart (manual):187-198        (getWarehouseStock)
```

---

## 8. العلاقات المتقاطعة المعقدة

### 8.1 مثلث FIFO الخطير

```
transaction_engine.dart
    │
    ├── يقرأ ProductBatches.quantity, costPrice, createdAt
    ├── يقرأ Products.stock
    ├── يستدعي packagingEngine.autoBreakIfNecessary()    ← يعدل ProductBatches
    ├── يعدل Products.stock
    └── يستدعي costingService.getBatchesForSale()        ← يقرأ ProductBatches
```

**المشكلة**: `packagingEngine.autoBreakIfNecessary()` ينشئ BROKEN batches بوقت الحالي (createdAt = now). ثم `costingService.getBatchesForSale()` يقرأ هذه الباتشات. إذا كانت الباتشات المكسورة أحدث من الباتشات الأصلية، فإن FIFO سيتأثر.

### 8.2 مثلث الوحدات الثلاثة

```
نظام 1: ProductUnits (جديد)
    ├── product_id → Products.id
    ├── unitFactor (Decimal)
    └── unitName

نظام 2: UnitConversions (قديم - مكرر)
    ├── product_id → Products.id  
    ├── factor (Decimal)
    └── unitName

نظام 3: Products.cartonUnit + piecesPerCarton (قديم جداً)
    ├── carton_unit TEXT DEFAULT 'carton'
    ├── pieces_per_carton INTEGER DEFAULT 1
    ├── kilo_unit TEXT nullable
    └── box_unit TEXT nullable
```

**3 أنظمة لنفس الشيء!** هذا يسبب ارتباكاً وأخطاء محتملة.

---

## 9. مصفوفة التغيير (Change Impact Matrix)

| غيِّر هذا ↓ | يتأثر (عدد الملفات) | CRITICAL | HIGH | MEDIUM |
|-------------|-------------------|----------|------|--------|
| `Products.stock` | 45 | 5 | 8 | 32 |
| `ProductBatches.quantity` | 20 | 4 | 2 | 14 |
| `unitFactor` | 15 | 0 | 2 | 13 |
| `costPrice` | 20 | 1 | 3 | 16 |
| `quantityInBaseUnit` | 3 | 0 | 0 | 3 |
| `TransactionEngine` API | 10 | 2 | 3 | 5 |
| `PackagingEngine.autoBreak` | 5 | 1 | 2 | 2 |
| `InventoryCostingService` | 8 | 0 | 1 | 7 |

---

## 10. نقاط الدخول الوحيدة (Single Points of Truth)

| المكون | الحالة | عدد المستخدمين |
|--------|--------|---------------|
| **TransactionEngine** | ✅ نقطة واحدة لترحيل الفواتير | 4 خدمات + عدة شاشات |
| **PostingEngine** | ✅ نقطة واحدة للقيود المحاسبية | 10+ خدمات |
| **Products.stock** | ❌ يُكتب من 14 مكان مختلف | 45 ملفاً |
| **ProductBatches.quantity** | ❌ يُكتب من 6 أماكن مختلفة | 20 ملفاً |
| **costPrice** | ❌ يُكتب من 5 أماكن مختلفة | 20 ملفاً |

**الخلاصة**: `Products.stock` و `ProductBatches.quantity` هما النقطتان الأضعف في النظام حالياً لأن update يتم من 14 و 6 أماكن مختلفة على التوالي.

---

## 11. توصيات السلامة

1. **لا تلمس `Products.stock` مباشرة** - استخدم `TransactionEngine` فقط
2. **لا تلمس `ProductBatches.quantity` مباشرة** - استخدم `TransactionEngine` أو `PackagingEngine` فقط
3. **وحّد نظام الوحدات** على `ProductUnits` وأهمل `UnitConversions` و `piecesPerCarton`
4. **قلّل من autoBreak** - لا تكسر الباتش إلا عند الضرورة القصوى
5. **أضف `reservedQuantity`** بدلاً من إنشاء BROKEN batches
