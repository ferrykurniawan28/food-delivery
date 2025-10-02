import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/bloc/bloc.dart';
import '../../../restaurant/domain/entities/restaurant.dart';
import '../../domain/entities/order.dart';
import '../blocs/order_bloc.dart';
import 'order_tracking_page.dart';
import '../../../../core/widgets/error_handling_widgets.dart';

class CheckoutPage extends StatefulWidget {
  final Restaurant restaurant;

  const CheckoutPage({super.key, required this.restaurant});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController(
    text: '123 Main St, City, State 12345',
  );
  final _instructionsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            // Clear the cart after successful order placement
            context.read<CartBloc>().add(ClearCartEvent());

            // Navigate to order tracking with the placed order
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => OrderBloc(),
                  child: OrderTrackingPage(
                    orderId: state.order.id,
                    initialOrder: state.order,
                  ),
                ),
              ),
            );
          } else if (state is OrderError) {
            ErrorSnackBar.show(context, state.message);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 24),
                _buildDeliveryAddress(),
                const SizedBox(height: 24),
                _buildSpecialInstructions(),
                const SizedBox(height: 24),
                _buildPaymentMethod(),
                const SizedBox(height: 32),
                _buildPlaceOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is! CartLoaded) {
          return const SizedBox.shrink();
        }

        final restaurantItems = cartState.cart.getItemsByRestaurant(
          widget.restaurant.id,
        );
        final subtotal = restaurantItems.fold<double>(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        const deliveryFee = 2.99;
        const serviceFee = 1.99;
        final total = subtotal + deliveryFee + serviceFee;

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.restaurant.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${restaurantItems.length} items',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...restaurantItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildSummaryRow('Subtotal', subtotal),
              _buildSummaryRow('Delivery Fee', deliveryFee),
              _buildSummaryRow('Service Fee', serviceFee),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildSummaryRow('Total', total, isTotal: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFFE53935) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
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
              Icon(Icons.location_on, color: const Color(0xFFE53935)),
              const SizedBox(width: 8),
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your delivery address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
              prefixIcon: const Icon(Icons.home),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your delivery address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialInstructions() {
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
              Icon(Icons.note_alt, color: const Color(0xFFE53935)),
              const SizedBox(width: 8),
              const Text(
                'Special Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _instructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests or delivery instructions?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
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
              Icon(Icons.payment, color: const Color(0xFFE53935)),
              const SizedBox(width: 8),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('•••• •••• •••• 4242'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment method selection coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is! CartLoaded) {
          return const SizedBox.shrink();
        }

        final restaurantItems = cartState.cart.getItemsByRestaurant(
          widget.restaurant.id,
        );
        final subtotal = restaurantItems.fold<double>(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        const deliveryFee = 2.99;
        const serviceFee = 1.99;
        final total = subtotal + deliveryFee + serviceFee;

        return BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            final isLoading = orderState is OrderLoading;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _placeOrder(cartState.cart, total),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Place Order • \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  void _placeOrder(cart, double total) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      cart: cart,
      restaurant: widget.restaurant,
      status: OrderStatus.placed,
      placedAt: DateTime.now(),
      totalAmount: total,
      deliveryAddress: _addressController.text.trim(),
      specialInstructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
      isPaid: true,
      driverName: _generateDriverName(),
      driverPhone:
          '+1 (555) ${100 + (DateTime.now().millisecondsSinceEpoch % 900)}-${1000 + (DateTime.now().millisecondsSinceEpoch % 9000)}',
    );

    try {
      final orderBloc = context.read<OrderBloc>();
      if (!orderBloc.isClosed) {
        orderBloc.add(PlaceOrder(order));
      }
    } catch (e) {
      // Handle the case where the BLoC is not available
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to place order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _generateDriverName() {
    final drivers = [
      'John Smith',
      'Sarah Johnson',
      'Mike Chen',
      'Emily Davis',
      'David Wilson',
      'Jessica Brown',
      'Chris Garcia',
      'Amanda Rodriguez',
    ];
    return drivers[DateTime.now().millisecondsSinceEpoch % drivers.length];
  }
}
