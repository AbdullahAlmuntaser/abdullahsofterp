import 'dart:convert';
import 'package:http/http.dart' as http;

class EcommerceIntegrationService {
  bool _isConnected = false;
  String? _storeUrl;
  String? _consumerKey;
  String? _consumerSecret;
  final http.Client _httpClient;

  bool get isConnected => _isConnected;
  String? get storeUrl => _storeUrl;

  EcommerceIntegrationService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<bool> connect(String storeUrl,
      {String? consumerKey, String? consumerSecret}) async {
    try {
      _storeUrl = storeUrl.endsWith('/')
          ? storeUrl.substring(0, storeUrl.length - 1)
          : storeUrl;
      _consumerKey = consumerKey;
      _consumerSecret = consumerSecret;
      _isConnected = await testConnection();
      return _isConnected;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    _storeUrl = null;
    _consumerKey = null;
    _consumerSecret = null;
  }

  Map<String, String> get _authHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_consumerKey != null && _consumerSecret != null) {
      final credentials = base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
      headers['Authorization'] = 'Basic $credentials';
    }
    return headers;
  }

  Uri _apiUri(String path, [Map<String, String>? params]) {
    final uri = Uri.parse('$_storeUrl/wp-json/wc/v3/$path');
    if (params != null && params.isNotEmpty) {
      return uri.replace(queryParameters: params);
    }
    return uri;
  }

  Future<List<OnlineOrder>> fetchOrders({int page = 1, int perPage = 20}) async {
    if (!_isConnected) return [];
    try {
      final uri = _apiUri('orders', {'page': '$page', 'per_page': '$perPage', 'status': 'any'});
      final response = await _httpClient.get(uri, headers: _authHeaders);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => OnlineOrder.fromWooCommerce(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> syncProducts({List<Map<String, dynamic>>? products}) async {
    if (!_isConnected) return false;
    try {
      for (final product in products ?? []) {
        final uri = _apiUri('products');
        await _httpClient.post(uri, headers: _authHeaders, body: jsonEncode(product));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateInventory(String productSku, int quantity) async {
    if (!_isConnected) return false;
    try {
      final uri = _apiUri('products', {'sku': productSku});
      final response = await _httpClient.get(uri, headers: _authHeaders);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final productId = (data.first as Map<String, dynamic>)['id'];
          final updateUri = _apiUri('products/$productId');
          await _httpClient.put(updateUri, headers: _authHeaders,
              body: jsonEncode({'stock_quantity': quantity}));
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> pushOrderToStore(OnlineOrder order) async {
    if (!_isConnected) return false;
    try {
      final uri = _apiUri('orders');
      final response = await _httpClient.post(uri,
          headers: _authHeaders,
          body: jsonEncode({
            'payment_method': 'cod',
            'customer_note': order.notes ?? '',
            'billing': {
              'first_name': order.customerName,
              'phone': order.customerPhone,
            },
            'shipping': {
              'address_1': order.customerAddress,
            },
            'line_items': order.items.map((item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
              'price': item.price.toString(),
            }).toList(),
          }));
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getStoreStats() async {
    if (!_isConnected) return {};
    try {
      final ordersUri = _apiUri('orders/count');
      final revenueUri = _apiUri('reports/revenue');
      final ordersRes = await _httpClient.get(ordersUri, headers: _authHeaders);
      final revenueRes = await _httpClient.get(revenueUri, headers: _authHeaders);

      final ordersData = ordersRes.statusCode == 200
          ? jsonDecode(ordersRes.body) as Map<String, dynamic>
          : <String, dynamic>{};
      final revenueData = revenueRes.statusCode == 200
          ? jsonDecode(revenueRes.body) as Map<String, dynamic>
          : <String, dynamic>{};

      return {
        'totalOrders': ordersData['total'] ?? 0,
        'pendingOrders': ordersData['pending'] ?? 0,
        'totalSales': revenueData['total_sales'] ?? 0.0,
        'lastSync': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'totalOrders': 0,
        'pendingOrders': 0,
        'totalSales': 0.0,
        'lastSync': null,
      };
    }
  }

  Future<bool> testConnection() async {
    try {
      final uri = _apiUri('');
      final response = await _httpClient.get(uri, headers: _authHeaders);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class OnlineOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OnlineOrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? notes;

  OnlineOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory OnlineOrder.fromWooCommerce(Map<String, dynamic> json) {
    final billing = json['billing'] as Map<String, dynamic>? ?? {};
    final shipping = json['shipping'] as Map<String, dynamic>? ?? {};
    final lineItems = (json['line_items'] as List<dynamic>?)
            ?.map((item) => OnlineOrderItem.fromWooCommerce(item as Map<String, dynamic>))
            .toList() ??
        [];
    return OnlineOrder(
      id: json['id']?.toString() ?? '',
      customerName: billing['first_name'] ?? '',
      customerPhone: billing['phone'] ?? '',
      customerAddress: shipping['address_1'] ?? '',
      items: lineItems,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['date_created'] ?? '') ?? DateTime.now(),
      notes: json['customer_note'],
    );
  }

  Map<String, dynamic> toLocalOrder() {
    return {
      'onlineOrderId': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class OnlineOrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OnlineOrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OnlineOrderItem.fromWooCommerce(Map<String, dynamic> json) {
    return OnlineOrderItem(
      productId: json['product_id']?.toString() ?? '',
      productName: json['name'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

class EcommerceSettings {
  final String? storeUrl;
  final String? apiKey;
  final bool autoSync;
  final bool autoAcceptOrders;
  final bool syncInventory;

  EcommerceSettings({
    this.storeUrl,
    this.apiKey,
    this.autoSync = false,
    this.autoAcceptOrders = false,
    this.syncInventory = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeUrl': storeUrl,
      'apiKey': apiKey,
      'autoSync': autoSync,
      'autoAcceptOrders': autoAcceptOrders,
      'syncInventory': syncInventory,
    };
  }

  factory EcommerceSettings.fromJson(Map<String, dynamic> json) {
    return EcommerceSettings(
      storeUrl: json['storeUrl'],
      apiKey: json['apiKey'],
      autoSync: json['autoSync'] ?? false,
      autoAcceptOrders: json['autoAcceptOrders'] ?? false,
      syncInventory: json['syncInventory'] ?? false,
    );
  }
}
