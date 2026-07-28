import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/inventory/inventory_costing_service.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

enum VoidReason { errorInEntry, customerReturn, duplicateEntry, other }

class FinancialControlResult {
  final bool success;
  final String? error;
  final String? message;
  final String? journalEntryId;

  FinancialControlResult({
    required this.success,
    this.error,
    this.message,
    this.journalEntryId,
  });
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, this.errors = const []});
}

class FinancialControlService {
  final AppDatabase db;
  final InventoryCostingService? costingService;
  late final AuditService _auditService;

  FinancialControlService(this.db, {this.costingService}) {
    _auditService = AuditService(db);
  }

  Future<ValidationResult> validateSale(String saleId) async {
    final List<String> errors = [];

    final sale = await (db.select(
      db.sales,
    )..where((s) => s.id.equals(saleId)))
        .getSingleOrNull();
    if (sale == null) {
      errors.add('الفاتورة غير موجودة');
      return ValidationResult(isValid: false, errors: errors);
    }

    if (sale.status == DocumentStatus.posted) {
      errors.add('الفاتورة مرحّلة مسبقاً');
    }
    if (sale.status == DocumentStatus.voided) {
      errors.add('الفاتورة ملغاة');
    }

    if (sale.total <= Decimal.zero) {
      errors.add('إجمالي الفاتورة يجب أن يكون أكبر من صفر');
    }

    final items = await (db.select(
      db.saleItems,
    )..where((si) => si.saleId.equals(saleId)))
        .get();
    if (items.isEmpty) {
      errors.add('الفاتورة لا تحتوي على أصناف');
    }

    for (var item in items) {
      if (item.quantity <= Decimal.zero) {
        errors.add('الكمية يجب أن تكون أكبر من صفر للمنتج');
      }
      if (item.price < Decimal.zero) {
        errors.add('السعر لا يمكن أن يكون سالب');
      }
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  Future<ValidationResult> validatePurchase(String purchaseId) async {
    final List<String> errors = [];

    final purchase = await (db.select(
      db.purchases,
    )..where((p) => p.id.equals(purchaseId)))
        .getSingleOrNull();
    if (purchase == null) {
      errors.add('الفاتورة غير موجودة');
      return ValidationResult(isValid: false, errors: errors);
    }

    if (purchase.status == DocumentStatus.posted) {
      errors.add('الفاتورة مرحّلة مسبقاً');
    }
    if (purchase.status == DocumentStatus.voided) {
      errors.add('الفاتورة ملغاة');
    }

    if (purchase.total <= Decimal.zero) {
      errors.add('إجمالي الفاتورة يجب أن يكون أكبر من صفر');
    }

    final items = await (db.select(
      db.purchaseItems,
    )..where((pi) => pi.purchaseId.equals(purchaseId)))
        .get();
    if (items.isEmpty) {
      errors.add('الفاتورة لا تحتوي على أصناف');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  Future<ValidationResult> validateGLEntry(String entryId) async {
    final List<String> errors = [];

    final entry = await (db.select(
      db.gLEntries,
    )..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();
    if (entry == null) {
      errors.add('القيد غير موجود');
      return ValidationResult(isValid: false, errors: errors);
    }

    if (entry.description.isEmpty) {
      errors.add('الوصف مطلوب');
    }

    final lines = await (db.select(
      db.gLLines,
    )..where((l) => l.entryId.equals(entryId)))
        .get();

    if (lines.isEmpty) {
      errors.add('القيد لا يحتوي على أسطر');
    }

    double totalDebit = 0;
    double totalCredit = 0;

    for (var line in lines) {
      totalDebit += line.debit.toDouble();
      totalCredit += line.credit.toDouble();
    }

    final difference = (totalDebit - totalCredit).abs();
    if (difference > 0.01) {
      errors.add('القيد غير متوازن - Debit: $totalDebit, Credit: $totalCredit');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  Future<ValidationResult> validateAccountingPeriod(
    DateTime date, {
    String? periodId,
  }) async {
    final List<String> errors = [];

    if (periodId != null) {
      final period = await (db.select(
        db.accountingPeriods,
      )..where((p) => p.id.equals(periodId)))
          .getSingleOrNull();
      if (period == null) {
        errors.add('الفترة المحاسبية غير موجودة');
      } else if (period.isClosed) {
        errors.add('الفترة المحاسبية مغلقة');
      }
    } else {
      final openPeriod = await _getOpenPeriod(date);
      if (openPeriod == null) {
        errors.add('لا توجد فترة محاسبية مفتوحة لهذا التاريخ');
      }
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  Future<ValidationResult> validateInventory(String productId) async {
    final List<String> errors = [];

    if (costingService == null) {
      errors.add('خدمة تقييم المخزون غير مُهيأة');
      return ValidationResult(isValid: false, errors: errors);
    }

    try {
      final valuation = await costingService!.getInventoryValuation(productId);

      if (valuation.totalQuantity < Decimal.zero) {
        errors.add('الكمية السالبة غير مسموحة: ${valuation.totalQuantity}');
      }

      if (valuation.totalQuantity == Decimal.zero &&
          valuation.totalValue != Decimal.zero) {
        errors.add(
            'تناقض في تقييم المخزون - الكمية صفر لكن القيمة: ${valuation.totalValue}');
      }
    } catch (e) {
      errors.add('خطأ في جلب تقييم المخزون: $e');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  Future<AccountingPeriod?> _getOpenPeriod(DateTime date) async {
    return await (db.select(db.accountingPeriods)
          ..where((p) => p.isClosed.equals(false))
          ..where((p) => p.startDate.isSmallerOrEqual(Variable(date)))
          ..where((p) => p.endDate.isBiggerOrEqual(Variable(date))))
        .getSingleOrNull();
  }

  /// Posting operations are handled by TransactionEngine + PostingEngine.
  /// This service provides only validation and period management.

  Future<FinancialControlResult> closeAccountingPeriod(
    String periodId, {
    String? note,
  }) async {
    final period = await (db.select(
      db.accountingPeriods,
    )..where((p) => p.id.equals(periodId)))
        .getSingleOrNull();

    if (period == null) {
      return FinancialControlResult(success: false, error: 'الفترة غير موجودة');
    }

    if (period.isClosed) {
      return FinancialControlResult(
        success: false,
        error: 'الفترة مغلقة مسبقاً',
      );
    }

    await (db.update(db.accountingPeriods)..where((p) => p.id.equals(periodId)))
        .write(const AccountingPeriodsCompanion(isClosed: Value(true)));

    await _auditService.logCreate(
      'AccountingPeriod',
      periodId,
      details:
          'إقفال الفترة المحاسبية: ${period.name}${note != null ? ' - $note' : ''}',
    );

    return FinancialControlResult(
      success: true,
      message: 'تم إقفال الفترة بنجاح',
    );
  }

  Future<FinancialControlResult> openAccountingPeriod({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final year = startDate.year;
    final existingOpen = await (db.select(
      db.accountingPeriods,
    )..where((p) => p.isClosed.equals(false)))
        .getSingleOrNull();

    if (existingOpen != null) {
      return FinancialControlResult(
        success: false,
        error:
            'توجد فترة مفتوحة سابقة: ${existingOpen.name}. يرجى إقفالها أولاً.',
      );
    }

    final existingForYear = await (db.select(db.accountingPeriods)
          ..where((p) =>
              p.fiscalYear.equals(year) &
              p.status.equals('OPEN')))
        .getSingleOrNull();

    if (existingForYear != null) {
      return FinancialControlResult(
        success: false,
        error: 'توجد فترة مفتوحة للسنة $year مسبقاً: ${existingForYear.name}.',
      );
    }

    if (startDate.isAfter(endDate)) {
      return FinancialControlResult(
        success: false,
        error: 'تاريخ البداية يجب أن يكون قبل تاريخ النهاية',
      );
    }

    final periodId = const Uuid().v4();
    await db.into(db.accountingPeriods).insert(
          AccountingPeriodsCompanion.insert(
            id: Value(periodId),
            name: name,
            fiscalYear: startDate.year,
            startDate: startDate,
            endDate: endDate,
            isClosed: const Value(false),
            syncStatus: const Value(1),
          ),
        );

    await _auditService.logCreate(
      'AccountingPeriod',
      periodId,
      details: 'فتح فترة محاسبية جديدة: $name',
    );

    return FinancialControlResult(
      success: true,
      message: 'تم فتح الفترة بنجاح',
    );
  }

  Future<bool> canEditSale(String saleId) async {
    final sale = await (db.select(
      db.sales,
    )..where((s) => s.id.equals(saleId)))
        .getSingleOrNull();
    return sale != null && sale.status == DocumentStatus.draft;
  }

  Future<bool> canEditPurchase(String purchaseId) async {
    final purchase = await (db.select(
      db.purchases,
    )..where((p) => p.id.equals(purchaseId)))
        .getSingleOrNull();
    return purchase != null && purchase.status == DocumentStatus.draft;
  }

  Future<bool> canEditGLEntry(String entryId) async {
    final entry = await (db.select(
      db.gLEntries,
    )..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();
    return entry != null && entry.status == 'draft';
  }

  Future<bool> canDeleteSale(String saleId) async {
    return await canEditSale(saleId);
  }

  Future<bool> canDeletePurchase(String purchaseId) async {
    return await canEditPurchase(purchaseId);
  }

  Future<List<Map<String, dynamic>>> getAuditTrail({
    String? entityType,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = db.select(db.auditLogs);

    if (entityType != null) {
      query = query..where((l) => l.targetEntity.equals(entityType));
    }
    if (entityId != null) {
      query = query..where((l) => l.entityId.equals(entityId));
    }
    if (startDate != null) {
      query = query
        ..where((l) => l.timestamp.isBiggerOrEqual(Variable(startDate)));
    }
    if (endDate != null) {
      query = query
        ..where((l) => l.timestamp.isSmallerOrEqual(Variable(endDate)));
    }

    query = query
      ..orderBy([
        (l) => OrderingTerm(expression: l.timestamp, mode: OrderingMode.desc),
      ]);

    final logs = await query.get();

    return logs
        .map(
          (log) => {
            'id': log.id,
            'entityType': log.targetEntity,
            'entityId': log.entityId,
            'action': log.action,
            'details': log.details,
            'timestamp': log.timestamp.toIso8601String(),
            'userId': log.userId,
          },
        )
        .toList();
  }
}
