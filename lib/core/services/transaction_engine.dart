import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/events/app_events.dart';
import 'package:supermarket/core/services/event_bus_service.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/inventory_costing_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/services/cash_management_service.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:supermarket/core/services/posting_engine.dart';
import 'package:supermarket/core/services/budget_service.dart';
import 'package:supermarket/core/services/approval_workflow_service.dart';
import 'package:supermarket/core/services/serial_number_service.dart';
import 'package:supermarket/core/exceptions/concurrency_exception.dart';
import 'package:uuid/uuid.dart';

/// Single source of truth for all business transactions.
/// Every operation is atomic - if any step fails, the entire transaction rolls back.
class TransactionEngine {
  final AppDatabase db;
  final EventBusService eventBus;
  final AuditService _auditService;
  final AppConfigService _configService;
  final PostingEngine _postingEngine;
  final PackagingEngine packagingEngine;
  BudgetService? _budgetService;
  ApprovalWorkflowService? _approvalService;
  final InventoryCostingService _costingService;
  SerialNumberService? _serialNumberService;

  TransactionEngine(
    this.db,
    this.eventBus,
    this._postingEngine,
    this.packagingEngine,
    this._costingService,
  )   : _auditService = AuditService(db),
        _configService = AppConfigService(db);

  /// Wire budget validation service
  void setBudgetService(BudgetService budgetService) {
    _budgetService = budgetService;
  }

  /// Wire approval workflow service
  void setApprovalService(ApprovalWorkflowService approvalService) {
    _approvalService = approvalService;
  }

  /// Wire serial number service
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
      throw Exception(
          'لا توجد فترة محاسبية مفتوحة حالياً. يرجى فتح فترة محاسبية جديدة.');
    }
  }

  /// ==================== POST PURCHASE ====================
  /// Creates: Purchase + Stock + Batches + GL Entry + Supplier Balance
  Future<void> postPurchase(String purchaseId, {String? userId}) async {
    if (purchaseId.isEmpty) {
      throw Exception('معرف الفاتورة غير صالح.');
    }

    await _checkAccountingPeriodOpen();

    await db.transaction(() async {
      final purchase = await (db.select(
        db.purchases,
      )..where((p) => p.id.equals(purchaseId)))
          .getSingle();

      if (purchase.isCredit && purchase.supplierId == null) {
        throw Exception('يجب اختيار مورد لفاتورة الشراء الآجل.');
      }
      if (purchase.status == DocumentStatus.posted) {
        throw Exception('هذه الفاتورة تم ترحيلها بالفعل.');
      }

      // Verify GRN exists for this purchase
      final grn = await (db.select(db.goodReceivedNotes)
            ..where((g) => g.purchaseId.equals(purchaseId))
            ..where((g) => g.status.equals('POSTED')))
          .getSingleOrNull();
      if (grn == null) {
        throw Exception('لا يمكن ترحيل الفاتورة قبل استلام البضاعة (GRN غير موجود أو غير مرحل).');
      }

      // Check if purchase requires approval (amount > 10,000)
      if (_approvalService != null && purchase.total > Decimal.fromInt(10000)) {
        final existingRequest = await _approvalService!.getRequestByReferenceId(purchaseId);
        if (existingRequest == null) {
          // Submit for approval instead of posting directly
          await _approvalService!.createRequest(
            type: 'PURCHASE',
            title: 'فاتورة مشتريات #${purchaseId.substring(0, 8)}',
            amount: purchase.total.toDouble(),
            requestedBy: userId ?? 'system',
            referenceId: purchaseId,
          );
          // Update purchase status to indicate pending approval
          await (db.update(db.purchases)..where((p) => p.id.equals(purchaseId)))
              .write(const PurchasesCompanion(status: Value(DocumentStatus.draft)));
          return; // Exit - don't post yet
        } else if (existingRequest['status'] != 'approved') {
          throw Exception('هذه الفاتورة بانتظار الموافقة. لا يمكن الترحيل حتى تتم الموافقة عليها.');
        }
      }

      final items = await (db.select(
        db.purchaseItems,
      )..where((pi) => pi.purchaseId.equals(purchaseId)))
          .get();

      if (items.isEmpty) {
        throw Exception('لا يمكن ترحيل فاتورة مشتريات بدون أصناف.');
      }

      Decimal subtotal = Decimal.zero;
      for (var item in items) {
        if (item.quantity <= Decimal.zero) {
          throw Exception('كمية الشراء يجب أن تكون أكبر من الصفر.');
        }
        subtotal += item.quantity * item.price;
      }

      // Process each item: update stock, create batches, allocate landed costs
      for (var item in items) {
        Decimal itemValue = item.quantity * item.price;
        Decimal proportion = subtotal > Decimal.zero
            ? (itemValue / subtotal).toDecimal()
            : Decimal.zero;
        Decimal allocatedLandedCost = purchase.landedCosts * proportion;
        Decimal landedCostPerUnit = item.quantity > Decimal.zero
            ? (allocatedLandedCost / item.quantity).toDecimal()
            : Decimal.zero;
        Decimal finalUnitCost = item.price + landedCostPerUnit;

        final product = await (db.select(
          db.products,
        )..where((p) => p.id.equals(item.productId)))
            .getSingle();

        Decimal qtyInBaseUnit = item.quantity * item.unitFactor;

        final batchId = const Uuid().v4();
        String? storedUnitId;
        if (item.unitId != null && item.unitId!.isNotEmpty) {
          storedUnitId = item.unitId;
        }
        await db.into(db.productBatches).insert(
              ProductBatchesCompanion.insert(
                id: Value(batchId),
                productId: item.productId,
                warehouseId: purchase.warehouseId ?? '',
                batchNumber:
                    item.batchNumber != null && item.batchNumber!.isNotEmpty
                        ? item.batchNumber!
                        : 'PUR-${purchase.id.substring(0, 8)}',
                expiryDate: Value(item.expiryDate),
                quantity: Value(qtyInBaseUnit),
                initialQuantity: Value(qtyInBaseUnit),
                costPrice: Value(
                  (finalUnitCost / item.unitFactor).toDecimal(),
                ),
                storedUnitId: Value(storedUnitId),
                quantityInStoredUnit: Value(item.quantity),
                syncStatus: const Value.absent(),
              ),
            );

        await (db.update(db.purchaseItems)
              ..where((pi) => pi.id.equals(item.id)))
            .write(PurchaseItemsCompanion(batchId: Value(batchId)));

        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: purchase.warehouseId ?? '',
                batchId: Value(batchId),
                quantity: Value(qtyInBaseUnit),
                type: 'PURCHASE',
                referenceId: purchaseId,
              ),
            );

        await (db.update(
          db.products,
        )..where((p) => p.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            stock: Value(product.stock + qtyInBaseUnit),
            buyPrice: Value(finalUnitCost),
          ),
        );
      }

      // Update purchase status
      await (db.update(db.purchases)..where((p) => p.id.equals(purchaseId)))
          .write(
              const PurchasesCompanion(status: Value(DocumentStatus.posted)));

      // Update supplier balance for credit purchases
      if (purchase.isCredit && purchase.supplierId != null) {
        final supplier = await (db.select(
          db.suppliers,
        )..where((s) => s.id.equals(purchase.supplierId!)))
            .getSingle();
        await (db.update(
          db.suppliers,
        )..where((s) => s.id.equals(supplier.id)))
            .write(
          SuppliersCompanion(balance: Value(supplier.balance + purchase.total)),
        );
      }

      // Single accounting entry through PostingEngine
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
  /// Creates: Sale Status + Stock Deduction + Batch Deduction + GL Entry + Customer Balance
  Future<void> postSale(String saleId, {String? userId, Map<String, List<String>>? serialNumbersByProduct}) async {
    await _checkAccountingPeriodOpen();

    final saleCheck = await (db.select(db.sales)
          ..where((s) => s.id.equals(saleId)))
        .getSingleOrNull();
    if (saleCheck == null) throw Exception('الفاتورة غير موجودة.');
    if (saleCheck.status == DocumentStatus.posted) {
      throw Exception('هذه الفاتورة تم ترحيلها بالفعل.');
    }

    if (saleCheck.paymentMethod == PaymentMethod.cash && userId != null) {
      final activeShift = await (db.select(db.shifts)
            ..where((s) => s.userId.equals(userId) & s.isOpen.equals(true)))
          .getSingleOrNull();
      if (activeShift == null) {
        throw Exception('لا يمكن إجراء عملية بيع نقدي بدون فتح وردية عمل.');
      }
    }

    await db.transaction(() async {
      final currentSale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId))
            ..where((s) => s.status.equals(DocumentStatus.draft.index)))
          .getSingleOrNull();
      if (currentSale == null) {
        throw Exception('حالة الفاتورة غير صالحة للترحيل.');
      }

      final sale = currentSale;
      final items = await (db.select(
        db.saleItems,
      )..where((si) => si.saleId.equals(saleId)))
          .get();
      if (items.isEmpty) {
        throw Exception('لا يمكن ترحيل فاتورة مبيعات بدون أصناف.');
      }

      Decimal saleCogs = Decimal.zero;
      for (var item in items) {
        if (item.quantity <= Decimal.zero) {
          throw Exception('الكمية يجب أن تكون أكبر من الصفر.');
        }
        if (item.price < Decimal.zero) {
          throw Exception('السعر يجب أن يكون أكبر من أو يساوي الصفر.');
        }

        // Validate against budget if item has a cost center
        if (item.costCenterId != null && _budgetService != null) {
          final now = DateTime.now();
          final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
          await _budgetService!.validateExpenseAgainstBudget(
            costCenterId: item.costCenterId!,
            expenseAmount: item.price * item.quantity,
            period: period,
          );
        }

        Decimal remainingToDeduct = item.quantity * item.unitFactor;
        final product = await (db.select(
          db.products,
        )..where((p) => p.id.equals(item.productId)))
            .getSingle();

        if (sale.warehouseId != null && sale.warehouseId!.isNotEmpty) {
          final warehouseStock = await db.productsDao
              .getWarehouseStock(item.productId, sale.warehouseId!);
          if (warehouseStock < remainingToDeduct) {
            await packagingEngine.autoBreakIfNecessary(
              productId: item.productId,
              warehouseId: sale.warehouseId!,
              requiredQtyInBase: remainingToDeduct,
            );
            final warehouseStockAfter = await db.productsDao
                .getWarehouseStock(item.productId, sale.warehouseId!);
            if (warehouseStockAfter < remainingToDeduct) {
              throw Exception(
                'المخزون غير كافٍ للمنتج: ${product.name} في المستودع المحدد. '
                'المتوفر: $warehouseStockAfter',
              );
            }
          }
        } else if (product.stock < remainingToDeduct) {
          await packagingEngine.autoBreakIfNecessary(
            productId: item.productId,
            warehouseId: '',
            requiredQtyInBase: remainingToDeduct,
          );
          final updatedProduct = await (db.select(db.products)
                ..where((p) => p.id.equals(item.productId)))
              .getSingle();
          if (updatedProduct.stock < remainingToDeduct) {
            throw Exception(
              'المخزون غير كافٍ للمنتج: ${product.name}. المتوفر: ${updatedProduct.stock}',
            );
          }
        }

        // Deduct from batches using costing service
        final batches = await _costingService.getBatchesForSale(
          item.productId,
          remainingToDeduct,
          warehouseId: sale.warehouseId,
        );
        Decimal totalDeducted = Decimal.zero;
        for (var batchData in batches) {
          if (batchData.remainingQuantity <= Decimal.zero) continue;
          final deduct = batchData.remainingQuantity;
          final reserved = batchData.batch.reservedQuantity;
          final deductFromReserved =
              reserved >= deduct ? deduct : reserved;
          final currentBatch = batchData.batch;
          final changes = await (db.update(
            db.productBatches,
          )..where((b) => b.id.equals(currentBatch.id) & b.version.equals(currentBatch.version)))
              .write(
            ProductBatchesCompanion(
              quantity: Value(currentBatch.quantity - deduct),
              reservedQuantity:
                  Value(reserved - deductFromReserved),
            ).copyWith(version: Value(currentBatch.version + 1)),
          );
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch ${currentBatch.id} was modified by another transaction');
          }
          await db.into(db.inventoryTransactions).insert(
                InventoryTransactionsCompanion.insert(
                  productId: item.productId,
                  warehouseId: batchData.batch.warehouseId,
                  batchId: Value(batchData.batch.id),
                  quantity: Value(-(batchData.remainingQuantity)),
                  type: 'SALE',
                  referenceId: saleId,
                ),
              );
          totalDeducted += batchData.remainingQuantity;
          saleCogs += batchData.remainingQuantity * batchData.costPerUnit;
        }
        await (db.update(
          db.products,
        )..where((p) => p.id.equals(item.productId)))
            .write(
          ProductsCompanion(stock: Value(product.stock - totalDeducted)),
        );

        // Release any orphaned reservedQuantity set by autoBreak but not consumed
        final batchesAfterDeduction = await (db.select(db.productBatches)
              ..where((b) => b.productId.equals(item.productId)))
            .get();
        for (final b in batchesAfterDeduction) {
          if (b.reservedQuantity > Decimal.zero) {
            final changes = await (db.update(db.productBatches)
                  ..where((p) => p.id.equals(b.id) & p.version.equals(b.version)))
                .write(ProductBatchesCompanion(
              reservedQuantity: Value(Decimal.zero),
            ).copyWith(version: Value(b.version + 1)));
            if (changes == 0) {
              throw ConcurrencyException('ProductBatch ${b.id} was modified by another transaction');
            }
          }
        }
      }

      // Mark serial numbers as sold
      if (_serialNumberService != null && serialNumbersByProduct != null) {
        for (final entry in serialNumbersByProduct.entries) {
          for (final sn in entry.value) {
            final serial =
                await _serialNumberService!.getSerialNumber(sn);
            if (serial != null && serial.status == 'IN_STOCK') {
              await _serialNumberService!.markAsSold(
                serialNumberId: serial.id,
                saleId: saleId,
              );
            }
          }
        }
      }
      // Mark sale as posted
      await (db.update(db.sales)..where((s) => s.id.equals(saleId))).write(
        const SalesCompanion(status: Value(DocumentStatus.posted)),
      );

      // Update customer balance for credit sales
      if (sale.isCredit && sale.customerId != null) {
        final customer = await (db.select(
          db.customers,
        )..where((c) => c.id.equals(sale.customerId!)))
            .getSingle();
        await (db.update(
          db.customers,
        )..where((c) => c.id.equals(customer.id)))
            .write(
          CustomersCompanion(balance: Value(customer.balance + sale.total)),
        );
      }

      // Single accounting entry through PostingEngine (revenue + tax)
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
          'branchId': sale.branchId,
          'currencyId': sale.currencyId,
          'exchangeRate': sale.exchangeRate,
          'date': sale.createdAt,
        },
      );

      // Update budget actual amounts for items with cost centers
      if (_budgetService != null) {
        final now = DateTime.now();
        final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
        for (var item in items) {
          if (item.costCenterId != null) {
            await _budgetService!.updateActualBudget(
              costCenterId: item.costCenterId!,
              expenseAmount: item.price * item.quantity,
              period: period,
            );
          }
        }
      }

      await _auditService.log(
        action: 'POST_SALE',
        targetEntity: 'Sales',
        entityId: saleId,
        userId: userId,
        details: 'Posted sale invoice $saleId',
      );

      eventBus
          .fire(SaleCreatedEvent(sale, items, cogs: saleCogs, userId: userId));
    });
  }

  /// ==================== POST SALE RETURN ====================
  Future<void> postSaleReturn(String returnId, {String? userId}) async {
    await _checkAccountingPeriodOpen();

    final existingTransactions = await (db.select(db.inventoryTransactions)
          ..where((t) => t.referenceId.equals(returnId))
          ..where((t) => t.type.equals('RETURN')))
        .get();
    if (existingTransactions.isNotEmpty) {
      throw Exception('تم معالجة مردود المبيعات بالفعل');
    }

    await db.transaction(() async {
      final saleReturn = await (db.select(
        db.salesReturns,
      )..where((r) => r.id.equals(returnId)))
          .getSingle();
      final items = await (db.select(
        db.salesReturnItems,
      )..where((ri) => ri.salesReturnId.equals(returnId)))
          .get();
      final sale = await (db.select(
        db.sales,
      )..where((s) => s.id.equals(saleReturn.saleId)))
          .getSingle();

      Decimal returnCogs = Decimal.zero;

      for (var item in items) {
        Decimal returnQty = item.quantity;
        final defaultWarehouse = await _configService.getDefaultWarehouseId();
        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .getSingle();

        final batchId = item.batchId;
        final batch = batchId != null
            ? await (db.select(db.productBatches)
                  ..where((b) => b.id.equals(batchId)))
                .getSingleOrNull()
            : null;

        if (batch != null) {
          final changes = await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
              .write(
            ProductBatchesCompanion(
                quantity: Value(batch.quantity + returnQty)).copyWith(version: Value(batch.version + 1)),
          );
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch ${batch.id} was modified by another transaction');
          }
          returnCogs += returnQty * batch.costPrice;
        } else {
          final existingBatches = await (db.select(db.productBatches)
                ..where((b) => b.productId.equals(item.productId))
                ..where((b) =>
                    b.quantity.isBiggerThan(Constant(Decimal.zero.toString())))
                ..orderBy([
                  (b) => OrderingTerm(
                      expression: b.expiryDate.isNull(),
                      mode: OrderingMode.asc),
                  (b) => OrderingTerm(
                      expression: b.expiryDate, mode: OrderingMode.asc),
                ]))
              .get();
          if (existingBatches.isNotEmpty) {
            final targetBatch = existingBatches.first;
            final changes = await (db.update(db.productBatches)
                  ..where((b) => b.id.equals(targetBatch.id) & b.version.equals(targetBatch.version)))
                .write(
              ProductBatchesCompanion(
                  quantity: Value(targetBatch.quantity + returnQty)).copyWith(version: Value(targetBatch.version + 1)),
            );
            if (changes == 0) {
              throw ConcurrencyException('ProductBatch ${targetBatch.id} was modified by another transaction');
            }
            returnCogs += returnQty * targetBatch.costPrice;
          } else {
            final newBatchId = const Uuid().v4();
            await db.into(db.productBatches).insert(
                  ProductBatchesCompanion.insert(
                    id: Value(newBatchId),
                    productId: item.productId,
                    warehouseId: defaultWarehouse,
                    batchNumber: 'RETURN-${returnId.substring(0, 8)}',
                    expiryDate: const Value(null),
                    quantity: Value(returnQty),
                    initialQuantity: Value(returnQty),
                    costPrice: Value(product.buyPrice),
                  ),
                );
            returnCogs += returnQty * product.buyPrice;
          }
        }

        await (db.update(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(stock: Value(product.stock + returnQty)));

        // Auto-reconcile batch vs product stock
        final batchesAfterReturn = await (db.select(db.productBatches)
              ..where((b) => b.productId.equals(item.productId)))
            .get();
        Decimal batchSum = Decimal.zero;
        for (var b in batchesAfterReturn) {
          batchSum += b.quantity;
        }
        final Decimal newStock = product.stock + returnQty;
        if ((batchSum - newStock).abs() > Decimal.parse('0.01')) {
          final mismatch = newStock - batchSum;
          if (batchesAfterReturn.isNotEmpty) {
            final targetBatch = batchesAfterReturn
                .reduce((a, b) => a.quantity > b.quantity ? a : b);
            final changes = await (db.update(db.productBatches)
                  ..where((b) => b.id.equals(targetBatch.id) & b.version.equals(targetBatch.version)))
                .write(ProductBatchesCompanion(
                    quantity: Value(targetBatch.quantity + mismatch)).copyWith(version: Value(targetBatch.version + 1)));
            if (changes == 0) {
              throw ConcurrencyException('ProductBatch ${targetBatch.id} was modified by another transaction');
            }
          }
        }

        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: batch?.warehouseId ?? defaultWarehouse,
                batchId: Value(batch?.id ?? ''),
                quantity: Value(returnQty),
                type: 'RETURN',
                referenceId: returnId,
              ),
            );
      }

      // Reverse customer balance for credit sales
      if (sale.isCredit && sale.customerId != null) {
        final customer = await (db.select(db.customers)
              ..where((c) => c.id.equals(sale.customerId!)))
            .getSingle();
        await (db.update(db.customers)..where((c) => c.id.equals(customer.id)))
            .write(CustomersCompanion(
          balance: Value(customer.balance - saleReturn.amountReturned),
        ));
      }

      // Single accounting through PostingEngine
      await _postingEngine.post(
        type: TransactionType.saleReturn,
        referenceId: returnId,
        context: {
          'amount': saleReturn.amountReturned,
          'cogs': returnCogs,
          'originalSaleId': saleReturn.saleId,
          'paymentMethod': sale.isCredit ? 'credit' : 'cash',
          'description': 'مردود مبيعات #${returnId.substring(0, 8)}',
          'branchId': sale.branchId,
          'date': saleReturn.createdAt,
        },
      );

      eventBus.fire(SaleReturnCreatedEvent(saleReturn, items, userId: userId));
    });
  }

  /// ==================== POST PURCHASE RETURN ====================
  Future<void> postPurchaseReturn(String returnId, {String? userId}) async {
    await _checkAccountingPeriodOpen();

    final existingTransactions = await (db.select(db.inventoryTransactions)
          ..where((t) => t.referenceId.equals(returnId))
          ..where((t) => t.type.equals('PURCHASE_RETURN')))
        .get();
    if (existingTransactions.isNotEmpty) {
      throw Exception('تم معالجة مردود المشتريات بالفعل');
    }

    await db.transaction(() async {
      final purchaseReturn = await (db.select(
        db.purchaseReturns,
      )..where((r) => r.id.equals(returnId)))
          .getSingle();
      final items = await (db.select(
        db.purchaseReturnItems,
      )..where((ri) => ri.purchaseReturnId.equals(returnId)))
          .get();
      final purchase = await (db.select(
        db.purchases,
      )..where((p) => p.id.equals(purchaseReturn.purchaseId)))
          .getSingle();

      Decimal returnCogs = Decimal.zero;

      for (var item in items) {
        Decimal remainingToDeduct = item.quantity;
        final batches = await _costingService.getBatchesInFifoOrder(
          item.productId,
          onlyAvailable: true,
        );

        for (var batch in batches) {
          if (remainingToDeduct <= Decimal.zero) break;
          final available = batch.quantity - batch.reservedQuantity;
          final deduct = remainingToDeduct > available ? available : remainingToDeduct;
          if (deduct <= Decimal.zero) continue;
          final deductFromReserved =
              batch.reservedQuantity >= deduct ? deduct : batch.reservedQuantity;
          final changes = await (db.update(db.productBatches)
                ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
              .write(ProductBatchesCompanion(
            quantity: Value(batch.quantity - deduct),
            reservedQuantity: Value(batch.reservedQuantity - deductFromReserved),
          ).copyWith(version: Value(batch.version + 1)));
          if (changes == 0) {
            throw ConcurrencyException('ProductBatch ${batch.id} was modified by another transaction');
          }
          await db.into(db.inventoryTransactions).insert(
                InventoryTransactionsCompanion.insert(
                  productId: item.productId,
                  warehouseId: batch.warehouseId,
                  batchId: Value(batch.id),
                  quantity: Value(-(deduct)),
                  type: 'PURCHASE_RETURN',
                  referenceId: returnId,
                ),
              );
          returnCogs += deduct * batch.costPrice;
          remainingToDeduct -= deduct;
        }

        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .getSingle();
        await (db.update(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .write(
                ProductsCompanion(stock: Value(product.stock - item.quantity)));
      }

      // Reverse supplier balance
      if (purchase.isCredit && purchase.supplierId != null) {
        final supplier = await (db.select(db.suppliers)
              ..where((s) => s.id.equals(purchase.supplierId!)))
            .getSingle();
        await (db.update(db.suppliers)..where((s) => s.id.equals(supplier.id)))
            .write(SuppliersCompanion(
          balance: Value(supplier.balance - purchaseReturn.amountReturned),
        ));
      }

      // Single accounting through PostingEngine
      await _postingEngine.post(
        type: TransactionType.purchaseReturn,
        referenceId: returnId,
        context: {
          'amount': purchaseReturn.amountReturned,
          'cogs': returnCogs,
          'originalPurchaseId': purchaseReturn.purchaseId,
          'paymentMethod': purchase.isCredit ? 'credit' : 'cash',
          'description': 'مردود مشتريات #${returnId.substring(0, 8)}',
          'branchId': purchase.branchId,
          'date': purchaseReturn.createdAt,
        },
      );

      eventBus.fire(
          PurchaseReturnCreatedEvent(purchaseReturn, items, userId: userId));
    });
  }

  /// ==================== CANCEL SALE ====================
  Future<void> cancelSale(String saleId, {String? userId, String? reason}) async {
    await _checkAccountingPeriodOpen();

    await db.transaction(() async {
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingleOrNull();
      if (sale == null) throw Exception('الفاتورة غير موجودة');
      if (sale.status != DocumentStatus.posted) {
        throw Exception('يمكن فقط إلغاء الفواتير المرحلة');
      }

      final items = await (db.select(db.saleItems)
            ..where((si) => si.saleId.equals(saleId)))
          .get();

      if (items.isEmpty) {
        throw Exception('لا يمكن إلغاء فاتورة مبيعات بدون أصناف.');
      }

      // 1. Reverse stock movements for each item
      for (var item in items) {
        final saleTransactions = await (db.select(db.inventoryTransactions)
              ..where((t) => t.referenceId.equals(saleId))
              ..where((t) => t.type.equals('SALE'))
              ..where((t) => t.productId.equals(item.productId)))
            .get();

        Decimal totalReversed = Decimal.zero;
        for (var tx in saleTransactions) {
          final qtyToRestore = tx.quantity.abs();
          totalReversed += qtyToRestore;

          if (tx.batchId != null && tx.batchId!.isNotEmpty) {
            final batch = await (db.select(db.productBatches)
                  ..where((b) => b.id.equals(tx.batchId!)))
                .getSingleOrNull();
            if (batch != null) {
              final changes = await (db.update(db.productBatches)
                    ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
                  .write(ProductBatchesCompanion(
                    quantity: Value(batch.quantity + qtyToRestore),
                  ).copyWith(version: Value(batch.version + 1)));
              if (changes == 0) {
                throw ConcurrencyException(
                    'ProductBatch ${batch.id} was modified by another transaction');
              }
            }
          }
        }

        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .getSingle();
        final changes = await (db.update(db.products)
              ..where((p) => p.id.equals(item.productId) & p.version.equals(product.version)))
            .write(ProductsCompanion(
              stock: Value(product.stock + totalReversed),
            ).copyWith(version: Value(product.version + 1)));
        if (changes == 0) {
          throw ConcurrencyException(
              'Product ${product.id} was modified by another transaction');
        }
      }

      // 2. Reverse customer balance for credit sales
      if (sale.isCredit && sale.customerId != null) {
        final customer = await (db.select(db.customers)
              ..where((c) => c.id.equals(sale.customerId!)))
            .getSingle();
        await (db.update(db.customers)..where((c) => c.id.equals(customer.id)))
            .write(CustomersCompanion(
              balance: Value(customer.balance - sale.total),
            ));
      }

      // 3. Reverse GL entries: mark originals cancelled + create reversal entries
      final existingEntries = await (db.select(db.gLEntries)
            ..where((e) => e.referenceId.equals(saleId))
            ..where((e) => e.referenceType.equals('SALE') | e.referenceType.equals('COGS')))
          .get();

      for (final entry in existingEntries) {
        await (db.update(db.gLEntries)
              ..where((e) => e.id.equals(entry.id)))
            .write(const GLEntriesCompanion(
              status: Value('CANCELLED'),
            ));

        final reversalEntryId = const Uuid().v4();
        final originalLines = await (db.select(db.gLLines)
              ..where((l) => l.entryId.equals(entry.id)))
            .get();

        await db.into(db.gLEntries).insert(GLEntriesCompanion.insert(
          id: Value(reversalEntryId),
          description: 'إلغاء: ${entry.description}',
          date: Value(DateTime.now()),
          referenceType: const Value('SALE_CANCELLATION'),
          referenceId: Value(saleId),
          status: const Value('POSTED'),
          postedAt: Value(DateTime.now()),
          branchId: Value(entry.branchId),
        ));

        for (final line in originalLines) {
          await db.into(db.gLLines).insert(GLLinesCompanion.insert(
            entryId: reversalEntryId,
            accountId: line.accountId,
            debit: Value(line.credit),
            credit: Value(line.debit),
          ));
        }
      }

      // 4. Mark sale as cancelled
      await (db.update(db.sales)..where((s) => s.id.equals(saleId)))
          .write(const SalesCompanion(status: Value(DocumentStatus.cancelled)));

      await _auditService.log(
        action: 'CANCEL_SALE',
        targetEntity: 'Sales',
        entityId: saleId,
        userId: userId,
        details: 'Cancelled sale: ${reason ?? 'No reason provided'}',
      );

      eventBus.fire(SaleCancelledEvent(sale, userId: userId, reason: reason));
    });
  }

  /// ==================== CANCEL PURCHASE ====================
  Future<void> cancelPurchase(String purchaseId, {String? userId, String? reason}) async {
    await _checkAccountingPeriodOpen();

    await db.transaction(() async {
      final purchase = await (db.select(db.purchases)
            ..where((p) => p.id.equals(purchaseId)))
          .getSingleOrNull();
      if (purchase == null) throw Exception('فاتورة المشتريات غير موجودة');
      if (purchase.status != DocumentStatus.posted) {
        throw Exception('يمكن فقط إلغاء فواتير المشتريات المرحلة');
      }

      final items = await (db.select(db.purchaseItems)
            ..where((pi) => pi.purchaseId.equals(purchaseId)))
          .get();

      if (items.isEmpty) {
        throw Exception('لا يمكن إلغاء فاتورة مشتريات بدون أصناف.');
      }

      // 1. Reverse stock movements for each item (deduct from batches)
      for (var item in items) {
        final purchaseTransactions = await (db.select(db.inventoryTransactions)
              ..where((t) => t.referenceId.equals(purchaseId))
              ..where((t) => t.type.equals('PURCHASE'))
              ..where((t) => t.productId.equals(item.productId)))
            .get();

        Decimal totalDeducted = Decimal.zero;
        for (var tx in purchaseTransactions) {
          final qtyToDeduct = tx.quantity.abs();
          totalDeducted += qtyToDeduct;

          if (tx.batchId != null && tx.batchId!.isNotEmpty) {
            final batch = await (db.select(db.productBatches)
                  ..where((b) => b.id.equals(tx.batchId!)))
                .getSingleOrNull();
            if (batch != null) {
              if (batch.quantity < qtyToDeduct) {
                throw Exception(
                    'لا يمكن إلغاء فاتورة المشتريات: تم بيع جزء من الكمية للصنف ${item.productId}');
              }
              final changes = await (db.update(db.productBatches)
                    ..where((b) => b.id.equals(batch.id) & b.version.equals(batch.version)))
                  .write(ProductBatchesCompanion(
                    quantity: Value(batch.quantity - qtyToDeduct),
                  ).copyWith(version: Value(batch.version + 1)));
              if (changes == 0) {
                throw ConcurrencyException(
                    'ProductBatch ${batch.id} was modified by another transaction');
              }
            }
          }
        }

        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .getSingle();
        final changes = await (db.update(db.products)
              ..where((p) => p.id.equals(item.productId) & p.version.equals(product.version)))
            .write(ProductsCompanion(
              stock: Value(product.stock - totalDeducted),
            ).copyWith(version: Value(product.version + 1)));
        if (changes == 0) {
          throw ConcurrencyException(
              'Product ${product.id} was modified by another transaction');
        }
      }

      // 2. Reverse supplier balance for credit purchases
      if (purchase.isCredit && purchase.supplierId != null) {
        final supplier = await (db.select(db.suppliers)
              ..where((s) => s.id.equals(purchase.supplierId!)))
            .getSingle();
        await (db.update(db.suppliers)
              ..where((s) => s.id.equals(supplier.id)))
            .write(SuppliersCompanion(
              balance: Value(supplier.balance - purchase.total),
            ));
      }

      // 3. Reverse GL entries: mark originals cancelled + create reversal entries
      final existingEntries = await (db.select(db.gLEntries)
            ..where((e) => e.referenceId.equals(purchaseId))
            ..where((e) => e.referenceType.equals('PURCHASE')))
          .get();

      for (final entry in existingEntries) {
        await (db.update(db.gLEntries)
              ..where((e) => e.id.equals(entry.id)))
            .write(const GLEntriesCompanion(
              status: Value('CANCELLED'),
            ));

        final reversalEntryId = const Uuid().v4();
        final originalLines = await (db.select(db.gLLines)
              ..where((l) => l.entryId.equals(entry.id)))
            .get();

        await db.into(db.gLEntries).insert(GLEntriesCompanion.insert(
          id: Value(reversalEntryId),
          description: 'إلغاء: ${entry.description}',
          date: Value(DateTime.now()),
          referenceType: const Value('PURCHASE_CANCELLATION'),
          referenceId: Value(purchaseId),
          status: const Value('POSTED'),
          postedAt: Value(DateTime.now()),
          branchId: Value(entry.branchId),
        ));

        for (final line in originalLines) {
          await db.into(db.gLLines).insert(GLLinesCompanion.insert(
            entryId: reversalEntryId,
            accountId: line.accountId,
            debit: Value(line.credit),
            credit: Value(line.debit),
          ));
        }
      }

      // 4. Mark purchase as cancelled
      await (db.update(db.purchases)..where((p) => p.id.equals(purchaseId)))
          .write(const PurchasesCompanion(
              status: Value(DocumentStatus.cancelled)));

      await _auditService.log(
        action: 'CANCEL_PURCHASE',
        targetEntity: 'Purchases',
        entityId: purchaseId,
        userId: userId,
        details: 'Cancelled purchase: ${reason ?? 'No reason provided'}',
      );

      eventBus.fire(
          PurchaseCancelledEvent(purchase, userId: userId, reason: reason));
    });
  }

  /// ==================== CUSTOMER PAYMENT ====================
  Future<void> postCustomerPayment({
    required String customerId,
    required Decimal amount,
    required String paymentMethod,
    String? note,
    String? userId,
    DateTime? paymentDate,
  }) async {
    await db.transaction(() async {
      final paymentId = const Uuid().v4();
      await db.into(db.customerPayments).insert(
            CustomerPaymentsCompanion.insert(
              id: Value(paymentId),
              customerId: customerId,
              amount: amount,
              paymentDate: Value(paymentDate ?? DateTime.now()),
              note: Value(note),
              syncStatus: const Value.absent(),
            ),
          );

      final customer = await (db.select(db.customers)
            ..where((c) => c.id.equals(customerId)))
          .getSingle();
      await (db.update(db.customers)..where((c) => c.id.equals(customerId)))
          .write(CustomersCompanion(balance: Value(customer.balance - amount)));

      // GL entry through PostingEngine
      await _postingEngine.post(
        type: TransactionType.customerPayment,
        referenceId: paymentId,
        context: {
          'amount': amount,
          'customerId': customerId,
          'paymentMethod': paymentMethod,
          'note': note,
          'description': 'سند قبض من ${customer.name}',
          'date': paymentDate ?? DateTime.now(),
        },
      );
    });
  }

  /// ==================== SUPPLIER PAYMENT ====================
  Future<void> postSupplierPayment({
    required String supplierId,
    required Decimal amount,
    required String paymentMethod,
    String? note,
    String? userId,
    DateTime? paymentDate,
  }) async {
    await db.transaction(() async {
      final paymentId = const Uuid().v4();
      await db.into(db.supplierPayments).insert(
            SupplierPaymentsCompanion.insert(
              id: Value(paymentId),
              supplierId: supplierId,
              amount: amount,
              paymentDate: Value(paymentDate ?? DateTime.now()),
              note: Value(note),
              syncStatus: const Value.absent(),
            ),
          );

      final supplier = await (db.select(db.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .getSingle();
      await (db.update(db.suppliers)..where((s) => s.id.equals(supplierId)))
          .write(SuppliersCompanion(balance: Value(supplier.balance - amount)));

      await _postingEngine.post(
        type: TransactionType.supplierPayment,
        referenceId: paymentId,
        context: {
          'amount': amount,
          'supplierId': supplierId,
          'paymentMethod': paymentMethod,
          'note': note,
          'description': 'سند صرف إلى ${supplier.name}',
          'date': paymentDate ?? DateTime.now(),
        },
      );
    });
  }

  /// ==================== CUSTOMER PAYMENT WITH ALLOCATIONS ====================
  Future<void> postCustomerPaymentWithAllocations({
    required String customerId,
    required Decimal amount,
    required String paymentMethod,
    String? note,
    String? userId,
    DateTime? paymentDate,
    required List<({String saleId, Decimal amount})> allocations,
  }) async {
    await db.transaction(() async {
      final paymentId = const Uuid().v4();
      await db.into(db.customerPayments).insert(
            CustomerPaymentsCompanion.insert(
              id: Value(paymentId),
              customerId: customerId,
              amount: amount,
              paymentDate: Value(paymentDate ?? DateTime.now()),
              note: Value(note),
              syncStatus: const Value.absent(),
            ),
          );

      for (final alloc in allocations) {
        await db.into(db.customerPaymentLinks).insert(
              CustomerPaymentLinksCompanion.insert(
                paymentId: paymentId,
                saleId: alloc.saleId,
                amount: Value(alloc.amount),
              ),
            );
      }

      final customer = await (db.select(db.customers)
            ..where((c) => c.id.equals(customerId)))
          .getSingle();
      await (db.update(db.customers)..where((c) => c.id.equals(customerId)))
          .write(CustomersCompanion(balance: Value(customer.balance - amount)));

      await _postingEngine.post(
        type: TransactionType.customerPayment,
        referenceId: paymentId,
        context: {
          'amount': amount,
          'customerId': customerId,
          'paymentMethod': paymentMethod,
          'note': note,
          'description': 'سند قبض ${customer.name} (توزيعات)',
          'date': paymentDate ?? DateTime.now(),
        },
      );
    });
  }

  /// ==================== SUPPLIER PAYMENT WITH ALLOCATIONS ====================
  Future<void> postSupplierPaymentWithAllocations({
    required String supplierId,
    required Decimal amount,
    required String paymentMethod,
    String? note,
    String? userId,
    DateTime? paymentDate,
    required List<({String purchaseId, Decimal amount})> allocations,
  }) async {
    await db.transaction(() async {
      final paymentId = const Uuid().v4();
      await db.into(db.supplierPayments).insert(
            SupplierPaymentsCompanion.insert(
              id: Value(paymentId),
              supplierId: supplierId,
              amount: amount,
              paymentDate: Value(paymentDate ?? DateTime.now()),
              note: Value(note),
              syncStatus: const Value.absent(),
            ),
          );

      for (final alloc in allocations) {
        await db.into(db.purchasePaymentLinks).insert(
              PurchasePaymentLinksCompanion.insert(
                paymentId: paymentId,
                purchaseId: alloc.purchaseId,
                amount: alloc.amount,
              ),
            );
      }

      final supplier = await (db.select(db.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .getSingle();
      await (db.update(db.suppliers)..where((s) => s.id.equals(supplierId)))
          .write(SuppliersCompanion(balance: Value(supplier.balance - amount)));

      await _postingEngine.post(
        type: TransactionType.supplierPayment,
        referenceId: paymentId,
        context: {
          'amount': amount,
          'supplierId': supplierId,
          'paymentMethod': paymentMethod,
          'note': note,
          'description': 'سند صرف ${supplier.name} (توزيعات)',
          'date': paymentDate ?? DateTime.now(),
        },
      );
    });
  }

  /// ==================== CASH TRANSACTIONS ====================
  Future<void> createCashReceipt({
    required Decimal amount,
    required String category,
    required String accountId,
    String? note,
    String? userId,
  }) async {
    final cashService = CashManagementService(db, _postingEngine);
    await cashService.createCashReceipt(
      amount: amount,
      category: category,
      accountId: accountId,
      note: note,
      userId: userId,
    );
  }

  Future<void> createCashPayment({
    required Decimal amount,
    required String category,
    required String accountId,
    String? note,
    String? userId,
    String? costCenterId,
  }) async {
    // Validate against budget if cost center is provided
    if (costCenterId != null && _budgetService != null) {
      final now = DateTime.now();
      final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await _budgetService!.validateExpenseAgainstBudget(
        costCenterId: costCenterId,
        expenseAmount: amount,
        period: period,
      );
    }

    final cashService = CashManagementService(db, _postingEngine);
    await cashService.createCashPayment(
      amount: amount,
      category: category,
      accountId: accountId,
      note: note,
      userId: userId,
    );

    // Update budget actual amount if cost center is provided
    if (costCenterId != null && _budgetService != null) {
      final now = DateTime.now();
      final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await _budgetService!.updateActualBudget(
        costCenterId: costCenterId,
        expenseAmount: amount,
        period: period,
      );
    }
  }

  /// ==================== OUTSTANDING BALANCES ====================
  Future<List<SaleWithBalance>> getOutstandingSales(String customerId) async {
    final sales = await (db.select(db.sales)
          ..where((s) => s.customerId.equals(customerId))
          ..where((s) => s.status.equals(DocumentStatus.posted.index))
          ..where((s) => s.isCredit.equals(true)))
        .get();

    final result = <SaleWithBalance>[];
    for (final sale in sales) {
      final paymentLinks = await (db.select(db.customerPaymentLinks)
            ..where((l) => l.saleId.equals(sale.id)))
          .get();
      Decimal totalPaid = Decimal.zero;
      for (final link in paymentLinks) {
        totalPaid += link.amount;
      }
      final balance = sale.total - totalPaid;
      if (balance > Decimal.zero) {
        result.add(SaleWithBalance(sale: sale, balance: balance));
      }
    }
    return result;
  }

  Future<List<PurchaseWithBalance>> getOutstandingPurchases(
      String supplierId) async {
    final purchases = await (db.select(db.purchases)
          ..where((p) => p.supplierId.equals(supplierId))
          ..where((p) => p.status.equals(DocumentStatus.posted.index))
          ..where((p) => p.isCredit.equals(true)))
        .get();

    final result = <PurchaseWithBalance>[];
    for (final purchase in purchases) {
      final paymentLinks = await (db.select(db.purchasePaymentLinks)
            ..where((l) => l.purchaseId.equals(purchase.id)))
          .get();
      Decimal totalPaid = Decimal.zero;
      for (final link in paymentLinks) {
        totalPaid += link.amount;
      }
      final balance = purchase.total - totalPaid;
      if (balance > Decimal.zero) {
        result.add(PurchaseWithBalance(purchase: purchase, balance: balance));
      }
    }
    return result;
  }

  /// ==================== POST BEGINNING BALANCE ====================
  Future<void> postBeginningBalance({
    required String warehouseId,
    required DateTime periodDate,
    required List<({String productId, Decimal quantity, Decimal cost})> items,
    String? userId,
  }) async {
    await db.transaction(() async {
      Decimal totalValue = Decimal.zero;

      for (final item in items) {
        await (db.update(db.products)
              ..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(
          stock: Value(item.quantity),
          buyPrice: Value(item.cost),
          updatedAt: Value(DateTime.now()),
        ));

        await db.into(db.inventoryTransactions).insert(
              InventoryTransactionsCompanion.insert(
                productId: item.productId,
                warehouseId: warehouseId,
                quantity: Value(item.quantity),
                type: 'BEGINNING_BALANCE',
                referenceId: item.productId,
                date: Value(periodDate),
              ),
            );

        totalValue += item.quantity * item.cost;

        await _auditService.log(
          userId: userId,
          action: 'BEGINNING_BALANCE',
          targetEntity: 'PRODUCT',
          entityId: item.productId,
          details: 'Beginning balance: qty=${item.quantity}, cost=${item.cost}',
        );
      }

      if (totalValue > Decimal.zero) {
        await _postingEngine.post(
          type: TransactionType.initial,
          referenceId: 'BB-$warehouseId',
          context: {
            'amount': totalValue,
            'description': 'رصيد افتتاحي للمستودع',
            'branchId': warehouseId,
            'date': periodDate,
          },
        );
      }
    });
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
