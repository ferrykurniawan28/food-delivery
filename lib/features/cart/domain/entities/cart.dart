import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// Represents the shopping cart containing items from restaurants
class Cart extends Equatable {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final Map<String, dynamic>? metadata;

  const Cart({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.metadata,
  });

  /// Get all unique restaurants in the cart
  List<String> get restaurantIds {
    return items.map((item) => item.restaurantId).toSet().toList();
  }

  /// Get all items from a specific restaurant
  List<CartItem> getItemsByRestaurant(String restaurantId) {
    return items.where((item) => item.restaurantId == restaurantId).toList();
  }

  /// Calculate total number of items in cart
  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calculate subtotal (sum of all item prices)
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Calculate total tax (assuming 8.5% tax rate)
  double get tax {
    return subtotal * 0.085;
  }

  /// Calculate delivery fee (could be dynamic based on restaurant)
  double get deliveryFee {
    if (items.isEmpty) return 0.0;

    // Get unique restaurants and their delivery fees
    final uniqueRestaurants = restaurantIds;
    if (uniqueRestaurants.length == 1) {
      // Single restaurant - use a base delivery fee
      return 2.99;
    } else {
      // Multiple restaurants - higher delivery fee
      return uniqueRestaurants.length * 2.99;
    }
  }

  /// Calculate service fee (typically 2-3% of subtotal)
  double get serviceFee {
    return subtotal * 0.025;
  }

  /// Calculate total amount including all fees
  double get total {
    return subtotal + tax + deliveryFee + serviceFee;
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if cart contains items from multiple restaurants
  bool get hasMultipleRestaurants => restaurantIds.length > 1;

  /// Calculate total calories for entire cart
  int get totalCalories {
    return items.fold(0, (sum, item) => sum + item.totalCalories);
  }

  /// Calculate estimated total preparation time
  int get estimatedPreparationTime {
    if (items.isEmpty) return 0;

    // Group by restaurant and get max preparation time per restaurant
    final restaurantPreparationTimes = <String, int>{};

    for (final item in items) {
      final currentMax = restaurantPreparationTimes[item.restaurantId] ?? 0;
      final itemTime = item.totalPreparationTime;
      restaurantPreparationTimes[item.restaurantId] = itemTime > currentMax
          ? itemTime
          : currentMax;
    }

    // If multiple restaurants, add extra time for coordination
    final maxTime = restaurantPreparationTimes.values.isEmpty
        ? 0
        : restaurantPreparationTimes.values.reduce((a, b) => a > b ? a : b);

    return hasMultipleRestaurants ? maxTime + 10 : maxTime;
  }

  /// Add item to cart or increase quantity if item already exists
  Cart addItem(CartItem newItem) {
    final existingItemIndex = items.indexWhere(
      (item) =>
          item.menuItemId == newItem.menuItemId &&
          item.restaurantId == newItem.restaurantId,
    );

    List<CartItem> updatedItems;

    if (existingItemIndex != -1) {
      // Item exists, increase quantity
      final existingItem = items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );

      updatedItems = [...items];
      updatedItems[existingItemIndex] = updatedItem;
    } else {
      // New item, add to cart
      updatedItems = [...items, newItem];
    }

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  /// Remove item from cart
  Cart removeItem(String cartItemId) {
    final updatedItems = items.where((item) => item.id != cartItemId).toList();

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  /// Update item quantity
  Cart updateItemQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(cartItemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  /// Clear all items from cart
  Cart clearCart() {
    return copyWith(items: [], updatedAt: DateTime.now());
  }

  /// Clear items from a specific restaurant
  Cart clearRestaurantItems(String restaurantId) {
    final updatedItems = items
        .where((item) => item.restaurantId != restaurantId)
        .toList();

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  /// Create a copy of this cart with updated values
  Cart copyWith({
    String? id,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Map<String, dynamic>? metadata,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    createdAt,
    updatedAt,
    userId,
    metadata,
  ];
}
