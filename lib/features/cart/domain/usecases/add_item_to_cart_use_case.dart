import '../entities/entities.dart';
import '../repositories/cart_repository.dart';

/// Use case for adding an item to the cart
class AddItemToCartUseCase {
  final CartRepository repository;

  AddItemToCartUseCase(this.repository);

  Future<Cart> call(CartItem item) async {
    return await repository.addItemToCart(item);
  }
}
