import '../../domain/entities/entities.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/models.dart';

/// Implementation of CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Cart?> getCart() async {
    try {
      final cartModel = await localDataSource.getCart();
      return cartModel; // CartModel extends Cart, so this works
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveCart(Cart cart) async {
    final cartModel = CartModel.fromEntity(cart);
    await localDataSource.saveCart(cartModel);
  }

  @override
  Future<Cart> addItemToCart(CartItem item) async {
    // Get current cart or create new one
    Cart currentCart = await getCart() ?? CartModel.empty();

    // Add item to cart
    final updatedCart = currentCart.addItem(item);

    // Save updated cart
    await saveCart(updatedCart);

    return updatedCart;
  }

  @override
  Future<Cart> removeItemFromCart(String cartItemId) async {
    final currentCart = await getCart();
    if (currentCart == null) {
      throw Exception('Cart not found');
    }

    final updatedCart = currentCart.removeItem(cartItemId);
    await saveCart(updatedCart);

    return updatedCart;
  }

  @override
  Future<Cart> updateItemQuantity(String cartItemId, int quantity) async {
    final currentCart = await getCart();
    if (currentCart == null) {
      throw Exception('Cart not found');
    }

    final updatedCart = currentCart.updateItemQuantity(cartItemId, quantity);
    await saveCart(updatedCart);

    return updatedCart;
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.deleteCart();
  }

  @override
  Future<Cart> clearRestaurantItems(String restaurantId) async {
    final currentCart = await getCart();
    if (currentCart == null) {
      throw Exception('Cart not found');
    }

    final updatedCart = currentCart.clearRestaurantItems(restaurantId);
    await saveCart(updatedCart);

    return updatedCart;
  }

  @override
  Future<int> getCartItemCount() async {
    final cart = await getCart();
    return cart?.totalItemCount ?? 0;
  }

  @override
  Future<bool> hasMultipleRestaurants() async {
    final cart = await getCart();
    return cart?.hasMultipleRestaurants ?? false;
  }

  @override
  Future<double> getCartTotal() async {
    final cart = await getCart();
    return cart?.total ?? 0.0;
  }
}
