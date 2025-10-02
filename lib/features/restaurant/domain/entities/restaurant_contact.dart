import 'package:equatable/equatable.dart';

/// Entity representing restaurant contact information
class RestaurantContact extends Equatable {
  final String phone;
  final String email;
  final String? website;
  final Map<String, String>?
  socialMedia; // e.g., {'instagram': '@restaurant', 'facebook': 'page'}

  const RestaurantContact({
    required this.phone,
    required this.email,
    this.website,
    this.socialMedia,
  });

  @override
  List<Object?> get props => [phone, email, website, socialMedia];
}
