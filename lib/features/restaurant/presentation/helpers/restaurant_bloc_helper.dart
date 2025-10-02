import 'package:flutter_modular/flutter_modular.dart';
import '../bloc/bloc.dart';

/// Example of how to integrate the RestaurantBloc with your existing UI
/// Add this to your restaurant_list.dart file initState method:
///
/// ```dart
/// @override
/// void initState() {
///   super.initState();
///   _restaurantBloc = Modular.get<RestaurantBloc>();
///   // Load restaurants for the initial category (Popular)
///   _loadRestaurantsByCategory(tabs[0].keys.first);
/// }
/// ```
///
/// And replace the _loadRestaurantsByCategory method with:
///
/// ```dart
/// void _loadRestaurantsByCategory(String category) {
///   _restaurantBloc.add(LoadRestaurantsByCategoryEvent(category));
/// }
/// ```
///
/// Then wrap your body content with BlocConsumer:
///
/// ```dart
/// body: BlocConsumer<RestaurantBloc, RestaurantState>(
///   bloc: _restaurantBloc,
///   listener: (context, state) {
///     if (state is RestaurantError) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text(state.message)),
///       );
///     }
///   },
///   builder: (context, state) {
///     if (state is RestaurantLoading) {
///       return const Center(child: CircularProgressIndicator());
///     }
///
///     if (state is RestaurantsLoaded) {
///       // Use state.restaurants for your restaurant list
///       return YourExistingListView(restaurants: state.restaurants);
///     }
///
///     if (state is RestaurantsEmpty) {
///       return Center(child: Text(state.message));
///     }
///
///     // Your existing ListView as fallback
///     return YourExistingContent();
///   },
/// ),
/// ```

class RestaurantBlocIntegrationHelper {
  /// Helper method to get the RestaurantBloc from Modular
  static RestaurantBloc getBloc() {
    return Modular.get<RestaurantBloc>();
  }

  /// Helper method to load restaurants by category
  static void loadRestaurantsByCategory(RestaurantBloc bloc, String category) {
    bloc.add(LoadRestaurantsByCategoryEvent(category));
  }

  /// Helper method to search restaurants
  static void searchRestaurants(RestaurantBloc bloc, String query) {
    bloc.add(SearchRestaurantsEvent(query));
  }

  /// Helper method to load all restaurants
  static void loadAllRestaurants(RestaurantBloc bloc) {
    bloc.add(const LoadRestaurantsEvent());
  }

  /// Helper method to refresh current restaurants
  static void refreshRestaurants(RestaurantBloc bloc) {
    bloc.add(const RefreshRestaurantsEvent());
  }
}
