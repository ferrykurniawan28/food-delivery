import '../repositories/cart_repository.dart';

/// Use case for getting cart item count
class GetCartItemCountUseCase {
  final CartRepository repository;

  GetCartItemCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getCartItemCount();
  }
}
