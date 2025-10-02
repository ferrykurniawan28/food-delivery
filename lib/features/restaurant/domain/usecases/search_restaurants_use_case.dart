import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Use case for searching restaurants
class SearchRestaurantsUseCase {
  final RestaurantRepository repository;

  const SearchRestaurantsUseCase(this.repository);

  Future<List<Restaurant>> call(String query) async {
    return await repository.findRestaurants(query);
  }
}
