import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

/// Model class for RestaurantContact with JSON serialization
class RestaurantContactModel extends RestaurantContact {
  const RestaurantContactModel({
    required super.phone,
    required super.email,
    super.website,
    super.socialMedia,
  });

  /// Create RestaurantContactModel from RestaurantContact entity
  factory RestaurantContactModel.fromEntity(RestaurantContact entity) {
    return RestaurantContactModel(
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
      socialMedia: entity.socialMedia,
    );
  }

  /// Create RestaurantContactModel from JSON
  factory RestaurantContactModel.fromJson(Map<String, dynamic> json) {
    return RestaurantContactModel(
      phone: json['phone'] as String,
      email: json['email'] as String,
      website: json['website'] as String?,
      socialMedia: json['socialMedia'] != null
          ? Map<String, String>.from(json['socialMedia'] as Map)
          : null,
    );
  }

  /// Convert RestaurantContactModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
      'socialMedia': socialMedia,
    };
  }

  /// Create a copy with updated fields
  RestaurantContactModel copyWith({
    String? phone,
    String? email,
    String? website,
    Map<String, String>? socialMedia,
  }) {
    return RestaurantContactModel(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }
}
