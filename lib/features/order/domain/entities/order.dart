import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../restaurant/domain/entities/restaurant.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  driverAssigned,
  pickedUp,
  enRoute,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final Cart cart;
  final Restaurant restaurant;
  final OrderStatus status;
  final DateTime placedAt;
  final DateTime? estimatedDeliveryTime;
  final String? driverName;
  final String? driverPhone;
  final String? trackingCode;
  final double totalAmount;
  final String deliveryAddress;
  final List<OrderStatusUpdate> statusHistory;
  final String? specialInstructions;
  final bool isPaid;

  const Order({
    required this.id,
    required this.cart,
    required this.restaurant,
    required this.status,
    required this.placedAt,
    this.estimatedDeliveryTime,
    this.driverName,
    this.driverPhone,
    this.trackingCode,
    required this.totalAmount,
    required this.deliveryAddress,
    this.statusHistory = const [],
    this.specialInstructions,
    this.isPaid = false,
  });

  Order copyWith({
    String? id,
    Cart? cart,
    Restaurant? restaurant,
    OrderStatus? status,
    DateTime? placedAt,
    DateTime? estimatedDeliveryTime,
    String? driverName,
    String? driverPhone,
    String? trackingCode,
    double? totalAmount,
    String? deliveryAddress,
    List<OrderStatusUpdate>? statusHistory,
    String? specialInstructions,
    bool? isPaid,
  }) {
    return Order(
      id: id ?? this.id,
      cart: cart ?? this.cart,
      restaurant: restaurant ?? this.restaurant,
      status: status ?? this.status,
      placedAt: placedAt ?? this.placedAt,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      trackingCode: trackingCode ?? this.trackingCode,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      statusHistory: statusHistory ?? this.statusHistory,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  String get statusDisplayText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Food';
      case OrderStatus.driverAssigned:
        return 'Driver Assigned';
      case OrderStatus.pickedUp:
        return 'Order Picked Up';
      case OrderStatus.enRoute:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get estimatedMinutesRemaining {
    if (estimatedDeliveryTime == null) return 0;
    final now = DateTime.now();
    final difference = estimatedDeliveryTime!.difference(now);
    return difference.inMinutes.clamp(0, 999);
  }

  bool get isActiveOrder {
    return status != OrderStatus.delivered && status != OrderStatus.cancelled;
  }

  @override
  List<Object?> get props => [
    id,
    cart,
    restaurant,
    status,
    placedAt,
    estimatedDeliveryTime,
    driverName,
    driverPhone,
    trackingCode,
    totalAmount,
    deliveryAddress,
    statusHistory,
    specialInstructions,
    isPaid,
  ];
}

class OrderStatusUpdate extends Equatable {
  final OrderStatus status;
  final DateTime timestamp;
  final String? message;

  const OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.message,
  });

  @override
  List<Object?> get props => [status, timestamp, message];
}
