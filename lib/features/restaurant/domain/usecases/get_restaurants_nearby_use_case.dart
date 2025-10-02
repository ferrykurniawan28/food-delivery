import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

/// Parameters for getting nearby restaurants
class GetRestaurantsNearbyParams {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  const GetRestaurantsNearbyParams({
    required this.latitude,
    required this.longitude,
    this.radiusInKm = 5.0,
  });
}

/// Use case for getting nearby restaurants
class GetRestaurantsNearbyUseCase {
  final RestaurantRepository repository;

  const GetRestaurantsNearbyUseCase(this.repository);

  Future<List<Restaurant>> call(GetRestaurantsNearbyParams params) async {
    return await repository.getRestaurantsNearby(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusInKm: params.radiusInKm,
    );
  }
}
