import '../models/models.dart';
import 'cart_local_datasource.dart';

/// Implementation of CartLocalDataSource using in-memory storage
/// TODO: Replace with SharedPreferences implementation
class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartModel? _cart;

  @override
  Future<CartModel?> getCart() async {
    return _cart;
  }

  @override
  Future<void> saveCart(CartModel cart) async {
    _cart = cart;
  }

  @override
  Future<void> deleteCart() async {
    _cart = null;
  }

  @override
  Future<bool> hasCart() async {
    return _cart != null;
  }
}
