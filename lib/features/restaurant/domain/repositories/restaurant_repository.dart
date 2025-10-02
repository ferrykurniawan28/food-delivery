import '../entities/restaurant.dart';

/// Abstract repository interface for restaurant operations
abstract class RestaurantRepository {
  /// Get all restaurants
  Future<List<Restaurant>> getRestaurants();

  /// Get restaurants by category/cuisine type
  Future<List<Restaurant>> getRestaurantsByCategory(String category);

  /// Find restaurants by search query (name, cuisine, etc.)
  Future<List<Restaurant>> findRestaurants(String query);

  /// Get a specific restaurant by ID
  Future<Restaurant?> getRestaurantById(String id);

  /// Get restaurants within a specific distance
  Future<List<Restaurant>> getRestaurantsNearby({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });

  /// Get restaurants with filters
  Future<List<Restaurant>> getRestaurantsWithFilters({
    String? category,
    double? minRating,
    String? priceRange,
    bool? isOpen,
    int? maxDeliveryTime,
  });
}
