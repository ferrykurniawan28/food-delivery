import 'package:equatable/equatable.dart';

/// Entity representing a menu item in a restaurant
class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final bool isAvailable;
  final int preparationTime; // in minutes
  final double calories;
  final Map<String, dynamic>? customizations; // e.g., size options, add-ons

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.ingredients,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isSpicy = false,
    this.isAvailable = true,
    this.preparationTime = 15,
    this.calories = 0.0,
    this.customizations,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    ingredients,
    isVegetarian,
    isVegan,
    isGlutenFree,
    isSpicy,
    isAvailable,
    preparationTime,
    calories,
    customizations,
  ];
}
