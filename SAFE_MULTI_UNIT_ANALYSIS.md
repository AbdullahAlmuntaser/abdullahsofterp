# SAFE_MULTI_UNIT_ANALYSIS.md
## تحليل شامل لنظام الوحدات المتعددة في المخزون

> تاريخ التحليل: 18 يوليو 2026  
> المشروع: SystemMarket ERP/POS  
> قاعدة البيانات: SQLCipher (مشفرة) عبر Drift ORM  
> الإطار: Flutter (Dart)

---

## 1. هيكل قاعدة البيانات - العلاقات والمفاتيح الأجنبية

### 1.1 جدول المنتجات (Products)

| العمود | النوع | الغرض | ملاحظات |
|--------|------|-------|---------|
| `id` | TEXT(PK) | المعرف الفريد | UUID |
| `name` | TEXT | اسم المنتج | |
| `sku` | TEXT UNIQUE | رمز المنتج | |
| `barcode` | TEXT UNIQUE | الباركود الرئيسي | |
| `category_id` | TEXT FK→Categories(id) | التصنيف | |
| **`unit`** | **TEXT** | **الوحدة الأساسية** | **افتراضي 'pcs'** |
| `carton_unit` | TEXT | اسم وحدة الكرتون | افتراضي 'carton' |
| `pieces_per_carton` | INTEGER | عدد القطع في الكرتون | افتراضي 1 |
| `kilo_unit` | TEXT | وحدة الكيلو | nullable |
| `box_unit` | TEXT | وحدة الصندوق | nullable |
| `buy_price` | TEXT(Decimal) | سعر الشراء | فيزيائياً بالقيمة فقط |
| `sell_price` | TEXT(Decimal) | سعر البيع | |
| `wholesale_price` | TEXT(Decimal) | سعر الجملة | |
| **`stock`** | **TEXT(Decimal)** | **الكمية الإجمالية** | **دائماً بالوحدة الأساسية** |
| `valuation_method` | TEXT | طريقة التقييم | FIFO, AVCO, LIFO |
| `supplier_id` | TEXT FK→Suppliers(id) | المورد الافتراضي | |

### 1.2 جدول وحدات المنتج (ProductUnits)

| العمود | النوع | الغرض |
|--------|------|-------|
| `id` | TEXT(PK) | المعرف |
| `product_id` | TEXT FK→Products(id) | المنتج |
| `unit_name` | TEXT | اسم الوحدة (مثل: كرتون، صندوق) |
| `barcode` | TEXT UNIQUE | باركود الوحدة |
| **`unit_factor`** | **TEXT(Decimal)** | **عامل التحويل (كم وحدة أساسية)** |
| `buy_price` | TEXT(Decimal) | سعر شراء للوحدة |
| `sell_price` | TEXT(Decimal) | سعر بيع للوحدة |
| `wholesale_price` | TEXT(Decimal) | سعر جملة |
| `half_wholesale_price` | TEXT(Decimal) | سعر نصف جملة |
| `is_default` | BOOLEAN | هل هي افتراضية |

### 1.3 جدول الباتشات (ProductBatches)

| العمود | النوع | الغرض |
|--------|------|-------|
| `id` | TEXT(PK) | المعرف |
| `product_id` | TEXT FK→Products(id) | المنتج |
| `warehouse_id` | TEXT FK→Warehouses(id) | المستودع |
| `batch_number` | TEXT | رقم الدفعة |
| `expiry_date` | DATETIME | تاريخ الانتهاء |
| **`quantity`** | **TEXT(Decimal)** | **الكمية المتبقية - دائماً بالوحدة الأساسية** |
| `initial_quantity` | TEXT(Decimal) | الكمية الأولية - دائماً بالوحدة الأساسية |
| `cost_price` | TEXT(Decimal) | تكلفة الوحدة الواحدة (بالعملة المحلية) |

### 1.4 جدول أصناف المبيعات (SaleItems)

| العمود | النوع | الغرض |
|--------|------|-------|
| `id` | TEXT(PK) | |
| `sale_id` | TEXT FK→Sales(id) | الفاتورة |
| `product_id` | TEXT FK→Products(id) | المنتج |
| **`quantity`** | **TEXT(Decimal)** | **الكمية المباعة - دائماً بالوحدة الأساسية** |
| `price` | TEXT(Decimal) | السعر |
| `unit_id` | TEXT FK→GlobalUnits(id) | معرف الوحدة (nullable) |
| **`unit_name`** | **TEXT** | **اسم الوحدة وقت البيع (افتراضي 'حبة')** |
| **`unit_factor`** | **TEXT(Decimal)** | **عامل التحويل وقت البيع** |
| `batch_id` | TEXT FK→ProductBatches(id) | |
| `warehouse_id` | TEXT FK→Warehouses(id) | |

### 1.5 جدول أصناف المشتريات (PurchaseItems)

| العمود | النوع | الغرض |
|--------|------|-------|
| `id` | TEXT(PK) | |
| `purchase_id` | TEXT FK→Purchases(id) | |
| `product_id` | TEXT FK→Products(id) | |
| **`quantity`** | **TEXT(Decimal)** | **الكمية (بالوحدة المختارة عند الشراء)** |
| **`quantity_in_base_unit`** | **TEXT(Decimal) NULLABLE** | **الكمية بالوحدة الأساسية** |
| **`unit_factor`** | **TEXT(Decimal)** | **عامل التحويل وقت الشراء** |
| `unit_id` | TEXT | معرف الوحدة (nullable) |
| `unit_price` | TEXT(Decimal) | سعر الوحدة الواحدة |
| **`is_carton`** | **BOOLEAN** | **هل تم الشراء بالكرتون؟** |

### 1.6 جداول أخرى تحتوي على كميات

| الجدول | حقل الكمية | حقل الوحدة |
|--------|-----------|------------|
| `StockMovements` | `quantity` (Decimal) | لا يوجد |
| `InventoryTransactions` | `quantity` (Decimal) | لا يوجد |
| `StockTransferItems` | `quantity` (Decimal) | لا يوجد |
| `InventoryAuditItems` | `system_stock`, `actual_stock`, `difference` | لا يوجد |
| `StockTakeItems` | `expected_qty`, `actual_qty`, `variance` | لا يوجد |
| `SalesReturnItems` | `quantity`, `unit_factor` | `unit_factor` |
| `PurchaseReturnItems` | `quantity` | لا يوجد |
| `GoodReceivedNoteItems` | `quantity` | لا يوجد |
| `DeliveryNoteItems` | `quantity` | لا يوجد |
| `SalesOrderItems` | `quantity` | (unit_id فقط) |

### 1.7 ملخص العلاقات (ER)

```
Products ──┬── ProductUnits (1:N عبر product_id)
           ├── ProductBatches (1:N عبر product_id)
           ├── SaleItems (1:N عبر product_id)
           ├── PurchaseItems (1:N عبر product_id)
           ├── StockMovements (1:N)
           └── InventoryTransactions (1:N)

ProductBatches ──┬── SaleItems (1:N عبر batch_id)
                 ├── StockTransferItems (1:N)
                 └── InventoryTransactions (1:N)

Warehouses ──┬── ProductBatches (1:N)
             ├── StockTransfers (1:N)
             └── StockMovements (1:N)
```

---

## 2. جميع الحقول المستخدمة في التحويل بين الوحدات

### 2.1 ProductUnits.unitFactor (Drift + Manual)
- كل ProductUnit له `unitFactor` وهو مضروب التحويل إلى الوحدة الأساسية
- مثال: إذا كان `unitFactor = 12` فهذا يعني أن الوحدة = 12 وحدة أساسية

### 2.2 Products.old-style fields (منقولة تدريجياً)
- `products.carton_unit` و `products.pieces_per_carton` - حقول قديمة
- `products.kilo_unit`, `products.box_unit` - حقول قديمة لم تستخدم في الكود الجديد

### 2.3 SaleItems.unitFactor
- يُسجل عامل التحويل في وقت البيع للحفاظ على دقة الفاتورة التاريخية

### 2.4 PurchaseItems.unitFactor + quantityInBaseUnit
- يُسجل `unitFactor` و `quantityInBaseUnit` لفصل كمية الشراء (بوحدة الشراء) عن التخزين (بالوحدة الأساسية)

### 2.5 UnitConversions table (موازٍ لـ ProductUnits)
- جدول منفصل `unit_conversions` بنفس الغرض تقريباً، قديم أو مكرر

### 2.6 مراجع حقل `حبة` (pcs) في النظام
- `SaleItems.unitName` افتراضي = 'حبة'
- `ProformaInvoiceItems.unitName` افتراضي = 'حبة'  
- ثوابت في `PackagingEngine` و `InventoryDisplayService` و `cart_widget.dart`

---

## 3. جميع الأماكن التي تعتمد على fields المخزون

### 3.1 التبعية على `stock` (Products.stock)

| الملف | السطر | النوع | الوصف |
|------|-------|-------|-------|
| `app_database.dart` | 146-148 | SCHEMA | تعريف العمود |
| `transaction_engine.dart` | 199, 376, 429, 601, 733 | WRITE | تحديث المخزون بعد بيع/شراء/مرتجع |
| `stock_operation_service.dart` | 34, 199-208, 204 | READ/WRITE | قراءة/تحديث المخزون في الجرد والخصم |
| `packaging_engine.dart` | 183-221 | READ | تنسيق عرض المخزون |
| `return_service.dart` | 54-64, 216-227 | WRITE | تحديث المخزون في المرتجعات |
| `grn_service.dart` | 103 | WRITE | تحديث المخزون عند استلام بضاعة |
| `delivery_notes_service.dart` | 119 | WRITE | خصم المخزون عند التوصيل |
| `credit_note_service.dart` | 114 | WRITE | إعادة المخزون في إشعارات الدائن |
| `production_service.dart` | (متعدد) | WRITE | صرف/إضافة مخزون في الإنتاج |
| `reorder_service.dart` | 49, 63 | READ/CALC | حساب كمية إعادة الطلب |
| `report_engine_service.dart` | 263-265 | READ | تقارير قيمة المخزون |
| `chart_service.dart` | 47, 73, 125 | READ | رسوم بيانية |
| `export_service.dart` | 189, 305 | READ | تصدير البيانات |
| `system_auditor.dart` | 22-23 | READ | التحقق من تطابق الباتشات مع المخزون |
| `inventory_reservation_service.dart` | 67 | READ | حجز المخزون |
| `notification_service.dart` | 152 | READ | إشعارات انخفاض المخزون |
| `dashbaord_service.dart` | (متعدد) | READ | لوحة المعلومات |
| `rest_api_service.dart` | 69, 100, 113 | READ/WRITE | REST API |
| `data_import_service.dart` | (متعدد) | WRITE | استيراد بيانات |
| `pos_bloc.dart` | 492, 563-568 | READ | التحقق من توفر المخزون في نقطة البيع |
| `pos_product_card.dart` | 69-73, 78 | UI | عرض المخزون في بطاقة المنتج |
| `smart_stock_widget.dart` | 28 | UI | عرض المخزون في الـ widget |
| `product_card.dart` | 51 | UI | عرض المخزون في بطاقة المنتج |
| `low_stock_products_page.dart` | 36 | UI | صفحة المنتجات منخفضة المخزون |
| `low_stock_report.dart` | 54 | UI | تقرير المخزون المنخفض |
| `stock_take_page.dart` | 585-587 | WRITE | الجرد الفعلي |
| `beginning_of_period_page.dart` | 67, 343-348 | READ/WRITE | بداية الفترة |
| `purchase_provider.dart` | 184, 351, 366 | READ/WRITE | مزود المشتريات |
| `sales_invoice_page.dart` | (متعدد) | READ | شاشة الفاتورة |
| `sales_orders_page.dart` | 495 | UI | عرض المخزون في طلبات البيع |
| `financial_control_service.dart` | 72 | LOGIC | رقابة مالية على المخزون |

### 3.2 التبعية على `quantity` في ProductBatches

| الملف | السطر | النوع | الوصف |
|------|-------|-------|-------|
| `transaction_engine.dart` | 170, 356, 401-409, 555-559, 707-713 | WRITE | خصم/إضافة كميات الباتشات |
| `stock_operation_service.dart` | 54-85 | WRITE | تعديل كميات الباتشات في الجرد |
| `packaging_engine.dart` | 70-107 | WRITE | تكسير الباتشات (auto-break) |
| `inventory_costing_service.dart` | 75-93, 229-310 | READ | حساب التكلفة |
| `products_dao.dart` | 56-68, 367-378 | READ | قراءة الكميات |
| `inventory_dao.dart` (manual) | 46-53, 187-198 | READ | قراءة الكميات يدوياً |
| `return_service.dart` | 69-87, 231-253 | WRITE | تحديث الباتشات في المرتجعات |
| `stock_transfer_service.dart` | 47-108 | WRITE | تحويل مخزون بين مستودعين |
| `production_service.dart` | 64-76 | WRITE | صرف مكونات إنتاج |
| `bom_service.dart` | 127, 180 | WRITE | مواد أولية |
| `manufacturing_service.dart` | 161-184 | WRITE | تصنيع |

### 3.3 التبعية على `unitFactor`

| الملف | السطر | النوع | الوصف |
|------|-------|-------|-------|
| `transaction_engine.dart` | 157, 173, 313 | CALC | تحويل كمية الشراء/البيع للوحدة الأساسية |
| `packaging_engine.dart` | 54-73, 203-208 | CALC | تكسير الوحدات الكبيرة إلى صغيرة |
| `inventory_display_service.dart` | 121, 175-203 | CALC/UI | عرض الكميات بوحدات متعددة |
| `auto_break_service.dart` | 65, 85-89 | CALC | تحليل التسلسل الهرمي للوحدات |
| `unit_conversion_service.dart` | 34, 55 | CALC | تحويل بين الوحدات |
| `pos_bloc.dart` | 474-475, 596-659 | CALC | حساب كميات نقطة البيع |
| `sales_invoice_page.dart` | 984-994 | CALC | تسجيل فاتورة مبيعات |
| `purchase_provider.dart` | 244-245 | WRITE | حفظ وحدة الشراء |
| `grn_service.dart` | 70-71 | CALC | استلام بضاعة |
| `proforma_service.dart` | 26, 59-60 | CALC | عروض الأسعار |
| `financial_control_service.dart` | 349 | CALC | رقابة مالية |

### 3.4 التبعية على `buyPrice`

| الملف | السطر | النوع | الوصف |
|------|-------|-------|-------|
| `transaction_engine.dart` | 200, 593 | WRITE/CALC | تحديث سعر الشراء |
| `stock_operation_service.dart` | 90, 105 | CALC | تقدير تكلفة تعديلات الجرد |
| `packaging_engine.dart` | (ضمني) | CALC | حساب تكلفة الوحدة المكسورة |
| `return_service.dart` | 86, 242-253 | CALC | حساب COGS في المرتجعات |
| `inventory_costing_service.dart` | (ضمني) | CALC | حسابات التقييم |
| `report_engine_service.dart` | 102, 263 | CALC | تقارير الربحية |
| `chart_service.dart` | 125 | CALC | قيمة المخزون في الرسوم |
| `dashboard_service.dart` | 274 | CALC | لوحة المعلومات |
| `purchase_provider.dart` | 193, 592, 616-621 | WRITE/CALC | تسعير المشتريات |
| `add_edit_product_dialog.dart` | 272-330 | WRITE | إضافة/تعديل منتج |
| `quick_product_add_dialog.dart` | 47-62 | WRITE | إضافة منتج سريع |
| `beginning_of_period_page.dart` | 70, 343-348 | WRITE | بداية الفترة |
| `data_import_service.dart` | 155-161 | WRITE | استيراد |
| `export_service.dart` | 42, 189-195, 305 | READ | تصدير |
| `rest_api_service.dart` | 66, 100 | READ/WRITE | API |
| `erp_data_service.dart` | 77 | READ | بيانات ERP |

### 3.5 التبعية على `averageCost`

| الملف | السطر | النوع | الوصف |
|------|-------|-------|-------|
| `inventory_costing_service.dart` | 24, 30, 108, 141, 182, 223 | CALC | حساب متوسط التكلفة |
| `erp_data_service.dart` | 7, 17, 74, 77, 88 | READ/WRITE | بيانات ERP |
| `purchase_provider.dart` | 27, 34, 352, 416, 492-512 | CALC/UI | مقارنة سعر الشراء مع المتوسط |
| `sales_provider.dart` | 114 | LOGIC | التحقق من سعر البيع |
| `report_engine_service.dart` | (ضمني) | CALC | تقارير |

---

## 4. جميع الخدمات والدوال التي تتعامل مع المخزون

### 4.1 المحركات الأساسية (Engines)

| الخدمة | الملف | الوظيفة الرئيسية |
|--------|-------|-----------------|
| **TransactionEngine** | `transaction_engine.dart` | **المحرك الرئيسي** لترحيل الفواتير (شراء، بيع، مرتجع) - نقطة واحدة للتغيير |
| **PostingEngine** | `posting_engine.dart` | ترحيل القيود المحاسبية (COGS, الإيرادات, المصروفات) |
| **PackagingEngine** | `packaging_engine.dart` | **تكسير العبوات** وإدارة التسلسل الهرمي للوحدات |

### 4.2 خدمات المخزون الرئيسية

| الخدمة | الملف | الوظيفة الرئيسية |
|--------|-------|-----------------|
| InventoryService | `inventory_service.dart` | واجهة موحدة للمخزون (تحتوي على Reports + Operations) |
| InventoryReportService | `inventory_report_service.dart` | تقارير المخزون (حركات، باتشات، منتهية الصلاحية) |
| StockOperationService | `stock_operation_service.dart` | عمليات المخزون (جرد، خصم، تحويل) |
| InventoryCostingService | `inventory_costing_service.dart` | **تقييم المخزون** (FIFO, AVCO, LIFO) وحساب COGS |
| InventoryDisplayService | `inventory_display_service.dart` | عرض المخزون بوحدات متعددة |
| InventoryReservationService | `inventory_reservation_service.dart` | حجز المخزون |
| InventoryAuditService | `inventory_audit_service.dart` | تسوية الجرد مع المخزون |

### 4.3 خدمات إدارة الوحدات

| الخدمة | الملف | الوظيفة الرئيسية |
|--------|-------|-----------------|
| UnitConversionService | `unit_conversion_service.dart` | تحويل بين الوحدات (يدوي) |
| AutoBreakService | `auto_break_service.dart` | خدمة التكسير التلقائي للعبوات |
| ProductUnitsDao | `product_units_dao.dart` | الوصول لجدول وحدات المنتج |

### 4.4 خدمات الحركة والتحويل

| الخدمة | الملف | الوظيفة الرئيسية |
|--------|-------|-----------------|
| StockTransferService | `stock_transfer_service.dart` | تحويل المخزون بين المستودعات |
| SalesOrderService | `sales_order_service.dart` | طلبات البيع |
| PurchaseService | `purchase_service.dart` | المشتريات |
| SalesService | `sales_service.dart` | المبيعات |
| ReturnService | `return_service.dart` | المرتجعات يدوياً |
| PurchaseConverter | `purchase_converter.dart` | تحويل أمر شراء لفاتورة |

### 4.5 خدمات التقارير والتحليل

| الخدمة | الملف | الوظيفة الرئيسية |
|--------|-------|-----------------|
| ReportEngineService | `report_engine_service.dart` | محرك التقارير |
| ProfitabilityService | `profitability_service.dart` | تحليل الربحية |
| ChartService | `chart_service.dart` | رسوم بيانية للمخزون |
| DashboardService | `dashbaord_service.dart` | لوحة المعلومات |
| ReorderService | `reorder_service.dart` | إعادة الطلب التلقائي |
| NotificationService | `notification_service.dart` | إشعارات المخزون |
| DataIntegrityValidator | `data_integrity_validator.dart` | التحقق من سلامة البيانات |
| SystemAuditor | `system_auditor.dart` | تدقيق النظام |

### 4.6 خدمات الإنتاج والتصنيع

| الخدمة | الملف |
|--------|-------|
| ManufacturingService | `manufacturing_service.dart` |
| ProductionService | `production_service.dart` |
| BomService | `bom_service.dart` |
| GrnService | `grn_service.dart` |

### 4.7 DAOs

| الملف | الوظيفة |
|-------|---------|
| `products_dao.dart` | DAO المنتجات مع الباتشات والمستودعات |
| `product_units_dao.dart` | DAO وحدات المنتج |
| `stock_movement_dao.dart` | DAO حركات المخزون |
| `inventory_dao.dart` (manual) | DAO يدوي للمخزون (باتشات، حركات، جرد) |
| `warehouses_dao.dart` | DAO المستودعات |

---

## 5. جميع الشاشات التي تعتمد على كمية المنتج

### 5.1 شاشات نقطة البيع (POS)

| الملف | الوظيفة |
|-------|---------|
| `pos_page.dart` | الصفحة الرئيسية - التحقق من توفر الكمية |
| `pos_bloc.dart` | منطق الأعمال - إدارة كميات السلة والتحقق من المخزون |
| `pos_product_card.dart` | عرض كمية المنتج في البطاقة |
| `cart_widget.dart` | عرض/تعديل كميات السلة + تبديل الوحدات |
| `add_unit_dialog.dart` | إضافة وحدة جديدة |
| `product_grid.dart` | شبكة المنتجات |
| `product_search_widget.dart` | بحث المنتجات |

### 5.2 شاشات المبيعات

| الملف | الوظيفة |
|-------|---------|
| `sales_invoice_page.dart` | إصدار فاتورة مبيعات - اختيار الوحدة والكمية |
| `sales_item_row.dart` | عرض/تعديل كمية صنف المبيعات |
| `sale_details_bottom_sheet.dart` | تفاصيل الفاتورة |
| `sales_history_page.dart` | سجل الفواتير |
| `sales_provider.dart` | مزود حالات المبيعات |
| `sales_return_page.dart` | مرتجعات المبيعات |
| `add_sales_return_page.dart` | إضافة مرتجع مبيعات |
| `credit_notes_page.dart` | إشعارات الدائن |

### 5.3 شاشات المشتريات

| الملف | الوظيفة |
|-------|---------|
| `add_purchase_page.dart` | إضافة فاتورة شراء - اختيار الوحدة والكمية + quantityInBaseUnit |
| `purchase_provider.dart` | مزود حالات المشتريات |
| `purchase_item_row.dart` | عرض/تعديل كمية صنف الشراء وعرض الوحدات |
| `purchase_details_page.dart` | تفاصيل فاتورة الشراء |
| `purchases_page.dart` | list فواتير الشراء |
| `purchase_return_page.dart` | مرتجعات المشتريات |
| `supplier_performance_page.dart` | أداء الموردين |
| `quick_product_add_dialog.dart` | إضافة منتج سريع |

### 5.4 شاشات المخزون

| الملف | الوظيفة |
|-------|---------|
| `stock_take_page.dart` | الجرد الفعلي |
| `stock_transfer_page.dart` | تحويل مخزون |
| `beginning_of_period_page.dart` | بداية الفترة (عرض/تعديل stock و buyPrice) |
| `warehouse_management_page.dart` | إدارة المستودعات |
| `low_stock_alert_page.dart` | تنبيهات المخزون المنخفض |
| `item_movement_detail_page.dart` | تفاصيل حركة صنف |
| `product_edit_log_page.dart` | سجل تعديل المنتج |

### 5.5 شاشات المنتجات

| الملف | الوظيفة |
|-------|---------|
| `products_page.dart` | صفحة المنتجات (مع المخزون) |
| `product_card.dart` | بطاقة المنتج مع المخزون |
| `smart_stock_widget.dart` | widget عرض المخزون الذكي |
| `add_edit_product_dialog.dart` | إضافة/تعديل منتج (buyPrice, stock) |
| `unit_conversion_page.dart` | إدارة وحدات المنتج |
| `barcode_printing_page.dart` | طباعة الباركود |

### 5.6 شاشات التقارير

| الملف | الوظيفة |
|-------|---------|
| `inventory_reports_screen.dart` | قائمة تقارير المخزون |
| `inventory_transactions_report.dart` | تقرير حركات المخزون |
| `inventory_value_report.dart` | تقرير قيمة المخزون |
| `low_stock_report.dart` | تقرير المخزون المنخفض |
| `product_batches_report.dart` | تقرير الباتشات |
| `item_movement_report_page.dart` | تقرير حركة صنف |
| `stock_movement_report_page.dart` | تقرير حركات المخزون |
| `inventory_audit_page.dart` | صفحة جرد المخزون |
| `product_profitability_page.dart` | ربحية المنتج |
| `advanced_profit_report_page.dart` | تقرير الربح المتقدم |
| `category_margin_page.dart` | هامش ربح التصنيف |
| `profitability_report_page.dart` | تقرير الربحية |
| `slow_moving_products_page.dart` | المنتجات بطيئة الحركة |
| `abc_analysis_page.dart` | تحليل ABC |
| `top_selling_products_page.dart` | الأعلى مبيعاً |

### 5.7 شاشات أخرى

| الملف | الوظيفة |
|-------|---------|
| `home_page.dart` / `dashboard_page.dart` | لوحة المعلومات الرئيسية |
| `low_stock_products_page.dart` | صفحة المخزون المنخفض |
| `sales_orders_page.dart` | طلبات البيع (مع عرض المخزون) |
| `add_sales_order_page.dart` | إضافة طلب بيع |
| `sales_order_detail_page.dart` | تفاصيل طلب بيع |
| `manufacturing/production_orders_page.dart` | أوامر الإنتاج |
| `manufacturing/bom_management_page.dart` | إدارة مواد أولية |
| `returns/returns_page.dart` | صفحة المرتجعات |
| `returns/create_return_page.dart` | إنشاء مرتجع |

---

## 6. تحليل المشكلة الحالية - هل التخزين بالوحدة الأساسية يسبب المشاكل المذكورة؟

### 6.1 صحة الادعاء: "النظام يخزن الكميات بالوحدة الأساسية فقط"

**نعم، هذا صحيح 100%.** جميع الكميات تُخزن بالوحدة الأساسية:

- `Products.stock` ← دائماً بالوحدة الأساسية
- `ProductBatches.quantity` ← دائماً بالوحدة الأساسية
- `InventoryTransactions.quantity` ← دائماً بالوحدة الأساسية
- `StockMovements.quantity` ← دائماً بالوحدة الأساسية

### 6.2 صحة الادعاء: "البيانات تظهر للمستخدم بوحدة أساسية غير مناسبة"

**نعم بشكل جزئي.** هناك محاولات للعرض الذكي:

- `PackagingEngine.formatInventoryBalance()` يحاول إظهار `10 Carton + 0 Piece`
- `InventoryDisplayService.formatForDisplay()` يحاول التقسيم الذكي
- ولكن الكثير من الشاشات لا تزال تعرض الرقم المجرد (مثل `product.stock`)

### 6.3 صحة الادعاء: "النظام ينشئ Broken Batches عند البيع بالحبة"

**نعم، هذه مشكلة حقيقية.** في `transaction_engine.dart` (السطر 335-339):
```dart
await packagingEngine.autoBreakIfNecessary(...)
```
وهذا يؤدي إلى:
1. إنشاء batches جديدة باسم `BROKEN-{original_batch}-{timestamp}`
2. كل عملية بيع بالحبة للكراتين تنشئ batch جديد
3. مع 100 عملية بيع، يمكن أن يتضاعف عدد الباتشات إلى 100+ لكل منتج
4. كل batch جديد له `costPrice` محسوب بقسمة تكلفة الكرتون
5. هذا يسبب مشاكل في FIFO حيث يصبح لديك batches متعددة بنفس التاريخ والسعر

### 6.4 صحة الادعاء: "يسبب تعقيد FIFO"

**نعم.** نظام FIFO في `InventoryCostingService.getBatchesForSale()` يفرز حسب تاريخ الإنشاء (createdAt) وتاريخ الانتهاء. الباتشات المكسورة حديثاً ستظهر كأحدث batches، مما يعطل ترتيب FIFO الصحيح.

### 6.5 صحة الادعاء: "يسبب بطء النظام"

**احتمال متوسط.** كلما زاد عدد الباتشات:
- Queries تصبح أبطأ (خصوصاً مع LEFT JOINs)
- `getBatchesForSale()` تتعامل مع قائمة أطول
- `calculateAverageCost()` تتعامل مع قائمة أطول

### 6.6 صحة الادعاء: "يسبب مشاكل الجرد"

**نعم.** عند عمل جرد، يجد المستخدمون عشرات الباتشات الصغيرة المكسورة مما يصعب مطابقة الجرد الفعلي مع النظام.

### 6.7 صحة الادعاء: "يسبب مشاكل تقييم المخزون"

**احتمال ضعيف.** تكلفة الباتشات المكسورة متطابقة رياضياص (costPrice / unitFactor * actualDeduction) مع الباتش الأصلي، ولكن في نظام AVCO، الباتشات المنفصلة لا تؤثر على المتوسط.

---

## 7. ملخص المشاكل المؤكدة بعد المراجعة الفعلية للكود

| # | المشكلة | التأثير | درجة الخطورة |
|---|--------|---------|-------------|
| 1 | تخزين جميع الكميات بالوحدة الأساسية | عرض غير مناسب تجارياً | MEDIUM |
| 2 | Broken Batches عند البيع بالتجزئة | تضخم الباتشات (100+ لمنتج) | HIGH |
| 3 | تعطل ترتيب FIFO بسبب تاريخ الباتشات المكسورة | تقييم غير دقيق للـ COGS | MEDIUM |
| 4 | `Products.stock` لا يحمل معلومات الوحدة | فقدان سياق الوحدة عند العرض | HIGH |
| 5 | `SaleItems.quantity` دائماً بالوحدة الأساسية | فقدان سياق البيع (هل 5 قطع من أصل 10 كراتين؟) | MEDIUM |
| 6 | `PurchaseItems.quantityInBaseUnit` nullable | فقدان البيانات أحياناً | LOW |
| 7 | تضارب بين `ProductUnits` و `UnitConversions` و `cartonUnit/piecesPerCarton` (3 أنظمة للوحدات) | تشتت البيانات | HIGH |
| 8 | `isCarton` في PurchaseItems (boolean لا يحدد أي وحدة) | غير دقيق | MEDIUM |
| 9 | Batch costPrice يحسب لكل وحدة أساسية (وليس لكل وحدة بيع) | صحيح رياضياً لكنه يتطلب تكسيراً | LOW |
| 10 | عدم وجود `unitId/unitName` في Batch نفسه | الباتش لا يعرف بأي وحدة تم شراؤه | CRITICAL |
