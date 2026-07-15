import 'package:supermarket/data/datasources/local/app_database.dart';

class StockDiscrepancy {
  final String productId;
  final String productName;
  final Decimal productsStock;
  final Decimal batchesSum;

  StockDiscrepancy({
    required this.productId,
    required this.productName,
    required this.productsStock,
    required this.batchesSum,
  });

  Decimal get diff => productsStock - batchesSum;
}

class IntegrityReport {
  final Decimal glBalance;
  final Decimal inventoryValue;
  final bool match;

  IntegrityReport({
    required this.glBalance,
    required this.inventoryValue,
    required this.match,
  });
}

class DataIntegrityValidator {
  final AppDatabase db;
  DataIntegrityValidator(this.db);

  Future<List<StockDiscrepancy>> validateStockIntegrity() async {
    final result = await db.customSelect('''
      SELECT p.id, p.name, p.stock AS products_stock,
             COALESCE(CAST(SUM(pb.quantity) AS REAL), 0) AS batches_sum
      FROM products p
      LEFT JOIN product_batches pb ON p.id = pb.product_id
      GROUP BY p.id
      HAVING ABS(p.stock - COALESCE(SUM(pb.quantity), 0)) > 0.001
    ''').get();

    return result.map((row) {
      final data = row.data;
      return StockDiscrepancy(
        productId: data['id'] as String,
        productName: data['name'] as String,
        productsStock: Decimal.parse(data['products_stock'].toString()),
        batchesSum: Decimal.parse(data['batches_sum'].toString()),
      );
    }).toList();
  }

  Future<IntegrityReport> validateGLInventoryMatch() async {
    final glRow = await db.customSelect('''
      SELECT COALESCE(SUM(
        CASE WHEN ga.account_type IN ('ASSET', 'EXPENSE')
          THEN CAST(gl.debit AS REAL) - CAST(gl.credit AS REAL)
          ELSE CAST(gl.credit AS REAL) - CAST(gl.debit AS REAL)
        END
      ), 0) AS balance
      FROM gl_lines gl
      JOIN gl_accounts ga ON gl.account_id = ga.id
      WHERE ga.code = '1040'
    ''').getSingle();

    final invRow = await db.customSelect('''
      SELECT COALESCE(
        SUM(CAST(pb.quantity AS REAL) * CAST(pb.cost_price AS REAL)), 0
      ) AS value
      FROM product_batches pb
    ''').getSingle();

    final glBalance = Decimal.parse(glRow.data['balance'].toString());
    final inventoryValue = Decimal.parse(invRow.data['value'].toString());

    return IntegrityReport(
      glBalance: glBalance,
      inventoryValue: inventoryValue,
      match: (glBalance - inventoryValue).abs() < Decimal.parse('0.01'),
    );
  }

  Future<int> countBrokenBatches() async {
    final result = await db.customSelect('''
      SELECT COUNT(*) AS cnt
      FROM product_batches
      WHERE batch_number LIKE 'BROKEN-%'
    ''').getSingle();
    return (result.data['cnt'] as int);
  }

  Future<Map<String, dynamic>> runAllChecks() async {
    final stockIssues = await validateStockIntegrity();
    final glReport = await validateGLInventoryMatch();
    final brokenCount = await countBrokenBatches();

    return {
      'stockIntegrity': {
        'passed': stockIssues.isEmpty,
        'discrepancies': stockIssues.length,
        'details': stockIssues,
      },
      'glInventoryMatch': {
        'passed': glReport.match,
        'glBalance': glReport.glBalance,
        'inventoryValue': glReport.inventoryValue,
      },
      'brokenBatches': {
        'passed': brokenCount == 0,
        'count': brokenCount,
      },
    };
  }
}
