import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_model.dart';

/// Data model for Cart
class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
    super.userId,
    super.metadata,
  });

  /// Create CartModel from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'metadata': metadata,
    };
  }

  /// Create CartModel from domain entity
  factory CartModel.fromEntity(Cart entity) {
    return CartModel(
      id: entity.id,
      items: entity.items
          .map((item) => CartItemModel.fromEntity(item))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
      metadata: entity.metadata,
    );
  }

  /// Create empty CartModel
  factory CartModel.empty() {
    final now = DateTime.now();
    return CartModel(
      id: 'cart_${now.millisecondsSinceEpoch}',
      items: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  CartModel copyWith({
    String? id,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Map<String, dynamic>? metadata,
  }) {
    return CartModel(
      id: id ?? this.id,
      items:
          items
              ?.map(
                (item) => item is CartItemModel
                    ? item
                    : CartItemModel.fromEntity(item),
              )
              .toList() ??
          this.items.map((item) => item as CartItemModel).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      metadata: metadata ?? this.metadata,
    );
  }
}
