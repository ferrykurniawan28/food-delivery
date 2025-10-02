import 'package:equatable/equatable.dart';

/// Entity representing restaurant location
class RestaurantLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  const RestaurantLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    address,
    city,
    state,
    zipCode,
    country,
  ];
}
