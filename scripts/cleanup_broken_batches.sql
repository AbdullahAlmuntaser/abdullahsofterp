-- ============================================================
-- Script: cleanup_broken_batches.sql
-- الغرض: تنظيف BROKEN batches بعد تفعيل reservedQuantity
-- التحذير: يجب أخذ نسخة احتياطية قبل التشغيل
-- ============================================================

-- الخطوة 1: إعادة الكميات من BROKEN batches إلى الباتشات الأصلية
UPDATE product_batches AS original
SET quantity = CAST(original.quantity AS REAL) + (
  SELECT COALESCE(SUM(CAST(broken.quantity AS REAL)), 0)
  FROM product_batches AS broken
  WHERE broken.batch_number LIKE 'BROKEN-' || original.batch_number || '-%'
    AND broken.product_id = original.product_id
    AND broken.warehouse_id = original.warehouse_id
)
WHERE original.batch_number NOT LIKE 'BROKEN-%';

-- الخطوة 2: حذف BROKEN batches
DELETE FROM product_batches
WHERE batch_number LIKE 'BROKEN-%';

-- الخطوة 3: التحقق من صحة البيانات
-- product.stock == SUM(batch.quantity) لكل منتج
SELECT p.id, p.name,
       CAST(p.stock AS REAL) AS product_stock,
       SUM(CAST(pb.quantity AS REAL)) AS batch_total,
       CAST(p.stock AS REAL) - SUM(CAST(pb.quantity AS REAL)) AS diff
FROM products p
LEFT JOIN product_batches pb ON pb.product_id = p.id
GROUP BY p.id
HAVING ABS(diff) > 0.01;
