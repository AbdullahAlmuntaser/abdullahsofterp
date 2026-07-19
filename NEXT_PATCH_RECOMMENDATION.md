# NEXT_PATCH_RECOMMENDATION.md

## Recommended Patch Order Based on Current State

### PATCH-07 (Immediate - HIGH priority): Fix autoBreak + reservedQuantity

**Goal**: Stop BROKEN batch creation. Use reservedQuantity properly.

**Changes**:
1. In `transaction_engine.dart:postSale`: Instead of calling `autoBreakIfNecessary` then deducting from quantity, increment `reservedQuantity` on batches. Only call autoBreak when available quantity < required.
2. Add "post" step at end of transaction: convert reservedQuantity → quantity deduction.
3. Fix `products_dao.dart:getWarehouseStock` to subtract `reservedQuantity`.

**Files**: `transaction_engine.dart`, `packaging_engine.dart`, `products_dao.dart`

**Fixes**: CR-02, CR-03 (prevents new BROKEN batches)

**Risk**: HIGH - Changes core transaction logic. Keep feature flag.

### PATCH-08 (HIGH priority): Clean up existing BROKEN batches

**Goal**: Remove all existing BROKEN batches from database.

**Changes**:
1. Run `scripts/cleanup_broken_batches.sql` (merge quantity back to parent, delete BROKEN records).
2. Backfill costPrice on any remaining orphaned batches.

**Files**: N/A (SQL script)

**Fixes**: CR-03

### PATCH-09 (MEDIUM priority): Complete UI display overhaul

**Goal**: All 31 remaining screens use StockDisplayAdapter.

**Changes**:
1. Wire `StockDisplayAdapter` into `InventoryDisplayService` as the central service.
2. Replace `product.stock.toString()` in all screens.
3. Add `display_unit_id` to `Products` table.

**Files**: 31 UI files + `InventoryDisplayService`

**Fixes**: HI-02, ME-04, HI-03

### PATCH-10 (MEDIUM priority): Service-level updates

**Goal**: All inventory services use reservedQuantity and storedUnitId consistently.

**Changes**:
1. `StockTransferService`: preserve storedUnitId on transfer.
2. `ReturnService`: preserve storedUnitId on return.
3. `ProductionService`/`ManufacturingService`: use available quantity (with reserved).
4. `pos_bloc.dart`: use available quantity for stock check.

**Files**: `stock_transfer_service.dart`, `return_service.dart`, `production_service.dart`, `manufacturing_service.dart`, `pos_bloc.dart`

**Fixes**: ME-01, ME-02, ME-03, ME-05

### PATCH-11 (LOW priority): Refactoring & Cleanup

**Goal**: Remove old systems, create migration, add integration tests.

**Changes**:
1. Remove `UnitConversions` references, `isCarton`, `cartonUnit`/`piecesPerCarton`.
2. Create actual DB migration (Drift schema migration).
3. Create integration test for full multi-unit flow.
4. Add REST API display fields.

**Files**: Multiple

**Fixes**: ME-06, LO-01 through LO-05, HI-04, ME-07

---

## Execution Timeline

```
Week 1:  PATCH-07 (Fix reservedQuantity usage)        🔴 CRITICAL
         PATCH-08 (Clean up existing BROKEN batches)   🔴 CRITICAL
Week 2:  PATCH-09 (UI display overhaul)                🟡 MEDIUM
Week 3:  PATCH-10 (Service-level updates)              🟡 MEDIUM
Week 4:  PATCH-11 (Refactoring + Migration + Tests)    🟢 LOW
```

---

## Regret Analysis

**If we stop now**:
- `costPrice` bug is fixed → COGS calculations are safe going forward ✅
- New batches store unit context ✅
- 31 screens still display confusing raw stock numbers ❌
- BROKEN batches still being created (and multiplying daily) ❌
- reservedQuantity is a dead column (read but never written) ❌
- No migration path for existing databases ❌

**Minimum viable stopping point**: PATCH-07 + PATCH-08 must be completed.
