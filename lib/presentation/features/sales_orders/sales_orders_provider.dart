import 'package:flutter/foundation.dart';
import 'package:supermarket/core/services/sales/sales_order_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class SalesOrdersProvider extends ChangeNotifier {
  final SalesOrderService _service;

  SalesOrdersProvider(this._service);

  List<SalesOrder> _orders = [];
  List<SalesOrder> get orders => _orders;

  List<SalesOrderWithCustomer> _ordersWithCustomer = [];
  List<SalesOrderWithCustomer> get ordersWithCustomer => _ordersWithCustomer;

  SalesOrder? _selectedOrder;
  SalesOrder? get selectedOrder => _selectedOrder;

  List<SalesOrderItem> _orderItems = [];
  List<SalesOrderItem> get orderItems => _orderItems;

  String _statusFilter = 'ALL';
  String get statusFilter => _statusFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Map<String, int> _statusCounts = {};
  Map<String, int> get statusCounts => _statusCounts;

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_statusFilter == 'ALL') {
        _ordersWithCustomer = await _service.getAllOrdersWithCustomer();
      } else {
        _ordersWithCustomer =
            await _service.getOrdersWithCustomerByStatus(_statusFilter);
      }
      _orders = _ordersWithCustomer.map((e) => e.order).toList();
      await _loadStatusCounts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadStatusCounts() async {
    _statusCounts = {
      'PENDING': await _service.getOrdersCountByStatus('PENDING'),
      'ORDERED': await _service.getOrdersCountByStatus('ORDERED'),
      'READY': await _service.getOrdersCountByStatus('READY'),
      'DELIVERED': await _service.getOrdersCountByStatus('DELIVERED'),
      'CANCELLED': await _service.getOrdersCountByStatus('CANCELLED'),
    };
  }

  Future<void> loadOrderDetails(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedOrder = await _service.getOrderById(orderId);
      _orderItems = await _service.getOrderItems(orderId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder({
    required String? customerId,
    required List<SalesOrderItemData> items,
    String? notes,
    String? userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createOrder(
        customerId: customerId,
        items: items,
        notes: notes,
        userId: userId,
      );
      await loadOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrder({
    required String orderId,
    String? customerId,
    required List<SalesOrderItemData> items,
    String? notes,
    String? userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.updateOrder(
        orderId: orderId,
        customerId: customerId,
        items: items,
        notes: notes,
        userId: userId,
      );
      await loadOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStatus(String orderId, String newStatus,
      {String? userId}) async {
    try {
      await _service.updateStatus(orderId, newStatus, userId: userId);
      await loadOrders();
      if (_selectedOrder?.id == orderId) {
        await loadOrderDetails(orderId);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId, {String? userId}) async {
    try {
      await _service.deleteOrder(orderId, userId: userId);
      await loadOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId, {String? userId}) async {
    try {
      await _service.cancelOrder(orderId, userId: userId);
      await loadOrders();
      if (_selectedOrder?.id == orderId) {
        await loadOrderDetails(orderId);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> convertToPurchaseOrder(
    String orderId, {
    required String supplierId,
    String? warehouseId,
    String? userId,
  }) async {
    try {
      await _service.convertToPurchaseOrder(
        orderId,
        supplierId: supplierId,
        warehouseId: warehouseId,
        userId: userId,
      );
      await loadOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
