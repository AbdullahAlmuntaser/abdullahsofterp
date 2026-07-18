import 'package:decimal/decimal.dart';

Decimal _d(dynamic v) {
  if (v == null) return Decimal.zero;
  if (v is Decimal) return v;
  return Decimal.tryParse(v.toString()) ?? Decimal.zero;
}

int _i(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

bool _b(dynamic v) => v == 1 || v == true || v == '1' || v == 'true';
DateTime _dt(dynamic v) => v == null ? DateTime.now() : DateTime.parse(v.toString());

// ===================== CORE =====================
class Branch {
  final String id; final String name; final String code;
  final String? address; final String? phone; final bool isActive;
  Branch.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], code = m['code'],
    address = m['address'], phone = m['phone'], isActive = _b(m['is_active']);
}

class AppUser {
  final String id; final String username; final String password;
  final String role; final String fullName;
  final String? passwordHash; final String? passwordSalt; final String? branchId;
  AppUser.fromMap(Map<String, dynamic> m) :
    id = m['id'], username = m['username'], password = m['password'],
    role = m['role'], fullName = m['full_name'],
    passwordHash = m['password_hash'], passwordSalt = m['password_salt'],
    branchId = m['branch_id'];
}

class Permission {
  final String id; final String code; final String? description;
  Permission.fromMap(Map<String, dynamic> m) :
    id = m['id'], code = m['code'], description = m['description'];
}

class RolePermission {
  final String id; final String role; final String permissionCode;
  RolePermission.fromMap(Map<String, dynamic> m) :
    id = m['id'], role = m['role'], permissionCode = m['permission_code'];
}

class SyncQueueItem {
  final String id; final String entityTable; final String entityId;
  final String operation; final String? payload; final int status;
  SyncQueueItem.fromMap(Map<String, dynamic> m) :
    id = m['id'], entityTable = m['entity_table'], entityId = m['entity_id'],
    operation = m['operation'], payload = m['payload'], status = _i(m['status']);
}

class AuditLog {
  final String id; final String? userId; final String action;
  final String targetEntity; final String entityId; final String? details;
  final DateTime timestamp;
  AuditLog.fromMap(Map<String, dynamic> m) :
    id = m['id'], userId = m['user_id'], action = m['action'],
    targetEntity = m['target_entity'], entityId = m['entity_id'],
    details = m['details'], timestamp = _dt(m['timestamp']);
}

// ===================== PRODUCTS =====================
class Category {
  final String id; final String name; final String? code;
  Category({required this.id, required this.name, this.code});
  Category.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], code = m['code'];
}

class Product {
  final String id; final String name; final String sku;
  final String? barcode; final String? categoryId; final String unit;
  final String? cartonUnit; final int piecesPerCarton;
  final String? kiloUnit; final String? boxUnit;
  final Decimal buyPrice; final Decimal sellPrice; final Decimal wholesalePrice;
  final Decimal stock; final Decimal maxStock;
  final String? supplierId; final String valuationMethod;
  final bool allowFreeQty; final bool isService; final Decimal alertLimit;
  final DateTime? expiryDate; final Decimal taxRate; final bool isActive;
  final String? parentProductId; final String? attributes;
  final Decimal? additionalCost; final String? imagePath;
  Product.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], sku = m['sku'],
    barcode = m['barcode'], categoryId = m['category_id'],
    unit = m['unit'] ?? 'pcs',
    cartonUnit = m['carton_unit'], piecesPerCarton = _i(m['pieces_per_carton']),
    kiloUnit = m['kilo_unit'], boxUnit = m['box_unit'],
    buyPrice = _d(m['buy_price']), sellPrice = _d(m['sell_price']),
    wholesalePrice = _d(m['wholesale_price']), stock = _d(m['stock']),
    maxStock = _d(m['max_stock']), supplierId = m['supplier_id'],
    valuationMethod = m['valuation_method'] ?? 'FIFO',
    allowFreeQty = _b(m['allow_free_qty']), isService = _b(m['is_service']),
    alertLimit = _d(m['alert_limit']),
    expiryDate = m['expiry_date'] != null ? DateTime.parse(m['expiry_date']) : null,
    taxRate = _d(m['tax_rate']), isActive = _b(m['is_active']),
    parentProductId = m['parent_product_id'], attributes = m['attributes'],
    additionalCost = _d(m['additional_cost']), imagePath = m['image_path'];
}

class ProductUnit {
  final String id; final String productId; final String unitName;
  final String? barcode; final Decimal unitFactor;
  final Decimal? buyPrice; final Decimal? sellPrice;
  final Decimal? wholesalePrice; final Decimal? halfWholesalePrice;
  final bool isDefault;
  ProductUnit.fromMap(Map<String, dynamic> m) :
    id = m['id'], productId = m['product_id'], unitName = m['unit_name'],
    barcode = m['barcode'], unitFactor = _d(m['unit_factor']),
    buyPrice = _d(m['buy_price']), sellPrice = _d(m['sell_price']),
    wholesalePrice = _d(m['wholesale_price']),
    halfWholesalePrice = _d(m['half_wholesale_price']),
    isDefault = _b(m['is_default']);
}

class ItemVariant {
  final String id; final String productId; final String attributeName;
  final String attributeValue; final Decimal additionalPrice; final String? sku;
  ItemVariant.fromMap(Map<String, dynamic> m) :
    id = m['id'], productId = m['product_id'],
    attributeName = m['attribute_name'] ?? '',
    attributeValue = m['attribute_value'] ?? '',
    additionalPrice = _d(m['additional_price']), sku = m['sku'];
}

// ===================== CUSTOMERS =====================
class Customer {
  final String id; final String name; final String? normalizedName;
  final String? phone; final String? taxNumber; final String? address;
  final String? email; final String customerType; final bool isActive;
  final Decimal creditLimit; final Decimal balance;
  final String? accountId; final String? currencyId;
  final Decimal exchangeRate; final bool isQuickCustomer;
  final bool createdFromPOS; final Decimal discountRate;
  Customer.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], normalizedName = m['normalized_name'],
    phone = m['phone'], taxNumber = m['tax_number'],
    address = m['address'], email = m['email'],
    customerType = m['customer_type'] ?? 'RETAIL',
    isActive = _b(m['is_active']),
    creditLimit = _d(m['credit_limit']), balance = _d(m['balance']),
    accountId = m['account_id'], currencyId = m['currency_id'],
    exchangeRate = _d(m['exchange_rate']),
    isQuickCustomer = _b(m['is_quick_customer']),
    createdFromPOS = _b(m['created_from_pos']),
    discountRate = _d(m['discount_rate']);
}

class CustomerPayment {
  final String id; final String customerId; final Decimal amount;
  final DateTime paymentDate; final String? note;
  final String paymentMethod; final String? referenceNumber;
  final String? accountId; final String status;
  CustomerPayment.fromMap(Map<String, dynamic> m) :
    id = m['id'], customerId = m['customer_id'], amount = _d(m['amount']),
    paymentDate = _dt(m['payment_date']), note = m['note'],
    paymentMethod = m['payment_method'] ?? 'cash',
    referenceNumber = m['reference_number'], accountId = m['account_id'],
    status = m['status'] ?? 'COMPLETED';
}

// ===================== SUPPLIERS =====================
class Supplier {
  final String id; final String name; final String? phone;
  final String? contactPerson; final String? taxNumber;
  final String? address; final String? email;
  final String supplierType; final bool isActive;
  final Decimal balance; final String? accountId;
  final Decimal creditLimit; final String? currencyId;
  final Decimal exchangeRate;
  Supplier.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], phone = m['phone'],
    contactPerson = m['contact_person'], taxNumber = m['tax_number'],
    address = m['address'], email = m['email'],
    supplierType = m['supplier_type'] ?? 'LOCAL',
    isActive = _b(m['is_active']), balance = _d(m['balance']),
    accountId = m['account_id'], creditLimit = _d(m['credit_limit']),
    currencyId = m['currency_id'], exchangeRate = _d(m['exchange_rate']);
}

// ===================== SALES =====================
class Sale {
  final String id; final String? customerId; final Decimal total;
  final Decimal discount; final Decimal tax; final int paymentMethod;
  final bool isCredit; final int status; final String saleType;
  final String? currencyId; final Decimal exchangeRate;
  final Decimal shippingCost; final Decimal otherExpenses;
  final String? warehouseId; final String? representativeId;
  final DateTime? exchangeDate; final String? qrCode;
  final String? hash; final String? signature; final DateTime createdAt;
  Sale.fromMap(Map<String, dynamic> m) :
    id = m['id'], customerId = m['customer_id'], total = _d(m['total']),
    discount = _d(m['discount']), tax = _d(m['tax']),
    paymentMethod = _i(m['payment_method']), isCredit = _b(m['is_credit']),
    status = _i(m['status']), saleType = m['sale_type'] ?? 'retail',
    currencyId = m['currency_id'], exchangeRate = _d(m['exchange_rate']),
    shippingCost = _d(m['shipping_cost']),
    otherExpenses = _d(m['other_expenses']),
    warehouseId = m['warehouse_id'], representativeId = m['representative_id'],
    exchangeDate = m['exchange_date'] != null ? _dt(m['exchange_date']) : null,
    qrCode = m['qr_code'], hash = m['hash'], signature = m['signature'],
    createdAt = _dt(m['created_at']);
}

class SaleItem {
  final String id; final String saleId; final String productId;
  final Decimal quantity; final Decimal price;
  final String? unitId; final String unitName; final Decimal unitFactor;
  final String? warehouseId; final String? batchId; final String? costCenterId;
  SaleItem.fromMap(Map<String, dynamic> m) :
    id = m['id'], saleId = m['sale_id'], productId = m['product_id'],
    quantity = _d(m['quantity']), price = _d(m['price']),
    unitId = m['unit_id'], unitName = m['unit_name'] ?? 'حبة',
    unitFactor = _d(m['unit_factor']), warehouseId = m['warehouse_id'],
    batchId = m['batch_id'], costCenterId = m['cost_center_id'];
}

class SalesOrder {
  final String id; final String? customerId; final Decimal total;
  final String? orderNumber; final DateTime date;
  final String status; final String? notes;
  SalesOrder.fromMap(Map<String, dynamic> m) :
    id = m['id'], customerId = m['customer_id'], total = _d(m['total']),
    orderNumber = m['order_number'], date = _dt(m['date']),
    status = m['status'] ?? 'QUOTATION', notes = m['notes'];
}

// ===================== PURCHASES =====================
class Purchase {
  final String id; final String? supplierId; final Decimal total;
  final Decimal tax; final Decimal discount; final Decimal landedCosts;
  final Decimal shippingCost; final Decimal otherExpenses;
  final String? invoiceNumber; final String purchaseType;
  final DateTime date; final bool isCredit; final int status;
  final String? warehouseId; final String? currencyId;
  final Decimal exchangeRate; final String? notes;
  final String? referenceDocument; final String? attachmentPath;
  Purchase.fromMap(Map<String, dynamic> m) :
    id = m['id'], supplierId = m['supplier_id'], total = _d(m['total']),
    tax = _d(m['tax']), discount = _d(m['discount']),
    landedCosts = _d(m['landed_costs']),
    shippingCost = _d(m['shipping_cost']),
    otherExpenses = _d(m['other_expenses']),
    invoiceNumber = m['invoice_number'],
    purchaseType = m['purchase_type'] ?? 'cash', date = _dt(m['date']),
    isCredit = _b(m['is_credit']), status = _i(m['status']),
    warehouseId = m['warehouse_id'], currencyId = m['currency_id'],
    exchangeRate = _d(m['exchange_rate']), notes = m['notes'],
    referenceDocument = m['reference_document'],
    attachmentPath = m['attachment_path'];
}

class PurchaseItem {
  final String id; final String purchaseId; final String productId;
  final String? unitId; final Decimal unitFactor; final Decimal quantity;
  final Decimal? quantityInBaseUnit; final Decimal unitPrice; final Decimal price;
  final Decimal discount; final Decimal discountPercent;
  final Decimal tax; final Decimal taxPercent; final Decimal landedCostShare;
  final String? batchId; final String? batchNumber;
  final DateTime? expiryDate; final String? warehouseId; final bool isCarton;
  PurchaseItem.fromMap(Map<String, dynamic> m) :
    id = m['id'], purchaseId = m['purchase_id'], productId = m['product_id'],
    unitId = m['unit_id'], unitFactor = _d(m['unit_factor']),
    quantity = _d(m['quantity']),
    quantityInBaseUnit = _d(m['quantity_in_base_unit']),
    unitPrice = _d(m['unit_price']), price = _d(m['price']),
    discount = _d(m['discount']), discountPercent = _d(m['discount_percent']),
    tax = _d(m['tax']), taxPercent = _d(m['tax_percent']),
    landedCostShare = _d(m['landed_cost_share']),
    batchId = m['batch_id'], batchNumber = m['batch_number'],
    expiryDate = m['expiry_date'] != null ? _dt(m['expiry_date']) : null,
    warehouseId = m['warehouse_id'], isCarton = _b(m['is_carton']);
}

// ===================== INVENTORY =====================
class Warehouse {
  final String id; final String name; final String? location;
  final String? accountId; final String? branchId; final bool isDefault;
  Warehouse.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], location = m['location'],
    accountId = m['account_id'], branchId = m['branch_id'],
    isDefault = _b(m['is_default']);
}

class ProductBatch {
  final String id; final String productId; final String warehouseId;
  final String batchNumber; final DateTime? expiryDate;
  final Decimal quantity; final Decimal initialQuantity; final Decimal costPrice;
  final Decimal reservedQuantity;
  ProductBatch.fromMap(Map<String, dynamic> m) :
    id = m['id'], productId = m['product_id'], warehouseId = m['warehouse_id'],
    batchNumber = m['batch_number'],
    expiryDate = m['expiry_date'] != null ? _dt(m['expiry_date']) : null,
    quantity = _d(m['quantity']), initialQuantity = _d(m['initial_quantity']),
    costPrice = _d(m['cost_price']),
    reservedQuantity = _d(m['reserved_quantity']);
}

class StockMovement {
  final String id; final String productId; final String? fromWarehouseId;
  final String? toWarehouseId; final Decimal quantity; final Decimal cost;
  final String? batchId; final DateTime movementDate; final String type;
  final String? transactionId; final String? referenceId;
  StockMovement.fromMap(Map<String, dynamic> m) :
    id = m['id'], productId = m['product_id'],
    fromWarehouseId = m['from_warehouse_id'],
    toWarehouseId = m['to_warehouse_id'], quantity = _d(m['quantity']),
    cost = _d(m['cost']), batchId = m['batch_id'],
    movementDate = _dt(m['movement_date']), type = m['type'],
    transactionId = m['transaction_id'], referenceId = m['reference_id'];
}

// ===================== ACCOUNTING =====================
class GLAccount {
  final String id; final String code; final String name;
  final int accountType; final String? analyticType;
  final String? parentId; final bool isHeader; final Decimal balance;
  GLAccount.fromMap(Map<String, dynamic> m) :
    id = m['id'], code = m['code'], name = m['name'],
    accountType = _i(m['account_type']), analyticType = m['analytic_type'],
    parentId = m['parent_id'], isHeader = _b(m['is_header']),
    balance = _d(m['balance']);
}

class CostCenter {
  final String id; final String code; final String name;
  final String? parentId; final String type; final bool isActive;
  CostCenter.fromMap(Map<String, dynamic> m) :
    id = m['id'], code = m['code'], name = m['name'],
    parentId = m['parent_id'], type = m['type'] ?? 'department',
    isActive = _b(m['is_active']);
}

class GLEntry {
  final String id; final String description; final DateTime date;
  final String? referenceType; final String? referenceId;
  final String status; final DateTime? postedAt; final String? postedBy;
  final String? currencyId; final Decimal exchangeRate;
  GLEntry.fromMap(Map<String, dynamic> m) :
    id = m['id'], description = m['description'], date = _dt(m['date']),
    referenceType = m['reference_type'], referenceId = m['reference_id'],
    status = m['status'] ?? 'DRAFT',
    postedAt = m['posted_at'] != null ? _dt(m['posted_at']) : null,
    postedBy = m['posted_by'], currencyId = m['currency_id'],
    exchangeRate = _d(m['exchange_rate']);
}

class GLLine {
  final String id; final String entryId; final String accountId;
  final String? costCenterId; final Decimal debit; final Decimal credit;
  final String? currencyId; final Decimal exchangeRate; final String? memo;
  GLLine.fromMap(Map<String, dynamic> m) :
    id = m['id'], entryId = m['entry_id'], accountId = m['account_id'],
    costCenterId = m['cost_center_id'], debit = _d(m['debit']),
    credit = _d(m['credit']), currencyId = m['currency_id'],
    exchangeRate = _d(m['exchange_rate']), memo = m['memo'];
}

// ===================== CASHBOX =====================
class CashboxTransaction {
  final String id; final Decimal amount; final String type;
  final String category; final String? referenceId;
  final String? note; final String userId;
  CashboxTransaction.fromMap(Map<String, dynamic> m) :
    id = m['id'], amount = _d(m['amount']), type = m['type'],
    category = m['category'], referenceId = m['reference_id'],
    note = m['note'], userId = m['user_id'];
}

// ===================== HR =====================
class Employee {
  final String id; final String name; final String employeeCode;
  final String? jobTitle; final String role; final Decimal basicSalary;
  final DateTime? hireDate; final String? warehouseId; final bool isActive;
  Employee.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], employeeCode = m['employee_code'],
    jobTitle = m['job_title'], role = m['role'] ?? 'USER',
    basicSalary = _d(m['basic_salary']),
    hireDate = m['hire_date'] != null ? _dt(m['hire_date']) : null,
    warehouseId = m['warehouse_id'], isActive = _b(m['is_active']);
}

class PayrollEntry {
  final String id; final int month; final int year;
  final DateTime generationDate; final String status; final String? note;
  PayrollEntry.fromMap(Map<String, dynamic> m) :
    id = m['id'], month = _i(m['month']), year = _i(m['year']),
    generationDate = _dt(m['generation_date']),
    status = m['status'] ?? 'DRAFT', note = m['note'];
}

class PayrollLine {
  final String id; final String payrollEntryId; final String employeeId;
  final Decimal basicSalary; final Decimal allowances;
  final Decimal deductions; final Decimal netSalary;
  PayrollLine.fromMap(Map<String, dynamic> m) :
    id = m['id'], payrollEntryId = m['payroll_entry_id'],
    employeeId = m['employee_id'], basicSalary = _d(m['basic_salary']),
    allowances = _d(m['allowances']), deductions = _d(m['deductions']),
    netSalary = _d(m['net_salary']);
}

// ===================== CURRENCIES =====================
class Currency {
  final String id; final String code; final String name;
  final String? fractionalUnit; final int decimalPlaces;
  final Decimal exchangeRate; final bool isBase;
  Currency.fromMap(Map<String, dynamic> m) :
    id = m['id'], code = m['code'], name = m['name'],
    fractionalUnit = m['fractional_unit'],
    decimalPlaces = m['decimal_places'] != null ? _i(m['decimal_places']) : 2,
    exchangeRate = _d(m['exchange_rate']), isBase = _b(m['is_base']);
}

// ===================== MANUFACTURING =====================
class BillOfMaterial {
  final String id; final String finishedProductId;
  final String componentProductId; final Decimal quantity;
  BillOfMaterial.fromMap(Map<String, dynamic> m) :
    id = m['id'], finishedProductId = m['finished_product_id'],
    componentProductId = m['component_product_id'], quantity = _d(m['quantity']);
}

class ProductionOrder {
  final String id; final String finishedProductId;
  final Decimal plannedQuantity; final Decimal actualQuantity;
  final DateTime date; final String status;
  final String? warehouseId; final String? note;
  ProductionOrder.fromMap(Map<String, dynamic> m) :
    id = m['id'], finishedProductId = m['finished_product_id'],
    plannedQuantity = _d(m['planned_quantity']),
    actualQuantity = _d(m['actual_quantity']), date = _dt(m['date']),
    status = m['status'] ?? 'PLANNED', warehouseId = m['warehouse_id'],
    note = m['note'];
}

// ===================== ADDITIONAL =====================
class FixedAsset {
  final String id; final String? assetCategoryId; final String code;
  final String name; final DateTime? purchaseDate;
  final Decimal purchaseCost; final Decimal currentValue;
  final Decimal salvageValue; final int usefulLifeYears;
  final String depreciationMethod; final Decimal depreciationRate;
  final Decimal accumulatedDepreciation; final String status;
  final String? location; final String? notes;
  FixedAsset.fromMap(Map<String, dynamic> m) :
    id = m['id'], assetCategoryId = m['asset_category_id'],
    code = m['code'], name = m['name'],
    purchaseDate = m['purchase_date'] != null ? _dt(m['purchase_date']) : null,
    purchaseCost = _d(m['purchase_cost']),
    currentValue = _d(m['current_value']),
    salvageValue = _d(m['salvage_value']),
    usefulLifeYears = _i(m['useful_life_years']),
    depreciationMethod = m['depreciation_method'] ?? 'STRAIGHT_LINE',
    depreciationRate = _d(m['depreciation_rate']),
    accumulatedDepreciation = _d(m['accumulated_depreciation']),
    status = m['status'] ?? 'ACTIVE', location = m['location'],
    notes = m['notes'];
}

class LeaveRequest {
  final String id; final String employeeId; final String leaveTypeId;
  final DateTime startDate; final DateTime endDate; final int daysCount;
  final String status; final String? reason; final String? approvedBy;
  LeaveRequest.fromMap(Map<String, dynamic> m) :
    id = m['id'], employeeId = m['employee_id'],
    leaveTypeId = m['leave_type_id'], startDate = _dt(m['start_date']),
    endDate = _dt(m['end_date']), daysCount = _i(m['days_count']),
    status = m['status'] ?? 'PENDING', reason = m['reason'],
    approvedBy = m['approved_by'];
}

class AttendanceRecord {
  final String id; final String employeeId; final DateTime date;
  final String? checkIn; final String? checkOut;
  final String status; final String? notes;
  AttendanceRecord.fromMap(Map<String, dynamic> m) :
    id = m['id'], employeeId = m['employee_id'], date = _dt(m['date']),
    checkIn = m['check_in'], checkOut = m['check_out'],
    status = m['status'] ?? 'PRESENT', notes = m['notes'];
}

class Check {
  final String id; final String checkNumber; final String bankName;
  final DateTime dueDate; final Decimal amount; final String type;
  final String status; final String? partnerId;
  final String? paymentAccountId; final String? note;
  final String? currencyId; final Decimal exchangeRate;
  Check.fromMap(Map<String, dynamic> m) :
    id = m['id'], checkNumber = m['check_number'],
    bankName = m['bank_name'], dueDate = _dt(m['due_date']),
    amount = _d(m['amount']), type = m['type'],
    status = m['status'] ?? 'PENDING', partnerId = m['partner_id'],
    paymentAccountId = m['payment_account_id'], note = m['note'],
    currencyId = m['currency_id'], exchangeRate = _d(m['exchange_rate']);
}

class SerialNumber {
  final String id; final String productId; final String serialNumber;
  final String? batchId; final String? warehouseId;
  final String status; final String? saleId; final String? purchaseId;
  SerialNumber.fromMap(Map<String, dynamic> m) :
    id = m['id'], productId = m['product_id'],
    serialNumber = m['serial_number'], batchId = m['batch_id'],
    warehouseId = m['warehouse_id'], status = m['status'] ?? 'IN_STOCK',
    saleId = m['sale_id'], purchaseId = m['purchase_id'];
}

class Promotion {
  final String id; final String name; final String type;
  final Decimal value; final DateTime startDate; final DateTime endDate;
  final bool isActive; final String? categoryId; final String? productId;
  final Decimal minPurchaseAmount;
  Promotion.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], type = m['type'],
    value = _d(m['value']), startDate = _dt(m['start_date']),
    endDate = _dt(m['end_date']), isActive = _b(m['is_active']),
    categoryId = m['category_id'], productId = m['product_id'],
    minPurchaseAmount = _d(m['min_purchase_amount']);
}

class WeeklyHoursEntry {
  final String id; final String employeeId; final int year; final int weekNumber;
  final Decimal regularHours; final Decimal overtimeHours;
  final Decimal totalHours;
  WeeklyHoursEntry.fromMap(Map<String, dynamic> m) :
    id = m['id'], employeeId = m['employee_id'],
    year = _i(m['year']), weekNumber = _i(m['week_number']),
    regularHours = _d(m['regular_hours']),
    overtimeHours = _d(m['overtime_hours']),
    totalHours = _d(m['total_hours']);
}

class PurchaseOrder {
  final String id; final String? supplierId; final Decimal total;
  final String? orderNumber; final DateTime date;
  final String status; final String? warehouseId; final String? notes;
  PurchaseOrder.fromMap(Map<String, dynamic> m) :
    id = m['id'], supplierId = m['supplier_id'], total = _d(m['total']),
    orderNumber = m['order_number'], date = _dt(m['date']),
    status = m['status'] ?? 'QUOTATION', warehouseId = m['warehouse_id'],
    notes = m['notes'];
}

class ProformaInvoice {
  final String id; final String? customerId; final Decimal total;
  final Decimal discount; final Decimal tax; final DateTime? validUntil;
  final String status; final String? notes;
  ProformaInvoice.fromMap(Map<String, dynamic> m) :
    id = m['id'], customerId = m['customer_id'], total = _d(m['total']),
    discount = _d(m['discount']), tax = _d(m['tax']),
    validUntil = m['valid_until'] != null ? _dt(m['valid_until']) : null,
    status = m['status'] ?? 'DRAFT', notes = m['notes'];
}

class AppSetting {
  final String id; final String key; final String value; final String? groupName;
  AppSetting.fromMap(Map<String, dynamic> m) :
    id = m['id'], key = m['key'], value = m['value'], groupName = m['group_name'];
}

// Result wrapper classes for relationships
class ProductWithCategory {
  final Product product; final Category? category;
  ProductWithCategory(this.product, this.category);
}

class SaleWithCustomer {
  final Sale sale; final Customer? customer;
  SaleWithCustomer(this.sale, this.customer);
}

class PurchaseWithSupplier {
  final Purchase purchase; final Supplier? supplier;
  PurchaseWithSupplier(this.purchase, this.supplier);
}

class GLAccountWithParent {
  final GLAccount account; final GLAccount? parent;
  GLAccountWithParent(this.account, this.parent);
}
