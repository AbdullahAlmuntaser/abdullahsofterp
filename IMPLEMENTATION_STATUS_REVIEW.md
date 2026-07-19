# IMPLEMENTATION_STATUS_REVIEW.md

## 1. What Has Been Fixed

### PATCH-01: costPrice in autoBreak
**Status: ✅ Fixed (Complete)**

| Aspect | Status |
|--------|--------|
| costPerUnit = batch.costPrice (not divide by packageSize) | ✅ Fixed |
| BROKEN batch.costPrice = batch.costPrice | ✅ Fixed |
| Tests added | ✅ `packaging_engine_cost_test.dart` |
| Unit test verifies correctness | ✅ |
| Safe for existing data | ✅ (doesn't modify old batches, only new) |
| Files: `packaging_engine.dart:104` | `costPerUnit = batch.costPrice` |

---

### PATCH-02: reservedQuantity
**Status: ⚠️ Partially Fixed**

| Aspect | Status |
|--------|--------|
| `reserved_quantity` column added to DB | ✅ Schema + Manual Schema |
| `inventory_costing_service.dart` reads `quantity - reservedQuantity` | ✅ `getBatchesForSale()` line 234 |
| `transaction_engine.dart` FIFO fallback reads available | ✅ Lines 407-408 |
| `packaging_engine.dart` `_getAvailableQuantity` accounts for reserved | ✅ Lines 164 |
| `inventory_dao.dart` queries filter by `quantity - reserved_quantity` | ✅ All queries updated |
| `products_dao.dart` Drift `getWarehouseStock` accounts for reserved | ❌ **NOT FIXED** (line 367-378, ignores reservedQuantity) |
| reservedQuantity actively incremented during sales | ❌ **NOT IMPLEMENTED** |
| autoBreak called only when needed | ❌ **Still called always** |
| Tests | ✅ `reserved_quantity_test.dart` |
| Files: `app_database.dart`, `packaging_engine.dart`, `transaction_engine.dart`, `inventory_costing_service.dart`, `inventory_dao.dart`, `schemas.dart`, `entities.dart` |

---

### PATCH-03: storedUnitId + StockDisplayAdapter
**Status: ✅ Fixed (Complete)**

| Aspect | Status |
|--------|--------|
| `stored_unit_id` column added | ✅ Schema + Manual Schema |
| `quantity_in_stored_unit` column added | ✅ Schema + Manual Schema |
| `StockDisplayAdapter` created | ✅ `stock_display_adapter.dart` |
| postPurchase stores unit context | ✅ `transaction_engine.dart:160-180` |
| autoBreak preserves unit context on break | ✅ `packaging_engine.dart:128-129` |
| Tests | ✅ `stock_display_adapter_test.dart` |
| Files: `app_database.dart`, `schemas.dart`, `entities.dart`, `stock_display_adapter.dart`, `transaction_engine.dart`, `packaging_engine.dart` |

---

### PATCH-04: UI Display Improvements
**Status: ⚠️ Partially Fixed**

| File | Status |
|------|--------|
| `packaging_engine.dart` `formatInventoryBalance` | ✅ Uses adapter when flag on |
| `pos_product_card.dart` | ✅ Updated |
| `product_card.dart` | ✅ Updated |
| `add_sales_order_page.dart` | ✅ Updated |
| `slow_moving_products_page.dart` | ✅ Updated |
| `low_stock_alert_page.dart` | ✅ Updated |
| `low_stock_products_page.dart` | ✅ Updated |
| `product_batches_report.dart` | ✅ Updated |
| `notification_service.dart` | ✅ Updated |
| Remaining 31 screens | ❌ **NOT UPDATED** |

---

### PATCH-05: Deprecate Old Systems
**Status: ⚠️ Partially Fixed**

| System | Status |
|--------|--------|
| `UnitConversions` table | ⚠️ Deprecated in comments only |
| `Products.cartonUnit` / `piecesPerCarton` | ⚠️ Deprecated in comments only |
| `PurchaseItems.isCarton` | ⚠️ Deprecated in comments only |
| `erp_logic.dart` `hasEnoughStock` | ⚠️ Marked deprecated |
| Actual removal of old usage | ❌ **NOT DONE** |

---

### PATCH-06: Testing & Cleanup
**Status: ⚠️ Partially Fixed**

| Item | Status |
|------|--------|
| `packaging_engine_cost_test.dart` | ✅ Created |
| `reserved_quantity_test.dart` | ✅ Created |
| `stock_display_adapter_test.dart` | ✅ Created |
| `cleanup_broken_batches.sql` | ✅ Created |
| Integration test (multi_unit_flow_test) | ❌ **NOT CREATED** |

---

## 2. Remaining Problems

### INVENTORY REPRESENTATION
**Status: ❌ Not Fixed**

| Scenario | Current Behavior | Expected |
|----------|-----------------|----------|
| 7 Cartons + 9 Pieces (93 pieces) | Stored as `93` only | Stored with `storedUnitId`, `quantityInStoredUnit` |
| New batches (post-PATCH-03) | `storedUnitId` set, `quantityInStoredUnit` set | ✅ Partially |
| Old batches (pre-PATCH-03) | `storedUnitId = NULL` | ❌ **Still shows "93 حبة"** |
| Display without flag | Falls back to `toStringAsFixed(0)` | ❌ **Still shows "93"** |

### BROKEN BATCHES
**Status: ❌ Not Fixed**

| Issue | Detail |
|-------|--------|
| autoBreak still creates BROKEN-* batches | `packaging_engine._breakOnePackage()` still called |
| BROKEN batches affect FIFO | Still included in `getBatchesForSale()` |
| BROKEN batches affect COGS | Still consumed in FIFO order |
| BROKEN batches affect inventory reports | Still appear in batch lists |
| BROKEN batches affect stock count | Still create confusion in physical counts |
| Cleanup script exists but not run | `cleanup_broken_batches.sql` not executed |
| reservedQuantity not used to prevent breaks | autoBreak called BEFORE any reservation |

### COST CALCULATION
**Status: ⚠️ Partially Fixed**

| Component | Status | Notes |
|-----------|--------|-------|
| `costPrice` in autoBreak | ✅ Fixed | |
| `averageCost` (AVCO) | ✅ Works | `calculateAverageCost` reads all batches |
| `saleCogs` | ✅ Works | Calculated from batch costPrice |
| `InventoryValuation` | ✅ Works | FIFO/AVCO/LIFO all function |
| BROKEN batch costPrice for old batches | ❌ **Old data still has wrong costPrice** | |
| Fallback FIFO in `transaction_engine.dart` | ⚠️ Uses reservedQuantity | Correct but basic |

### DISPLAY LAYER
**Status: ⚠️ Partially Fixed**

| Component | Status |
|-----------|--------|
| `InventoryDisplayService` | ❌ **Not using StockDisplayAdapter** |
| `pos_bloc.dart` stock display | ❌ **Still shows raw stock** |
| `sales_invoice_page.dart` | ❌ **Still shows raw quantity** |
| `purchase_provider.dart` | ❌ **Still compares raw stock** |
| 31+ remaining screens | ❌ **Raw stock display** |
| `formatInventoryBalance` with flag ON | ✅ Shows "7 Cartons + 9 Pieces" |
