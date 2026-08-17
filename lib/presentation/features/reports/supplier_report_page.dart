import 'package:flutter/material.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/core/utils/export_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class SupplierReportPage extends StatefulWidget {
  const SupplierReportPage({super.key});

  @override
  State<SupplierReportPage> createState() => _SupplierReportPageState();
}

class _SupplierReportPageState extends State<SupplierReportPage> {
  List<Supplier> _allSuppliers = [];
  List<Supplier> _filteredSuppliers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 0;
  final int _pageSize = 20;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final db = di.sl<AppDatabase>();
      _allSuppliers = await (db.select(db.suppliers)
            ..where((s) => s.isActive.equals(true)))
          .get();
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredSuppliers = _allSuppliers
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (s.phone?.contains(_searchQuery) ?? false))
          .toList();
      _currentPage = 0;
    });
  }

  List<Supplier> get _currentPageItems {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredSuppliers.length);
    if (start >= _filteredSuppliers.length) return [];
    return _filteredSuppliers.sublist(start, end);
  }

  bool get _hasMoreItems => (_currentPage + 1) * _pageSize < _filteredSuppliers.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentItems = _currentPageItems;
    final totalBalance =
        _filteredSuppliers.fold<double>(0, (sum, s) => sum + s.balance.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tqryrAlmwrdyn),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => _exportToPdf(_filteredSuppliers)),
          IconButton(
              icon: const Icon(Icons.table_chart),
              onPressed: () => _exportToExcel(_filteredSuppliers)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('حدث خطأ أثناء تحميل التقرير'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: l10n.bhthBalasmAwAlhatf,
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (val) {
                          _searchQuery = val;
                          _applyFilter();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem(l10n.ijmalyAlmwrdyn, '${_filteredSuppliers.length}'),
                          _statItem(l10n.alrsydAlijmaly,
                              '${totalBalance.toStringAsFixed(2)} ${l10n.currencySar}'),
                          _statItem(l10n.mwrdynBdyn,
                              '${_filteredSuppliers.where((s) => s.balance > Decimal.zero).length}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: currentItems.isEmpty
                          ? const Center(child: Text('لا توجد موردين'))
                          : ListView.builder(
                              itemCount: currentItems.length + (_hasMoreItems ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == currentItems.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final supplier = currentItems[index];
                                return ListTile(
                                  title: Text(supplier.name),
                                  subtitle: Text(supplier.phone ?? ''),
                                  trailing: Text(
                                    '${supplier.balance} ${l10n.currencySar}',
                                    style: TextStyle(
                                      color: supplier.balance > Decimal.zero
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (_filteredSuppliers.length > _pageSize)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'عرض ${currentItems.length} من ${_filteredSuppliers.length} مورد',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _exportToPdf(List<Supplier> data) async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToPdf(
        'suppliers',
        data
            .map((s) => {
                  'name': s.name,
                  'phone': s.phone ?? '',
                  'balance': s.balance.toString(),
                })
            .toList());
  }

  void _exportToExcel(List<Supplier> data) async {
    final service = ExportService(di.sl<AppDatabase>());
    await service.exportToCsv(
        'suppliers',
        data
            .map((s) => {
                  'name': s.name,
                  'phone': s.phone ?? '',
                  'balance': s.balance.toString(),
                })
            .toList());
  }
}
