import '../entities/entities.dart';

/// Abstract repository interface for cart operations
abstract class CartRepository {
  /// Get the current cart
  Future<Cart?> getCart();

  /// Save cart to storage
  Future<void> saveCart(Cart cart);

  /// Add item to cart
  Future<Cart> addItemToCart(CartItem item);

  /// Remove item from cart
  Future<Cart> removeItemFromCart(String cartItemId);

  /// Update item quantity in cart
  Future<Cart> updateItemQuantity(String cartItemId, int quantity);

  /// Clear entire cart
  Future<void> clearCart();

  /// Clear items from specific restaurant
  Future<Cart> clearRestaurantItems(String restaurantId);

  /// Get cart item count
  Future<int> getCartItemCount();

  /// Check if cart has items from multiple restaurants
  Future<bool> hasMultipleRestaurants();

  /// Get cart total amount
  Future<double> getCartTotal();
}
