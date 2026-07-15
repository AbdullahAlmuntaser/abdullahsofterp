# ERP Multi-Unit, POS, Inventory & Safe Refactoring Analysis
## SystemMarket ERP — Architectural Deep-Dive & Migration Plan

---

## PART 1: EXECUTIVE SUMMARY

### Current State

SystemMarket ERP has **3 competing unit systems** and a **PackagingEngine** that creates physical inventory movements (`BROKEN-` batches) for what should be a display-only concern. This creates data integrity risks, complicates costing, and deviates from the principle "store in base unit only".

### Key Findings (TL;DR)

| Finding | Severity | Impact |
|---------|----------|--------|
| 3 competing unit systems (ProductUnits, UnitConversions, Products.piecesPerCarton) | CRITICAL | Inconsistent conversion factors |
| PackagingEngine._breakOnePackage() creates physical BROKEN- batches | HIGH | Unnecessary stock movements |
| ReturnService bypasses PostingEngine | HIGH | Risk of unbalanced GL entries |
| ReturnItemData has no unitFactor | HIGH | Returns apply wrong quantities |
| ErpLogic.hasEnoughStock() uses piecesPerCarton (int) instead of unitFactor | MEDIUM | Incompatible with Decimal |
| formatInventory() uses UnitConversions table, not ProductUnits | MEDIUM | Display inconsistent |
| No Products.stock == SUM(ProductBatches.quantity) validation | MEDIUM | Data integrity gap |
| No Inventory Ledger == GL Inventory reconciliation | LOW | Financial audit gap |

### Architectural Rule (MUST PRESERVE)

**DO** store ALL quantities in base units only (e.g., pieces, not cartons).
**DO** convert to commercial units (cartons, boxes) ONLY for display.
**DO NOT** create physical BROKEN- batches for display purposes.
**DO** unify unit definitions under a single source of truth (ProductUnits table).

---

## PART 2: CURRENT BEHAVIOR ANALYSIS

### 2.1 Purchase Flow — Unit Handling (CORRECT)

```
User enters: "10 Cartons" (unitFactor = 20, so 1 carton = 20 pieces)
PurchaseItems.quantity = 10
PurchaseItems.unitFactor = 20

TransactionEngine.postPurchase() [transaction_engine.dart:140-203]:
  Line 157: qtyInBaseUnit = 10 * 20 = 200  ✓
  Line 170: ProductBatches.quantity = 200     ✓ stored in base units
  Line 199: Products.stock += 200             ✓
  Line 173: costPrice = (purchasePrice / 20)  ✓ cost per piece
```

### 2.2 Sale Flow — Unit Handling (CORRECT conversion, PROBLEMATIC packaging)

```
POS: User scans "Carton" barcode (unitFactor = 20)
CartItem.quantity = 1, CartItem.unitFactor = 20

TransactionEngine.postSale() [transaction_engine.dart:293-431]:
  Line 313: remainingToDeduct = 1 * 20 = 20  ✓
  Line 335: packagingEngine.autoBreakIfNecessary()  ← PROBLEM
  Lines 347-424: Deduct 20 from batches via FIFO   ✓
  Line 376/429: Products.stock -= 20               ✓
```

**The unit conversion is correct.** But `autoBreakIfNecessary()` physically breaks packages before deduction — this is unnecessary in a base-unit system.

### 2.3 Return Flow — Unit Handling (BROKEN)

```dart
// lib/core/services/return_service.dart:315-325
class ReturnItemData {
  final String productId;
  final double quantity;    // ← unit ambiguous: base or commercial?
  final double price;       // ← no unitFactor!
}
```

In `processSalesReturn()` [line 63]:
```dart
stock: Value(product.stock + item.quantity)
// If caller passes 2 (meaning 2 cartons = 40 pieces),
// only 2 pieces are added back → DATA CORRUPTION
```

In `processPurchaseReturn()` [line 226]:
```dart
stock: Value(product.stock - item.quantity)
// Same ambiguity issue
// Additionally: remainingToDeduct = item.quantity (line 230)
// No unitFactor means no base unit conversion
```

### 2.4 PackagingEngine Flow — The Core Problem

```
autoBreakIfNecessary(productId, warehouseId, requiredQtyInBase):
  1. Get packaging hierarchy from ProductUnits table
  2. Get total available quantity for product in warehouse
  3. If available >= required: return early (most cases)
  4. If NOT enough: physically break cartons into pieces
     _breakOnePackage(batch, unit, actualDeduction)
       → Creates NEW batch: "BROKEN-" + uuid
       → Deducts packageSize from source batch
       → Records PACKAGE_BREAK inventory transaction
       → Posts AVCO recalculation GL entry
```

**WHY this is wrong in a base-unit system:**
- All stock is already stored as pieces (base units)
- No physical "breaking" is needed
- The engine creates REAL inventory movements for a DISPLAY concern
- The BROKEN- batches clutter the batch table
- The PACKAGE_BREAK transactions add noise to inventory ledger

### 2.5 Display Conversion — Fragmented Sources

| Function | Table Used | Location |
|----------|-----------|----------|
| PackagingEngine.formatInventoryBalance() | ProductUnits | packaging_engine.dart:183-221 |
| AutoBreakService.getInventoryBreakdown() | ProductUnits | auto_break_service.dart:217-258 |
| ErpLogic.formatInventory() | UnitConversions | erp_logic.dart:92-124 |
| ErpLogic.hasEnoughStock() | Products.piecesPerCarton | erp_logic.dart:81-89 |

**Three different data sources for the same business concept.**

---

## PART 3: PROBLEMS FOUND

### 3.1 Critical Problems

#### P1: ReturnItemData has no unitFactor
| File | Lines |
|------|-------|
| return_service.dart | 315-325 |

**Impact**: Returns apply wrong quantities. If a sale was for 1 carton (20 pieces), returning "1" might only return 1 piece instead of 20.

**Root Cause**: ReturnItemData was designed before multi-unit support was added to the system.

---

#### P2: ReturnService bypasses PostingEngine
| File | Lines |
|------|-------|
| return_service.dart | 97-166, 257-300 |

**Impact**: No period validation, no posting profiles, no double-entry validation for return GL entries. The TransactionEngine already has `postSaleReturn()` and `postPurchaseReturn()` methods, but ReturnService doesn't use them.

**Root Cause**: ReturnService was built before TransactionEngine/PostingEngine were unified.

---

#### P3: PackagingEngine creates physical BROKEN- batches
| File | Lines |
|------|-------|
| packaging_engine.dart | 94-147 (_breakOnePackage) |
| packaging_engine.dart | 173-181 (_postPackagingBreakGL) |

**Impact**: Unnecessary inventory movements, batch table bloat, FIFO complications, potential data drift.

**Root Cause**: The engine was designed for a physical retail model where cartons physically need to be opened. In a base-unit storage system, this is irrelevant.

---

#### P4: Three competing unit systems
| System | Table | Files Using It |
|--------|-------|---------------|
| ProductUnits (unitFactor: Decimal) | product_units | PackagingEngine, AutoBreakService, PosBloc |
| UnitConversions (factor: Decimal) | unit_conversions | ErpLogic, UnitConversionPage |
| Products legacy (piecesPerCarton: int) | products | ErpLogic.hasEnoughStock, BOM |

**Impact**: Inconsistent conversion factors across features.

---

### 3.2 Medium Problems

#### P5: processPurchaseReturn stock sign ambiguity
| File | Line |
|------|------|
| return_service.dart | 226 |

```dart
stock: Value(product.stock - item.quantity)
```
Semantically correct (stock decreases when returning to supplier), but unit is ambiguous.

#### P6: ErpLogic.hasEnoughStock() uses int piecesPerCarton
| File | Line |
|------|------|
| erp_logic.dart | 87 |

Cannot handle Decimal unitFactor. Only works with boolean `isCarton`.

#### P7: Hardcoded Arabic labels in formatInventoryBalance()
| File | Line |
|------|------|
| packaging_engine.dart | 208-210 |

```dart
final baseUnitSynonyms = {'حبة', 'piece', 'pcs', 'unit'};
```
Not localized, fragile matching.

### 3.3 Minor Problems

#### P8: No data integrity validation
No automated checks exist for:
- Products.stock == SUM(ProductBatches.quantity)
- GL Inventory balance == Inventory valuation (sum of batches * costPrice)

---

## PART 4: ROOT CAUSE ANALYSIS

### RC1: Evolutionary Architecture — 3-Phase Unit System

**Phase 1**: Simple Products.cartonUnit/piecesPerCarton (int-based, one commercial unit).
**Phase 2**: UnitConversions table with flexible Decimal factor. Used by reports and purchase pages.
**Phase 3**: ProductUnits table with unitFactor for POS multi-unit support.

Each phase added a NEW system without removing the OLD one.

### RC2: PackagingEngine — Solving a Non-Existent Problem

In a physical retail store:
- "I have 1 carton (24 pieces). Customer wants 1 piece."
- You OPEN the carton, take 1 piece, 23 remain as "broken" stock.
- This requires a physical operation.

In a base-unit ERP system:
- "I have 24 pieces. Customer wants 1 piece."
- Deduct 1 piece. 23 remain.
- NO physical operation needed.

**The PackagingEngine.autoBreakIfNecessary() is unnecessary when everything is stored in base units.**

### RC3: ReturnService — Pre-Dates Engine Unification

The ReturnService was written before TransactionEngine had postSaleReturn/postPurchaseReturn methods. It duplicates GL entry logic that PostingEngine already handles.

---

## PART 5: DEPENDENCY GRAPH

### 5.1 PackagingEngine Dependency Graph

```
PackagingEngine (packaging_engine.dart)
│
├── DEPENDS ON:
│   ├── AppDatabase (SQL queries)
│   ├── ProductBatches (read/write BROKEN- batches)
│   ├── Products (stock reads)
│   ├── ProductUnits (packaging hierarchy)
│   └── InventoryCostingService (AVCO recalculation)
│
├── USED BY (DIRECT CALLERS):
│   ├── TransactionEngine.postSale() [line 335]
│   │   └── autoBreakIfNecessary() called per-item before batch deduction
│   ├── AutoBreakService.autoBreakForSale() [line 168]
│   └── PosProductCard (via Provider) [line 19]
│
├── USED BY (DISPLAY ONLY):
│   ├── CartWidget (formatInventoryBalance)
│   └── SmartStockWidget (formatInventoryBalance)
│
└── AFFECTED BY REMOVAL:
    ├── core_module.dart:97 — DI registration
    ├── core_module.dart:111 — TransactionEngine injection
    ├── hr_module.dart:26 — AutoBreakService injection
    └── injection_container.dart:249,337 — Provider registrations
```

### 5.2 AutoBreakService Dependency Graph

```
AutoBreakService (auto_break_service.dart)
│
├── DEPENDS ON:
│   ├── PackagingEngine (wraps autoBreakIfNecessary)
│   ├── AppDatabase (ProductUnits queries)
│   └── ProductUnitsDao
│
├── USED BY:
│   ├── Currently unused in core business flows
│   └── Registered in DI (hr_module.dart:26)
│
└── AFFECTED BY REMOVAL:
    └── hr_module.dart:26 — Remove registration
```

### 5.3 ReturnService Dependency Graph

```
ReturnService (return_service.dart)
│
├── DEPENDS ON:
│   ├── AppDatabase (direct SQL/Drift queries)
│   ├── SalesReturns table
│   ├── PurchaseReturns table
│   ├── ProductBatches (return stock)
│   ├── Products (update stock)
│   └── AccountingDao (direct GL entry creation)
│
├── USED BY:
│   ├── POS return flow (via Bloc)
│   ├── Sales return pages
│   └── Purchase return pages
│
└── BYPASSES:
    ├── TransactionEngine.postSaleReturn()  [line ~600]
    ├── TransactionEngine.postPurchaseReturn()  [line ~700]
    └── PostingEngine (creates entries without posting profiles)
```

### 5.4 Unit System Fragmentation Graph

```
┌───────────────────────────────┐
│ ProductUnits table            │
│ unitFactor: Decimal           │
│ unitName: String              │
│ barcode: String               │
│ prices: Decimal               │
├───────────────────────────────┤
│ USED BY:                      │
│ - PackagingEngine             │
│ - AutoBreakService            │
│ - PosBloc (unit selection)    │
│ - SaleItems.unitFactor        │
│ - PurchaseItems.unitFactor    │
└───────────┬───────────────────┘
            │
            ▼ (single source of truth candidate)
┌───────────────────────────────┐
│ UnitConversions table         │
│ factor: Decimal               │
│ unitName: String              │
│ isBaseUnit: bool              │
├───────────────────────────────┤
│ USED BY:                      │
│ - ErpLogic.formatInventory()  │
│ - UnitConversionService       │
│ - UnitConversionPage (UI)     │
└───────────────────────────────┘

┌───────────────────────────────┐
│ Products legacy columns       │
│ cartonUnit: String            │
│ piecesPerCarton: int          │
│ kiloUnit: String?             │
│ boxUnit: String?              │
├───────────────────────────────┤
│ USED BY:                      │
│ - ErpLogic.hasEnoughStock()   │
│ - BOM domain entity           │
└───────────────────────────────┘

THREE SEPARATE SYSTEMS — NOT SYNCHRONIZED
```

---

## PART 6: SAFE SOLUTION

### 6.1 Solution Overview

| Phase | Description | Risk | Timeline |
|-------|-------------|------|----------|
| 0 | Pre-migration audit (validate data integrity) | None | Day 1 |
| 1 | Create InventoryDisplayService (display-only) | None | Day 1-2 |
| 2 | Unify unit system under ProductUnits | Low-Medium | Day 3-5 |
| 3 | Remove autoBreakIfNecessary from TransactionEngine | HIGH | Day 6-7 |
| 4 | Fix ReturnService with unitFactor | HIGH | Day 8-10 |
| 5 | Cleanup PackagingEngine and legacy code | Low | Day 11-12 |

### 6.2 PRD: InventoryDisplayService

```
NEW SERVICE: InventoryDisplayService
FILE: lib/core/services/inventory_display_service.dart
PURPOSE: Convert base units to display format ONLY
RULE: NEVER writes to database, NEVER creates batches

Methods:

1. formatForDisplay(baseQty: Decimal, productId: String) → String
   Input:  135 (pieces), product "Water"
   Output: "6 Cartons + 15 Pieces"  or  "6.75 Cartons"
   Source: ProductUnits table (single truth)

2. getUnitBreakdown(baseQty: Decimal, productId: String)
       → List<UnitBreakdown>
   Input:  135
   Output: [{unit: "Carton", qty: 6}, {unit: "Piece", qty: 15}]

3. suggestBestUnit(baseQty: Decimal, productId: String) → ProductUnit
   Input:  135
   Output: {unitName: "Carton", unitFactor: 20}
   (largest unit with factor <= quantity)
```

### 6.3 ReturnItemData Fix

```dart
// CHANGED
class ReturnItemData {
  final String productId;
  final Decimal quantity;           // was: double
  final Decimal unitFactor;         // NEW
  final Decimal price;

  Decimal get qtyInBaseUnit => quantity * unitFactor;  // NEW helper

  ReturnItemData({
    required this.productId,
    required this.quantity,
    required this.price,
    this.unitFactor = Decimal.one,  // default: 1 = backward compatible
  });
}
```

### 6.4 TransactionEngine.postSale() — Remove autoBreakIfNecessary

```dart
// CURRENT (transaction_engine.dart ~335):
await packagingEngine.autoBreakIfNecessary(
  productId: item.productId,
  warehouseId: sale.warehouseId ?? '',
  requiredQtyInBase: remainingToDeduct,
);

// CHANGE TO: nothing — remove these lines entirely.
// WHY: Not needed. Batches can be partially deducted via FIFO.
// RISK: LOW — FIFO deduction already handles partial quantities.
```

### 6.5 ErpLogic.hasEnoughStock() Fix

```dart
// CURRENT:
static bool hasEnoughStock(Product product, Quantity requestedQty, bool isCarton) {
  final actualQty = isCarton ? requestedQty * product.piecesPerCarton : requestedQty;
  return product.stock >= actualQty.value;
}

// CHANGE TO:
static bool hasEnoughStock(Product product, Quantity requestedQty, Decimal unitFactor) {
  final actualQty = requestedQty * unitFactor;
  return product.stock >= actualQty.value;
}
```

### 6.6 ErpLogic.formatInventory() — Migrate to ProductUnits

```dart
// CURRENT: uses UnitConversions table
static String formatInventory({required Quantity totalBaseQty, ...}) {
  // ... uses UnitConversion with factor field
}

// CHANGE TO: use ProductUnits like PackagingEngine does
static String formatInventory({required Quantity totalBaseQty, ...}) {
  // ... use ProductUnit with unitFactor field
  // Data source: ProductUnits table (unified)
}
```

---

## PART 7: MIGRATION PLAN

### Phase 0 — Pre-Migration Data Validation

Run these validation queries BEFORE any code changes.

```sql
-- Check 1: Products.stock == SUM(ProductBatches.quantity)
SELECT p.id, p.name, p.stock AS expected,
       COALESCE(SUM(pb.quantity), 0) AS actual,
       (p.stock - COALESCE(SUM(pb.quantity), 0)) AS diff
FROM products p
LEFT JOIN product_batches pb ON p.id = pb.product_id
GROUP BY p.id
HAVING diff != 0;

-- Check 2: GL Inventory (account 1040) vs Inventory Valuation
SELECT
  (SELECT SUM(debit - credit) FROM gl_lines WHERE account_id IN
    (SELECT id FROM gl_accounts WHERE code = '1040')) AS gl_balance,
  (SELECT SUM(pb.quantity * pb.cost_price) FROM product_batches) AS inv_value;
```

### Phase 1 — InventoryDisplayService (No Regression Risk)

| Step | Description | Risk | Files |
|------|-------------|------|-------|
| 1.1 | Create InventoryDisplayService class | None | NEW file |
| 1.2 | Register in DI container | None | injection_container.dart |
| 1.3 | Add UnitBreakdown model | None | NEW model |

### Phase 2 — Unify Unit System

| Step | Description | Risk | Files |
|------|-------------|------|-------|
| 2.1 | Migrate ErpLogic.hasEnoughStock() to unitFactor param | Low | erp_logic.dart:87 |
| 2.2 | Migrate ErpLogic.formatInventory() to ProductUnits | Medium | erp_logic.dart:92-124 |
| 2.3 | Replace formatInventoryBalance() calls with InventoryDisplayService | Low | cart_widget.dart, smart_stock_widget.dart |
| 2.4 | Deprecate Products.cartonUnit/piecesPerCarton in UI forms | Low | product_forms |

### Phase 3 — Disable PackagingEngine Breaking (HIGH RISK)

| Step | Description | Risk | Files |
|------|-------------|------|-------|
| 3.1 | Remove autoBreakIfNecessary() from postSale() | HIGH | transaction_engine.dart:335 |
| 3.2 | Remove autoBreakIfNecessary() from autoBreakForSale() | Low | auto_break_service.dart:168 |
| 3.3 | Remove _breakOnePackage() and _postPackagingBreakGL() | Medium | packaging_engine.dart:94-181 |

### Phase 4 — Fix ReturnService (HIGH RISK)

| Step | Description | Risk | Files |
|------|-------------|------|-------|
| 4.1 | Add unitFactor to ReturnItemData | HIGH | return_service.dart:315-325 |
| 4.2 | Use qtyInBaseUnit in processSalesReturn | Medium | return_service.dart:25-88 |
| 4.3 | Use qtyInBaseUnit in processPurchaseReturn | Medium | return_service.dart:179-255 |
| 4.4 | Delegate to TransactionEngine.postSaleReturn/postPurchaseReturn | HIGH | return_service.dart |

### Phase 5 — Cleanup

| Step | Description | Risk | Files |
|------|-------------|------|-------|
| 5.1 | Remove PackagingEngine from DI (if unused) | Medium | core_module.dart |
| 5.2 | Remove AutoBreakService from DI | Low | hr_module.dart |
| 5.3 | Remove legacy fields from product forms | Low | product_forms |

---

## PART 8: REGRESSION RISKS & MITIGATION

### HIGH Risk Changes

| Change | Risk | Mitigation |
|--------|------|------------|
| Remove autoBreakIfNecessary from postSale() | If any batch has quantity < remainingToDeduct but total batches >= remainingToDeduct, sale may fail | Test: FIFO already deducts across multiple batches. This should NOT break. |
| Add unitFactor to ReturnItemData | All callers must pass unitFactor | Set default Decimal.one for backward compatibility |
| Delegate ReturnService to TransactionEngine | Double GL entries if both run | Remove old GL code from ReturnService first |

### MEDIUM Risk Changes

| Change | Risk | Mitigation |
|--------|------|------------|
| Replace formatInventoryBalance with InventoryDisplayService | Different output format | Match exact output format |
| Remove _postPackagingBreakGL() | AVCO batches lose one recalculation point | AVCO recalculates on every sale anyway |
| Change ErpLogic.hasEnoughStock() signature | All callers must update | Add backward-compatible overload or default param |

### LOW Risk Changes

| Change | Risk | Mitigation |
|--------|------|------------|
| Deprecate Products.cartonUnit/piecesPerCarton | Legacy UI may show empty | Keep field but mark deprecated |
| Remove AutoBreakService from DI (Phase 5) | Easy to revert | Keep it registered but orphaned first |

---

## PART 9: REQUIRED CODE CHANGES (Minimal Set)

### Change 1: InventoryDisplayService — NEW FILE

**lib/core/services/inventory_display_service.dart**

```dart
class InventoryDisplayService {
  final AppDatabase db;
  InventoryDisplayService(this.db);

  /// Converts base-unit qty to display string. NEVER writes to DB.
  Future<String> formatForDisplay({
    required Decimal baseQty,
    required String productId,
  }) async {
    if (baseQty <= Decimal.zero) return '0 ${await _getBaseUnitName(productId)}';
    final units = await _getPackagingUnits(productId);
    final breakdown = _calculateBreakdown(baseQty, units);
    return _formatBreakdown(breakdown);
  }

  /// Returns structured unit breakdown for UI widgets.
  Future<List<UnitBreakdown>> getUnitBreakdown({
    required Decimal baseQty,
    required String productId,
  }) async {
    final units = await _getPackagingUnits(productId);
    return _calculateBreakdown(baseQty, units);
  }
}
```

### Change 2: ReturnItemData — Add unitFactor

**lib/core/services/return_service.dart**

```dart
class ReturnItemData {
  final String productId;
  final Decimal quantity;
  final Decimal unitFactor;      // ← NEW
  final Decimal price;

  Decimal get qtyInBaseUnit => quantity * unitFactor;  // ← NEW

  ReturnItemData({
    required this.productId,
    required this.quantity,
    required this.price,
    this.unitFactor = Decimal.one,  // ← backward compatible default
  });
}
```

### Change 3: Remove packagingEngine.autoBreakIfNecessary()

**lib/core/services/transaction_engine.dart:335**

```
// DELETE lines 334-339 (7 lines):
// await packagingEngine.autoBreakIfNecessary(
//   productId: item.productId,
//   warehouseId: sale.warehouseId ?? '',
//   requiredQtyInBase: remainingToDeduct,
// );
```

### Change 4: ReturnService — Use qtyInBaseUnit

**lib/core/services/return_service.dart**

```dart
// Line 63-64 (processSalesReturn):
stock: Value(product.stock + item.qtyInBaseUnit),    // was: + item.quantity

// Line 80-82 (processSalesReturn batch update):
quantity: Value(latestBatch.quantity + item.qtyInBaseUnit),  // was: + item.quantity

// Line 225-226 (processPurchaseReturn):
stock: Value(product.stock - item.qtyInBaseUnit),    // was: - item.quantity

// Line 249-251 (processPurchaseReturn batch update):
quantity: Value(batch.quantity - item.qtyInBaseUnit), // was: - item.quantity

// Line 230 (processPurchaseReturn):
Decimal remainingToDeduct = item.qtyInBaseUnit;       // was: item.quantity
```

### Change 5: ErpLogic.hasEnoughStock() — Use unitFactor

**lib/core/utils/erp_logic.dart:81-89**

```dart
// REPLACE:
static bool hasEnoughStock(Product product, Quantity requestedQty, bool isCarton) {
  final actualQty = isCarton ? requestedQty * product.piecesPerCarton : requestedQty;
  return product.stock >= actualQty.value;
}

// WITH:
static bool hasEnoughStock(Product product, Quantity requestedQty, Decimal unitFactor) {
  final actualQty = requestedQty * unitFactor;
  return product.stock >= actualQty.value;
}
```

---

## PART 10: TEST SCENARIOS

### Scenario 1 — Full Cycle: Purchase → Sell → Return

**Setup:**
```
Product: Water
Base Unit: Piece (unitFactor = 1)
Carton: unitFactor = 20
Carton barcode: "2001", Piece barcode: "2002"
Prices: Carton Wholesale = 1600, Carton Retail = 1700, Piece Retail = 100
Purchase Cost: 1500/carton = 75/piece
```

**Steps:**
| # | Operation | Input | Expected Stock | Expected COGS |
|---|-----------|-------|---------------|---------------|
| 1 | Purchase | 10 Cartons @ 1500 | 200 pieces | — |
| 2 | Sell | 1 Piece @ 100 | 199 | 75 |
| 3 | Sell | 1 Carton @ 1600 (wholesale) | 179 | 1500 (20x75) |
| 4 | Return | 1 Piece from sale #2 | 180 | COGS reversed: 75 |
| 5 | Return | 1 Carton from sale #3 | 200 | COGS reversed: 1500 |

**Verification SQL:**
```sql
SELECT p.stock == SUM(pb.quantity) FROM products p
JOIN product_batches pb ON p.id = pb.product_id GROUP BY p.id;
-- Expected: TRUE (all discrepancies = 0)

SELECT SUM(debit - credit) FROM gl_lines WHERE account_id IN
  (SELECT id FROM gl_accounts WHERE code = '5010');  -- COGS
-- Expected: 0 (fully reversed)
```

### Scenario 2 — Multiple FIFO Batches Costing

**Setup:**
```
Batch A: 100 pieces @ 50 (purchased Jan 1)
Batch B: 100 pieces @ 75 (purchased Jan 15)
```

**Steps:**
1. Sell 150 pieces
   - 100 from Batch A (cost 5000) + 50 from Batch B (cost 3750)
   - Total COGS = 8750
   - Remaining: Batch A = 0, Batch B = 50

**Verification:**
```
COGS = 8750
Products.stock = 50
Batch B.quantity = 50
```

### Scenario 3 — Barcode + Multi-Unit + Price List

**Setup:**
```
Carton barcode "2001" → unitFactor=20, wholesale=1600, retail=1700
Piece barcode "2002" → unitFactor=1, retail=100
```

**Steps:**
1. Scan "2001" (wholesale mode) → 1 carton @ 1600
2. Scan "2002" → 1 piece @ 100
3. Checkout
   - Stock deduct = 20 + 1 = 21 pieces
   - Revenue = 1600 + 100 = 1700
   - COGS = 21 * avg cost

### Scenario 4 — Data Integrity (MUST PASS after EVERY operation)

```dart
// 1. Products.stock == SUM(ProductBatches.quantity) per product
// 2. GL Inventory == ProductBatches valuation
// 3. No BROKEN- batches exist (after Phase 3-5 cleanup)
// 4. All ReturnItemData have unitFactor populated
```

### Scenario 5 — Display Only (NO Data Modification)

```
Input: Products.stock = 135, ProductUnits = [{Piece,1}, {Carton,20}]
Output: "6 Cartons + 15 Pieces"
Database state: UNCHANGED
  → Products.stock still = 135
  → No StockMovements created
  → No ProductBatches created
  → No BROKEN- batches
```

---

## PART 11: WHAT WE CHANGE vs WHAT WE DO NOT CHANGE

### We WILL Change

| File | Change | Risk | Phase |
|------|--------|------|-------|
| NEW inventory_display_service.dart | Create display-only service | None | 1 |
| injection_container.dart | Register InventoryDisplayService | None | 1 |
| erp_logic.dart:87 | Use unitFactor param (not piecesPerCarton) | Low | 2 |
| erp_logic.dart:92-124 | Use ProductUnits (not UnitConversions) | Medium | 2 |
| transaction_engine.dart:335 | Remove autoBreakIfNecessary() call | HIGH | 3 |
| packaging_engine.dart:94-181 | Remove _breakOnePackage and _postPackagingBreakGL | Medium | 3 |
| return_service.dart:315-325 | Add unitFactor to ReturnItemData | HIGH | 4 |
| return_service.dart:63,80,225,249 | Convert to qtyInBaseUnit | HIGH | 4 |

### We WILL NOT Change

- ❌ Products.stock storage method (always base units)
- ❌ ProductBatches.quantity storage method
- ❌ FIFO/AVCO/LIFO costing logic in InventoryCostingService
- ❌ PostingEngine GL entry creation
- ❌ POS unit selection UX in PosBloc
- ❌ Database schema for core tables (no migrations needed)
- ❌ SaleItems/PurchaseItems table structure (unitFactor already exists)

---

## PART 12: DATA INTEGRITY VALIDATOR

Add this to **SystemAuditor** (lib/core/services/system_auditor.dart) or create a dedicated `DataIntegrityValidator`:

```dart
class StockDiscrepancy {
  final String productId;
  final String productName;
  final Decimal productsStock;
  final Decimal batchesSum;
  Decimal get diff => productsStock - batchesSum;
}

class DataIntegrityValidator {
  final AppDatabase db;
  DataIntegrityValidator(this.db);

  /// Check 1: Products.stock == SUM(ProductBatches.quantity)
  Future<List<StockDiscrepancy>> validateStockIntegrity() async {
    // SQL: SELECT p.id, p.name, p.stock, SUM(pb.quantity)
    // FROM products p LEFT JOIN product_batches pb ON p.id=pb.product_id
    // GROUP BY p.id HAVING p.stock != SUM(pb.quantity)
  }

  /// Check 2: GL Inventory == Inventory Valuation
  Future<Decimal?> validateGLInventoryMatch() async {
    // Sum of GL account 1040 balance
    // vs SUM(ProductBatches.quantity * costPrice)
  }

  /// Check 3: No orphaned BROKEN- batches
  Future<int> countBrokenBatches() async {
    // COUNT of batches with batch_number LIKE 'BROKEN-%'
  }
}
```

---

## APPENDIX: FULL FILE INVENTORY AFFECTED

| # | File Path | Lines | Change Type |
|---|-----------|-------|-------------|
| 1 | lib/core/services/inventory_display_service.dart | NEW | CREATE |
| 2 | lib/core/services/return_service.dart | 315-325 | MODIFY (ReturnItemData) |
| 3 | lib/core/services/return_service.dart | 25-88, 179-255 | MODIFY (use qtyInBaseUnit) |
| 4 | lib/core/services/transaction_engine.dart | 334-339 | DELETE (autoBreak call) |
| 5 | lib/core/services/packaging_engine.dart | 94-147, 173-181 | DELETE (break methods) |
| 6 | lib/core/utils/erp_logic.dart | 81-89 | MODIFY (hasEnoughStock) |
| 7 | lib/core/utils/erp_logic.dart | 92-124 | MODIFY (formatInventory) |
| 8 | lib/injection_container.dart | variable | MODIFY (register service) |
| 9 | lib/core/di/core_module.dart | 97, 111 | MODIFY (remove if unused) |
| 10 | lib/presentation/features/pos/widgets/cart_widget.dart | 192-548 | MODIFY (use new service) |

---

*Analysis Date: July 2026*
*Author: ERP Senior Architect*
*Next Step: Review and approve Phase 0 validation before any code changes.*
