import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order.dart';
import '../blocs/order_bloc.dart';
import '../../../../core/widgets/error_handling_widgets.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;
  final Order? initialOrder;
  final bool isFromCheckout;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
    this.initialOrder,
    this.isFromCheckout = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Track Your Order'),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: isFromCheckout
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          // Initialize the bloc with the initial order or track the order
          if (state is OrderInitial) {
            if (initialOrder != null) {
              // Use the initial order and start tracking
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<OrderBloc>().add(
                  InitializeOrderTracking(initialOrder!),
                );
              });
            } else {
              // Try to track the order (fallback)
              context.read<OrderBloc>().add(TrackOrder(orderId));
            }
          }

          if (state is OrderLoading) {
            return const LoadingOverlay(
              message: 'Loading order details...',
              isVisible: true,
            );
          }

          if (state is OrderError) {
            return ErrorHandlingWidget(
              error: state.message,
              onRetry: () {
                if (initialOrder != null) {
                  context.read<OrderBloc>().add(
                    InitializeOrderTracking(initialOrder!),
                  );
                } else {
                  context.read<OrderBloc>().add(TrackOrder(orderId));
                }
              },
            );
          }

          if (state is OrderPlaced ||
              state is OrderTracking ||
              state is OrderStatusUpdated) {
            final order = state is OrderPlaced
                ? state.order
                : state is OrderTracking
                ? state.order
                : (state as OrderStatusUpdated).order;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderBloc>().add(TrackOrder(orderId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(context, order),
                    const SizedBox(height: 24),
                    _buildProgressTracker(context, order),
                    const SizedBox(height: 24),
                    _buildOrderDetails(context, order),
                    const SizedBox(height: 24),
                    _buildDriverInfo(context, order),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, order),
                  ],
                ),
              ),
            );
          }

          return const ErrorHandlingWidget(
            error: 'Order not found',
            onRetry: null,
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.statusDisplayText,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              if (order.estimatedMinutesRemaining > 0)
                Text(
                  '${order.estimatedMinutesRemaining} min',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.restaurant.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Order #${order.trackingCode}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (order.estimatedDeliveryTime != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Estimated delivery: ${_formatTime(order.estimatedDeliveryTime!)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressTracker(BuildContext context, Order order) {
    final steps = [
      (OrderStatus.confirmed, 'Order Confirmed', Icons.check_circle),
      (OrderStatus.preparing, 'Preparing', Icons.restaurant),
      (OrderStatus.driverAssigned, 'Driver Assigned', Icons.person),
      (OrderStatus.pickedUp, 'Picked Up', Icons.shopping_bag),
      (OrderStatus.enRoute, 'On the Way', Icons.delivery_dining),
      (OrderStatus.delivered, 'Delivered', Icons.home),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final (status, title, icon) = entry.value;
              final isCompleted = order.status.index >= status.index;
              final isCurrent = order.status == status;
              final isLast = index == steps.length - 1;

              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFE53935)
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: isCompleted ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 30,
                          color: isCompleted
                              ? const Color(0xFFE53935)
                              : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCompleted
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        if (isCurrent && order.statusHistory.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.statusHistory.last.message ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...order.cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.name)),
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(BuildContext context, Order order) {
    if (order.status.index < OrderStatus.driverAssigned.index) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Driver',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFE53935),
                child: Text(
                  order.driverName?.substring(0, 1).toUpperCase() ?? 'D',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.driverName ?? 'Delivery Driver',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text('4.8'),
                        const SizedBox(width: 8),
                        Text(
                          '${(DateTime.now().millisecondsSinceEpoch % 500 + 100)} deliveries',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (order.driverPhone != null)
                IconButton(
                  onPressed: () {
                    // In a real app, this would open phone dialer
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling ${order.driverPhone}...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    if (order.status == OrderStatus.delivered) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to rating/review page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rate your experience!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.star_outline),
          label: const Text('Rate & Review'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (order.status.index >= OrderStatus.pickedUp.index) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _showCancelDialog(context, order);
        },
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Cancel Order'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<OrderBloc>().add(
                CancelOrder(order.id, 'Cancelled by customer'),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.driverAssigned:
      case OrderStatus.pickedUp:
        return Colors.purple;
      case OrderStatus.enRoute:
        return const Color(0xFFE53935);
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Delivered';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
