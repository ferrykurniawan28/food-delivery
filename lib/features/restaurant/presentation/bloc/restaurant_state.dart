import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';

/// Base class for all restaurant states
abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

/// Loading state
class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

/// Success state with restaurants list
class RestaurantsLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final String? category;
  final String? searchQuery;

  const RestaurantsLoaded({
    required this.restaurants,
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [restaurants, category, searchQuery];

  /// Create a copy with updated values
  RestaurantsLoaded copyWith({
    List<Restaurant>? restaurants,
    String? category,
    String? searchQuery,
  }) {
    return RestaurantsLoaded(
      restaurants: restaurants ?? this.restaurants,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Success state with single restaurant
class RestaurantDetailsLoaded extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantDetailsLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

/// Error state
class RestaurantError extends RestaurantState {
  final String message;
  final String? errorCode;

  const RestaurantError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

/// Empty state when no restaurants found
class RestaurantsEmpty extends RestaurantState {
  final String message;

  const RestaurantsEmpty({this.message = 'No restaurants found'});

  @override
  List<Object?> get props => [message];
}
