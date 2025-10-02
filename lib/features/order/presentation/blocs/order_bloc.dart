import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../data/services/order_storage_service.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final Order order;

  const PlaceOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class TrackOrder extends OrderEvent {
  final String orderId;

  const TrackOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;
  final String? message;

  const UpdateOrderStatus(this.orderId, this.newStatus, {this.message});

  @override
  List<Object?> get props => [orderId, newStatus, message];
}

class LoadActiveOrders extends OrderEvent {}

class LoadOrderHistory extends OrderEvent {}

class CancelOrder extends OrderEvent {
  final String orderId;
  final String reason;

  const CancelOrder(this.orderId, this.reason);

  @override
  List<Object?> get props => [orderId, reason];
}

class StartOrderSimulation extends OrderEvent {
  final String orderId;

  const StartOrderSimulation(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class InitializeOrderTracking extends OrderEvent {
  final Order order;

  const InitializeOrderTracking(this.order);

  @override
  List<Object?> get props => [order];
}

// States
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;

  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderTracking extends OrderState {
  final Order order;

  const OrderTracking(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersLoaded extends OrderState {
  final List<Order> activeOrders;
  final List<Order> orderHistory;

  const OrdersLoaded({
    this.activeOrders = const [],
    this.orderHistory = const [],
  });

  @override
  List<Object?> get props => [activeOrders, orderHistory];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderStatusUpdated extends OrderState {
  final Order order;

  const OrderStatusUpdated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderCancelled extends OrderState {
  final String orderId;
  final String reason;

  const OrderCancelled(this.orderId, this.reason);

  @override
  List<Object?> get props => [orderId, reason];
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderStorageService _orderStorage = OrderStorageService();
  final Map<String, Timer?> _orderTimers = {};

  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<TrackOrder>(_onTrackOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<LoadActiveOrders>(_onLoadActiveOrders);
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<CancelOrder>(_onCancelOrder);
    on<StartOrderSimulation>(_onStartOrderSimulation);
    on<InitializeOrderTracking>(_onInitializeOrderTracking);
  }

  @override
  Future<void> close() {
    // Cancel all active timers
    for (final timer in _orderTimers.values) {
      timer?.cancel();
    }
    _orderTimers.clear();
    return super.close();
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final order = event.order.copyWith(
        status: OrderStatus.confirmed,
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
        trackingCode: 'FD${DateTime.now().millisecondsSinceEpoch}',
      );

      _orderStorage.addOrder(order);

      emit(OrderPlaced(order));

      // Start automatic status updates simulation
      add(StartOrderSimulation(order.id));
    } catch (e) {
      emit(OrderError('Failed to place order: ${e.toString()}'));
    }
  }

  Future<void> _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());

      final order = _orderStorage.getOrder(event.orderId);
      if (order == null) {
        emit(const OrderError('Order not found'));
        return;
      }

      emit(OrderTracking(order));
    } catch (e) {
      emit(OrderError('Failed to track order: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final existingOrder = _orderStorage.getOrder(event.orderId);
      if (existingOrder == null) {
        emit(const OrderError('Order not found'));
        return;
      }

      final statusUpdate = OrderStatusUpdate(
        status: event.newStatus,
        timestamp: DateTime.now(),
        message: event.message,
      );

      final updatedOrder = existingOrder.copyWith(
        status: event.newStatus,
        statusHistory: [...existingOrder.statusHistory, statusUpdate],
      );

      _orderStorage.updateOrder(updatedOrder);

      emit(OrderStatusUpdated(updatedOrder));

      // If order is delivered or cancelled, stop the timer
      if (event.newStatus == OrderStatus.delivered ||
          event.newStatus == OrderStatus.cancelled) {
        _orderTimers[event.orderId]?.cancel();
        _orderTimers.remove(event.orderId);
      }
    } catch (e) {
      emit(OrderError('Failed to update order status: ${e.toString()}'));
    }
  }

  Future<void> _onLoadActiveOrders(
    LoadActiveOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());

      final activeOrders = _orderStorage.getActiveOrders();
      final orderHistory = _orderStorage.getOrderHistory();

      emit(
        OrdersLoaded(activeOrders: activeOrders, orderHistory: orderHistory),
      );
    } catch (e) {
      emit(OrderError('Failed to load orders: ${e.toString()}'));
    }
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());

      final orderHistory = _orderStorage.getOrderHistory();

      emit(OrdersLoaded(orderHistory: orderHistory));
    } catch (e) {
      emit(OrderError('Failed to load order history: ${e.toString()}'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final existingOrder = _orderStorage.getOrder(event.orderId);
      if (existingOrder == null) {
        emit(const OrderError('Order not found'));
        return;
      }

      // Can only cancel orders that haven't been picked up
      if (existingOrder.status.index >= OrderStatus.pickedUp.index) {
        emit(const OrderError('Cannot cancel order - already picked up'));
        return;
      }

      add(
        UpdateOrderStatus(
          event.orderId,
          OrderStatus.cancelled,
          message: event.reason,
        ),
      );

      emit(OrderCancelled(event.orderId, event.reason));
    } catch (e) {
      emit(OrderError('Failed to cancel order: ${e.toString()}'));
    }
  }

  Future<void> _onStartOrderSimulation(
    StartOrderSimulation event,
    Emitter<OrderState> emit,
  ) async {
    final orderId = event.orderId;

    // Cancel existing timer for this order
    _orderTimers[orderId]?.cancel();

    // Create realistic progression timeline
    const progressionSchedule = [
      (
        Duration(minutes: 2),
        OrderStatus.preparing,
        "Restaurant is preparing your food",
      ),
      (
        Duration(minutes: 8),
        OrderStatus.driverAssigned,
        "Driver is on the way to restaurant",
      ),
      (
        Duration(minutes: 12),
        OrderStatus.pickedUp,
        "Driver picked up your order",
      ),
      (
        Duration(minutes: 25),
        OrderStatus.enRoute,
        "Driver is heading to your location",
      ),
      (
        Duration(minutes: 30),
        OrderStatus.delivered,
        "Order delivered successfully!",
      ),
    ];

    int currentStep = 0;

    void scheduleNextUpdate() {
      if (currentStep >= progressionSchedule.length) return;

      final (duration, status, message) = progressionSchedule[currentStep];

      _orderTimers[orderId] = Timer(duration, () {
        if (!isClosed) {
          add(UpdateOrderStatus(orderId, status, message: message));
          currentStep++;
          scheduleNextUpdate();
        }
      });
    }

    scheduleNextUpdate();
  }

  Future<void> _onInitializeOrderTracking(
    InitializeOrderTracking event,
    Emitter<OrderState> emit,
  ) async {
    try {
      // Store the order and start tracking
      _orderStorage.addOrder(event.order);

      emit(OrderTracking(event.order));

      // Start the simulation if the order is still active
      if (event.order.isActiveOrder) {
        add(StartOrderSimulation(event.order.id));
      }
    } catch (e) {
      emit(OrderError('Failed to initialize order tracking: ${e.toString()}'));
    }
  }
}
