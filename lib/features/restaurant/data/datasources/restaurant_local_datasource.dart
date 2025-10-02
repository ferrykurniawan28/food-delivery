import '../models/restaurant_model.dart';

/// Abstract interface for local restaurant data source (caching)
abstract class RestaurantLocalDataSource {
  /// Get cached restaurants
  Future<List<RestaurantModel>> getCachedRestaurants();

  /// Cache restaurants locally
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants);

  /// Get cached restaurants by category
  Future<List<RestaurantModel>> getCachedRestaurantsByCategory(String category);

  /// Search cached restaurants by query
  Future<List<RestaurantModel>> searchCachedRestaurants(String query);

  /// Get a specific cached restaurant by ID
  Future<RestaurantModel?> getCachedRestaurantById(String id);

  /// Clear all cached restaurants
  Future<void> clearCache();

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid();

  /// Get last cache update time
  Future<DateTime?> getLastCacheTime();
}
