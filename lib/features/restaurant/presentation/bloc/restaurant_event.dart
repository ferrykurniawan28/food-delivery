import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_restaurants_with_filters_use_case.dart';
import '../../domain/usecases/get_restaurants_nearby_use_case.dart';

/// Base class for all restaurant events
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all restaurants
class LoadRestaurantsEvent extends RestaurantEvent {
  const LoadRestaurantsEvent();
}

/// Event to load restaurants by category
class LoadRestaurantsByCategoryEvent extends RestaurantEvent {
  final String category;

  const LoadRestaurantsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to search restaurants
class SearchRestaurantsEvent extends RestaurantEvent {
  final String query;

  const SearchRestaurantsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to load restaurant by ID
class LoadRestaurantByIdEvent extends RestaurantEvent {
  final String id;

  const LoadRestaurantByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to load restaurants with filters
class LoadRestaurantsWithFiltersEvent extends RestaurantEvent {
  final GetRestaurantsWithFiltersParams params;

  const LoadRestaurantsWithFiltersEvent(this.params);

  @override
  List<Object?> get props => [params];
}

/// Event to load nearby restaurants
class LoadRestaurantsNearbyEvent extends RestaurantEvent {
  final GetRestaurantsNearbyParams params;

  const LoadRestaurantsNearbyEvent(this.params);

  @override
  List<Object?> get props => [params];
}

/// Event to refresh restaurants
class RefreshRestaurantsEvent extends RestaurantEvent {
  const RefreshRestaurantsEvent();
}

/// Event to clear search
class ClearSearchEvent extends RestaurantEvent {
  const ClearSearchEvent();
}
