import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Use case for getting all restaurants
class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  const GetRestaurantsUseCase(this.repository);

  Future<List<Restaurant>> call() async {
    return await repository.getRestaurants();
  }
}
