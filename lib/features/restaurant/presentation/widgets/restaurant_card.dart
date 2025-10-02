import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to.pushNamed('/restaurant/${restaurant.id}');
      },
      child: Container(
        height: 110,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text: '${restaurant.priceRange} ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '• ${restaurant.cuisineTypes.join(', ')}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: '${restaurant.rating} ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextSpan(
                          text: '★',
                          style: TextStyle(color: Colors.yellow[700]),
                        ),
                        TextSpan(
                          text:
                              ' • ${restaurant.deliveryTime} min • ${restaurant.priceRange}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${restaurant.distance.toStringAsFixed(1)} km',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Hero(
              tag: 'restaurant_${restaurant.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  restaurant.imageUrl,
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 110,
                      width: 110,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
