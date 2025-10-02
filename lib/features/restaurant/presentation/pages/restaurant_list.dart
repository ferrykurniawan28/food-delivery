import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/core/themes/app_theme.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_bloc.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_event.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/restaurant_state.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  int _currentIndex = 0;
  List<Map<String, String>> tabs = [
    {'Popular': 'assets/images/recomendation.webp'},
    {'Pizza': 'assets/images/pizza.webp'},
    {'Burger': 'assets/images/burger.webp'},
    {'Chicken': 'assets/images/chicken.webp'},
    {'Tacos': 'assets/images/tacos.webp'},
  ];

  late RestaurantBloc _restaurantBloc;

  @override
  void initState() {
    super.initState();
    _restaurantBloc = Modular.get<RestaurantBloc>();
    // Load restaurants for the initial category (Popular)
    _loadRestaurantsByCategory(tabs[0].keys.first);
  }

  void _loadRestaurantsByCategory(String category) {
    _restaurantBloc.add(LoadRestaurantsByCategoryEvent(category));
  }

  @override
  void dispose() {
    // _restaurantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivering to Main Street 123'),
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          _loadRestaurantsByCategory(tabs[_currentIndex].keys.first);
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
                  style: TextStyle(color: Color(0xFF876363)),
                  decoration: InputDecoration(
                    hintText: 'Search for restaurants or dishes',
                    hintStyle: TextStyle(color: Color(0xFF876363)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF876363)),
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
                            // Load restaurants for selected category
                            _loadRestaurantsByCategory(tabs[index].keys.first);
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
                      return RestaurantCard(
                        title: restaurant.name,
                        imageUrl: restaurant.imageUrl,
                        priceRange: restaurant.priceRange,
                        deliveryTime: '${restaurant.deliveryTime} min',
                        cuisine: restaurant.cuisineTypes.join(', '),
                        rating: restaurant.rating,
                        distance:
                            '${restaurant.distance.toStringAsFixed(1)} km',
                      );
                    },
                  );
                }

                // Default: show loading
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
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

class RestaurantCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String priceRange;
  final String deliveryTime;
  final String cuisine;
  final double rating;
  final String distance;
  const RestaurantCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.priceRange,
    required this.deliveryTime,
    required this.cuisine,
    required this.rating,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  children: [
                    TextSpan(
                      text: '$priceRange ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '• $cuisine',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text: '$rating ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextSpan(
                        text: '★',
                        style: TextStyle(color: Colors.yellow[700]),
                      ),
                      TextSpan(
                        text: ' • $deliveryTime • $priceRange',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 8),
              Text(
                distance,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
