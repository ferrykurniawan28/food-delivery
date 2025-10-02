import '../entities/entities.dart';
import '../repositories/cart_repository.dart';

/// Use case for getting the current cart
class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Cart?> call() async {
    return await repository.getCart();
  }
}
