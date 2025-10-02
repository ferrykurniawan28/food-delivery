import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class UpdateItemQuantityUseCase {
  final CartRepository repository;

  UpdateItemQuantityUseCase({required this.repository});

  Future<Cart> call(String cartItemId, int quantity) async {
    return await repository.updateItemQuantity(cartItemId, quantity);
  }
}
