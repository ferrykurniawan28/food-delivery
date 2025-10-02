import 'package:equatable/equatable.dart';
import 'menu_category.dart';
import 'menu_item.dart';
import 'operating_hours.dart';
import 'restaurant_contact.dart';
import 'restaurant_location.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> cuisineTypes;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final int deliveryTime;
  final double distance;
  final bool isOpen;
  final bool acceptingOrders;
  final double deliveryFee;
  final double minimumOrder;
  final List<MenuCategory> menuCategories;
  final List<OperatingHours> operatingHours;
  final RestaurantLocation location;
  final RestaurantContact contact;
  final List<String> paymentMethods;
  final List<String> deliveryAreas;
  final Map<String, dynamic>? additionalInfo;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cuisineTypes,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.deliveryTime,
    required this.distance,
    required this.isOpen,
    required this.acceptingOrders,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.menuCategories,
    required this.operatingHours,
    required this.location,
    required this.contact,
    required this.paymentMethods,
    required this.deliveryAreas,
    this.additionalInfo,
  });

  List<MenuItem> get allMenuItems =>
      menuCategories.expand((c) => c.items).toList();

  bool get isCurrentlyOpen {
    if (operatingHours.isEmpty) return isOpen;
    final now = DateTime.now();
    final day = _weekdayName(now.weekday);
    final today = operatingHours.firstWhere(
      (h) => h.dayOfWeek.toLowerCase() == day,
      orElse: () => const OperatingHours(
        dayOfWeek: '',
        openTime: '',
        closeTime: '',
        isClosed: true,
      ),
    );
    if (today.isClosed) return false;
    final current = _fmt(now);
    return current.compareTo(today.openTime) >= 0 &&
        current.compareTo(today.closeTime) <= 0;
  }

  String _weekdayName(int w) => const [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ][(w < 1 || w > 7) ? 0 : w - 1];

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    cuisineTypes,
    rating,
    reviewCount,
    priceRange,
    deliveryTime,
    distance,
    isOpen,
    acceptingOrders,
    deliveryFee,
    minimumOrder,
    menuCategories,
    operatingHours,
    location,
    contact,
    paymentMethods,
    deliveryAreas,
    additionalInfo,
  ];
}
