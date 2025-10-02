import '../../domain/entities/order.dart';

class OrderStorageService {
  static final OrderStorageService _instance = OrderStorageService._internal();
  factory OrderStorageService() => _instance;
  OrderStorageService._internal();

  final Map<String, Order> _orders = {};

  // Get all orders
  Map<String, Order> get orders => Map.unmodifiable(_orders);

  // Add or update an order
  void addOrder(Order order) {
    _orders[order.id] = order;
  }

  // Get a specific order
  Order? getOrder(String orderId) {
    return _orders[orderId];
  }

  // Get active orders
  List<Order> getActiveOrders() {
    return _orders.values.where((order) => order.isActiveOrder).toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
  }

  // Get order history
  List<Order> getOrderHistory() {
    return _orders.values.where((order) => !order.isActiveOrder).toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
  }

  // Update order status
  void updateOrder(Order updatedOrder) {
    _orders[updatedOrder.id] = updatedOrder;
  }

  // Remove an order (for testing purposes)
  void removeOrder(String orderId) {
    _orders.remove(orderId);
  }

  // Clear all orders (for testing purposes)
  void clearAll() {
    _orders.clear();
  }
}
