import 'dart:typed_data';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/purchases/purchase_totals.dart';

class PurchasePrintingService {
  final AppDatabase db;

  PurchasePrintingService(this.db);

  Future<void> printPurchase(String purchaseId) async {
    final purchase = await (db.select(db.purchases)
          ..where((p) => p.id.equals(purchaseId)))
        .getSingleOrNull();
    if (purchase == null) {
      throw StateError('فاتورة المشتريات غير موجودة');
    }

    Supplier? supplier;
    if (purchase.supplierId != null) {
      supplier = await (db.select(db.suppliers)
            ..where((s) => s.id.equals(purchase.supplierId!)))
          .getSingleOrNull();
    }

    final rows = await (db.select(db.purchaseItems).join([
      drift.innerJoin(
        db.products,
        db.products.id.equalsExp(db.purchaseItems.productId),
      ),
    ])
          ..where(db.purchaseItems.purchaseId.equals(purchaseId)))
        .get();

    final products = <String, Product>{
      for (final row in rows) row.readTable(db.products).id: row.readTable(db.products),
    };

    final totals = PurchaseTotalsCalculator.fromPurchase(purchase);
    final pdfData = await _generatePdfData(purchase, rows, supplier, products, totals);
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  Future<Uint8List> _generatePdfData(
    Purchase purchase,
    List<drift.TypedResult> rows,
    Supplier? supplier,
    Map<String, Product> products,
    PurchaseTotals totals,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة مشتريات',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text('رقم الفاتورة: ${purchase.invoiceNumber ?? purchase.id.substring(0, 8)}'),
              pw.Text('التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(purchase.date)}'),
              if (supplier != null) pw.Text('المورد: ${supplier.name}'),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                data: rows.map((row) {
                  final item = row.readTable(db.purchaseItems);
                  final product = products[item.productId];
                  return [
                    product?.name ?? item.productId.substring(0, 8),
                    item.quantity.toStringAsFixed(2),
                    item.unitPrice.toStringAsFixed(2),
                    (item.quantity * item.unitPrice).toStringAsFixed(2),
                  ];
                }).toList(),
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                },
              ),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('المجموع الفرعي: ${totals.subtotal.toStringAsFixed(2)}'),
                      if (totals.discount > Decimal.zero)
                        pw.Text('الخصم: ${totals.discount.toStringAsFixed(2)}'),
                      if (totals.shippingCost > Decimal.zero)
                        pw.Text('الشحن: ${totals.shippingCost.toStringAsFixed(2)}'),
                      if (totals.otherExpenses > Decimal.zero)
                        pw.Text('مصاريف أخرى: ${totals.otherExpenses.toStringAsFixed(2)}'),
                      if (totals.landedCosts > Decimal.zero)
                        pw.Text('تكاليف واردة: ${totals.landedCosts.toStringAsFixed(2)}'),
                      pw.Text('الضريبة: ${totals.tax.toStringAsFixed(2)}'),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'الإجمالي: ${totals.total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
