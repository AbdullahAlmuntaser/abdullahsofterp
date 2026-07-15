# Solution Design: Multi-Unit Inventory Management
## SystemMarket ERP — Safe Refactoring Blueprint

---

## PART 1: PROBLEM STATEMENT

### Current Architecture Flaws

```
┌─────────────────────────────────────────────────────────────┐
│                    CURRENT STATE (BROKEN)                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  3 Unit Systems ─► ProductUnits / UnitConversions / legacy  │
│                                                             │
│  PackagingEngine ─► Creates REAL BROKEN- batches            │
│                                                             │
│  ReturnService ─► No unitFactor, ambiguous quantities       │
│                                                             │
│  Display Logic ─► Mixed across 3 services                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Root Cause

The system evolved through 3 phases without consolidating:
1. **Phase 1**: Simple int-based `piecesPerCarton` (legacy)
2. **Phase 2**: `UnitConversions` table for flexible conversions
3. **Phase 3**: `ProductUnits` table with `unitFactor` for POS

All three coexist unsynchronized. The `PackagingEngine` was built to solve a problem that doesn't exist in a base-unit system: physically breaking packages.

---

## PART 2: TARGET ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────┐
│                    TARGET STATE (CLEAN)                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SINGLE SOURCE OF TRUTH: ProductUnits table                 │
│                                                             │
│  STORAGE: Base Units Only (pieces, kg, meters, etc.)        │
│                                                             │
│  DISPLAY: InventoryDisplayService (Read-Only)               │
│                                                             │
│  SELLING: SaleMode enum (wholesale / retail / mixed)         │
│                                                             │
│  RETURNS: ReturnItemData with unitFactor                    │
│                                                             │
│  VALIDATION: DataIntegrityValidator                         │
│                                                             │
│  Engine: TransactionEngine (unchanged posting logic)         │
│                                                             │
│  Costing: InventoryCostingService (unchanged)               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow (Target)

```
PURCHASE:
  User enters "10 Cartons" (unitFactor=20)
  → PurchaseItem { qty: 10, unitFactor: 20 }
  → TransactionEngine: qtyInBaseUnit = 10 × 20 = 200
  → ProductBatches.quantity = 200  ✓ Base unit
  → Products.stock += 200          ✓ Base unit

SALE (Wholesale):
  User selects "Carton", price list = wholesale
  → CartItem { qty: 1, unitFactor: 20, isWholesale: true }
  → TransactionEngine: remainingToDeduct = 1 × 20 = 20
  → Deduct 20 from batches (FIFO/AVCO/LIFO)
  → Products.stock -= 20
  → PostingEngine: DR Cash/AR, CR Revenue, CR VAT
  → PostingEngine: DR COGS, CR Inventory

SALE (Retail):
  User selects "Piece", price list = retail
  → CartItem { qty: 1, unitFactor: 1, isWholesale: false }
  → TransactionEngine: remainingToDeduct = 1 × 1 = 1
  → Deduct 1 from batches

DISPLAY:
  Products.stock = 135
  → InventoryDisplayService.formatForDisplay(135, productId)
  → Returns "6 Cartons + 15 Pieces"
  → NO database writes, NO batch creation

RETURN:
  User returns "1 Carton" (unitFactor=20)
  → ReturnItemData { qty: 1, unitFactor: 20 }
  → qtyInBaseUnit = 1 × 20 = 20
  → Products.stock += 20
  → ProductBatches.quantity += 20
  → PostingEngine: reverse COGS + Revenue
```

---

## PART 3: COMPONENT SPECIFICATIONS

### 3.1 ProductUnits — Single Source of Truth

**Table:** Already exists as `product_units` in Drift schema.

**Model:**
```dart
class ProductUnit {
  final String id;
  final String productId;
  final String unitName;       // "Carton", "Piece", "Box"
  final Decimal unitFactor;    // 20 for Carton (1 Carton = 20 Pieces)
  final String barcode;        // Multi-barcode support
  final Decimal salePrice;     // Retail price
  final Decimal wholesalePrice; // Wholesale price
  final bool allowFraction;    // Allow 0.5 kg, 1.5 meters, etc.
  final bool canSellWholesale; // Visible in wholesale mode
  final bool canSellRetail;    // Visible in retail mode
  final bool isDefaultWholesale; // Default unit in wholesale mode
  final bool isDefaultRetail;  // Default unit in retail mode
  final bool isDisplayUnit;    // Used in display breakdown
}
```

**Migration:**
- Add missing columns to `ProductUnits` table (allowFraction, canSellWholesale, canSellRetail, isDefaultWholesale, isDefaultRetail, isDisplayUnit)
- Seed data for existing products based on Products.cartonUnit/piecesPerCarton
- No data loss — ProductUnits already has core fields

### 3.2 SaleMode Enum

```dart
enum SaleMode {
  wholesale,  // Show only canSellWholesale units, use wholesalePrice
  retail,     // Show only canSellRetail units, use salePrice
  mixed,      // Show all units, use appropriate price
}
```

**Impact:**
- POS Bloc: Add `SaleMode` to state
- CartItem: Add `isWholesale` boolean
- PricingService: Use `wholesalePrice` or `salePrice` based on mode

### 3.3 InventoryDisplayService

```dart
/// Purpose: Convert base-unit quantities to human-readable display.
/// Rule: NEVER writes to database. NEVER creates batches.
/// Source: ProductUnits table only.
class InventoryDisplayService {
  final AppDatabase db;
  InventoryDisplayService(this.db);

  /// Convert 135 pieces → "6 Cartons + 15 Pieces"
  Future<String> formatForDisplay({
    required Decimal baseQty,
    required String productId,
  }) async { ... }

  /// Convert 135 → [{Carton,6}, {Piece,15}]
  Future<List<UnitBreakdown>> getUnitBreakdown({
    required Decimal baseQty,
    required String productId,
  }) async { ... }

  /// Find best unit for a quantity (largest factor <= qty)
  Future<ProductUnit> suggestBestUnit({
    required Decimal baseQty,
    required String productId,
  }) async { ... }
}

class UnitBreakdown {
  final String unitName;
  final int quantity;
  final Decimal unitFactor;
}
```

**Key Implementation Detail:**
```dart
List<UnitBreakdown> _calculateBreakdown(Decimal qty, List<ProductUnit> units) {
  final displayUnits = units
      .where((u) => u.isDisplayUnit && u.unitFactor > Decimal.one)
      .toList()
    ..sort((a, b) => b.unitFactor.compareTo(a.unitFactor));

  List<UnitBreakdown> result = [];
  Decimal remaining = qty;

  for (var unit in displayUnits) {
    final count = (remaining / unit.unitFactor).toDecimal(scaleOnInfinitePrecision: 0);
    if (count > Decimal.zero) {
      result.add(UnitBreakdown(
        unitName: unit.unitName,
        quantity: count.toInt(),
        unitFactor: unit.unitFactor,
      ));
      remaining -= count * unit.unitFactor;
    }
  }

  if (remaining > Decimal.zero) {
    final baseUnit = units.firstWhere(
      (u) => u.unitFactor == Decimal.one,
      orElse: () => ProductUnit(unitName: 'pcs', unitFactor: Decimal.one, ...),
    );
    result.add(UnitBreakdown(
      unitName: baseUnit.unitName,
      quantity: remaining.toInt(),
      unitFactor: Decimal.one,
    ));
  }

  return result;
}
```

### 3.4 ReturnItemData (Fixed)

```dart
class ReturnItemData {
  final String productId;
  final Decimal quantity;      // In selected unit (e.g., 2 cartons = 2)
  final Decimal unitFactor;    // e.g., 20 for cartons
  final Decimal price;         // Price per selected unit

  /// Computed: always use this for stock operations
  Decimal get qtyInBaseUnit => quantity * unitFactor;

  ReturnItemData({
    required this.productId,
    required this.quantity,
    required this.price,
    this.unitFactor = Decimal.one,  // Default = base unit (backward compat)
  });
}
```

### 3.5 DataIntegrityValidator

```dart
class DataIntegrityValidator {
  final AppDatabase db;
  DataIntegrityValidator(this.db);

  /// Check 1: Products.stock == SUM(ProductBatches.quantity)
  Future<List<StockDiscrepancy>> validateStockIntegrity() async {
    final result = await db.customSelect('''
      SELECT p.id, p.name, p.stock AS products_stock,
             COALESCE(CAST(SUM(pb.quantity) AS REAL), 0) AS batches_sum
      FROM products p
      LEFT JOIN product_batches pb ON p.id = pb.product_id
      GROUP BY p.id
      HAVING ABS(p.stock - COALESCE(SUM(pb.quantity), 0)) > 0.001
    ''').get();
    return result.map((row) => StockDiscrepancy(
      productId: row.data['id'] as String,
      productName: row.data['name'] as String,
      productsStock: Decimal.parse(row.data['products_stock'].toString()),
      batchesSum: Decimal.parse(row.data['batches_sum'].toString()),
    )).toList();
  }

  /// Check 2: GL Inventory == Inventory Valuation
  Future<IntegrityReport> validateGLInventoryMatch() async {
    // GL Balance for account 1040 (Inventory)
    final glBalance = await db.customSelect('''
      SELECT COALESCE(SUM(
        CASE WHEN gl.account_type IN ('ASSET', 'EXPENSE')
          THEN debit - credit
          ELSE credit - debit
        END
      ), 0) AS balance
      FROM gl_lines gl
      JOIN gl_accounts ga ON gl.account_id = ga.id
      WHERE ga.code = '1040'
    ''').getSingle();

    // Inventory Valuation
    final invValue = await db.customSelect('''
      SELECT COALESCE(SUM(CAST(pb.quantity AS REAL) * CAST(pb.cost_price AS REAL)), 0) AS value
      FROM product_batches pb
    ''').getSingle();

    return IntegrityReport(
      glBalance: Decimal.parse(glBalance.data['balance'].toString()),
      inventoryValue: Decimal.parse(invValue.data['value'].toString()),
      match: (glBalance.data['balance'] - invValue.data['value']).abs() < 0.01,
    );
  }

  /// Check 3: No BROKEN- batches exist
  Future<int> countBrokenBatches() async {
    final result = await db.customSelect('''
      SELECT COUNT(*) AS cnt FROM product_batches
      WHERE batch_number LIKE 'BROKEN-%'
    ''').getSingle();
    return (result.data['cnt'] as int);
  }

  /// Check 4: No usage of legacy fields (post-migration)
  Future<bool> checkNoLegacyUsage() async {
    // Verify no code paths still reference piecesPerCarton/UnitConversions
    // This is a static analysis check, not a DB query
    return true;
  }
}

class StockDiscrepancy {
  final String productId;
  final String productName;
  final Decimal productsStock;
  final Decimal batchesSum;
  Decimal get diff => productsStock - batchesSum;
}

class IntegrityReport {
  final Decimal glBalance;
  final Decimal inventoryValue;
  final bool match;
}
```

### 3.6 Enhanced CartItem (POS)

```dart
class CartItem {
  final String productId;
  final String productName;
  final Decimal quantity;
  final Decimal unitFactor;    // Normalized from selected product unit
  final Decimal price;        // From salePrice or wholesalePrice based on mode
  final String unitName;      // Display name (e.g., "Carton")
  final bool isWholesale;     // true = wholesale pricing
  final SaleMode saleMode;    // wholesale / retail / mixed

  Decimal get qtyInBaseUnit => quantity * unitFactor;
}
```

---

## PART 4: CHANGES BY FILE

### Phase 1: Foundation (No Behavioral Changes)

| File | Change | Risk |
|------|--------|------|
| NEW: `lib/core/services/inventory_display_service.dart` | Create display-only service | None |
| NEW: `lib/core/models/unit_breakdown.dart` | UnitBreakdown model | None |
| NEW: `lib/core/models/sale_mode.dart` | SaleMode enum | None |
| NEW: `lib/core/services/data_integrity_validator.dart` | Create validator | None |
| `injection_container.dart` | Register new services | None |

### Phase 2: ProductUnits Enhancement

| File | Change | Risk |
|------|--------|------|
| `app_database.dart` (ProductUnits table) | Add: allowFraction, canSellWholesale, canSellRetail, isDefaultWholesale, isDefaultRetail, isDisplayUnit | Medium (schema change) |
| `lib/core/di/core_module.dart` | Add ProductUnitsDao registration if missing | Low |
| Migration: seed ProductUnits from Products.cartonUnit/piecesPerCarton | One-time data migration | Medium |

### Phase 3: ReturnItemData Fix

| File | Change | Risk |
|------|--------|------|
| `return_service.dart:315-325` | Add unitFactor to ReturnItemData | HIGH |
| `return_service.dart:63,80,225,249` | Use qtyInBaseUnit instead of raw quantity | HIGH |

### Phase 4: Remove PackagingEngine Breaking

| File | Change | Risk |
|------|--------|------|
| `transaction_engine.dart:335` | Remove autoBreakIfNecessary() call | HIGH |
| `packaging_engine.dart:94-147,173-181` | Deprecate _breakOnePackage, _postPackagingBreakGL | Medium |
| `packaging_engine.dart:183-221` | Keep formatInventoryBalance() or redirect to InventoryDisplayService | Low |
| `auto_break_service.dart:168` | Remove autoBreakForSale body | Low |

### Phase 5: Display Migration

| File | Change | Risk |
|------|--------|------|
| `cart_widget.dart` | Replace PackagingEngine.formatInventoryBalance() with InventoryDisplayService | Low |
| `smart_stock_widget.dart` | Replace with new service | Low |
| `pos_product_card.dart:19` | Remove context.read<PackagingEngine>() | Low |
| `erp_logic.dart:92-124` | Migrate formatInventory() to use ProductUnits via InventoryDisplayService | Medium |

### Phase 6: SaleMode Integration

| File | Change | Risk |
|------|--------|------|
| `pos_bloc.dart` | Add SaleMode to state, filter units by mode | Medium |
| `pos_state.dart` | Add SaleMode, isWholesale fields | Low |
| `pos_event.dart` | Add SetSaleMode event | Low |
| `pricing_service.dart` | Select salePrice vs wholesalePrice based on mode | Low |

### Phase 7: Legacy Cleanup

| File | Change | Risk |
|------|--------|------|
| `erp_logic.dart:87` | Remove hasEnoughStock piecesPerCarton logic | Low |
| `domain/entities/bom_entry.dart:11` | Remove piecesPerCarton | Low |
| All references to UnitConversions table | Migrate to ProductUnits | Medium |

---

## PART 5: WHAT WE DO NOT CHANGE

❌ Products.stock — stays as base units
❌ ProductBatches.quantity — stays as base units
❌ InventoryCostingService (FIFO/AVCO/LIFO) — unchanged
❌ PostingEngine._postSale() — unchanged
❌ PostingEngine._postPurchase() — unchanged
❌ PostingEngine._postSaleReturn() — unchanged
❌ PostingEngine._postPurchaseReturn() — unchanged
❌ TransactionEngine.postPurchase() — unchanged (already correct)
❌ TransactionEngine.postSale() batch deduction — unchanged
❌ GLAccounts / GLEntries / GLLines schema — unchanged
❌ POS Bloc checkout flow — unchanged (only unit selection changes)

---

## PART 6: TEST SCENARIOS

### Test 1: Full Cycle with Multi-Unit

**Setup:**
```
Product: Water
Units: Piece (factor=1), Carton (factor=20)
Carton barcode: "2001", Piece barcode: "2002"
Carton wholesale: 1600, Carton retail: 1700, Piece: 100
```

| Step | Operation | Expected Stock |
|------|-----------|---------------|
| 1 | Purchase 10 Cartons @ 1500 | 200 pieces |
| 2 | Sell 1 Piece @ 100 | 199 pieces |
| 3 | Sell 1 Carton @ 1600 (wholesale) | 179 pieces |
| 4 | Return 1 Piece from sale #2 | 180 pieces |
| 5 | Return 1 Carton from sale #3 | 200 pieces |

**Verify:**
```sql
SELECT p.stock == SUM(pb.quantity) FROM products p
JOIN product_batches pb ON p.id = pb.product_id
GROUP BY p.id;  -- Expected: TRUE
```

### Test 2: FIFO Costing Integrity

**Setup:**
```
Batch A: 100 pieces @ 50
Batch B: 100 pieces @ 75
```

| Step | Operation | COGS | Remaining |
|------|-----------|------|-----------|
| 1 | Sell 60 pieces | 60×50=3000 (all from A) | A:40, B:100 |
| 2 | Sell 80 pieces | 40×50 + 40×75 = 5000 | A:0, B:60 |
| 3 | Return 10 pieces from step 2 | COGS reversed: 10×75=750 | A:0, B:70 |

### Test 3: SaleMode Filtering

**Setup:**
```
ProductUnits:
- Piece: factor=1, canSellRetail=true, canSellWholesale=false
- Carton: factor=20, canSellRetail=true, canSellWholesale=true
```

| Mode | Visible Units |
|------|---------------|
| Wholesale | Carton only |
| Retail | Piece + Carton |
| Mixed | Piece + Carton |

### Test 4: Display Only — No Data Modification

```dart
// Arrange
final service = InventoryDisplayService(db);
final beforeStock = await getProductStock("water-id"); // = 135

// Act
final display = await service.formatForDisplay(
  baseQty: Decimal.fromInt(135),
  productId: "water-id",
); // = "6 Cartons + 15 Pieces"

final afterStock = await getProductStock("water-id"); // = 135

// Assert
assert(display == "6 Cartons + 15 Pieces");
assert(beforeStock == afterStock); // No database change
assert(await countBrokenBatches() == 0); // No BROKEN- batches created
```

### Test 5: Data Integrity Post-Migration

```dart
final validator = DataIntegrityValidator(db);

// Run all checks
final stockIssues = await validator.validateStockIntegrity();
final glReport = await validator.validateGLInventoryMatch();
final brokenCount = await validator.countBrokenBatches();

assert(stockIssues.isEmpty);     // All products balanced
assert(glReport.match);          // GL == Inventory valuation
assert(brokenCount == 0);        // No BROKEN- batches
```

---

## PART 7: ROLLBACK PLAN

### If Phase 3 (ReturnItemData) breaks:
```dart
// Option A: Reset to Decimal.one default
class ReturnItemData {
  final Decimal unitFactor = Decimal.one; // Force backward compat
}

// Option B: Revert return_service.dart to git
git checkout -- lib/core/services/return_service.dart
```

### If Phase 4 (remove autoBreak) breaks:
```dart
// Restore the 7 lines in transaction_engine.dart
await packagingEngine.autoBreakIfNecessary(
  productId: item.productId,
  warehouseId: sale.warehouseId ?? '',
  requiredQtyInBase: remainingToDeduct,
);
```

### General Rollback:
```bash
git reset --hard HEAD  # Revert all uncommitted changes
```

---

## PART 8: MIGRATION ORDER (Dependency-Aware)

```
Phase 1: Foundation ──────────────────────────────────┐
  InventoryDisplayService (NEW)                        │
  DataIntegrityValidator (NEW)                         │
  SaleMode enum (NEW)                                  │
  UnitBreakdown model (NEW)                            │
  ← No existing code changes                           │
                                                       │
Phase 2: ProductUnits Enhancement ────────────────────┤
  Schema migration (add columns)                       │
  Seed data from Products legacy fields                │
                                                       │
Phase 3: ReturnItemData Fix ──────────────────────────┤
  return_service.dart ← HIGH RISK                     │
                                                       │
Phase 4: Remove PackagingEngine Breaking ─────────────┤
  transaction_engine.dart ← HIGH RISK                 │
  packaging_engine.dart                                │
                                                       │
Phase 5: Display Migration ───────────────────────────┤
  cart_widget.dart                                      │
  smart_stock_widget.dart                              │
  erp_logic.dart (formatInventory only)                 │
                                                       │
Phase 6: SaleMode Integration ────────────────────────┤
  pos_bloc.dart, pos_state.dart, pos_event.dart         │
  pricing_service.dart                                  │
                                                       │
Phase 7: Legacy Cleanup ──────────────────────────────┤
  erp_logic.dart (hasEnoughStock)                       │
  bom_entry.dart                                        │
  Remove UnitConversions references                     │
  ─────────────────────────────────────────────────────┘
```

---

## PART 9: SUMMARY

```
┌─────────────────────────────────────────────────────────────┐
│                      FINAL STATE                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Storage:    Base Units Only (pieces, kg, meters)           │
│  Display:    InventoryDisplayService (read-only)             │
│  Units:      ProductUnits (single source of truth)           │
│  Selling:    SaleMode (wholesale/retail/mixed)               │
│  Returns:    ReturnItemData with unitFactor                  │
│  Costing:    FIFO/AVCO/LIFO (unchanged)                      │
│  Posting:    PostingEngine (unchanged)                       │
│  Validation: DataIntegrityValidator (continuous)             │
│                                                             │
│  NO: BROKEN- batches, fake movements, legacy fields          │
│  YES: Professional, scalable, audit-ready inventory system   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Effort Estimate

| Phase | Files | Risk | Estimated Effort |
|-------|-------|------|-----------------|
| 1 Foundation | 5 new files | None | 1 day |
| 2 ProductUnits | 2-3 files | Medium | 2 days |
| 3 ReturnItemData | 1 file | HIGH | 1 day |
| 4 Remove Breaking | 2-3 files | HIGH | 2 days |
| 5 Display Migration | 4 files | Low | 1 day |
| 6 SaleMode | 4 files | Medium | 2 days |
| 7 Legacy Cleanup | 3+ files | Medium | 2 days |
| **Total** | **~20 files** | | **~11 days** |

### Critical Rule Reminder

> **Store in base units. Display in commercial units. Never create inventory movements for display.**
