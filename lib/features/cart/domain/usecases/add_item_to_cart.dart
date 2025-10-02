import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddItemToCartUseCase {
  final CartRepository repository;

  AddItemToCartUseCase({required this.repository});

  Future<Cart> call(CartItem item) async {
    return await repository.addItemToCart(item);
  }
}
