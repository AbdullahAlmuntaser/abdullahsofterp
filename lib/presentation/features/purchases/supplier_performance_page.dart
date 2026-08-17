import 'package:flutter/material.dart';
import 'package:supermarket/core/services/purchases/supplier_analytics_service.dart';
import 'package:supermarket/injection_container.dart';
import 'package:supermarket/presentation/widgets/app_snack_bar.dart';

class SupplierPerformancePage extends StatefulWidget {
  const SupplierPerformancePage({super.key});

  @override
  State<SupplierPerformancePage> createState() =>
      _SupplierPerformancePageState();
}

class _SupplierPerformancePageState extends State<SupplierPerformancePage> {
  final SupplierAnalyticsService _service = sl<SupplierAnalyticsService>();
  List<SupplierPerformance> _report = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _report = await _service.getSupplierPerformanceReport();
    } catch (e) {
      _error = e.toString();
      if (mounted) {
        AppSnackBar.error(context, 'فشل تحميل تقرير أداء الموردين: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير أداء الموردين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReport,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ أثناء تحميل التقرير',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadReport,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_report.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات أداء للموردين'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _report.length,
      itemBuilder: (context, index) {
        final p = _report[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              p.supplierName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('عدد الفواتير: ${p.totalInvoices}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الإجمالي: ${p.totalPurchases.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'متوسط الفاتورة: ${p.averagePrice.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
