import '../datasources/restaurant_local_datasource.dart';
import '../models/restaurant_model.dart';

/// Implementation of RestaurantLocalDataSource using in-memory storage
/// In a real app, you would use SharedPreferences, Hive, or SQLite
class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  static final Map<String, dynamic> _cache = {};
  static const String _restaurantsKey = 'cached_restaurants';
  static const String _lastCacheTimeKey = 'last_cache_time';
  static const Duration _cacheValidDuration = Duration(hours: 1);

  @override
  Future<List<RestaurantModel>> getCachedRestaurants() async {
    final cachedData = _cache[_restaurantsKey] as List<RestaurantModel>?;
    return cachedData ?? [];
  }

  @override
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants) async {
    _cache[_restaurantsKey] = restaurants;
    _cache[_lastCacheTimeKey] = DateTime.now();
  }

  @override
  Future<List<RestaurantModel>> getCachedRestaurantsByCategory(
    String category,
  ) async {
    final cachedRestaurants = await getCachedRestaurants();

    if (category.toLowerCase() == 'popular') {
      // Return restaurants with high ratings for popular category
      return cachedRestaurants.where((r) => r.rating >= 4.5).toList();
    }

    return cachedRestaurants.where((restaurant) {
      return restaurant.cuisineTypes.any(
        (cuisine) => cuisine.toLowerCase().contains(category.toLowerCase()),
      );
    }).toList();
  }

  @override
  Future<List<RestaurantModel>> searchCachedRestaurants(String query) async {
    final cachedRestaurants = await getCachedRestaurants();
    final lowerQuery = query.toLowerCase();

    return cachedRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowerQuery) ||
          restaurant.description.toLowerCase().contains(lowerQuery) ||
          restaurant.cuisineTypes.any(
            (cuisine) => cuisine.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }

  @override
  Future<RestaurantModel?> getCachedRestaurantById(String id) async {
    final cachedRestaurants = await getCachedRestaurants();

    try {
      return cachedRestaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    _cache.remove(_restaurantsKey);
    _cache.remove(_lastCacheTimeKey);
  }

  @override
  Future<bool> isCacheValid() async {
    final lastCacheTime = await getLastCacheTime();

    if (lastCacheTime == null) {
      return false;
    }

    final now = DateTime.now();
    final difference = now.difference(lastCacheTime);

    return difference < _cacheValidDuration;
  }

  @override
  Future<DateTime?> getLastCacheTime() async {
    return _cache[_lastCacheTimeKey] as DateTime?;
  }
}
