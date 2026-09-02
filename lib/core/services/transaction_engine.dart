import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/events/app_events.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/accounting/budget_service.dart';
import 'package:supermarket/core/services/approval_workflow_service.dart';
import 'package:supermarket/core/services/inventory/serial_number_service.dart';
import 'package:uuid/uuid.dart';

class TransactionEngine {
  final AppDatabase db;
  final EventBusService eventBus;
  final AuditService _auditService;
  // ignore: unused_field
  final AppConfigService _configService;
  final PostingEngine _postingEngine;
  final PackagingEngine packagingEngine;
  // ignore: unused_field
  BudgetService? _budgetService;
  // ignore: unused_field
  ApprovalWorkflowService? _approvalService;
  // ignore: unused_field
  final InventoryCostingService _costingService;
  // ignore: unused_field
  SerialNumberService? _serialNumberService;

  TransactionEngine(
    this.db,
    this.eventBus,
    this._postingEngine,
    this.packagingEngine,
    this._costingService,
  )   : _auditService = AuditService(db),
        _configService = AppConfigService(db);

  void setBudgetService(BudgetService budgetService) {
    _budgetService = budgetService;
  }

  void setApprovalService(ApprovalWorkflowService approvalService) {
    _approvalService = approvalService;
  }

  void setSerialNumberService(SerialNumberService serialNumberService) {
    _serialNumberService = serialNumberService;
  }

  Future<void> _checkAccountingPeriodOpen() async {
    final now = DateTime.now();
    final openPeriod = await (db.select(db.accountingPeriods)
          ..where((p) => p.isClosed.equals(false))
          ..where((p) => p.startDate.isSmallerOrEqual(Variable(now)))
          ..where((p) => p.endDate.isBiggerOrEqual(Variable(now))))
        .get()
        .then((rows) => rows.isEmpty ? null : rows.first);
    if (openPeriod == null) {
      throw const BusinessException(
          message: 'لا توجد فترة محاسبية مفتوحة حالياً. يرجى فتح فترة محاسبية جديدة.');
    }
  }

  /// ==================== POST PURCHASE ====================
  Future<void> postPurchase(String purchaseId, {String? userId}) async {
    if (purchaseId.isEmpty) {
      throw const BusinessException(message: 'معرف الفاتورة غير صالح.');
    }

    await _checkAccountingPeriodOpen();

    await db.transaction(() async {
      final purchase = await (db.select(db.purchases)..where((p) => p.id.equals(purchaseId))).getSingle();

      if (purchase.isCredit && purchase.supplierId == null) {
        throw const BusinessException(message: 'يجب اختيار مورد لفاتورة الشراء الآجل.');
      }
      if (purchase.status == DocumentStatus.posted) {
        throw const BusinessException(message: 'هذه الفاتورة تم ترحيلها بالفعل.');
      }

      final items = await (db.select(db.purchaseItems)..where((pi) => pi.purchaseId.equals(purchaseId))).get();

      if (items.isEmpty) {
        throw const BusinessException(message: 'لا يمكن ترحيل فاتورة مشتريات بدون أصناف.');
      }

      Decimal subtotal = Decimal.zero;
      for (var item in items) {
        if (item.quantity <= Decimal.zero) {
          throw const BusinessException(message: 'كمية الشراء يجب أن تكون أكبر من الصفر.');
        }
        subtotal += item.quantity * item.price;
      }

      for (var item in items) {
        Decimal itemValue = item.quantity * item.price;
        Decimal proportion = subtotal > Decimal.zero ? (itemValue / subtotal).toDecimal() : Decimal.zero;
        Decimal allocatedLandedCost = purchase.landedCosts * proportion;
        Decimal landedCostPerUnit = item.quantity > Decimal.zero ? (allocatedLandedCost / item.quantity).toDecimal() : Decimal.zero;
        Decimal finalUnitCost = item.price + landedCostPerUnit;

        final batchId = const Uuid().v4();
        await db.into(db.productBatches).insert(
              ProductBatchesCompanion.insert(
                id: Value(batchId),
                productId: item.productId,
                warehouseId: purchase.warehouseId ?? '',
                batchNumber: item.batchNumber != null && item.batchNumber!.isNotEmpty
                    ? item.batchNumber!
                    : 'PUR-${purchase.id.substring(0, 8)}',
                expiryDate: Value(item.expiryDate),
                quantity: Value(item.quantity),
                initialQuantity: Value(item.quantity),
                costPrice: Value(finalUnitCost),
                storedUnitId: Value(item.unitId),
                quantityInStoredUnit: Value(item.quantity),
                syncStatus: const Value.absent(),
              ),
            );

        await (db.update(db.purchaseItems)..where((pi) => pi.id.equals(item.id)))
            .write(PurchaseItemsCompanion(batchId: Value(batchId)));

        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: purchase.warehouseId ?? '',
                batchId: Value(batchId),
                quantity: Value(item.quantity),
                type: 'PURCHASE',
                referenceId: purchaseId,
              ),
            );

        // Stock is updated by GRN service. Only update buyPrice here.
        await (db.update(db.products)..where((p) => p.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            buyPrice: Value(finalUnitCost),
          ),
        );
      }

      await (db.update(db.purchases)..where((p) => p.id.equals(purchaseId)))
          .write(const PurchasesCompanion(status: Value(DocumentStatus.posted)));

      if (purchase.isCredit && purchase.supplierId != null) {
        final supplier = await (db.select(db.suppliers)..where((s) => s.id.equals(purchase.supplierId!))).getSingle();
        await (db.update(db.suppliers)..where((s) => s.id.equals(supplier.id)))
            .write(SuppliersCompanion(balance: Value(supplier.balance + purchase.total)));
      }

      await _postingEngine.post(
        type: TransactionType.purchase,
        referenceId: purchaseId,
        context: {
          'amount': purchase.total,
          'tax': purchase.tax,
          'paymentMethod': purchase.isCredit ? 'credit' : 'cash',
          'description': 'إثبات فاتورة مشتريات #${purchaseId.substring(0, 8)}',
          'supplierId': purchase.supplierId,
          'branchId': purchase.branchId,
          'currencyId': purchase.currencyId,
          'exchangeRate': purchase.exchangeRate,
          'date': purchase.date,
        },
      );

      await _auditService.log(
        action: 'POST_PURCHASE',
        targetEntity: 'Purchases',
        entityId: purchaseId,
        userId: userId,
        details: 'Posted purchase invoice $purchaseId',
      );

      eventBus.fire(PurchasePostedEvent(purchase, items, userId: userId));
    });
  }

  /// ==================== POST SALE ====================
  Future<void> postSale(String saleId, {String? userId, Map<String, List<String>>? serialNumbersByProduct}) async {
    await _checkAccountingPeriodOpen();

    final saleCheck = await (db.select(db.sales)..where((s) => s.id.equals(saleId))).getSingleOrNull();
    if (saleCheck == null) throw const BusinessException(message: 'الفاتورة غير موجودة.');
    if (saleCheck.status == DocumentStatus.posted) {
      throw const BusinessException(message: 'هذه الفاتورة تم ترحيلها بالفعل.');
    }

    await db.transaction(() async {
      final sale = saleCheck;
      final items = await (db.select(db.saleItems)..where((si) => si.saleId.equals(saleId))).get();
      
      Decimal saleCogs = Decimal.zero;
      for (var item in items) {
        Decimal remainingToDeduct = item.quantity;
        final product = await (db.select(db.products)..where((p) => p.id.equals(item.productId))).getSingle();

        // Find batches matching the sold unit name
        var unitBatchesQuery = db.select(db.productBatches)
          ..where((b) => b.productId.equals(item.productId))
          ..where((b) => b.quantity.isBiggerThanValue(Decimal.zero.toString()));
        
        // Filter by storedUnitId matching the sale's unitName
        if (item.unitName.isNotEmpty && item.unitName != product.unit) {
          unitBatchesQuery = unitBatchesQuery..where((b) => b.storedUnitId.equals(item.unitName));
        } else {
          // Selling in main unit - find batches stored in main unit or unassigned
          unitBatchesQuery = unitBatchesQuery..where(
            (b) => b.storedUnitId.equals(product.unit) | b.storedUnitId.isNull(),
          );
        }
        
        if (sale.warehouseId != null && sale.warehouseId!.isNotEmpty) {
          unitBatchesQuery = unitBatchesQuery..where((b) => b.warehouseId.equals(sale.warehouseId!));
        }

        final unitBatches = await unitBatchesQuery.get();
        Decimal availableInSameUnit = unitBatches.fold(Decimal.zero, (sum, b) => sum + b.quantity);

        if (availableInSameUnit < remainingToDeduct) {
          throw BusinessException(
            message: 'المخزون غير كافٍ للمنتج: ${product.name} بوحدة ${item.unitName}. '
            'المتوفر من هذه الوحدة: $availableInSameUnit. '
            'يرجى إجراء عملية "تفكيك" إذا كان لديك وحدات كبرى.',
          );
        }

        for (final currentBatch in unitBatches) {
          if (remainingToDeduct <= Decimal.zero) break;
          final deduct = remainingToDeduct > currentBatch.quantity ? currentBatch.quantity : remainingToDeduct;
          
          await (db.update(db.productBatches)..where((b) => b.id.equals(currentBatch.id)))
              .write(ProductBatchesCompanion(quantity: Value(currentBatch.quantity - deduct)));
          
          await db.into(db.inventoryTransactions).insert(
                InventoryTransactionsCompanion.insert(
                  productId: item.productId,
                  warehouseId: currentBatch.warehouseId,
                  batchId: Value(currentBatch.id),
                  quantity: Value(-deduct),
                  type: 'SALE',
                  referenceId: saleId,
                ),
              );
          
          saleCogs += deduct * currentBatch.costPrice;
          remainingToDeduct -= deduct;
        }

        // Stock is tracked in main unit. Deduct the sold quantity directly.
        await (db.update(db.products)..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(stock: Value(product.stock - item.quantity)));
      }

      await (db.update(db.sales)..where((s) => s.id.equals(saleId))).write(
        const SalesCompanion(status: Value(DocumentStatus.posted)),
      );

      await _postingEngine.post(
        type: TransactionType.sale,
        referenceId: saleId,
        context: {
          'amount': sale.total,
          'tax': sale.tax,
          'cogs': saleCogs,
          'paymentMethod': sale.isCredit ? 'credit' : 'cash',
          'description': 'إثبات فاتورة مبيعات #${saleId.substring(0, 8)}',
          'customerId': sale.customerId,
          'date': sale.createdAt,
        },
      );
    });
  }

  Future<void> postSaleReturn(String returnId, {String? userId}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      final saleReturn = await (db.select(db.salesReturns)..where((r) => r.id.equals(returnId))).getSingle();
      final items = await (db.select(db.salesReturnItems)..where((ri) => ri.salesReturnId.equals(returnId))).get();
      final sale = await (db.select(db.sales)..where((s) => s.id.equals(saleReturn.saleId))).getSingle();

      Decimal returnCogs = Decimal.zero;
      for (var item in items) {
        final product = await (db.select(db.products)..where((p) => p.id.equals(item.productId))).getSingle();
        final batchId = item.batchId;
        if (batchId != null) {
          final batch = await (db.select(db.productBatches)..where((b) => b.id.equals(batchId))).getSingle();
          await (db.update(db.productBatches)..where((b) => b.id.equals(batchId)))
              .write(ProductBatchesCompanion(quantity: Value(batch.quantity + item.quantity)));
          returnCogs += item.quantity * batch.costPrice;
        }
        await (db.update(db.products)..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(stock: Value(product.stock + item.quantity)));
      }

      await _postingEngine.post(
        type: TransactionType.saleReturn,
        referenceId: returnId,
        context: {
          'amount': saleReturn.amountReturned,
          'cogs': returnCogs,
          'originalSaleId': saleReturn.saleId,
          'paymentMethod': sale.isCredit ? 'credit' : 'cash',
          'description': 'مردود مبيعات #${returnId.substring(0, 8)}',
          'date': DateTime.now(),
        },
      );
    });
  }

  Future<void> postPurchaseReturn(String returnId, {String? userId}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      final purchaseReturn = await (db.select(db.purchaseReturns)..where((r) => r.id.equals(returnId))).getSingle();
      final items = await (db.select(db.purchaseReturnItems)..where((ri) => ri.purchaseReturnId.equals(returnId))).get();
      final purchase = await (db.select(db.purchases)..where((p) => p.id.equals(purchaseReturn.purchaseId))).getSingle();

      for (var item in items) {
        final product = await (db.select(db.products)..where((p) => p.id.equals(item.productId))).getSingle();
        await (db.update(db.products)..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(stock: Value(product.stock - item.quantity)));
      }

      await _postingEngine.post(
        type: TransactionType.purchaseReturn,
        referenceId: returnId,
        context: {
          'amount': purchaseReturn.amountReturned,
          'originalPurchaseId': purchaseReturn.purchaseId,
          'paymentMethod': purchase.isCredit ? 'credit' : 'cash',
          'description': 'مردود مشتريات #${returnId.substring(0, 8)}',
          'date': DateTime.now(),
        },
      );
    });
  }

  Future<void> cancelSale(String saleId, {String? userId, String? reason}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      await (db.select(db.sales)..where((s) => s.id.equals(saleId))).getSingle();
      await (db.update(db.sales)..where((s) => s.id.equals(saleId)))
          .write(const SalesCompanion(status: Value(DocumentStatus.cancelled)));
    });
  }

  Future<void> cancelPurchase(String purchaseId, {String? userId, String? reason}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      await (db.select(db.purchases)..where((p) => p.id.equals(purchaseId))).getSingle();
      await (db.update(db.purchases)..where((p) => p.id.equals(purchaseId)))
          .write(const PurchasesCompanion(status: Value(DocumentStatus.cancelled)));
    });
  }

  Future<void> postCustomerPayment({required String customerId, required Decimal amount, required String paymentMethod, String? note, String? userId, DateTime? paymentDate}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      await db.into(db.customerPayments).insert(CustomerPaymentsCompanion.insert(
        customerId: customerId,
        amount: amount,
        paymentDate: Value(paymentDate ?? DateTime.now()),
        note: Value(note),
      ));
      final customer = await (db.select(db.customers)..where((c) => c.id.equals(customerId))).getSingle();
      await (db.update(db.customers)..where((c) => c.id.equals(customerId)))
          .write(CustomersCompanion(balance: Value(customer.balance - amount)));
    });
  }

  Future<void> postSupplierPayment({required String supplierId, required Decimal amount, required String paymentMethod, String? note, String? userId, DateTime? paymentDate}) async {
    await _checkAccountingPeriodOpen();
    await db.transaction(() async {
      await db.into(db.supplierPayments).insert(SupplierPaymentsCompanion.insert(
        supplierId: supplierId,
        amount: amount,
        paymentDate: Value(paymentDate ?? DateTime.now()),
        note: Value(note),
      ));
      final supplier = await (db.select(db.suppliers)..where((s) => s.id.equals(supplierId))).getSingle();
      await (db.update(db.suppliers)..where((s) => s.id.equals(supplierId)))
          .write(SuppliersCompanion(balance: Value(supplier.balance - amount)));
    });
  }

  Future<void> postCustomerPaymentWithAllocations({required String customerId, required Decimal amount, required String paymentMethod, String? note, String? userId, DateTime? paymentDate, required List<({String saleId, Decimal amount})> allocations}) async {
    await postCustomerPayment(customerId: customerId, amount: amount, paymentMethod: paymentMethod, note: note, userId: userId, paymentDate: paymentDate);
  }

  Future<void> postSupplierPaymentWithAllocations({required String supplierId, required Decimal amount, required String paymentMethod, String? note, String? userId, DateTime? paymentDate, required List<({String purchaseId, Decimal amount})> allocations}) async {
    await postSupplierPayment(supplierId: supplierId, amount: amount, paymentMethod: paymentMethod, note: note, userId: userId, paymentDate: paymentDate);
  }

  Future<List<SaleWithBalance>> getOutstandingSales(String customerId) async {
    final sales = await (db.select(db.sales)..where((s) => s.customerId.equals(customerId) & s.isCredit.equals(true))).get();
    return sales.map((s) => SaleWithBalance(sale: s, balance: s.total)).toList();
  }

  Future<List<PurchaseWithBalance>> getOutstandingPurchases(String supplierId) async {
    final purchases = await (db.select(db.purchases)..where((p) => p.supplierId.equals(supplierId) & p.isCredit.equals(true))).get();
    return purchases.map((p) => PurchaseWithBalance(purchase: p, balance: p.total)).toList();
  }

  Future<void> postBeginningBalance({required String warehouseId, required DateTime periodDate, required List<({String productId, Decimal quantity, Decimal cost})> items, String? userId}) async {
    await _checkAccountingPeriodOpen();
  }
}

class SaleWithBalance {
  final Sale sale;
  final Decimal balance;
  SaleWithBalance({required this.sale, required this.balance});
}

class PurchaseWithBalance {
  final Purchase purchase;
  final Decimal balance;
  PurchaseWithBalance({required this.purchase, required this.balance});
}
