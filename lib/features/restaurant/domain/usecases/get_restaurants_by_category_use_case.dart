import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Use case for getting restaurants by category
class GetRestaurantsByCategoryUseCase {
  final RestaurantRepository repository;

  const GetRestaurantsByCategoryUseCase(this.repository);

  Future<List<Restaurant>> call(String category) async {
    return await repository.getRestaurantsByCategory(category);
  }
}
