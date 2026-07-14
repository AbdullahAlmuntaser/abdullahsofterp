import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class RestApiService {
  final AppDatabase _db;

  RestApiService(this._db, {http.Client? client});

  Future<Map<String, dynamic>> handleRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? authToken,
  }) async {

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await _handleGet(endpoint);
        case 'POST':
          return await _handlePost(endpoint, body ?? {});
        case 'PUT':
          return await _handlePut(endpoint, body ?? {});
        case 'DELETE':
          return await _handleDelete(endpoint);
        default:
          return {'error': 'Method not allowed', 'status': 405};
      }
    } catch (e) {
      return {'error': e.toString(), 'status': 500};
    }
  }

  Future<Map<String, dynamic>> _handleGet(String endpoint) async {
    final parts = endpoint.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return {'error': 'Not found', 'status': 404};

    switch (parts[0]) {
      case 'products':
        return _getProducts(parts);
      case 'customers':
        return _getCustomers(parts);
      case 'sales':
        return _getSales(parts);
      case 'inventory':
        return _getInventory(parts);
      default:
        return {'error': 'Unknown endpoint', 'status': 404};
    }
  }

  Future<Map<String, dynamic>> _handlePost(
      String endpoint, Map<String, dynamic> body) async {
    final parts = endpoint.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return {'error': 'Not found', 'status': 404};

    switch (parts[0]) {
      case 'products':
        final id = await _db.into(_db.products).insert(ProductsCompanion.insert(
              name: body['name'] as String,
              sku: body['sku'] as String? ?? '',
              sellPrice: Value(Decimal.tryParse(body['sellPrice']?.toString() ?? '') ??
                  Decimal.zero),
              buyPrice: Value(Decimal.tryParse(body['buyPrice']?.toString() ?? '') ??
                  Decimal.zero),
              categoryId: Value(body['categoryId'] as String?),
              stock: Value(Decimal.tryParse(body['stock']?.toString() ?? '') ??
                  Decimal.zero),
            ));
        return {'id': id, 'status': 201};
      case 'sales':
        return {'error': 'Use POS interface for sales', 'status': 400};
      default:
        return {'error': 'Unknown endpoint', 'status': 404};
    }
  }

  Future<Map<String, dynamic>> _handlePut(
      String endpoint, Map<String, dynamic> body) async {
    return {'message': 'Not implemented', 'status': 501};
  }

  Future<Map<String, dynamic>> _handleDelete(String endpoint) async {
    return {'message': 'Not implemented', 'status': 501};
  }

  Future<Map<String, dynamic>> _getProducts(List<String> parts) async {
    if (parts.length > 1) {
      final product = await (_db.select(_db.products)
            ..where((p) => p.id.equals(parts[1])))
          .getSingleOrNull();
      if (product == null) return {'error': 'Not found', 'status': 404};
      return {
        'id': product.id,
        'name': product.name,
        'sku': product.sku,
        'sellPrice': product.sellPrice.toString(),
        'buyPrice': product.buyPrice.toString(),
        'stock': product.stock.toString(),
        'status': 200,
      };
    }
    final products = await _db.select(_db.products).get();
    return {
      'products': products
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'sku': p.sku,
                'sellPrice': p.sellPrice.toString(),
                'stock': p.stock.toString(),
              })
          .toList(),
      'status': 200,
    };
  }

  Future<Map<String, dynamic>> _getCustomers(List<String> parts) async {
    final customers = await _db.select(_db.customers).get();
    return {
      'customers': customers
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'phone': c.phone,
                'balance': c.balance.toString(),
              })
          .toList(),
      'status': 200,
    };
  }

  Future<Map<String, dynamic>> _getSales(List<String> parts) async {
    final sales = await _db.select(_db.sales).get();
    return {
      'sales': sales
          .map((s) => {
                'id': s.id,
                'total': s.total.toString(),
                'status': s.status.toString(),
                'createdAt': s.createdAt.toIso8601String(),
              })
          .toList(),
      'status': 200,
    };
  }

  Future<Map<String, dynamic>> _getInventory(List<String> parts) async {
    final batches = await _db.select(_db.productBatches).get();
    return {
      'inventory': batches
          .map((b) => {
                'productId': b.productId,
                'batchNumber': b.batchNumber,
                'quantity': b.quantity.toString(),
                'costPrice': b.costPrice.toString(),
                'warehouseId': b.warehouseId,
              })
          .toList(),
      'status': 200,
    };
  }
}
