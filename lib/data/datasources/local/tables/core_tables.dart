part of '../app_database.dart';

class Branches extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get code => text().unique()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Users extends Table with SyncableTable {
  TextColumn get username => text().unique()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get fullName => text()();
  TextColumn get passwordHash => text().nullable()();
  TextColumn get passwordSalt => text().nullable()();
}

class Categories extends Table with SyncableTable {
  TextColumn get name => text().unique()();
  TextColumn get code => text().unique().nullable()();
}

class Products extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get sku => text().unique()();
  TextColumn get barcode => text().unique().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get unit =>
      text().withDefault(const Constant('pcs'))();
  TextColumn get kiloUnit => text().nullable()();
  TextColumn get boxUnit => text().nullable()();
  TextColumn get buyPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get sellPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get wholesalePrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get stock => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get maxStock => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.fromInt(1000).toString()))();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get valuationMethod =>
      text().withDefault(const Constant('FIFO'))();
  BoolColumn get allowFreeQty => boolean().withDefault(const Constant(false))();
  BoolColumn get isService => boolean().withDefault(const Constant(false))();
  TextColumn get alertLimit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.fromInt(10).toString()))();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get taxRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get parentProductId => text().nullable()();
  TextColumn get attributes =>
      text().nullable()();
  TextColumn get additionalCost => text()
      .map(const DecimalConverter())
      .nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get displayUnitId => text().nullable()();
}

class ProductUnits extends Table with SyncableTable {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get unitName => text()();
  TextColumn get barcode =>
      text().unique().nullable()();
  TextColumn get unitFactor => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get buyPrice => text()
      .map(const DecimalConverter())
      .nullable()();
  TextColumn get sellPrice => text()
      .map(const DecimalConverter())
      .nullable()();
  TextColumn get wholesalePrice => text()
      .map(const DecimalConverter())
      .nullable()();
  TextColumn get halfWholesalePrice =>
      text().map(const DecimalConverter()).nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

class Customers extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get normalizedName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get customerType => text().withDefault(
        const Constant('RETAIL'),
      )();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  TextColumn get creditLimit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get balance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get accountId =>
      text().nullable().references(GLAccounts, #id)();
  TextColumn get currencyId => text().nullable().references(Currencies, #id)();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  BoolColumn get isQuickCustomer =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get createdFromPOS =>
      boolean().withDefault(const Constant(false))();
  TextColumn get discountRate =>
      text().map(const DecimalConverter()).withDefault(
          Constant(Decimal.zero.toString()))();
}

class Suppliers extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get supplierType => text().withDefault(
        const Constant('LOCAL'),
      )();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  TextColumn get balance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get accountId =>
      text().nullable().references(GLAccounts, #id)();
  TextColumn get creditLimit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get currencyId => text().nullable().references(Currencies, #id)();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
}

class GlobalUnits extends Table with SyncableTable {
  TextColumn get name => text().unique()();
  TextColumn get symbol => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(true))();
}

class Sales extends Table with SyncableTable {
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get total => text().map(const DecimalConverter())();
  TextColumn get discount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get tax => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  IntColumn get paymentMethod =>
      integer().map(const PaymentMethodConverter())();
  BoolColumn get isCredit => boolean().withDefault(const Constant(false))();
  IntColumn get status => integer()
      .map(const DocumentStatusConverter())
      .withDefault(const Constant(0))();
  TextColumn get saleType =>
      text().withDefault(const Constant('retail'))();
  TextColumn get currencyId => text().nullable()();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get shippingCost => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get otherExpenses => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  TextColumn get representativeId => text().nullable()();
  DateTimeColumn get exchangeDate => dateTime().nullable()();
  TextColumn get qrCode => text().nullable()();
  TextColumn get hash => text().nullable()();
  TextColumn get signature => text().nullable()();
}

class SaleItems extends Table with SyncableTable {
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get price => text().map(const DecimalConverter())();
  TextColumn get unitId => text().nullable().references(GlobalUnits, #id)();
  TextColumn get unitName => text().withDefault(const Constant('\u062D\u0628\u0629'))();
  TextColumn get unitFactor => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  TextColumn get costCenterId =>
      text().nullable().references(CostCenters, #id)();
}

class StockMovements extends Table with SyncableTable {
  @ReferenceName('productStockMovements')
  TextColumn get productId => text().references(Products, #id)();
  @ReferenceName('fromWarehouseStockMovements')
  TextColumn get fromWarehouseId =>
      text().nullable().references(Warehouses, #id)();
  @ReferenceName('toWarehouseStockMovements')
  TextColumn get toWarehouseId =>
      text().nullable().references(Warehouses, #id)();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get cost => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  DateTimeColumn get movementDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get type =>
      text()();
  TextColumn get transactionId => text().nullable()();
  TextColumn get referenceId => text().nullable()();
}

class Purchases extends Table with SyncableTable {
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get total => text().map(const DecimalConverter())();
  TextColumn get tax => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get discount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get landedCosts => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get shippingCost => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get otherExpenses => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get purchaseType => text().withDefault(const Constant('cash'))();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get time => dateTime().nullable()();
  BoolColumn get isCredit => boolean().withDefault(const Constant(false))();
  IntColumn get status => integer()
      .map(const DocumentStatusConverter())
      .withDefault(const Constant(0))();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  TextColumn get currencyId => text().nullable()();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get notes => text().nullable()();
  TextColumn get referenceDocument => text().nullable()();
  TextColumn get attachmentPath => text().nullable()();
}

class PurchaseItems extends Table with SyncableTable {
  TextColumn get purchaseId => text().references(Purchases, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get unitId =>
      text().nullable()();
  TextColumn get unitFactor => text().map(const DecimalConverter()).withDefault(
      Constant(Decimal.one.toString()))();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get quantityInBaseUnit => text()
      .map(const DecimalConverter())
      .nullable()();
  TextColumn get unitPrice =>
      text().map(const DecimalConverter())();
  TextColumn get price => text()
      .map(const DecimalConverter())();
  TextColumn get discount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get discountPercent =>
      text().map(const DecimalConverter()).withDefault(
          Constant(Decimal.zero.toString()))();
  TextColumn get tax => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get taxPercent => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get landedCostShare =>
      text().map(const DecimalConverter()).withDefault(
          Constant(Decimal.zero.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get warehouseId => text().nullable().references(
        Warehouses,
        #id,
      )();
}

class Warehouses extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  TextColumn get accountId => text()
      .nullable()
      .references(GLAccounts, #id)();
  @override
  TextColumn get branchId => text().nullable().references(Branches, #id)();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

@DataClassName('ProductBatch')
class ProductBatches extends Table with SyncableTable {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get batchNumber => text()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get initialQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get costPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get reservedQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get storedUnitId => text().nullable()();
  TextColumn get quantityInStoredUnit => text()
      .map(const DecimalConverter())
      .nullable()();
}

class ItemVariants extends Table with SyncableTable {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get attributeName => text()();
  TextColumn get attributeValue => text()();
  TextColumn get additionalPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get sku => text().nullable()();
  @override
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class SalesReturns extends Table with SyncableTable {
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get amountReturned => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get reason => text().nullable()();
}

class SalesReturnItems extends Table with SyncableTable {
  TextColumn get salesReturnId => text().references(SalesReturns, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get price => text().map(const DecimalConverter())();
  TextColumn get unitFactor => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
}

class PurchaseReturns extends Table with SyncableTable {
  TextColumn get purchaseId => text().references(Purchases, #id)();
  TextColumn get amountReturned => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get reason => text().nullable()();
}

class PurchaseReturnItems extends Table with SyncableTable {
  TextColumn get purchaseReturnId => text().references(PurchaseReturns, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get price => text().map(const DecimalConverter())();
}

class CustomerPayments extends Table with SyncableTable {
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get amount => text().map(const DecimalConverter())();
  DateTimeColumn get paymentDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  TextColumn get paymentMethod => text()
      .withDefault(const Constant('cash'))();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get accountId => text().nullable().references(GLAccounts, #id)();
  TextColumn get status => text().withDefault(
        const Constant('COMPLETED'),
      )();
}

class SupplierPayments extends Table with SyncableTable {
  TextColumn get supplierId => text().references(Suppliers, #id)();
  TextColumn get amount => text().map(const DecimalConverter())();
  TextColumn get remainingAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  DateTimeColumn get paymentDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  TextColumn get paymentMethod => text()
      .withDefault(const Constant('cash'))();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get accountId => text().nullable().references(GLAccounts, #id)();
  TextColumn get status => text().withDefault(
        const Constant('COMPLETED'),
      )();
}

class PurchasePaymentLinks extends Table with SyncableTable {
  TextColumn get paymentId => text().references(SupplierPayments, #id)();
  TextColumn get purchaseId => text().references(Purchases, #id)();
  TextColumn get amount =>
      text().map(const DecimalConverter())();
}

class GLAccounts extends Table with SyncableTable {
  @override
  String get tableName => 'gl_accounts';

  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  IntColumn get accountType => integer().map(const AccountTypeConverter())();
  TextColumn get analyticType =>
      text().nullable()();
  TextColumn get parentId => text().nullable()();
  BoolColumn get isHeader => boolean().withDefault(const Constant(false))();
  TextColumn get balance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class CostCenters extends Table with SyncableTable {
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get type => text().withDefault(
      const Constant('department'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class GLEntries extends Table with SyncableTable {
  @override
  String get tableName => 'gl_entries';

  TextColumn get description => text()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get referenceType =>
      text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get status => text().withDefault(
        const Constant('DRAFT'),
      )();
  DateTimeColumn get postedAt => dateTime().nullable()();
  TextColumn get postedBy => text().nullable()();
  TextColumn get currencyId => text().nullable()();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
}

class GLLines extends Table with SyncableTable {
  @override
  String get tableName => 'gl_lines';

  TextColumn get entryId => text().references(GLEntries, #id)();
  TextColumn get accountId => text().references(GLAccounts, #id)();
  TextColumn get costCenterId =>
      text().nullable().references(CostCenters, #id)();
  TextColumn get debit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get credit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get currencyId => text().nullable().references(Currencies, #id)();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  TextColumn get memo => text().nullable()();
}

class AccountingPeriods extends Table with SyncableTable {
  TextColumn get name => text()();
  IntColumn get fiscalYear => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get closedBy => text().nullable()();
  TextColumn get closingType => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('OPEN'))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {fiscalYear, status},
  ];
}

class ApprovalWorkflows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get documentType => text()();
  TextColumn get conditionType => text().nullable()();
  TextColumn get conditionValue => text().map(const DecimalConverter()).nullable()();
  TextColumn get operator => text().nullable()();
  IntColumn get levelOrder => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ApprovalLevels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workflowId => integer()();
  IntColumn get levelOrder => integer()();
  TextColumn get role => text().nullable()();
  IntColumn get userId => integer().nullable()();
  TextColumn get minAmount => text().map(const DecimalConverter()).nullable()();
  TextColumn get maxAmount => text().map(const DecimalConverter()).nullable()();
  BoolColumn get requiresSignature => boolean().withDefault(const Constant(false))();
}

class ApprovalRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get documentType => text()();
  IntColumn get documentId => integer()();
  IntColumn get workflowId => integer()();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get requestedBy => integer().nullable()();
  DateTimeColumn get requestedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class ApprovalHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get requestId => integer()();
  IntColumn get levelOrder => integer()();
  IntColumn get approverId => integer().nullable()();
  TextColumn get approverRole => text().nullable()();
  TextColumn get action => text()();
  TextColumn get comments => text().nullable()();
  DateTimeColumn get actionDate => dateTime()();
}

class Quotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quotationNumber => text().unique()();
  IntColumn get customerId => integer()();
  IntColumn get branchId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get subtotal => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get discountTotal => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get taxTotal => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get totalAmount => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get notes => text().nullable()();
  IntColumn get createdBy => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class QuotationItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get quotationId => integer()();
  IntColumn get productId => integer()();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get unitPrice => text().map(const DecimalConverter())();
  TextColumn get discountPercent => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get discountAmount => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get taxPercent => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get taxAmount => text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get totalAmount => text().map(const DecimalConverter())();
  TextColumn get notes => text().nullable()();
}

class SyncQueue extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get entityTable => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get status => integer().withDefault(const Constant(0))();
  TextColumn get deviceId => text().nullable()();

  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InventoryAudits extends Table with SyncableTable {
  DateTimeColumn get auditDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  TextColumn get auditedBy => text().nullable()();
}

class InventoryAuditItems extends Table with SyncableTable {
  TextColumn get auditId => text().references(InventoryAudits, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get systemStock => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get actualStock => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get difference => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class Shifts extends Table with SyncableTable {
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get startTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get openingCash => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get closingCash =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get expectedCash =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isOpen => boolean().withDefault(const Constant(true))();
}

class Reconciliations extends Table with SyncableTable {
  TextColumn get accountId => text().references(GLAccounts, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get bookBalance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get actualBalance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get difference => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get note => text().nullable()();
}

class ReconciliationDetails extends Table {
  TextColumn get reconciliationId => text().references(Reconciliations, #id)();
  TextColumn get transactionId => text().references(AccountTransactions, #id)();
  TextColumn get statementAmount => text().map(const DecimalConverter())();
  DateTimeColumn get statementDate => dateTime()();
  TextColumn get reference => text().nullable()();
  TextColumn get branchId => text().nullable().references(Branches, #id)();
}

class AuditLogs extends Table with SyncableTable {
  TextColumn get userId => text().nullable().references(Users, #id)();
  TextColumn get action => text()();
  TextColumn get targetEntity => text()();
  TextColumn get entityId => text()();
  TextColumn get details => text().nullable()();
  TextColumn get oldValues => text().nullable()();
  TextColumn get newValues => text().nullable()();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get accountingPeriodId => text().nullable().references(AccountingPeriods, #id)();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class StockTransfers extends Table with SyncableTable {
  @ReferenceName('fromWarehouseStockTransfers')
  TextColumn get fromWarehouseId => text().references(Warehouses, #id)();
  @ReferenceName('toWarehouseStockTransfers')
  TextColumn get toWarehouseId => text().references(Warehouses, #id)();
  DateTimeColumn get transferDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('COMPLETED'))();
}

class StockTransferItems extends Table with SyncableTable {
  TextColumn get transferId => text().references(StockTransfers, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get batchId => text().references(ProductBatches, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class Employees extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get employeeCode => text().unique()();
  TextColumn get jobTitle => text().nullable()();
  TextColumn get role =>
      text().withDefault(const Constant('USER'))();
  TextColumn get basicSalary => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  DateTimeColumn get hireDate => dateTime().nullable()();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class PayrollEntries extends Table with SyncableTable {
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  DateTimeColumn get generationDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  TextColumn get note => text().nullable()();
}

class PayrollLines extends Table with SyncableTable {
  TextColumn get payrollEntryId => text().references(PayrollEntries, #id)();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get basicSalary => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get allowances => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get deductions => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get netSalary => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class Permissions extends Table with SyncableTable {
  TextColumn get code => text().unique()();
  TextColumn get description => text().nullable()();
}

class RolePermissions extends Table with SyncableTable {
  TextColumn get role => text()();
  TextColumn get permissionCode => text().references(Permissions, #code)();
}

class CashboxTransactions extends Table with SyncableTable {
  TextColumn get amount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get type => text()();
  TextColumn get category => text()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get userId => text().references(Users, #id)();
}

class FinancialTransfers extends Table with SyncableTable {
  TextColumn get senderAccountId => text().references(GLAccounts, #id)();
  @ReferenceName('receiverAccountFinancialTransfers')
  TextColumn get receiverAccountId => text().references(GLAccounts, #id)();
  TextColumn get amount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();

  TextColumn get commission => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get company => text().nullable()();
  TextColumn get transferType => text()();
  TextColumn get checkId => text().nullable().references(Checks, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('POSTED'))();
}

class PriceLists extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
}

class PriceListItems extends Table with SyncableTable {
  TextColumn get priceListId => text().references(PriceLists, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get price => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get minQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class Promotions extends Table with SyncableTable {
  TextColumn get name => text()();
  TextColumn get type =>
      text()();
  TextColumn get value => text().map(const DecimalConverter()).withDefault(
      Constant(Decimal.zero.toString()))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get productId => text().nullable().references(Products, #id)();
  TextColumn get minPurchaseAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class PriceHistory extends Table with SyncableTable {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get oldPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get newPrice => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get type => text()();
}

class Currencies extends Table with SyncableTable {
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get fractionalUnit => text().nullable()();
  IntColumn get decimalPlaces =>
      integer().withDefault(const Constant(2))();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
  BoolColumn get isBase => boolean().withDefault(const Constant(false))();
}

class ExchangeRates extends Table {
  @ReferenceName('fromCurrencyExchangeRates')
  TextColumn get fromCurrencyCode => text().references(Currencies, #code)();
  @ReferenceName('toCurrencyExchangeRates')
  TextColumn get toCurrencyCode => text().references(Currencies, #code)();
  TextColumn get rate => text().map(const DecimalConverter())();
  DateTimeColumn get effectiveDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class APInvoices extends Table with SyncableTable {
  TextColumn get supplierId => text().references(Suppliers, #id)();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get invoiceDate =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get totalAmount => integer().map(const CentConverter())();
  TextColumn get taxAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get paidAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get status => text()
      .withDefault(const Constant('DRAFT'))();
  TextColumn get notes => text().nullable()();
  TextColumn get accountId => text().nullable().references(GLAccounts, #id)();
}

class ARInvoices extends Table with SyncableTable {
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get invoiceDate =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get totalAmount => integer().map(const CentConverter())();
  TextColumn get taxAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get paidAmount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get status => text()
      .withDefault(const Constant('DRAFT'))();
  TextColumn get notes => text().nullable()();
  TextColumn get accountId => text().nullable().references(GLAccounts, #id)();
}

class InventoryTransactions extends Table with SyncableTable {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  TextColumn get quantity => text().map(const DecimalConverter()).withDefault(
      Constant(Decimal.zero.toString()))();
  TextColumn get type =>
      text()();
  TextColumn get referenceId => text()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}

class AccountTransactions extends Table with SyncableTable {
  TextColumn get accountId => text().references(GLAccounts, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get type => text()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get debit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get credit => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  BoolColumn get reconciled => boolean().withDefault(const Constant(false))();
}

class StockTakes extends Table with SyncableTable {
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status =>
      text().withDefault(const Constant('DRAFT'))();
  TextColumn get note => text().nullable()();
}

class StockTakeItems extends Table with SyncableTable {
  TextColumn get stockTakeId => text().references(StockTakes, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get expectedQty => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get actualQty => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get variance => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class PostingProfiles extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get operationType =>
      text()();
  TextColumn get accountType =>
      text()();
  TextColumn get accountId => text().nullable().references(GLAccounts, #id)();
  TextColumn get description => text().nullable()();
  TextColumn get accountCode =>
      text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sequence =>
      integer().withDefault(const Constant(0))();
  TextColumn get side => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get branchId => text().nullable().references(Branches, #id)();
  IntColumn get syncStatus => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class GoodReceivedNotes extends Table with SyncableTable {
  TextColumn get purchaseId => text().nullable().references(Purchases, #id)();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get grnNumber => text().unique()();
  DateTimeColumn get receivedDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get receivedBy => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('DRAFT'))();
}

class GoodReceivedNoteItems extends Table with SyncableTable {
  TextColumn get grnId => text().references(GoodReceivedNotes, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
}

class DeliveryNotes extends Table with SyncableTable {
  TextColumn get saleOrderId => text().references(SalesOrders, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get deliveryNumber => text().unique()();
  DateTimeColumn get deliveryDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get deliveredBy => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('DRAFT'))();
}

class DeliveryNoteItems extends Table with SyncableTable {
  TextColumn get deliveryNoteId => text().references(DeliveryNotes, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
}

class PickingLists extends Table with SyncableTable {
  TextColumn get salesOrderId => text().references(SalesOrders, #id)();
  TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get pickListNumber => text().unique()();
  DateTimeColumn get pickDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get pickedBy => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
}

class PickingListItems extends Table with SyncableTable {
  TextColumn get pickListId => text().references(PickingLists, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get pickedQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
}

class PackingLists extends Table with SyncableTable {
  TextColumn get pickListId => text().references(PickingLists, #id)();
  TextColumn get deliveryNoteId => text().nullable().references(DeliveryNotes, #id)();
  TextColumn get packListNumber => text().unique()();
  DateTimeColumn get packDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get packedBy => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
}

class PackingListItems extends Table with SyncableTable {
  TextColumn get packListId => text().references(PackingLists, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
}

class Checks extends Table with SyncableTable {
  TextColumn get checkNumber => text()();
  TextColumn get bankName => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get amount => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get type =>
      text()();
  TextColumn get status => text().withDefault(
        const Constant('PENDING'),
      )();
  TextColumn get partnerId => text().nullable()();
  TextColumn get paymentAccountId =>
      text().nullable().references(GLAccounts, #id)();
  TextColumn get note => text().nullable()();
  TextColumn get currencyId => text().nullable().references(Currencies, #id)();
  TextColumn get exchangeRate => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.one.toString()))();
}

class BillOfMaterials extends Table with SyncableTable {
  @ReferenceName('finishedProduct')
  TextColumn get finishedProductId => text().references(Products, #id)();
  @ReferenceName('componentProduct')
  TextColumn get componentProductId => text().references(Products, #id)();
  TextColumn get quantity =>
      text().map(const DecimalConverter()).withDefault(Constant(Decimal.zero
          .toString()))();
}

class ProductionOrders extends Table with SyncableTable {
  TextColumn get finishedProductId => text().references(Products, #id)();
  TextColumn get plannedQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get actualQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant(
      'PLANNED'))();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  TextColumn get note => text().nullable()();
}

class ProductionOrderItems extends Table with SyncableTable {
  TextColumn get productionOrderId =>
      text().references(ProductionOrders, #id)();
  TextColumn get componentProductId => text().references(Products, #id)();
  TextColumn get plannedQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get actualQuantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get unitCost => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
}

class PurchaseOrders extends Table with SyncableTable {
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get total => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get orderNumber => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(
        const Constant('QUOTATION'),
      )();
  TextColumn get warehouseId => text().nullable().references(Warehouses, #id)();
  TextColumn get notes => text().nullable()();
}

class PurchaseOrderItems extends Table with SyncableTable {
  TextColumn get orderId => text().references(PurchaseOrders, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get price => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get unitId => text().nullable()();
}

class SalesOrders extends Table with SyncableTable {
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get total => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get orderNumber => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(
        const Constant('QUOTATION'),
      )();
  TextColumn get notes => text().nullable()();
}

class SalesOrderItems extends Table with SyncableTable {
  TextColumn get orderId => text().references(SalesOrders, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get quantity => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get price => text()
      .map(const DecimalConverter())
      .withDefault(Constant(Decimal.zero.toString()))();
  TextColumn get unitId => text().nullable()();
}

class CustomerPaymentLinks extends Table with SyncableTable {
  TextColumn get paymentId => text().references(CustomerPayments, #id)();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get amount => text().map(const DecimalConverter()).withDefault(
      Constant(Decimal.zero.toString()))();
}
