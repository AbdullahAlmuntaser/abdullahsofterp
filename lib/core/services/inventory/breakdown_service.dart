import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/exceptions/app_exception.dart';
import 'package:uuid/uuid.dart';

class InventoryBreakdownService {
  final AppDatabase db;

  InventoryBreakdownService(this.db);

  /// تحويل كمية من وحدة كبيرة إلى وحدة أصغر
  /// مثال: تفكيك 1 كرتون إلى 20 حبة
  Future<void> breakUnit({
    required String productId,
    required String warehouseId,
    required String fromBatchId,
    required double quantityToBreak, // الكمية بالوحدة الكبيرة (مثلاً 1 كرتون)
    required ProductUnit targetUnit, // الوحدة المستهدفة (الحبة)
  }) async {
    await db.transaction(() async {
      // 1. الحصول على الـ Batch المصدر (الكرتون)
      final sourceBatch = await (db.select(db.productBatches)
            ..where((b) => b.id.equals(fromBatchId)))
          .getSingleOrNull();

      if (sourceBatch == null) {
        throw const BusinessException(message: 'لم يتم العثور على الدفعة المصدر.');
      }

      if (sourceBatch.quantity < Decimal.parse(quantityToBreak.toString())) {
        throw const BusinessException(message: 'الكمية المتوفرة في هذه الدفعة غير كافية للتفكيك.');
      }

      // 2. حساب الكمية الناتجة بالوحدة الصغيرة
      // معامل التحويل للوحدة المستهدفة (مثلاً 1 حبة = 1)
      // نحن نحتاج معامل تحويل الوحدة الكبيرة (مثلاً 1 كرتون = 20 حبة)
      // سنحصل عليه من الـ ProductUnit الخاصة بالمنتج
      final product = await (db.select(db.products)..where((p) => p.id.equals(productId))).getSingle();
      
      // الحصول على معامل تحويل الوحدة المصدر
      final sourceUnit = await (db.select(db.productUnits)
        ..where((u) => u.productId.equals(productId) & u.unitName.equals(sourceBatch.storedUnitId ?? '')))
        .getSingleOrNull();
      
      final double conversionFactor = sourceUnit?.unitFactor.toDouble() ?? 1.0;
      final double resultingQuantity = quantityToBreak * conversionFactor;

      // 3. خصم من الوحدة الكبيرة
      await (db.update(db.productBatches)..where((b) => b.id.equals(fromBatchId)))
          .write(ProductBatchesCompanion(
        quantity: Value(sourceBatch.quantity - Decimal.parse(quantityToBreak.toString())),
      ));

      // 4. إضافة للوحدة الصغيرة (إنشاء Batch جديد أو التحديث على واحد موجود)
      // نبحث عن Batch موجود بنفس الوحدة الصغيرة وتاريخ الانتهاء
      final existingTargetBatch = await (db.select(db.productBatches)
            ..where((b) =>
                b.productId.equals(productId) &
                b.warehouseId.equals(warehouseId) &
                b.storedUnitId.equals(targetUnit.unitName) &
                b.expiryDate.equals(sourceBatch.expiryDate)))
          .getSingleOrNull();

      if (existingTargetBatch != null) {
        await (db.update(db.productBatches)..where((b) => b.id.equals(existingTargetBatch.id)))
            .write(ProductBatchesCompanion(
          quantity: Value(existingTargetBatch.quantity + Decimal.parse(resultingQuantity.toString())),
        ));
      } else {
        await db.into(db.productBatches).insert(
              ProductBatchesCompanion.insert(
                id: Value(const Uuid().v4()),
                productId: productId,
                warehouseId: warehouseId,
                batchNumber: 'BRK-${sourceBatch.batchNumber}',
                expiryDate: Value(sourceBatch.expiryDate),
                quantity: Decimal.parse(resultingQuantity.toString()),
                initialQuantity: Decimal.parse(resultingQuantity.toString()),
                costPrice: Value(sourceBatch.costPrice / Decimal.parse(conversionFactor.toString())),
                storedUnitId: Value(targetUnit.unitName),
                quantityInStoredUnit: Value(Decimal.parse(resultingQuantity.toString())),
              ),
            );
      }

      // 5. تسجيل حركة مخزون (نقص كرتون وزيادة حبات)
      await db.into(db.inventoryTransactions).insert(
            InventoryTransactionsCompanion.insert(
              productId: productId,
              warehouseId: warehouseId,
              batchId: Value(fromBatchId),
              quantity: Value(Decimal.parse((-quantityToBreak).toString())),
              type: 'BREAKDOWN_OUT',
              referenceId: 'BREAKDOWN',
            ),
          );

      await db.into(db.inventoryTransactions).insert(
            InventoryTransactionsCompanion.insert(
              productId: productId,
              warehouseId: warehouseId,
              quantity: Value(Decimal.parse(resultingQuantity.toString())),
              type: 'BREAKDOWN_IN',
              referenceId: 'BREAKDOWN',
            ),
          );
    });
  }
}
