import 'package:fooddelivery/features/restaurant/domain/entities/menu_category.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/operating_hours.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/restaurant.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/restaurant_contact.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/restaurant_location.dart';

import 'menu_category_model.dart';
import 'operating_hours_model.dart';
import 'restaurant_contact_model.dart';
import 'restaurant_location_model.dart';

/// Model class for Restaurant with JSON serialization
class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.cuisineTypes,
    required super.rating,
    required super.reviewCount,
    required super.priceRange,
    required super.deliveryTime,
    required super.distance,
    required super.isOpen,
    required super.acceptingOrders,
    required super.deliveryFee,
    required super.minimumOrder,
    required super.menuCategories,
    required super.operatingHours,
    required super.location,
    required super.contact,
    required super.paymentMethods,
    required super.deliveryAreas,
    super.additionalInfo,
  });

  /// Create RestaurantModel from Restaurant entity
  factory RestaurantModel.fromEntity(Restaurant entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      cuisineTypes: entity.cuisineTypes,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      priceRange: entity.priceRange,
      deliveryTime: entity.deliveryTime,
      distance: entity.distance,
      isOpen: entity.isOpen,
      acceptingOrders: entity.acceptingOrders,
      deliveryFee: entity.deliveryFee,
      minimumOrder: entity.minimumOrder,
      menuCategories: entity.menuCategories,
      operatingHours: entity.operatingHours,
      location: entity.location,
      contact: entity.contact,
      paymentMethods: entity.paymentMethods,
      deliveryAreas: entity.deliveryAreas,
      additionalInfo: entity.additionalInfo,
    );
  }

  /// Create RestaurantModel from JSON
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      cuisineTypes: List<String>.from(json['cuisineTypes'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      priceRange: json['priceRange'] as String,
      deliveryTime: json['deliveryTime'] as int,
      distance: (json['distance'] as num).toDouble(),
      isOpen: json['isOpen'] as bool,
      acceptingOrders: json['acceptingOrders'] as bool,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      minimumOrder: (json['minimumOrder'] as num).toDouble(),
      menuCategories: (json['menuCategories'] as List)
          .map(
            (category) =>
                MenuCategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList(),
      operatingHours: (json['operatingHours'] as List)
          .map(
            (hours) =>
                OperatingHoursModel.fromJson(hours as Map<String, dynamic>),
          )
          .toList(),
      location: RestaurantLocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      contact: RestaurantContactModel.fromJson(
        json['contact'] as Map<String, dynamic>,
      ),
      paymentMethods: List<String>.from(json['paymentMethods'] as List),
      deliveryAreas: List<String>.from(json['deliveryAreas'] as List),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  /// Convert RestaurantModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'cuisineTypes': cuisineTypes,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'deliveryTime': deliveryTime,
      'distance': distance,
      'isOpen': isOpen,
      'acceptingOrders': acceptingOrders,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'menuCategories': menuCategories
          .map(
            (category) => category is MenuCategoryModel
                ? category.toJson()
                : MenuCategoryModel.fromEntity(category).toJson(),
          )
          .toList(),
      'operatingHours': operatingHours
          .map(
            (hours) => hours is OperatingHoursModel
                ? hours.toJson()
                : OperatingHoursModel.fromEntity(hours).toJson(),
          )
          .toList(),
      'location': location is RestaurantLocationModel
          ? (location as RestaurantLocationModel).toJson()
          : RestaurantLocationModel.fromEntity(location).toJson(),
      'contact': contact is RestaurantContactModel
          ? (contact as RestaurantContactModel).toJson()
          : RestaurantContactModel.fromEntity(contact).toJson(),
      'paymentMethods': paymentMethods,
      'deliveryAreas': deliveryAreas,
      'additionalInfo': additionalInfo,
    };
  }

  /// Create a copy with updated fields
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? cuisineTypes,
    double? rating,
    int? reviewCount,
    String? priceRange,
    int? deliveryTime,
    double? distance,
    bool? isOpen,
    bool? acceptingOrders,
    double? deliveryFee,
    double? minimumOrder,
    List<MenuCategory>? menuCategories,
    List<OperatingHours>? operatingHours,
    RestaurantLocation? location,
    RestaurantContact? contact,
    List<String>? paymentMethods,
    List<String>? deliveryAreas,
    Map<String, dynamic>? additionalInfo,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceRange: priceRange ?? this.priceRange,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      distance: distance ?? this.distance,
      isOpen: isOpen ?? this.isOpen,
      acceptingOrders: acceptingOrders ?? this.acceptingOrders,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      menuCategories: menuCategories ?? this.menuCategories,
      operatingHours: operatingHours ?? this.operatingHours,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      deliveryAreas: deliveryAreas ?? this.deliveryAreas,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
