import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/core/themes/app_theme.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_bloc.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_event.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_state.dart';
import 'package:fooddelivery/features/restaurant/presentation/widgets/restaurant_card.dart';

import '../../../cart/presentation/bloc/bloc.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, String>> tabs = [
    {'Popular': 'assets/images/recomendation.webp'},
    {'Pizza': 'assets/images/pizza.webp'},
    {'Burger': 'assets/images/burger.webp'},
    {'Chicken': 'assets/images/chicken.webp'},
    {'Tacos': 'assets/images/tacos.webp'},
  ];

  late RestaurantBloc _restaurantBloc;
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restaurantBloc = Modular.get<RestaurantBloc>();
    _cartBloc = Modular.get<CartBloc>();

    // Load restaurants for the initial category (Popular)
    _loadRestaurantsByCategory(tabs[0].keys.first);

    // Load cart to ensure we have the latest state - check if bloc is not closed
    if (!_cartBloc.isClosed) {
      _cartBloc.add(LoadCartEvent());
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     // Refresh cart when app becomes active (e.g., returning from another page)
  //     _cartBloc.add(LoadCartEvent());
  //   }
  // }

  void _loadRestaurantsByCategory(String category) {
    _restaurantBloc.add(LoadRestaurantsByCategoryEvent(category));
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      // If search is empty, load restaurants by current category
      _loadRestaurantsByCategory(tabs[_currentIndex].keys.first);
    } else {
      // Search for restaurants or dishes
      _restaurantBloc.add(SearchRestaurantsEvent(query));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _loadRestaurantsByCategory(tabs[_currentIndex].keys.first);
  }

  @override
  void dispose() {
    _searchController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    // _restaurantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivering to Main Street 123'),
        scrolledUnderElevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            bloc: _cartBloc,
            builder: (context, state) {
              print('Cart state: $state'); // Debug print
              print('State type: ${state.runtimeType}'); // Debug print

              if (state is CartLoaded) {
                print(
                  'Cart has ${state.cart.items.length} items',
                ); // Debug print
                print('Cart items: ${state.cart.items}'); // Debug print
              }

              // Always show the cart icon in a Stack so we can add badge when needed
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_rounded),
                    onPressed: () {
                      Modular.to.pushNamed('/cart');
                    },
                  ),
                  // Show badge only when there are items
                  if (state is CartLoaded && state.cart.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.cart.items.length}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          if (_searchQuery.isNotEmpty) {
            _restaurantBloc.add(SearchRestaurantsEvent(_searchQuery));
          } else {
            _loadRestaurantsByCategory(tabs[_currentIndex].keys.first);
          }
        },
        child: ListView(
          // padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F0F0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Color(0xFF876363)),
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search for restaurants or dishes',
                    hintStyle: TextStyle(color: Color(0xFF876363)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF876363)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Color(0xFF876363)),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Only show category tabs when not searching
            if (_searchQuery.isEmpty) ...[
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        tabs.length,
                        (index) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                              // Clear search when switching categories
                              if (_searchQuery.isNotEmpty) {
                                _clearSearch();
                              } else {
                                // Load restaurants for selected category
                                _loadRestaurantsByCategory(
                                  tabs[index].keys.first,
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: Image.asset(
                                      tabs[index].values.first,
                                    ).image,
                                  ),
                                  Text(
                                    tabs[index].keys.first,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentIndex == index
                                          ? AppTheme.lightTheme.primaryColor
                                          : Colors.black,
                                      fontWeight: _currentIndex == index
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Color(0xFFE53935).withOpacity(0.3)),
            ],
            // Show search results info when searching
            if (_searchQuery.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Search results for "$_searchQuery"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            // BLoC Consumer for restaurant list
            BlocBuilder<RestaurantBloc, RestaurantState>(
              bloc: _restaurantBloc,
              builder: (context, state) {
                if (state is RestaurantLoading) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is RestaurantError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else if (state is RestaurantsLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      return RestaurantCard(restaurant: restaurant);
                    },
                  );
                }

                // Default: show loading
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
