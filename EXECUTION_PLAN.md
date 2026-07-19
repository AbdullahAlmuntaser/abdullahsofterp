# EXECUTION PLAN - Multi-Unit Refactoring

> تاريخ البدء: 19 يوليو 2026  
> المشروع: SystemMarket ERP/POS  
> الإستراتيجية: التنفيذ التدريجي مع feature flag

---

## How To Use This File

- ✅ = Completed
- ⬜ = Pending
- 🔄 = In Progress
- ❌ = Cancelled/Blocked

---

## PATCH-01: Fix costPrice in autoBreak

| Item | Status |
|------|--------|
| Fix `_breakOnePackage` costPrice calculation | ✅ |
| Tests | ✅ |
| **Completion** | ✅ **Done** |

---

## PATCH-02: Add reservedQuantity to ProductBatches

| Item | Status |
|------|--------|
| Add `reserved_quantity` column (Drift schema) | ✅ |
| Add `reserved_quantity` column (Manual schema) | ✅ |
| Update `entities.dart` | ✅ |
| Update `inventory_costing_service.dart` available check | ✅ |
| Update `transaction_engine.dart` FIFO fallback | ✅ |
| Update `packaging_engine.dart` `_getAvailableQuantity` | ✅ |
| Update manual `inventory_dao.dart` queries | ✅ |
| Update Drift `products_dao.dart` `getWarehouseStock` | ⬜ **Moved to PATCH-07** |
| Actively manage reservedQuantity during sales | ⬜ **Moved to PATCH-07** |
| Tests | ✅ |
| **Completion** | ⚠️ **Partial** |

---

## PATCH-03: Add storedUnitId + StockDisplayAdapter

| Item | Status |
|------|--------|
| Add `stored_unit_id`, `quantity_in_stored_unit` (Drift) | ✅ |
| Add `stored_unit_id`, `quantity_in_stored_unit` (Manual) | ✅ |
| Create `StockDisplayAdapter` | ✅ |
| Update `transaction_engine.dart` postPurchase | ✅ |
| Update `packaging_engine.dart` autoBreak preserve | ✅ |
| Tests | ✅ |
| **Completion** | ✅ **Done** |

---

## PATCH-04: UI Display Improvements

| Item | Status |
|------|--------|
| `packaging_engine.dart` formatInventoryBalance | ✅ |
| `pos_product_card.dart` | ✅ |
| `product_card.dart` | ✅ |
| `add_sales_order_page.dart` | ✅ |
| `slow_moving_products_page.dart` | ✅ |
| `low_stock_alert_page.dart` | ✅ |
| `low_stock_products_page.dart` | ✅ |
| `product_batches_report.dart` | ✅ |
| `notification_service.dart` | ✅ |
| Remaining 31 screens | ⬜ **Moved to PATCH-09** |
| **Completion** | ⚠️ **8/39 (21%)** |

---

## PATCH-05: Deprecate Old Systems

| Item | Status |
|------|--------|
| Deprecation comments on `erp_logic.dart` | ✅ |
| Remove `UnitConversions` references | ⬜ **Moved to PATCH-11** |
| Remove `isCarton` usage | ⬜ **Moved to PATCH-11** |
| Remove `cartonUnit`/`piecesPerCarton` usage | ⬜ **Moved to PATCH-11** |
| **Completion** | ⚠️ **Minimal** |

---

## PATCH-06: Testing & Cleanup

| Item | Status |
|------|--------|
| `packaging_engine_cost_test.dart` | ✅ |
| `reserved_quantity_test.dart` | ✅ |
| `stock_display_adapter_test.dart` | ✅ |
| `cleanup_broken_batches.sql` | ✅ |
| Integration test (`multi_unit_flow_test.dart`) | ⬜ **Moved to PATCH-11** |
| **Completion** | ⚠️ **Partial** |

---

## PATCH-07: Fix autoBreak + reservedQuantity (CRITICAL)

**Goal**: Stop unnecessary BROKEN batch creation. Fix available quantity checks.

| # | Item | Status | Files |
|---|------|--------|-------|
| 7.1 | Fix `getWarehouseStock` to use `quantity - reservedQuantity` | ✅ | `products_dao.dart:367-378` |
| 7.2 | Move autoBreak call inside validation (only when stock insufficient) | ✅ | `transaction_engine.dart:325-358` |
| 7.3 | Calculate available qty correctly before deciding to break | ✅ | `transaction_engine.dart` |
| 7.4 | Keep BROKEN batch creation as last resort only | ✅ | `packaging_engine.dart` (already last resort) |
| 7.5 | Update tests for new flow | ⬜ | Test files |
| | **Completion** | ⚠️ **4/5** | |

**Verification**: `dart analyze` passes with no issues. Key changes:
- `getWarehouseStock` now sums `(quantity - reservedQuantity)` instead of raw `quantity`
- `autoBreakIfNecessary` only called when stock check fails, not unconditionally
- After autoBreak, stock is re-checked before throwing exception

---

## PATCH-08: Clean Up Existing BROKEN Batches (CRITICAL)

**Goal**: Remove all existing BROKEN batches from database.

| # | Item | Status | Files |
|---|------|--------|-------|
| 8.1 | Run `cleanup_broken_batches.sql` | ⬜ | `scripts/cleanup_broken_batches.sql` |
| 8.2 | Backfill costPrice on orphaned batches if needed | ⬜ | Manual |
| 8.3 | Verify sum(batch.quantity) == product.stock | ⬜ | SQL query |
| | **Completion** | ⬜ | |

---

## PATCH-09: Complete UI Display Overhaul (MEDIUM)

**Goal**: All 31 remaining screens use StockDisplayAdapter.

| # | File | Status | Risk |
|---|------|--------|------|
| 9.1 | `pos_bloc.dart` | ⬜ | HIGH |
| 9.2 | `cart_widget.dart` | ⬜ | MEDIUM |
| 9.3 | `sales_invoice_page.dart` | ⬜ | MEDIUM |
| 9.4 | `stock_take_page.dart` | ⬜ | MEDIUM |
| 9.5 | `smart_stock_widget.dart` | ⬜ | LOW |
| 9.6 | `beginning_of_period_page.dart` | ⬜ | MEDIUM |
| 9.7 | `sales_orders_page.dart` | ⬜ | LOW |
| 9.8 | `inventory_value_report.dart` | ⬜ | LOW |
| 9.9 | `low_stock_report.dart` | ⬜ | LOW |
| 9.10 | `item_movement_detail_page.dart` | ⬜ | LOW |
| 9.11 | `inventory_transactions_report.dart` | ⬜ | LOW |
| 9.12 | `sales_item_row.dart` | ⬜ | LOW |
| 9.13 | `sale_details_bottom_sheet.dart` | ⬜ | LOW |
| 9.14 | `sales_order_detail_page.dart` | ⬜ | LOW |
| 9.15 | `products_page.dart` | ⬜ | LOW |
| 9.16 | `dashboard_service.dart` | ⬜ | LOW |
| 9.17 | `chart_service.dart` | ⬜ | LOW |
| 9.18 | `report_engine_service.dart` | ⬜ | LOW |
| 9.19 | `export_service.dart` | ⬜ | LOW |
| 9.20 | `rest_api_service.dart` | ⬜ | LOW |
| 9.21 | `data_import_service.dart` | ⬜ | LOW |
| 9.22 | `erp_data_service.dart` | ⬜ | LOW |
| 9.23 | `profitability_service.dart` | ⬜ | LOW |
| 9.24 | `dashboard_page.dart` | ⬜ | LOW |
| 9.25 | `home_page.dart` | ⬜ | LOW |
| 9.26 | `inventory_reports_screen.dart` | ⬜ | LOW |
| 9.27 | `purchase_item_row.dart` | ⬜ | LOW |
| 9.28 | `purchase_details_page.dart` | ⬜ | LOW |
| 9.29 | `inventory_display_service.dart` | ⬜ | LOW |
| 9.30 | `purchase_provider.dart` | ⬜ | MEDIUM |
| 9.31 | `sales_provider.dart` | ⬜ | LOW |
| | **Completion** | ⬜ **0/31** | |

---

## PATCH-10: Service-Level Updates (MEDIUM)

**Goal**: All inventory services manage reservedQuantity and storedUnitId consistently.

| # | Item | Status | Files |
|---|------|--------|-------|
| 10.1 | `StockTransferService`: preserve storedUnitId on transfer | ⬜ | `stock_transfer_service.dart` |
| 10.2 | `ReturnService`: preserve storedUnitId on return | ⬜ | `return_service.dart` |
| 10.3 | `ProductionService`: use available quantity (with reserved) | ⬜ | `production_service.dart` |
| 10.4 | `ManufacturingService`: use available quantity | ⬜ | `manufacturing_service.dart` |
| 10.5 | `pos_bloc.dart`: use available quantity for stock check | ⬜ | `pos_bloc.dart` |
| | **Completion** | ⬜ | |

---

## PATCH-11: Refactoring & Cleanup (LOW)

**Goal**: Remove old systems, create migration, add integration tests.

| # | Item | Status | Files |
|---|------|--------|-------|
| 11.1 | Remove `UnitConversions` references from code | ⬜ | Multiple |
| 11.2 | Remove `isCarton` usage from code | ⬜ | `purchase_provider.dart` |
| 11.3 | Remove `cartonUnit`/`piecesPerCarton` from UI code | ⬜ | Multiple |
| 11.4 | Create Drift schema migration for existing DBs | ⬜ | `app_database.dart` |
| 11.5 | Remove duplicate FIFO logic in transaction_engine | ⬜ | `transaction_engine.dart` |
| 11.6 | Create integration test for multi-unit flow | ⬜ | `test/integration/` |
| 11.7 | Add `display_unit_id` to Products | ⬜ | Schema + code |
| 11.8 | Add `displayStock` to REST API | ⬜ | `rest_api_service.dart` |
| 11.9 | `beginning_of_period_page.dart` use TransactionEngine | ⬜ | UI file |
| 11.10 | `stock_operation_service.dart` use TransactionEngine | ⬜ | Service |
| | **Completion** | ⬜ | |

---

## MASTER SUMMARY

| Patch | Description | Priority | Completion |
|-------|-------------|----------|------------|
| PATCH-01 | Fix costPrice in autoBreak | HIGH | ✅ 100% |
| PATCH-02 | Add reservedQuantity | HIGH | ⚠️ 60% |
| PATCH-03 | Add storedUnitId + StockDisplayAdapter | MEDIUM | ✅ 100% |
| PATCH-04 | UI Display Improvements | MEDIUM | ⚠️ 21% |
| PATCH-05 | Deprecate Old Systems | LOW | ⚠️ 10% |
| PATCH-06 | Testing & Cleanup | MEDIUM | ⚠️ 50% |
| **PATCH-07** | **Fix autoBreak + reservedQuantity** | **🔴 CRITICAL** | **⬜ 0%** |
| **PATCH-08** | **Clean Up BROKEN Batches** | **🔴 CRITICAL** | **⬜ 0%** |
| **PATCH-09** | **Complete UI Display Overhaul** | **🟡 MEDIUM** | **⬜ 0%** |
| **PATCH-10** | **Service-Level Updates** | **🟡 MEDIUM** | **⬜ 0%** |
| **PATCH-11** | **Refactoring & Cleanup** | **🟢 LOW** | **⬜ 0%** |

**Overall Progress: 20%**
