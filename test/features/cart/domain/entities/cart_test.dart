import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery/features/cart/domain/entities/cart_item.dart';
import 'package:fooddelivery/features/cart/domain/entities/cart.dart';

void main() {
  group('Cart Entity Tests', () {
    late CartItem testItem1;
    late CartItem testItem2;
    late Cart testCart;

    setUp(() {
      testItem1 = const CartItem(
        id: '1',
        menuItemId: 'menu1',
        name: 'Burger',
        description: 'Delicious burger',
        price: 10.99,
        imageUrl: 'assets/burger.jpg',
        quantity: 2,
        restaurantId: 'rest1',
        restaurantName: 'Burger Palace',
        ingredients: ['beef', 'lettuce', 'tomato'],
        category: 'Main Course',
        isVegetarian: false,
        isVegan: false,
        calories: 550,
        preparationTime: 15,
      );

      testItem2 = const CartItem(
        id: '2',
        menuItemId: 'menu2',
        name: 'Fries',
        description: 'Crispy fries',
        price: 4.99,
        imageUrl: 'assets/fries.jpg',
        quantity: 1,
        restaurantId: 'rest1',
        restaurantName: 'Burger Palace',
        ingredients: ['potato', 'salt'],
        category: 'Sides',
        isVegetarian: true,
        isVegan: true,
        calories: 300,
        preparationTime: 10,
      );

      testCart = Cart(
        id: 'cart1',
        items: [testItem1, testItem2],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('CartItem Tests', () {
      test('should calculate total price correctly', () {
        expect(testItem1.totalPrice, equals(21.98)); // 10.99 * 2
      });

      test('should calculate total calories correctly', () {
        expect(testItem1.totalCalories, equals(1100)); // 550 * 2
      });

      test('should calculate total preparation time correctly', () {
        expect(testItem1.totalPreparationTime, equals(30)); // 15 * 2
      });

      test('should create copy with updated quantity', () {
        final updatedItem = testItem1.copyWith(quantity: 3);
        expect(updatedItem.quantity, equals(3));
        expect(updatedItem.totalPrice, equals(32.97)); // 10.99 * 3
        expect(
          updatedItem.name,
          equals(testItem1.name),
        ); // Other properties unchanged
      });

      test('should maintain equality based on properties', () {
        final identicalItem = testItem1.copyWith();
        expect(testItem1, equals(identicalItem));
      });
    });

    group('Cart Tests', () {
      test('should calculate total item count correctly', () {
        expect(testCart.totalItemCount, equals(3)); // 2 + 1
      });

      test('should calculate subtotal correctly', () {
        expect(testCart.subtotal, equals(26.97)); // 21.98 + 4.99
      });

      test('should calculate tax correctly', () {
        final expectedTax = 26.97 * 0.085; // 8.5% tax
        expect(testCart.tax, closeTo(expectedTax, 0.01));
      });

      test('should calculate delivery fee based on restaurant count', () {
        expect(testCart.deliveryFee, equals(2.99)); // Single restaurant
      });

      test('should calculate total correctly', () {
        final expectedTotal =
            testCart.subtotal +
            testCart.tax +
            testCart.deliveryFee +
            testCart.serviceFee;
        expect(testCart.total, closeTo(expectedTotal, 0.01));
      });

      test('should identify unique restaurants correctly', () {
        expect(testCart.restaurantIds, equals(['rest1']));
        expect(testCart.hasMultipleRestaurants, isFalse);
      });

      test('should add new item to cart', () {
        final newItem = testItem1.copyWith(id: '3', menuItemId: 'menu3');
        final updatedCart = testCart.addItem(newItem);

        expect(updatedCart.items.length, equals(3));
        expect(updatedCart.totalItemCount, equals(5)); // 2 + 1 + 2
      });

      test('should increase quantity when adding existing item', () {
        final existingItem = testItem1.copyWith(
          quantity: 1,
        ); // Same menuItemId, different quantity
        final updatedCart = testCart.addItem(existingItem);

        expect(updatedCart.items.length, equals(2)); // Still 2 items
        expect(updatedCart.items.first.quantity, equals(3)); // 2 + 1
      });

      test('should remove item from cart', () {
        final updatedCart = testCart.removeItem('1');

        expect(updatedCart.items.length, equals(1));
        expect(updatedCart.items.first.id, equals('2'));
      });

      test('should update item quantity', () {
        final updatedCart = testCart.updateItemQuantity('1', 5);

        expect(updatedCart.items.first.quantity, equals(5));
        expect(updatedCart.totalItemCount, equals(6)); // 5 + 1
      });

      test('should remove item when quantity is set to 0', () {
        final updatedCart = testCart.updateItemQuantity('1', 0);

        expect(updatedCart.items.length, equals(1));
        expect(updatedCart.items.first.id, equals('2'));
      });

      test('should clear all items from cart', () {
        final clearedCart = testCart.clearCart();

        expect(clearedCart.items.isEmpty, isTrue);
        expect(clearedCart.totalItemCount, equals(0));
        expect(clearedCart.subtotal, equals(0.0));
      });

      test('should calculate preparation time for multiple restaurants', () {
        final item3 = testItem2.copyWith(
          id: '3',
          restaurantId: 'rest2',
          restaurantName: 'Pizza Place',
          preparationTime: 20,
        );
        final multiRestaurantCart = testCart.addItem(item3);

        expect(multiRestaurantCart.hasMultipleRestaurants, isTrue);
        expect(
          multiRestaurantCart.estimatedPreparationTime,
          equals(40),
        ); // max(15*2, 10, 20) + 10 = max(30, 10, 20) + 10 = 40
      });
    });

    group('Edge Cases', () {
      test('should handle empty cart', () {
        final emptyCart = Cart(
          id: 'empty',
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(emptyCart.isEmpty, isTrue);
        expect(emptyCart.totalItemCount, equals(0));
        expect(emptyCart.subtotal, equals(0.0));
        expect(emptyCart.deliveryFee, equals(0.0));
        expect(emptyCart.estimatedPreparationTime, equals(0));
      });

      test('should handle zero quantity items', () {
        final zeroQuantityItem = testItem1.copyWith(quantity: 0);
        expect(zeroQuantityItem.totalPrice, equals(0.0));
        expect(zeroQuantityItem.totalCalories, equals(0));
      });
    });
  });
}
