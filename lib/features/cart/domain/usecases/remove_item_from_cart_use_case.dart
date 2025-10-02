import '../entities/entities.dart';
import '../repositories/cart_repository.dart';

/// Use case for removing an item from the cart
class RemoveItemFromCartUseCase {
  final CartRepository repository;

  RemoveItemFromCartUseCase(this.repository);

  Future<Cart> call(String cartItemId) async {
    return await repository.removeItemFromCart(cartItemId);
  }
}
