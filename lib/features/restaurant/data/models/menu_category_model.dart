import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

import 'menu_item_model.dart';

/// Model class for MenuCategory with JSON serialization
class MenuCategoryModel extends MenuCategory {
  const MenuCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.items,
    super.isAvailable = true,
  });

  /// Create MenuCategoryModel from MenuCategory entity
  factory MenuCategoryModel.fromEntity(MenuCategory entity) {
    return MenuCategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      items: entity.items,
      isAvailable: entity.isAvailable,
    );
  }

  /// Create MenuCategoryModel from JSON
  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      items: (json['items'] as List)
          .map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  /// Convert MenuCategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'items': items
          .map(
            (item) => item is MenuItemModel
                ? item.toJson()
                : MenuItemModel.fromEntity(item).toJson(),
          )
          .toList(),
      'isAvailable': isAvailable,
    };
  }

  /// Create a copy with updated fields
  MenuCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<MenuItem>? items,
    bool? isAvailable,
  }) {
    return MenuCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      items: items ?? this.items,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
