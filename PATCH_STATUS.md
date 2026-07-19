# PATCH_STATUS.md

---

## PATCH-01: Fix costPrice in autoBreak

| Field | Value |
|-------|-------|
| **Description** | Fix incorrect costPrice calculation in `_breakOnePackage()` where `(batch.costPrice / packageSize) * actualDeduction` was used instead of `batch.costPrice` directly. This caused incorrect COGS when `packageSize != actualDeduction`. |
| **Status** | ✅ **Completed** |
| **Risk** | 🔴 HIGH (accounting impact) |
| **Completed** | 2026-07-18 |
| **Files Modified** | `packaging_engine.dart:104,126` |
| **Test Coverage** | `test/unit/packaging_engine_cost_test.dart` |
| **Verification** | `costPerUnit = batch.costPrice` (line 104), `costPrice: Value(batch.costPrice)` (line 126) |
| **Safe** | ✅ - Only affects new breaks, old data unchanged |

---

## PATCH-02: Add reservedQuantity to ProductBatches

| Field | Value |
|-------|-------|
| **Description** | Add `reserved_quantity` column to `ProductBatches` to enable partial sales without creating BROKEN batches. Update availability checks everywhere. |
| **Status** | ⚠️ **Partially Completed** |
| **Risk** | 🔴 HIGH |
| **Completed** | 2026-07-18 |
| **Files Modified** | `app_database.dart`, `schemas.dart`, `entities.dart`, `transaction_engine.dart`, `packaging_engine.dart`, `inventory_costing_service.dart`, `inventory_dao.dart`, `app_database.g.dart` |
| **Test Coverage** | `test/unit/reserved_quantity_test.dart` |
| **What's Done** | ✅ Column added. ✅ Availability checks in costing service. ✅ Availability checks in FIFO fallback. ✅ Manual DAO queries updated. ✅ `_getAvailableQuantity` accounts for reserved. |
| **What's Missing** | ❌ `products_dao.dart` `getWarehouseStock` doesn't subtract reserved. ❌ reservedQuantity is never actively incremented (only used as filter). ❌ autoBreak still creates BROKEN batches (reserved not used as alternative). |
| **Safe** | ⚠️ - Column is nullable with default 0, old data works |

---

## PATCH-03: Add storedUnitId + StockDisplayAdapter

| Field | Value |
|-------|-------|
| **Description** | Add `stored_unit_id` and `quantity_in_stored_unit` columns to `ProductBatches` to preserve unit-of-measure context. Create `StockDisplayAdapter` for intelligent quantity display. |
| **Status** | ✅ **Completed** |
| **Risk** | 🟡 MEDIUM |
| **Completed** | 2026-07-18 |
| **Files Modified** | `app_database.dart`, `schemas.dart`, `entities.dart`, `stock_display_adapter.dart` (new), `transaction_engine.dart`, `packaging_engine.dart` |
| **Test Coverage** | `test/unit/stock_display_adapter_test.dart` |
| **Verification** | postPurchase sets storedUnitId + quantityInStoredUnit. autoBreak preserves them. Adapter formats "X Cartons + Y Pieces". |
| **Safe** | ✅ - New columns nullable, old data = NULL → fallback to "X حبة" |

---

## PATCH-04: Improve Quantity Display in Screens

| Field | Value |
|-------|-------|
| **Description** | Replace `product.stock.toString()` with `StockDisplayAdapter.formatProductStock()` across all 39 screens. |
| **Status** | ❌ **8/39 Done (21%)** |
| **Risk** | 🟡 MEDIUM |
| **Completed** | 2026-07-18 (partial) |
| **Files Modified** | `packaging_engine.dart`, `pos_product_card.dart`, `product_card.dart`, `add_sales_order_page.dart`, `slow_moving_products_page.dart`, `low_stock_alert_page.dart`, `low_stock_products_page.dart`, `product_batches_report.dart`, `notification_service.dart` |
| **Remaining (31 files)** | `pos_bloc.dart`, `cart_widget.dart`, `sales_invoice_page.dart`, `stock_take_page.dart`, `smart_stock_widget.dart`, `beginning_of_period_page.dart`, `sales_orders_page.dart`, `inventory_value_report.dart`, `low_stock_report.dart`, `item_movement_detail_page.dart`, `inventory_transactions_report.dart`, `sales_item_row.dart`, `sale_details_bottom_sheet.dart`, `sales_order_detail_page.dart`, `products_page.dart`, `dashboard_service.dart`, `chart_service.dart`, `report_engine_service.dart`, `export_service.dart`, `rest_api_service.dart`, `data_import_service.dart`, `erp_data_service.dart`, `profitability_service.dart`, `dashboard_page.dart`, `home_page.dart`, `inventory_reports_screen.dart`, `purchase_item_row.dart`, `purchase_details_page.dart`, `inventory_display_service.dart`, `purchase_provider.dart`, `sales_provider.dart` |
| **Safe** | ✅ - Display only, no data modification |

---

## PATCH-05: Deprecate Old Unit Systems

| Field | Value |
|-------|-------|
| **Description** | Stop using old unit systems (`UnitConversions`, `cartonUnit`, `piecesPerCarton`, `isCarton`) and unify on `ProductUnits`. |
| **Status** | ⚠️ **Minimally Completed** |
| **Risk** | 🟢 LOW |
| **Completed** | 2026-07-18 |
| **Files Modified** | `erp_logic.dart` (deprecation comments only) |
| **What's Missing** | ❌ `UnitConversions` table not removed from code. ❌ `cartonUnit`/`piecesPerCarton` still in `Products` table. ❌ `isCarton` still in `PurchaseItems`. ❌ `auto_break_service.dart` still uses `UnitConversions`. ❌ `purchase_provider.dart` still uses `isCarton`. ❌ `unit_conversion_service.dart` still references old systems. |
| **Safe** | ✅ - Comments only, no functional changes |
| **Note** | This needs a dedicated refactoring pass |

---

## PATCH-06: Testing & Cleanup

| Field | Value |
|-------|-------|
| **Description** | Comprehensive tests + BROKEN batches cleanup script. |
| **Status** | ⚠️ **Partially Completed** |
| **Risk** | 🟡 MEDIUM |
| **Completed** | 2026-07-18 |
| **Files Created** | `test/unit/packaging_engine_cost_test.dart`, `test/unit/reserved_quantity_test.dart`, `test/unit/stock_display_adapter_test.dart`, `scripts/cleanup_broken_batches.sql` |
| **What's Missing** | ❌ Integration test (`multi_unit_flow_test.dart`). ❌ Cleanup script not executed. ❌ No regression test suite. |
