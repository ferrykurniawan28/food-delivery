import '../../domain/entities/cart_item.dart';

/// Data model for CartItem
class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.menuItemId,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.quantity,
    required super.restaurantId,
    required super.restaurantName,
    required super.ingredients,
    required super.category,
    required super.isVegetarian,
    required super.isVegan,
    required super.calories,
    required super.preparationTime,
    super.customizations,
    super.specialInstructions,
  });

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      quantity: json['quantity'] as int,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      category: json['category'] as String,
      isVegetarian: json['isVegetarian'] as bool,
      isVegan: json['isVegan'] as bool,
      calories: json['calories'] as int,
      preparationTime: json['preparationTime'] as int,
      customizations: json['customizations'] as Map<String, dynamic>?,
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'ingredients': ingredients,
      'category': category,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'calories': calories,
      'preparationTime': preparationTime,
      'customizations': customizations,
      'specialInstructions': specialInstructions,
    };
  }

  /// Create CartItemModel from domain entity
  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      menuItemId: entity.menuItemId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      ingredients: entity.ingredients,
      category: entity.category,
      isVegetarian: entity.isVegetarian,
      isVegan: entity.isVegan,
      calories: entity.calories,
      preparationTime: entity.preparationTime,
      customizations: entity.customizations,
      specialInstructions: entity.specialInstructions,
    );
  }

  @override
  CartItemModel copyWith({
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
    return CartItemModel(
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
}
