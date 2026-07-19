# PATCH_PROGRESS.md

**Date**: 2026-07-19  
**Branch**: `main`

---

## Summary

| Metric | Value |
|--------|-------|
| Total patches | 11 (PATCH-01 through PATCH-11) |
| Fully complete | 3 (PATCH-01, PATCH-02, PATCH-03) |
| Partially complete | 3 (PATCH-04, PATCH-05, PATCH-06) |
| Currently in progress | 1 (PATCH-07) |
| Not started | 4 (PATCH-08, PATCH-09, PATCH-10, PATCH-11) |
| Overall progress | ~38% |

---

## PATCH-02: Add reservedQuantity to ProductBatches (HIGH)

**Goal**: Actively manage `reservedQuantity` to prevent BROKEN batch creation and enable partial sales.

| # | Item | Status | Evidence |
|---|------|--------|----------|
| 2.1 | `reservedQuantity` column added (schema + manual) | ✅ Complete | Schema + migrations |
| 2.2 | Availability checks in `inventory_costing_service` | ✅ Complete | `getBatchesForSale` filters by `(qty - reserved) > 0` |
| 2.3 | Availability checks in FIFO fallback | ✅ Complete | `transaction_engine.dart:424` reads `qty - reserved` |
| 2.4 | `_getAvailableQuantity` in packaging engine | ✅ Complete | `packaging_engine.dart:139` sums `qty - reserved` |
| 2.5 | `getWarehouseStock` in products_dao | ✅ Complete | `products_dao.dart:376` sums `qty - reserved` (PATCH-07) |
| **2.6** | **autoBreak uses reservedQuantity instead of BROKEN batches** | **✅ Complete** | `packaging_engine.dart:_breakOnePackage` now increments `reservedQuantity` instead of creating `BROKEN-*` batches |
| **2.7** | **Deduction paths decrement reservedQuantity** | **✅ Complete** | `transaction_engine.dart:369-380,429-440` — both costing service and FIFO paths decrement `reserved` when deducting from `quantity` |
| **2.8** | **Batch reload in while loop to prevent over-reservation** | **✅ Complete** | `packaging_engine.dart:71-84` — reloads batch each iteration to use current `reservedQuantity` |
| 2.9 | Tests | ✅ Complete | 10 tests in PATCH-02 group |
| | **Completion** | **✅ 100%** | |

### Test Coverage (2.6–2.8) — 10 tests in `auto_break_flow_test.dart`

| Test | What It Verifies |
|------|------------------|
| `autoBreak increments reservedQuantity instead of creating BROKEN batch` | qty unchanged, reserved incremented |
| `repeated breaks accumulate reservedQuantity` | 5 + 10 = 15, available = 45 |
| `reservedQuantity never exceeds batch quantity` | Guard prevents reserving beyond available |
| `deduction decrements reservedQuantity along with quantity` | Deduct 5 from (qty=60, reserved=5) → (55, 0) |
| `deduction clears reserved when deduct exceeds reserved` | Deduct 10 from (qty=60, reserved=3) → (50, 0) |
| `no BROKEN batch number generated when using reservedQuantity` | BROKEN prefix no longer produced |
| `full flow: reserve then deduct maintains consistency` | Reserve 5 → deduct 5 → qty=55, reserved=0 |
| `full flow: multiple reserves then partial deduction` | Reserve 10+20 → deduct 10 → deduct 20 → qty=90, reserved=0 |
| `deduction without prior reservation leaves reserved at zero` | No reservation, deduct 5 → qty=55, reserved=0 |

---

## PATCH-07: Fix autoBreak + reservedQuantity (CRITICAL)

**Goal**: Stop unnecessary BROKEN batch creation. Fix available quantity checks.

| # | Item | Status | Evidence |
|---|------|--------|----------|
| 7.1 | Fix `getWarehouseStock` to use `quantity - reservedQuantity` | ✅ Complete | `products_dao.dart:376` |
| 7.2 | Move autoBreak call inside validation (only when stock insufficient) | ✅ Complete | `transaction_engine.dart:328-357` |
| 7.3 | Calculate available qty correctly before deciding to break | ✅ Complete | `transaction_engine.dart:326-327,343` |
| 7.4 | Keep BROKEN batch creation as last resort only | ✅ Complete | Now uses `reservedQuantity` instead (PATCH-02) |
| **7.5** | **Update tests for new flow** | **✅ Complete** | `test/unit/auto_break_flow_test.dart` (11 tests) |
| | **Completion** | **✅ 100%** | |

---

## Compilation Issues

| File | Issue | Status |
|------|-------|--------|
| `lib/core/services/inventory_display_service.dart` | 2 unused imports (`AppConfigService`, `StockDisplayAdapter`) | ✅ Fixed — imports removed |
| `lib/core/services/packaging_engine.dart` | Unused `uuid` import | ✅ Fixed — removed |

**Static analysis**: `flutter analyze` — No issues found (0 issues across all modified files + tests).

---

## Files Modified This Session

| File | Change |
|------|--------|
| `lib/core/services/packaging_engine.dart` | `_breakOnePackage` uses `reservedQuantity` instead of creating `BROKEN-*` batches; removed unused `uuid` import; batch reload in while loop |
| `lib/core/services/transaction_engine.dart` | Costing service and FIFO deduction paths decrement `reservedQuantity` when deducting from `quantity` |
| `lib/core/services/inventory_display_service.dart` | Removed 2 unused imports |
| `test/unit/auto_break_flow_test.dart` | **Extended** — added 10 PATCH-02 tests (20 total) |

---

## Next Steps (Recommended Order)

| Priority | Patch | Action |
|----------|-------|--------|
| 🟡 MEDIUM | **PATCH-09** | Wire `StockDisplayAdapter` into `InventoryDisplayService` + update 31 remaining screens |
| 🟡 MEDIUM | **PATCH-10** | Update services (`StockTransferService`, `ReturnService`, `ProductionService`, etc.) |
| 🟢 LOW | **PATCH-11** | Remove old systems, create migration, integration tests |
| 🔴 CRITICAL | **PATCH-08** | Run `scripts/cleanup_broken_batches.sql` on live DB (requires DB path — skipped for now) |
