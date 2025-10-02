import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_local_datasource.dart';
import '../datasources/restaurant_remote_datasource.dart';

/// Implementation of RestaurantRepository
class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  final RestaurantLocalDataSource localDataSource;

  const RestaurantRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      // Try to get fresh data from remote
      final restaurants = await remoteDataSource.getRestaurants();
      // Cache the data locally
      await localDataSource.cacheRestaurants(restaurants);
      return restaurants;
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedRestaurants = await localDataSource.getCachedRestaurants();
        if (cachedRestaurants.isNotEmpty) {
          return cachedRestaurants;
        }
      } catch (cacheError) {
        // If both fail, rethrow the original error
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    try {
      // Try to get fresh data from remote
      final restaurants = await remoteDataSource.getRestaurantsByCategory(
        category,
      );
      return restaurants;
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedRestaurants = await localDataSource
            .getCachedRestaurantsByCategory(category);
        if (cachedRestaurants.isNotEmpty) {
          return cachedRestaurants;
        }
      } catch (cacheError) {
        // If both fail, rethrow the original error
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> findRestaurants(String query) async {
    try {
      // Try to get search results from remote
      final restaurants = await remoteDataSource.searchRestaurants(query);
      return restaurants;
    } catch (e) {
      // If remote fails, try to search cached data
      try {
        final cachedRestaurants = await localDataSource.searchCachedRestaurants(
          query,
        );
        if (cachedRestaurants.isNotEmpty) {
          return cachedRestaurants;
        }
      } catch (cacheError) {
        // If both fail, rethrow the original error
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<Restaurant?> getRestaurantById(String id) async {
    try {
      // Try to get restaurant from remote
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return restaurant;
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedRestaurant = await localDataSource.getCachedRestaurantById(
          id,
        );
        return cachedRestaurant;
      } catch (cacheError) {
        // If both fail, rethrow the original error
        rethrow;
      }
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsNearby({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    try {
      // Get nearby restaurants from remote
      final restaurants = await remoteDataSource.getRestaurantsNearby(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
      );
      return restaurants;
    } catch (e) {
      // For location-based queries, we typically don't cache as location might change
      // but you could implement a basic fallback here if needed
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsWithFilters({
    String? category,
    double? minRating,
    String? priceRange,
    bool? isOpen,
    int? maxDeliveryTime,
  }) async {
    try {
      // Get filtered restaurants from remote
      final restaurants = await remoteDataSource.getRestaurantsWithFilters(
        category: category,
        minRating: minRating,
        priceRange: priceRange,
        isOpen: isOpen,
        maxDeliveryTime: maxDeliveryTime,
      );
      return restaurants;
    } catch (e) {
      // For complex filtered queries, fallback to cached data might not be accurate
      // but you could implement basic filtering on cached data here
      rethrow;
    }
  }

  /// Clear local cache
  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }

  /// Check if cache is valid
  Future<bool> isCacheValid() async {
    return await localDataSource.isCacheValid();
  }
}
