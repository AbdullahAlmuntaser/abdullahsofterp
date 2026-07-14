import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

enum ImportType { products, customers, suppliers, inventory }

class ImportResult {
  final int successCount;
  final int failureCount;
  final List<String> errors;
  final List<Map<String, dynamic>> importedData;

  ImportResult({
    required this.successCount,
    required this.failureCount,
    required this.errors,
    required this.importedData,
  });

  bool get hasErrors => failureCount > 0;
  int get totalCount => successCount + failureCount;
}

class DataImportService {
  final AppDatabase? db;

  DataImportService({this.db});

  Future<String> _readFileContent(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    // 2.23: Detect and strip UTF-8 BOM
    int start = 0;
    if (bytes.length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
      start = 3;
    }

    // Try UTF-8 first, fall back to Windows-1252 / Latin-1
    try {
      return utf8.decode(bytes.sublist(start));
    } catch (_) {
      return latin1.decode(bytes.sublist(start));
    }
  }

  Future<ImportResult> importFromCsv(String filePath, ImportType type) async {
    try {
      final ext = path.extension(filePath).toLowerCase();
      if (ext == '.xlsx' || ext == '.xls') {
        return ImportResult(
          successCount: 0,
          failureCount: 0,
          errors: [
            'XLSX/XLS format not supported directly. Please save as CSV first.'
          ],
          importedData: [],
        );
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(
          successCount: 0,
          failureCount: 0,
          errors: ['File not found: $filePath'],
          importedData: [],
        );
      }

      final content = await _readFileContent(filePath);
      final lines =
          content.split('\n').where((l) => l.trim().isNotEmpty).toList();

      if (lines.isEmpty) {
        return ImportResult(
          successCount: 0,
          failureCount: 0,
          errors: ['File is empty'],
          importedData: [],
        );
      }

      final headers = _parseCsvLine(lines.first);
      final data = <Map<String, dynamic>>[];
      final errors = <String>[];
      int successCount = 0;
      int failureCount = 0;

      for (int i = 1; i < lines.length; i++) {
        try {
          final values = _parseCsvLine(lines[i]);
          if (values.length != headers.length) {
            errors.add('Row $i: Column count mismatch (expected ${headers.length}, got ${values.length})');
            failureCount++;
            continue;
          }

          final row = <String, dynamic>{};
          for (int j = 0; j < headers.length; j++) {
            row[headers[j]] = values[j].trim();
          }

          final validation = _validateRow(row, type, i);
          if (validation != null) {
            errors.add(validation);
            failureCount++;
            continue;
          }

          data.add(row);
          successCount++;
        } catch (e) {
          errors.add('Row $i: ${e.toString()}');
          failureCount++;
        }
      }

      // 2.22: Persist imported data to database if available
      if (db != null && data.isNotEmpty) {
        final persistErrors = await _persistData(data, type);
        errors.addAll(persistErrors);
      }

      return ImportResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
        importedData: data,
      );
    } catch (e) {
      return ImportResult(
        successCount: 0,
        failureCount: 0,
        errors: ['Import failed: ${e.toString()}'],
        importedData: [],
      );
    }
  }

  Future<List<String>> _persistData(
      List<Map<String, dynamic>> data, ImportType type) async {
    final errors = <String>[];
    final database = db!;

    for (int i = 0; i < data.length; i++) {
      try {
        final row = data[i];
        switch (type) {
          case ImportType.products:
            final decSell = Decimal.tryParse(row['sell_price']?.toString() ?? '0') ?? Decimal.zero;
            final decBuy = Decimal.tryParse(row['buy_price']?.toString() ?? '0') ?? Decimal.zero;
            await database.into(database.products).insert(
              ProductsCompanion.insert(
                name: row['name']?.toString() ?? '',
                sku: row['sku']?.toString() ?? const Uuid().v4(),
                sellPrice: Value(decSell),
                buyPrice: Value(decBuy),
                barcode: Value<String?>(row['barcode']?.toString()),
                unit: Value(row['unit']?.toString() ?? 'pcs'),
              ),
            );
            break;
          case ImportType.customers:
            final creditLimit = Decimal.tryParse(row['credit_limit']?.toString() ?? '0') ?? Decimal.zero;
            await database.into(database.customers).insert(
              CustomersCompanion.insert(
                name: row['name']?.toString() ?? '',
                phone: Value(row['phone']?.toString()),
                email: Value(row['email']?.toString()),
                address: Value(row['address']?.toString()),
                taxNumber: Value(row['tax_number']?.toString()),
                creditLimit: Value(creditLimit),
              ),
            );
            break;
          case ImportType.suppliers:
            await database.into(database.suppliers).insert(
              SuppliersCompanion.insert(
                name: row['name']?.toString() ?? '',
                phone: Value(row['phone']?.toString()),
                email: Value(row['email']?.toString()),
                address: Value(row['address']?.toString()),
                taxNumber: Value(row['tax_number']?.toString()),
              ),
            );
            break;
          case ImportType.inventory:
            // Inventory imports just validate; updates handled by stock movements
            break;
        }
      } catch (e) {
        errors.add('Row ${i + 1}: Failed to persist: $e');
      }
    }
    return errors;
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        // 2.24: Handle "" inside quoted fields (escaped quotes)
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString());

    return result;
  }

  String? _validateRow(Map<String, dynamic> row, ImportType type, int rowNum) {
    switch (type) {
      case ImportType.products:
        if (row['name'] == null || row['name'].toString().isEmpty) {
          return 'Row $rowNum: Product name is required';
        }
        if (row['barcode'] != null && row['barcode'].toString().isNotEmpty) {
          if (row['barcode'].toString().length < 4) {
            return 'Row $rowNum: Invalid barcode length';
          }
        }
        break;
      case ImportType.customers:
        if (row['name'] == null || row['name'].toString().isEmpty) {
          return 'Row $rowNum: Customer name is required';
        }
        break;
      case ImportType.suppliers:
        if (row['name'] == null || row['name'].toString().isEmpty) {
          return 'Row $rowNum: Supplier name is required';
        }
        break;
      case ImportType.inventory:
        if (row['product_id'] == null || row['product_id'].toString().isEmpty) {
          return 'Row $rowNum: Product ID is required';
        }
        if (row['quantity'] == null) {
          return 'Row $rowNum: Quantity is required';
        }
        break;
    }
    return null;
  }

  List<String> getCsvTemplate(ImportType type) {
    switch (type) {
      case ImportType.products:
        return [
          'name',
          'barcode',
          'sku',
          'category',
          'sell_price',
          'buy_price',
          'unit',
          'tax_type'
        ];
      case ImportType.customers:
        return [
          'name',
          'phone',
          'email',
          'address',
          'tax_number',
          'credit_limit'
        ];
      case ImportType.suppliers:
        return [
          'name',
          'phone',
          'email',
          'address',
          'tax_number',
          'payment_terms'
        ];
      case ImportType.inventory:
        return ['product_id', 'warehouse_id', 'quantity', 'expiry_date'];
    }
  }

  String generateTemplateCsv(ImportType type) {
    final headers = getCsvTemplate(type);
    return headers.join(',');
  }

  Future<bool> isValidFile(String filePath) async {
    final ext = path.extension(filePath).toLowerCase();
    return ['.csv', '.xlsx', '.xls'].contains(ext);
  }

  String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }
}
