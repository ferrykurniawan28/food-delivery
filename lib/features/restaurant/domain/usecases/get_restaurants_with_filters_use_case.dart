import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Parameters for filtering restaurants
class GetRestaurantsWithFiltersParams {
  final String? category;
  final double? minRating;
  final String? priceRange;
  final bool? isOpen;
  final int? maxDeliveryTime;

  const GetRestaurantsWithFiltersParams({
    this.category,
    this.minRating,
    this.priceRange,
    this.isOpen,
    this.maxDeliveryTime,
  });
}

/// Use case for getting restaurants with filters
class GetRestaurantsWithFiltersUseCase {
  final RestaurantRepository repository;

  const GetRestaurantsWithFiltersUseCase(this.repository);

  Future<List<Restaurant>> call(GetRestaurantsWithFiltersParams params) async {
    return await repository.getRestaurantsWithFilters(
      category: params.category,
      minRating: params.minRating,
      priceRange: params.priceRange,
      isOpen: params.isOpen,
      maxDeliveryTime: params.maxDeliveryTime,
    );
  }
}
