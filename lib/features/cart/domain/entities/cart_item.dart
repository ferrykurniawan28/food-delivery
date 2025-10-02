import 'package:equatable/equatable.dart';

/// Represents an item in the shopping cart
class CartItem extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  final String restaurantId;
  final String restaurantName;
  final List<String> ingredients;
  final String category;
  final bool isVegetarian;
  final bool isVegan;
  final int calories;
  final int preparationTime;
  final Map<String, dynamic>? customizations;
  final String? specialInstructions;

  const CartItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
    required this.ingredients,
    required this.category,
    required this.isVegetarian,
    required this.isVegan,
    required this.calories,
    required this.preparationTime,
    this.customizations,
    this.specialInstructions,
  });

  /// Calculate total price for this cart item
  double get totalPrice => price * quantity;

  /// Calculate total calories for this cart item
  int get totalCalories => calories * quantity;

  /// Calculate total preparation time for this cart item
  int get totalPreparationTime => preparationTime * quantity;

  /// Create a copy of this cart item with updated values
  CartItem copyWith({
    String? id,
    String? menuItemId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? quantity,
    String? restaurantId,
    String? restaurantName,
    List<String>? ingredients,
    String? category,
    bool? isVegetarian,
    bool? isVegan,
    int? calories,
    int? preparationTime,
    Map<String, dynamic>? customizations,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      customizations: customizations ?? this.customizations,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [
    id,
    menuItemId,
    name,
    description,
    price,
    imageUrl,
    quantity,
    restaurantId,
    restaurantName,
    ingredients,
    category,
    isVegetarian,
    isVegan,
    calories,
    preparationTime,
    customizations,
    specialInstructions,
  ];
}
