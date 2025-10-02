import '../repositories/cart_repository.dart';

/// Use case for clearing the entire cart
class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<void> call() async {
    await repository.clearCart();
  }
}
