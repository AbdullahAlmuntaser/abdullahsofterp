import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';
import 'audit_service.dart';

class ReturnService {
  final AppDatabase db;
  late final AuditService _auditService;

  ReturnService(this.db) {
    _auditService = AuditService(db);
  }

  /// Creates return records only. Stock and GL handled by TransactionEngine.
  Future<String> processSalesReturn({
    required String saleId,
    required List<ReturnItemData> items,
    String? reason,
    String? userId,
  }) async {
    final returnId = const Uuid().v4();
    Decimal totalAmount = Decimal.zero;

    for (var item in items) {
      totalAmount += item.quantity * item.price;
    }

    await db.into(db.salesReturns).insert(
          SalesReturnsCompanion.insert(
            id: Value(returnId),
            saleId: saleId,
            amountReturned: Value(totalAmount),
            reason: Value(reason),
          ),
        );

    for (var item in items) {
      await db.into(db.salesReturnItems).insert(
            SalesReturnItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              salesReturnId: returnId,
              productId: item.productId,
              quantity: item.quantity,
              price: item.price,
            ),
          );
    }

    await _auditService.log(
      action: 'SALES_RETURN',
      targetEntity: 'SalesReturns',
      entityId: returnId,
      userId: userId,
      details: 'Created return record for sale $saleId. Total: $totalAmount',
    );

    return returnId;
  }

  /// Creates return records only. Stock and GL handled by TransactionEngine.
  Future<String> processPurchaseReturn({
    required String purchaseId,
    required List<ReturnItemData> items,
    String? reason,
    String? userId,
  }) async {
    final returnId = const Uuid().v4();
    Decimal totalAmount = Decimal.zero;

    for (var item in items) {
      totalAmount += item.quantity * item.price;
    }

    await db.into(db.purchaseReturns).insert(
          PurchaseReturnsCompanion.insert(
            id: Value(returnId),
            purchaseId: purchaseId,
            amountReturned: Value(totalAmount),
            reason: Value(reason),
          ),
        );

    for (var item in items) {
      await db.into(db.purchaseReturnItems).insert(
            PurchaseReturnItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              purchaseReturnId: returnId,
              productId: item.productId,
              quantity: item.quantity,
              price: item.price,
            ),
          );
    }

    await _auditService.log(
      action: 'PURCHASE_RETURN',
      targetEntity: 'PurchaseReturns',
      entityId: returnId,
      userId: userId,
      details:
          'Created return record for purchase $purchaseId. Total: $totalAmount',
    );

    return returnId;
  }
}

class ReturnItemData {
  final String productId;
  final Decimal quantity;
  final Decimal price;

  ReturnItemData({
    required this.productId,
    required this.quantity,
    required this.price,
  });
}


