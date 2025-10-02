import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// Entity representing a menu category
class MenuCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<MenuItem> items;
  final bool isAvailable;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.items,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    items,
    isAvailable,
  ];
}
