import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/usecases.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

/// BLoC for managing restaurant state
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUseCase getRestaurantsUseCase;
  final GetRestaurantsByCategoryUseCase getRestaurantsByCategoryUseCase;
  final SearchRestaurantsUseCase searchRestaurantsUseCase;
  final GetRestaurantByIdUseCase getRestaurantByIdUseCase;
  final GetRestaurantsWithFiltersUseCase getRestaurantsWithFiltersUseCase;
  final GetRestaurantsNearbyUseCase getRestaurantsNearbyUseCase;

  RestaurantBloc({
    required this.getRestaurantsUseCase,
    required this.getRestaurantsByCategoryUseCase,
    required this.searchRestaurantsUseCase,
    required this.getRestaurantByIdUseCase,
    required this.getRestaurantsWithFiltersUseCase,
    required this.getRestaurantsNearbyUseCase,
  }) : super(const RestaurantInitial()) {
    on<LoadRestaurantsEvent>(_onLoadRestaurants);
    on<LoadRestaurantsByCategoryEvent>(_onLoadRestaurantsByCategory);
    on<SearchRestaurantsEvent>(_onSearchRestaurants);
    on<LoadRestaurantByIdEvent>(_onLoadRestaurantById);
    on<LoadRestaurantsWithFiltersEvent>(_onLoadRestaurantsWithFilters);
    on<LoadRestaurantsNearbyEvent>(_onLoadRestaurantsNearby);
    on<RefreshRestaurantsEvent>(_onRefreshRestaurants);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final restaurants = await getRestaurantsUseCase();
      if (restaurants.isEmpty) {
        emit(const RestaurantsEmpty());
      } else {
        emit(RestaurantsLoaded(restaurants: restaurants));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onLoadRestaurantsByCategory(
    LoadRestaurantsByCategoryEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final restaurants = await getRestaurantsByCategoryUseCase(event.category);
      if (restaurants.isEmpty) {
        emit(
          RestaurantsEmpty(
            message: 'No restaurants found for ${event.category}',
          ),
        );
      } else {
        emit(
          RestaurantsLoaded(restaurants: restaurants, category: event.category),
        );
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadRestaurantsEvent());
      return;
    }

    emit(const RestaurantLoading());
    try {
      final restaurants = await searchRestaurantsUseCase(event.query);
      if (restaurants.isEmpty) {
        emit(
          RestaurantsEmpty(
            message: 'No restaurants found for "${event.query}"',
          ),
        );
      } else {
        emit(
          RestaurantsLoaded(restaurants: restaurants, searchQuery: event.query),
        );
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onLoadRestaurantById(
    LoadRestaurantByIdEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final restaurant = await getRestaurantByIdUseCase(event.id);
      if (restaurant != null) {
        emit(RestaurantDetailsLoaded(restaurant));
      } else {
        emit(const RestaurantError(message: 'Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onLoadRestaurantsWithFilters(
    LoadRestaurantsWithFiltersEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final restaurants = await getRestaurantsWithFiltersUseCase(event.params);
      if (restaurants.isEmpty) {
        emit(
          const RestaurantsEmpty(message: 'No restaurants match your filters'),
        );
      } else {
        emit(RestaurantsLoaded(restaurants: restaurants));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onLoadRestaurantsNearby(
    LoadRestaurantsNearbyEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final restaurants = await getRestaurantsNearbyUseCase(event.params);
      if (restaurants.isEmpty) {
        emit(const RestaurantsEmpty(message: 'No restaurants found nearby'));
      } else {
        emit(RestaurantsLoaded(restaurants: restaurants));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    // Check current state to determine what to refresh
    if (state is RestaurantsLoaded) {
      final currentState = state as RestaurantsLoaded;
      if (currentState.category != null) {
        add(LoadRestaurantsByCategoryEvent(currentState.category!));
      } else if (currentState.searchQuery != null) {
        add(SearchRestaurantsEvent(currentState.searchQuery!));
      } else {
        add(const LoadRestaurantsEvent());
      }
    } else {
      add(const LoadRestaurantsEvent());
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    add(const LoadRestaurantsEvent());
  }
}
