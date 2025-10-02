import 'package:fooddelivery/features/restaurant/domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.ingredients,
    super.isVegetarian = false,
    super.isVegan = false,
    super.isGlutenFree = false,
    super.isSpicy = false,
    super.isAvailable = true,
    super.preparationTime = 15,
    super.calories = 0.0,
    super.customizations,
  });

  /// Create MenuItemModel from MenuItem entity
  factory MenuItemModel.fromEntity(MenuItem entity) {
    return MenuItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      category: entity.category,
      ingredients: entity.ingredients,
      isVegetarian: entity.isVegetarian,
      isVegan: entity.isVegan,
      isGlutenFree: entity.isGlutenFree,
      isSpicy: entity.isSpicy,
      isAvailable: entity.isAvailable,
      preparationTime: entity.preparationTime,
      calories: entity.calories,
      customizations: entity.customizations,
    );
  }

  /// Create MenuItemModel from JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isSpicy: json['isSpicy'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      preparationTime: json['preparationTime'] as int? ?? 15,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      customizations: json['customizations'] as Map<String, dynamic>?,
    );
  }

  /// Convert MenuItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'isSpicy': isSpicy,
      'isAvailable': isAvailable,
      'preparationTime': preparationTime,
      'calories': calories,
      'customizations': customizations,
    };
  }

  /// Create a copy with updated fields
  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    List<String>? ingredients,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isSpicy,
    bool? isAvailable,
    int? preparationTime,
    double? calories,
    Map<String, dynamic>? customizations,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSpicy: isSpicy ?? this.isSpicy,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTime: preparationTime ?? this.preparationTime,
      calories: calories ?? this.calories,
      customizations: customizations ?? this.customizations,
    );
  }
}
