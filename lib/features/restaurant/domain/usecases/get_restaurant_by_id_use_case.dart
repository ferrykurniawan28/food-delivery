import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Use case for getting restaurant by ID
class GetRestaurantByIdUseCase {
  final RestaurantRepository repository;

  const GetRestaurantByIdUseCase(this.repository);

  Future<Restaurant?> call(String id) async {
    return await repository.getRestaurantById(id);
  }
}
