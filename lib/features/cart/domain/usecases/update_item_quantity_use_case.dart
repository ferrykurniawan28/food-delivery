import '../entities/entities.dart';
import '../repositories/cart_repository.dart';

/// Use case for updating item quantity in the cart
class UpdateItemQuantityUseCase {
  final CartRepository repository;

  UpdateItemQuantityUseCase(this.repository);

  Future<Cart> call(String cartItemId, int quantity) async {
    return await repository.updateItemQuantity(cartItemId, quantity);
  }
}
