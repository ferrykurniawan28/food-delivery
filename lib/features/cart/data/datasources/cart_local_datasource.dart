import '../models/models.dart';

/// Abstract interface for cart local data source
abstract class CartLocalDataSource {
  /// Get cart from local storage
  Future<CartModel?> getCart();

  /// Save cart to local storage
  Future<void> saveCart(CartModel cart);

  /// Delete cart from local storage
  Future<void> deleteCart();

  /// Check if cart exists in local storage
  Future<bool> hasCart();
}
