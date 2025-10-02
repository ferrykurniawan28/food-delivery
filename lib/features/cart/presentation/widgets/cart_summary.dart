import 'package:flutter/material.dart';
import 'package:fooddelivery/core/themes/app_theme.dart';
import '../../domain/entities/cart.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPriceRow('Subtotal', cart.subtotal),
            const SizedBox(height: 8),
            _buildPriceRow('Delivery Fee', cart.deliveryFee),
            const SizedBox(height: 8),
            _buildPriceRow('Tax', cart.tax),
            const Divider(height: 24),
            _buildPriceRow('Total', cart.total, isTotal: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cart.items.isEmpty
                  ? null
                  : () => _proceedToCheckout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Proceed to Checkout (${cart.totalItemCount} items)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppTheme.lightTheme.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // TODO: Navigate to checkout page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout feature coming soon!'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
