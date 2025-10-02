import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/core/themes/app_theme.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/bloc.dart';
import '../../../order/presentation/pages/checkout_page.dart';
import '../../../order/presentation/blocs/order_bloc.dart';
import '../bloc/bloc.dart';
import '../../domain/entities/entities.dart';

class RestaurantPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantPage({super.key, required this.restaurantId});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late final RestaurantBloc _restaurantBloc;

  @override
  void initState() {
    super.initState();
    _restaurantBloc = Modular.get<RestaurantBloc>();
    _loadRestaurantDetails();
  }

  void _loadRestaurantDetails() {
    _restaurantBloc.add(LoadRestaurantByIdEvent(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _restaurantBloc,
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading) {
              return const _LoadingView();
            } else if (state is RestaurantDetailsLoaded) {
              return Stack(
                children: [
                  _RestaurantDetailView(restaurant: state.restaurant),
                  _CartBottomNavBar(restaurant: state.restaurant),
                ],
              );
            } else if (state is RestaurantError) {
              return _ErrorView(
                message: state.message,
                onRetry: _loadRestaurantDetails,
              );
            } else {
              return const _NotFoundView();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _restaurantBloc.close();
    super.dispose();
  }
}

class _RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantDetailView({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _RestaurantAppBar(restaurant: restaurant),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RestaurantHeader(restaurant: restaurant),
              _MenuSection(restaurant: restaurant),
              _RestaurantInfo(restaurant: restaurant),
              _LocationSection(restaurant: restaurant),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _RestaurantAppBar extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantAppBar({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, color: Colors.black87),
          ),
          onPressed: () {
            // TODO: Implement favorite functionality
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.black87),
          ),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'restaurant_${restaurant.id}',
          child: Image.asset(
            restaurant.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.restaurant,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantHeader({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: restaurant.isOpen ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  restaurant.isOpen ? 'Open' : 'Closed',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: restaurant.cuisineTypes
                .map(
                  (cuisine) => Chip(
                    label: Text(cuisine, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[100],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                restaurant.rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${restaurant.reviewCount} reviews)',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              Icon(Icons.access_time, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text(
                '${restaurant.deliveryTime} min',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.delivery_dining, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text(
                '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Min. order: \$${restaurant.minimumOrder.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              Text(
                restaurant.priceRange,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestaurantInfo extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantInfo({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restaurant Information',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.access_time,
            title: 'Opening Hours',
            subtitle: _getOpeningHoursText(),
          ),
          _InfoRow(
            icon: Icons.phone,
            title: 'Phone',
            subtitle: restaurant.contact.phone,
          ),
          _InfoRow(
            icon: Icons.email,
            title: 'Email',
            subtitle: restaurant.contact.email,
          ),
          if (restaurant.contact.website != null)
            _InfoRow(
              icon: Icons.web,
              title: 'Website',
              subtitle: restaurant.contact.website!,
            ),
          _InfoRow(
            icon: Icons.payment,
            title: 'Payment Methods',
            subtitle: restaurant.paymentMethods.join(', '),
          ),
          _InfoRow(
            icon: Icons.delivery_dining,
            title: 'Delivery Areas',
            subtitle: restaurant.deliveryAreas.join(', '),
          ),
        ],
      ),
    );
  }

  String _getOpeningHoursText() {
    if (restaurant.operatingHours.isEmpty) return 'Not available';

    // For simplicity, show Monday's hours
    final mondayHours = restaurant.operatingHours
        .where((hours) => hours.dayOfWeek == 'Monday')
        .firstOrNull;

    if (mondayHours == null) return 'Not available';

    if (mondayHours.isClosed) return 'Closed on Monday';

    return '${mondayHours.openTime} - ${mondayHours.closeTime}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final Restaurant restaurant;

  const _MenuSection({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    if (restaurant.menuCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...restaurant.menuCategories.map(
            (category) =>
                _MenuCategoryCard(category: category, restaurant: restaurant),
          ),
        ],
      ),
    );
  }
}

class _MenuCategoryCard extends StatefulWidget {
  final MenuCategory category;
  final Restaurant restaurant;

  const _MenuCategoryCard({required this.category, required this.restaurant});

  @override
  State<_MenuCategoryCard> createState() => _MenuCategoryCardState();
}

class _MenuCategoryCardState extends State<_MenuCategoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.category.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.restaurant_menu),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.category.items.length} items',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            ...widget.category.items.map(
              (item) =>
                  _MenuItemTile(item: item, restaurant: widget.restaurant),
            ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItem item;
  final Restaurant restaurant;

  const _MenuItemTile({required this.item, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (item.isVegetarian)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${item.calories} cal',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.preparationTime} min',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (item.ingredients.isNotEmpty)
                  Text(
                    'Ingredients: ${item.ingredients.join(', ')}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      // Find if this item is already in cart
                      int currentQuantity = 0;
                      String? cartItemId;

                      if (state is CartLoaded) {
                        // Find cart item safely
                        try {
                          final cartItem = state.cart.items.firstWhere(
                            (cartItem) => cartItem.menuItemId == item.id,
                          );
                          currentQuantity = cartItem.quantity;
                          cartItemId = cartItem.id;
                        } catch (e) {
                          // Item not found in cart, keep defaults
                          currentQuantity = 0;
                          cartItemId = null;
                        }
                      }

                      if (!item.isAvailable) {
                        return ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Not Available'),
                        );
                      }

                      if (currentQuantity == 0) {
                        // Show "Add to Cart" button
                        return ElevatedButton(
                          onPressed: () {
                            // Create cart item
                            final cartItem = CartItem(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              menuItemId: item.id,
                              name: item.name,
                              description: item.description,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              quantity: 1,
                              restaurantId: restaurant.id,
                              restaurantName: restaurant.name,
                              ingredients: item.ingredients,
                              category: item.category,
                              isVegetarian: item.isVegetarian,
                              isVegan: item.isVegan,
                              calories: item.calories.round(),
                              preparationTime: item.preparationTime,
                            );

                            // Add to cart using BLoC
                            BlocProvider.of<CartBloc>(
                              context,
                            ).add(AddItemToCartEvent(cartItem));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Add to Cart'),
                        );
                      } else {
                        // Show quantity controls
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Decrease button
                              IconButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.lightTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (currentQuantity > 1) {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateItemQuantityEvent(
                                        cartItemId!,
                                        currentQuantity - 1,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<CartBloc>(
                                      context,
                                    ).add(RemoveItemFromCartEvent(cartItemId!));
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              // Quantity display
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  currentQuantity.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                              // Increase button
                              IconButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.lightTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context).add(
                                    UpdateItemQuantityEvent(
                                      cartItemId!,
                                      currentQuantity + 1,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  final Restaurant restaurant;

  const _LocationSection({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location & Delivery',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.location.address,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${restaurant.location.city}, ${restaurant.location.state} ${restaurant.location.zipCode}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${restaurant.distance.toStringAsFixed(1)} km away',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Open maps functionality
                },
                icon: const Icon(Icons.directions, size: 16),
                label: const Text('Directions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading restaurant',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Restaurant Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'The restaurant you\'re looking for could not be found.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartBottomNavBar extends StatelessWidget {
  final Restaurant restaurant;

  const _CartBottomNavBar({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoaded) {
          return const SizedBox.shrink();
        }

        // Filter cart items for this restaurant only
        final restaurantItems = state.cart.items
            .where((item) => item.restaurantId == restaurant.id)
            .toList();

        if (restaurantItems.isEmpty) {
          return const SizedBox.shrink();
        }

        // Calculate totals for this restaurant
        final totalItems = restaurantItems.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final totalValue = restaurantItems.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: Modular.get<CartBloc>()),
                          BlocProvider(create: (context) => OrderBloc()),
                        ],
                        child: CheckoutPage(restaurant: restaurant),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Cart icon with item count
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 24,
                            ),
                            if (totalItems > 0)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    totalItems > 99
                                        ? '99+'
                                        : totalItems.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Cart summary
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$totalItems ${totalItems == 1 ? 'item' : 'items'} in cart',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'From ${restaurant.name}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Total value
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${totalValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
