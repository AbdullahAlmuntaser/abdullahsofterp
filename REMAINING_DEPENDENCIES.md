# REMAINING_DEPENDENCIES.md

## 1. Dependencies on `stock` (Products.stock) NOT using StockDisplayAdapter

| File | Line(s) | Function | Risk | Notes |
|------|---------|----------|------|-------|
| `products_dao.dart` | 367-378 | `getWarehouseStock` | **HIGH** | Doesn't account for reservedQuantity! |
| `pos_bloc.dart` | 492, 563-568 | Stock validation & display | **HIGH** | Uses raw stock, no unit context |
| `sales_invoice_page.dart` | Multiple | Invoice display | **HIGH** | Shows raw stock |
| `purchase_provider.dart` | 184, 351, 366 | Purchase stock comparison | **HIGH** | Compares raw stock |
| `inventory_display_service.dart` | Full file | Display service | **HIGH** | **Not using StockDisplayAdapter** |
| `cart_widget.dart` | 28+ | Cart quantity display | **MEDIUM** | Shows raw stock |
| `stock_take_page.dart` | 585-587 | Stock take display | **MEDIUM** | Shows raw stock numbers |
| `smart_stock_widget.dart` | 28 | Widget display | **MEDIUM** | Shows raw stock |
| `beginning_of_period_page.dart` | 67, 343-348 | Period start stock | **MEDIUM** | Raw stock display & write |
| `sales_orders_page.dart` | 495 | Sales order display | **MEDIUM** | Raw stock |
| `inventory_value_report.dart` | Multiple | Report display | **MEDIUM** | Uses raw stock for value calc |
| `low_stock_report.dart` | 54 | Low stock report | **MEDIUM** | Raw stock comparison |
| `item_movement_detail_page.dart` | Multiple | Movement details | **MEDIUM** | Raw stock |
| `inventory_transactions_report.dart` | Multiple | Transactions report | **MEDIUM** | Raw stock |
| `sales_item_row.dart` | Multiple | Sale item row | **MEDIUM** | Raw quantity |
| `sale_details_bottom_sheet.dart` | Multiple | Sale details | **MEDIUM** | Raw quantity |
| `sales_order_detail_page.dart` | Multiple | Order details | **MEDIUM** | Raw quantity |
| `products_page.dart` | Multiple | Products list | **MEDIUM** | Raw stock |
| `dashboard_service.dart` | 274 | Dashboard | **LOW** | Uses stock for calculations |
| `chart_service.dart` | 47, 73, 125 | Charts | **LOW** | Uses stock for calculations |
| `report_engine_service.dart` | 263-265 | Reports | **LOW** | Uses stock for valuation |
| `export_service.dart` | 189, 305 | Export | **LOW** | Exports raw stock |
| `rest_api_service.dart` | 69, 100, 113 | REST API | **LOW** | API returns raw stock |
| `financial_control_service.dart` | 72 | Financial control | **LOW** | Uses stock for logic |
| `profitability_service.dart` | 53 | Profitability calc | **LOW** | Uses stock for calc |
| `thermal_printer_service.dart` | 151 | Thermal printing | **LOW** | Prints raw stock |
| `invoice_service.dart` | 158 | Invoice | **LOW** | Raw stock display |
| `proforma_service.dart` | 26 | Proforma | **LOW** | Raw stock calc |

## 2. Dependencies on `quantity` (ProductBatches.quantity)

| File | Line(s) | Function | Risk | Notes |
|------|---------|----------|------|-------|
| `products_dao.dart` | 56-68, 367-378 | Batch queries | **HIGH** | `getWarehouseStock` ignores reservedQuantity |
| `inventory_costing_service.dart` | 75-93, 229-310 | FIFO/AVCO/LIFO | **HIGH** | Uses quantity, not accounting for reserved in some paths |
| `stock_transfer_service.dart` | 47-108 | Stock transfer | **HIGH** | Uses quantity directly, no reserved check |
| `production_service.dart` | 64-76 | Production | **HIGH** | Uses quantity directly |
| `bom_service.dart` | 127, 180 | BOM | **HIGH** | Uses quantity directly |
| `manufacturing_service.dart` | 161-184, 318 | Manufacturing | **HIGH** | Uses quantity directly |
| `return_service.dart` | 69-87, 231-253 | Returns | **MEDIUM** | Updates batch quantity |
| `report_engine_service.dart` | Implicit | Reports | **MEDIUM** | Reads batch quantity |
| `notification_service.dart` | 192-201 | Notifications | **MEDIUM** | Reads batch quantity |
| `inventory_report_service.dart` | 51-89 | Inventory reports | **MEDIUM** | Reads batch quantity |
| `auto_break_service.dart` | 221-258 | Auto break | **MEDIUM** | Reads batch quantity |
| `system_auditor.dart` | 22 | System audit | **LOW** | Reads batch quantity |

## 3. Dependencies on `unitFactor`

| File | Function | Risk | Notes |
|------|----------|------|-------|
| `transaction_engine.dart` | postSale (line 319) | **HIGH** | Calculates base qty = qty * unitFactor |
| `packaging_engine.dart` | autoBreak logic | **MEDIUM** | Uses unitFactor for break decisions |
| `auto_break_service.dart` | Full file | **MEDIUM** | Uses unitFactor |
| `unit_conversion_service.dart` | Full file | **MEDIUM** | Uses unitFactor |
| `pos_bloc.dart` | 474-475, 592-659 | **MEDIUM** | Uses unitFactor for POS |
| `sales_invoice_page.dart` | 984-994 | **MEDIUM** | Uses unitFactor |
| `purchase_provider.dart` | 244-245 | **MEDIUM** | Stores unitFactor |
| `grn_service.dart` | 70-71 | **MEDIUM** | Uses unitFactor |
| `proforma_service.dart` | 26, 59-60 | **LOW** | Uses unitFactor |
| `financial_control_service.dart` | 349 | **LOW** | Uses unitFactor |
| `purchase_item_row.dart` | 250-252 | **LOW** | Displays unitFactor |

## 4. Dependencies on `costPrice` / `buyPrice`

| File | Function | Risk | Notes |
|------|----------|------|-------|
| `inventory_costing_service.dart` | FIFO/AVCO/LIFO | **HIGH** | Core costing logic |
| `report_engine_service.dart` | 102, 263 | **MEDIUM** | Profit reports |
| `purchase_provider.dart` | 193, 492-512, 592, 616-621 | **MEDIUM** | Purchase pricing |
| `return_service.dart` | 86, 242-253 | **MEDIUM** | Return costing |
| `stock_operation_service.dart` | 84, 90, 101, 105 | **MEDIUM** | Stock operations |
| `production_service.dart` | 90 | **LOW** | Production costing |
| `bom_service.dart` | 205 | **LOW** | BOM costing |
| `manufacturing_service.dart` | 161, 184, 271, 341 | **LOW** | Manufacturing costing |

## 5. Dependencies on `averageCost`

| File | Function | Risk | Notes |
|------|----------|------|-------|
| `inventory_costing_service.dart` | 24, 30, 108, 141, 182, 223 | **HIGH** | Core AVCO logic |
| `purchase_provider.dart` | 27, 34, 352, 416, 492-512 | **MEDIUM** | Price comparison |
| `sales_provider.dart` | 114 | **LOW** | Price validation |
| `report_engine_service.dart` | Implicit | **LOW** | Report calculations |

## Dependency Count Summary

| Field | Total Files | Unresolved | Risk Distribution |
|-------|-------------|------------|-------------------|
| `stock` | 45 | ~31 screens + 1 DAO | 3 HIGH, 12 MEDIUM, 13 LOW |
| `quantity` | 20 | ~8 services | 5 HIGH, 4 MEDIUM, 1 LOW |
| `unitFactor` | 15 | ~10 services | 0 HIGH, 8 MEDIUM, 2 LOW |
| `costPrice` | 20 | ~8 services | 1 HIGH, 5 MEDIUM, 2 LOW |
| `averageCost` | 4 | ~2 services | 1 HIGH, 1 MEDIUM, 2 LOW |
