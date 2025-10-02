import '../models/restaurant_model.dart';

/// Abstract interface for remote restaurant data source
abstract class RestaurantRemoteDataSource {
  /// Fetch all restaurants from remote API
  Future<List<RestaurantModel>> getRestaurants();

  /// Fetch restaurants by category from remote API
  Future<List<RestaurantModel>> getRestaurantsByCategory(String category);

  /// Search restaurants by query from remote API
  Future<List<RestaurantModel>> searchRestaurants(String query);

  /// Get a specific restaurant by ID from remote API
  Future<RestaurantModel?> getRestaurantById(String id);

  /// Get restaurants within a specific distance from remote API
  Future<List<RestaurantModel>> getRestaurantsNearby({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });

  /// Get restaurants with filters from remote API
  Future<List<RestaurantModel>> getRestaurantsWithFilters({
    String? category,
    double? minRating,
    String? priceRange,
    bool? isOpen,
    int? maxDeliveryTime,
  });
}
