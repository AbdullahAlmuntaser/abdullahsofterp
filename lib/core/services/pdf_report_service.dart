import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supermarket/core/services/financial_report_service.dart';
import 'package:supermarket/core/models/accounting/income_statement_data.dart';
import 'package:supermarket/core/models/accounting/balance_sheet_data.dart';
import 'package:supermarket/core/models/accounting/cash_flow_data.dart';

class PdfReportService {
  final FinancialReportService _financialReportService;

  PdfReportService(this._financialReportService);

  Future<void> printIncomeStatement({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final data = await _financialReportService.getIncomeStatement(
      startDate: startDate,
      endDate: endDate,
    );
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildIncomeStatement(context, data, startDate, endDate),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) => doc.save(),
    );
  }

  Future<void> printBalanceSheet({required DateTime date}) async {
    final data = await _financialReportService.getBalanceSheet(date: date);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildBalanceSheet(context, data, date),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) => doc.save(),
    );
  }

  Future<void> printCashFlow({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final data = await _financialReportService.getCashFlowStatement(
      startDate: startDate,
      endDate: endDate,
    );
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildCashFlow(context, data, startDate, endDate),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) => doc.save(),
    );
  }

  pw.Widget _buildIncomeStatement(
    pw.Context context,
    IncomeStatementData data,
    DateTime startDate,
    DateTime endDate,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text('قائمة الدخل',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text('من ${startDate.toLocal().toString().split(' ')[0]} إلى ${endDate.toLocal().toString().split(' ')[0]}'),
          ),
          pw.SizedBox(height: 24),
          pw.Text('الإيرادات: ${data.totalRevenue}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 8),
          pw.Text('المصاريف: ${data.totalExpense}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.Text('صافي الدخل: ${data.netIncome}',
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _buildBalanceSheet(
    pw.Context context,
    BalanceSheetData data,
    DateTime date,
  ) {
    final isBalanced = data.totalAssets == data.totalLiabilities + data.totalEquity;
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text('الميزانية العمومية',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text('في تاريخ ${date.toLocal().toString().split(' ')[0]}')),
          pw.SizedBox(height: 24),
          pw.Text('الأصول: ${data.totalAssets}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 8),
          pw.Text('الخصوم: ${data.totalLiabilities}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 8),
          pw.Text('حقوق الملكية: ${data.totalEquity}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.Text('الأصول = الخصوم + حقوق الملكية: ${isBalanced ? '✓' : '✗'}',
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: isBalanced ? PdfColors.green : PdfColors.red)),
        ],
      ),
    );
  }

  pw.Widget _buildCashFlow(
    pw.Context context,
    CashFlowData data,
    DateTime startDate,
    DateTime endDate,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text('قائمة التدفقات النقدية',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text('من ${startDate.toLocal().toString().split(' ')[0]} إلى ${endDate.toLocal().toString().split(' ')[0]}'),
          ),
          pw.SizedBox(height: 24),
          pw.Text('صافي التدفق التشغيلي: ${data.operatingActivities}'),
          pw.SizedBox(height: 8),
          pw.Text('صافي التدفق الاستثماري: ${data.investingActivities}'),
          pw.SizedBox(height: 8),
          pw.Text('صافي التدفق التمويلي: ${data.financingActivities}'),
          pw.SizedBox(height: 8),
          pw.Divider(),
          pw.Text('صافي التغير في النقد: ${data.netCashFlow}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('رصيد النقد أول المدة: ${data.beginningCashBalance}'),
          pw.SizedBox(height: 8),
          pw.Text('رصيد النقد آخر المدة: ${data.endingCashBalance}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
