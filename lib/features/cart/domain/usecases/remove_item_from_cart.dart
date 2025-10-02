import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class RemoveItemFromCartUseCase {
  final CartRepository repository;

  RemoveItemFromCartUseCase({required this.repository});

  Future<Cart> call(String cartItemId) async {
    return await repository.removeItemFromCart(cartItemId);
  }
}
