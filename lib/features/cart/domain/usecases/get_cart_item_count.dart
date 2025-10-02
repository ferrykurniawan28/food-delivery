import '../repositories/cart_repository.dart';

class GetCartItemCountUseCase {
  final CartRepository repository;

  GetCartItemCountUseCase({required this.repository});

  Future<int> call() async {
    return await repository.getCartItemCount();
  }
}
