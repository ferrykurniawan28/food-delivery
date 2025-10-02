import '../../domain/entities/entities.dart';

/// Model class for RestaurantLocation with JSON serialization
class RestaurantLocationModel extends RestaurantLocation {
  const RestaurantLocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.country,
  });

  /// Create RestaurantLocationModel from RestaurantLocation entity
  factory RestaurantLocationModel.fromEntity(RestaurantLocation entity) {
    return RestaurantLocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      country: entity.country,
    );
  }

  /// Create RestaurantLocationModel from JSON
  factory RestaurantLocationModel.fromJson(Map<String, dynamic> json) {
    return RestaurantLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
    );
  }

  /// Convert RestaurantLocationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  /// Create a copy with updated fields
  RestaurantLocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return RestaurantLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }
}
