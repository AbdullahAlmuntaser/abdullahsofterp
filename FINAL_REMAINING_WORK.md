# FINAL_REMAINING_WORK.md

---

## Critical Issues (3)

| # | Issue | Files Affected | Current State | Requires |
|---|-------|---------------|---------------|----------|
| **CR-01** | **BROKEN batches still created by autoBreak** | `packaging_engine.dart:96-154`, `transaction_engine.dart:341-345` | ❌ Not fixed | Redesign: autoBreak should use reservedQuantity instead of creating BROKEN batches. Need to increment `batch.reservedQuantity` and only decrement `quantity` on post. |
| **CR-02** | **reservedQuantity never actively managed** | `transaction_engine.dart:348-438` | ❌ Not fixed | Redesign: reservedQuantity is only used as a filter (read-only). It should be incremented during sale and decremented on post. PATCH_PLAN.md described this but it wasn't implemented. |
| **CR-03** | **Old BROKEN batches still exist in DB** | All batch-related queries, FIFO, COGS | ❌ Not fixed | Patch: Run `cleanup_broken_batches.sql`. Create backfill script. Old batches have wrong costPrice. |

---

## High Issues (5)

| # | Issue | Files Affected | Current State | Requires |
|---|-------|---------------|---------------|----------|
| **HI-01** | **getWarehouseStock (Drift) ignores reservedQuantity** | `products_dao.dart:367-378` | ❌ Not fixed | Fix: Subtract reservedQuantity from sum. Also used in transaction_engine validation. |
| **HI-02** | **31+ screens still display raw stock** | 31 files listed in PATCH_04 | ❌ Not fixed | Patch: Systematically replace `product.stock.toString()` with `adapter.formatProductStock()`. |
| **HI-03** | **No display_unit_id on Products table** | `app_database.dart` | ❌ Not fixed | Add: Missing column for preferred display unit. Proposed in MULTI_UNIT_REFACTOR_PLAN. |
| **HI-04** | **No database migration for existing DBs** | N/A | ❌ Not fixed | Create: Migration path for SQLCipher databases. Schema changes exist but no upgrade path. |
| **HI-05** | **BROKEN batches still affect FIFO, COGS, Inventory Reports** | `inventory_costing_service.dart`, all reports | ⚠️ Partially | Redesign: Filter BROKEN batches from reporting queries, or clean them up. |

---

## Medium Issues (7)

| # | Issue | Current State | Requires |
|---|-------|---------------|----------|
| **ME-01** | `StockTransferService` doesn't use reservedQuantity or storedUnitId | ❌ Not fixed | Patch: Update stock transfer to preserve batch context |
| **ME-02** | `ReturnService` doesn't preserve storedUnitId on return | ❌ Not fixed | Patch: Copy storedUnitId from original batch |
| **ME-03** | `ProductionService` / `ManufacturingService` don't use reservedQuantity | ❌ Not fixed | Patch: Add availability checks |
| **ME-04** | `InventoryDisplayService` not using StockDisplayAdapter | ❌ Not fixed | Patch: Wire adapter into display service |
| **ME-05** | `pos_bloc.dart` stock comparison uses raw stock | ❌ Not fixed | Patch: Use available quantity instead of raw stock |
| **ME-06** | Old unit systems still referenced (`UnitConversions`, `isCarton`) | ⚠️ Partially | Refactor: Remove references and unify on ProductUnits |
| **ME-07** | Fallback FIFO in transaction_engine doesn't use costing service | ❌ Not fixed | Refactor: Remove duplicate FIFO logic, always use costing service |

---

## Low Issues (5)

| # | Issue | Current State | Requires |
|---|-------|---------------|----------|
| **LO-01** | `beginning_of_period_page.dart` writes stock directly | ❌ Not fixed | Refactor: Use TransactionEngine instead |
| **LO-02** | `stock_operation_service.dart` writes stock/batch directly | ❌ Not fixed | Refactor: Use TransactionEngine |
| **LO-03** | `financial_control_service.dart` writes stock directly | ❌ Not fixed | Refactor: Use TransactionEngine |
| **LO-04** | REST API returns raw stock only | ❌ Not fixed | Enhancement: Add `displayStock` field |
| **LO-05** | No integration test for multi-unit flow | ❌ Not fixed | Create: End-to-end test |

---

## Summary by Priority

| Priority | Fixed | Partially Fixed | Not Fixed |
|----------|-------|-----------------|-----------|
| Critical | 0 | 0 | 3 |
| High | 1 (PATCH-01) | 1 (PATCH-04) | 3 |
| Medium | 0 | 2 (PATCH-02, PATCH-05) | 5 |
| Low | 0 | 0 | 5 |
| **Total** | **1** | **3** | **16** |
