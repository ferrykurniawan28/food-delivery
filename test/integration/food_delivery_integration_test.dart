import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';
import 'package:fooddelivery/features/cart/domain/entities/entities.dart';
import 'package:fooddelivery/features/order/domain/entities/order.dart';
import 'package:fooddelivery/features/order/data/services/order_storage_service.dart';

void main() {
  group('Food Delivery Integration Tests', () {
    late Restaurant testRestaurant;
    late MenuItem testMenuItem;
    late CartItem testCartItem;
    late Cart testCart;
    late OrderStorageService orderStorageService;

    setUp(() {
      orderStorageService = OrderStorageService();
      orderStorageService.clearAll();

      // Create test restaurant
      testRestaurant = Restaurant(
        id: 'restaurant-1',
        name: 'Pizza Palace',
        description: 'Best pizza in town',
        imageUrl: 'assets/pizza_palace.jpg',
        cuisineTypes: ['Italian', 'Pizza'],
        rating: 4.5,
        reviewCount: 150,
        priceRange: '\$\$',
        deliveryTime: 35,
        distance: 2.1,
        isOpen: true,
        acceptingOrders: true,
        deliveryFee: 4.99,
        minimumOrder: 15.0,
        menuCategories: [],
        operatingHours: [],
        location: RestaurantLocation(
          address: '123 Pizza Street',
          latitude: 40.7128,
          longitude: -74.0060,
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
        ),
        contact: RestaurantContact(
          phone: '555-PIZZA',
          email: 'orders@pizzapalace.com',
        ),
        paymentMethods: ['credit_card', 'debit_card', 'cash'],
        deliveryAreas: ['downtown', 'midtown'],
      );

      // Create test menu item
      testMenuItem = MenuItem(
        id: 'item-1',
        name: 'Margherita Pizza',
        description: 'Fresh tomatoes, mozzarella, and basil',
        price: 18.99,
        imageUrl: 'assets/margherita.jpg',
        category: 'Pizza',
        ingredients: ['tomato sauce', 'mozzarella cheese', 'fresh basil'],
        isVegetarian: true,
        isVegan: false,
        isGlutenFree: false,
        isSpicy: false,
        isAvailable: true,
        preparationTime: 20,
        calories: 280.0,
      );

      // Create test cart item
      testCartItem = CartItem(
        id: 'cart-item-1',
        menuItemId: testMenuItem.id,
        name: testMenuItem.name,
        description: testMenuItem.description,
        price: testMenuItem.price,
        imageUrl: testMenuItem.imageUrl,
        quantity: 2,
        restaurantId: testRestaurant.id,
        restaurantName: testRestaurant.name,
        ingredients: testMenuItem.ingredients,
        category: testMenuItem.category,
        isVegetarian: testMenuItem.isVegetarian,
        isVegan: testMenuItem.isVegan,
        calories: testMenuItem.calories.toInt(),
        preparationTime: testMenuItem.preparationTime,
      );

      // Create test cart
      testCart = Cart(
        id: 'cart-1',
        items: [testCartItem],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('Complete User Journey', () {
      test(
        'should complete full workflow: browse restaurant → add to cart → place order',
        () async {
          // Step 1: User browses restaurants and finds a restaurant
          expect(testRestaurant.isOpen, isTrue);
          expect(testRestaurant.acceptingOrders, isTrue);
          expect(testRestaurant.rating, greaterThan(4.0));

          // Step 2: User views restaurant menu and selects items
          expect(testMenuItem.isAvailable, isTrue);
          expect(testMenuItem.price, greaterThan(0));

          // Step 3: User adds items to cart
          expect(testCart.items.length, equals(1));
          expect(testCart.items.first.quantity, equals(2));
          expect(testCart.subtotal, equals(37.98)); // 18.99 * 2

          // Step 4: User reviews cart before checkout
          expect(testCart.totalItemCount, equals(2));
          expect(testCart.subtotal, greaterThan(testRestaurant.minimumOrder));

          // Step 5: User places order
          final order = Order(
            id: 'order-1',
            cart: testCart,
            restaurant: testRestaurant,
            status: OrderStatus.placed,
            placedAt: DateTime.now(),
            totalAmount: testCart.total,
            deliveryAddress: '456 Customer Street, New York, NY 10002',
          );

          // Simulate order placement
          orderStorageService.addOrder(order);

          // Verify order was placed successfully
          final placedOrder = orderStorageService.getOrder(order.id);
          expect(placedOrder, isNotNull);
          expect(placedOrder?.status, equals(OrderStatus.placed));
          expect(placedOrder?.cart.items.length, equals(1));
          expect(placedOrder?.restaurant.id, equals(testRestaurant.id));

          // Step 6: Order status updates (restaurant confirms)
          final confirmedOrder = placedOrder!.copyWith(
            status: OrderStatus.confirmed,
            estimatedDeliveryTime: DateTime.now().add(
              Duration(minutes: testRestaurant.deliveryTime),
            ),
          );
          orderStorageService.updateOrder(confirmedOrder);

          final updatedOrder = orderStorageService.getOrder(order.id);
          expect(updatedOrder?.status, equals(OrderStatus.confirmed));
          expect(updatedOrder?.estimatedDeliveryTime, isNotNull);
        },
      );

      test('should handle multiple items from same restaurant', () async {
        // Create second menu item
        final secondMenuItem = MenuItem(
          id: 'item-2',
          name: 'Pepperoni Pizza',
          description: 'Classic pepperoni with mozzarella',
          price: 21.99,
          imageUrl: 'assets/pepperoni.jpg',
          category: 'Pizza',
          ingredients: ['tomato sauce', 'mozzarella cheese', 'pepperoni'],
          isVegetarian: false,
          preparationTime: 25,
          calories: 320.0,
        );

        final secondCartItem = CartItem(
          id: 'cart-item-2',
          menuItemId: secondMenuItem.id,
          name: secondMenuItem.name,
          description: secondMenuItem.description,
          price: secondMenuItem.price,
          imageUrl: secondMenuItem.imageUrl,
          quantity: 1,
          restaurantId: testRestaurant.id,
          restaurantName: testRestaurant.name,
          ingredients: secondMenuItem.ingredients,
          category: secondMenuItem.category,
          isVegetarian: secondMenuItem.isVegetarian,
          isVegan: secondMenuItem.isVegan,
          calories: secondMenuItem.calories.toInt(),
          preparationTime: secondMenuItem.preparationTime,
        );

        // Add second item to cart
        final updatedCart = testCart.addItem(secondCartItem);

        expect(updatedCart.items.length, equals(2));
        expect(updatedCart.totalItemCount, equals(3)); // 2 + 1
        expect(updatedCart.subtotal, equals(59.97)); // 37.98 + 21.99

        // Verify all items are from same restaurant
        expect(updatedCart.restaurantIds.length, equals(1));
        expect(updatedCart.hasMultipleRestaurants, isFalse);
      });

      test('should calculate proper order timing and preparation', () async {
        // Test order timing calculations
        // testCart has 2 items with 20 minutes prep time each = 40 minutes total
        expect(
          testCart.estimatedPreparationTime,
          equals(40),
        ); // 20 * 2 quantity

        // Create cart with single item
        final singleItemCart = Cart(
          id: 'single-cart',
          items: [testCartItem.copyWith(quantity: 1)],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(
          singleItemCart.estimatedPreparationTime,
          equals(20),
        ); // 20 * 1 quantity

        // Create cart with multiple items (different menu items)
        final secondCartItem = CartItem(
          id: 'cart-item-2',
          menuItemId: 'menu-item-2', // Different menu item ID
          name: 'Pepperoni Pizza',
          description: 'Delicious pepperoni pizza',
          price: 21.99,
          imageUrl: 'assets/pepperoni.jpg',
          quantity: 1,
          restaurantId: testRestaurant.id,
          restaurantName: testRestaurant.name,
          ingredients: ['tomato sauce', 'mozzarella', 'pepperoni'],
          category: 'Pizza',
          isVegetarian: false,
          isVegan: false,
          calories: 320,
          preparationTime: 30,
        );
        final multiItemCart = singleItemCart.addItem(secondCartItem);

        // Since both items are from same restaurant, should take max of individual total prep times
        // First item: 20 * 1 = 20 minutes, Second item: 30 * 1 = 30 minutes
        // Max should be 30 minutes
        expect(multiItemCart.estimatedPreparationTime, equals(30));
        expect(
          multiItemCart.items.length,
          equals(2),
        ); // Verify it's actually two different items

        // Test delivery time calculation with order
        final totalTime =
            testRestaurant.deliveryTime + testCart.estimatedPreparationTime;
        expect(totalTime, equals(75)); // 35 delivery + 40 preparation
      });

      test('should handle order status progression', () async {
        final order = Order(
          id: 'order-status-test',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: DateTime.now(),
          totalAmount: testCart.total,
          deliveryAddress: 'Test Address',
        );

        orderStorageService.addOrder(order);

        // Test status progression: placed → confirmed → preparing → delivered
        final statuses = [
          OrderStatus.confirmed,
          OrderStatus.preparing,
          OrderStatus.driverAssigned,
          OrderStatus.pickedUp,
          OrderStatus.enRoute,
          OrderStatus.delivered,
        ];

        Order currentOrder = order;
        for (final status in statuses) {
          currentOrder = currentOrder.copyWith(status: status);
          orderStorageService.updateOrder(currentOrder);

          final updatedOrder = orderStorageService.getOrder(order.id);
          expect(updatedOrder?.status, equals(status));
        }

        // Verify final state
        final finalOrder = orderStorageService.getOrder(order.id);
        expect(finalOrder?.status, equals(OrderStatus.delivered));
        expect(finalOrder?.isActiveOrder, isFalse);
      });
    });

    group('Error Handling and Edge Cases', () {
      test('should handle minimum order requirements', () async {
        // Create cart below minimum order
        final smallCartItem = testCartItem.copyWith(quantity: 1, price: 5.99);
        final smallCart = Cart(
          id: 'small-cart',
          items: [smallCartItem],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(smallCart.subtotal, lessThan(testRestaurant.minimumOrder));

        // User should not be able to proceed to checkout
        final meetsMinimum = smallCart.subtotal >= testRestaurant.minimumOrder;
        expect(meetsMinimum, isFalse);
      });

      test('should handle cart operations correctly', () async {
        // Test adding item
        expect(testCart.items.length, equals(1));

        // Test updating quantity
        final updatedCart = testCart.updateItemQuantity(testCartItem.id, 3);
        expect(updatedCart.items.first.quantity, equals(3));
        expect(updatedCart.subtotal, equals(56.97)); // 18.99 * 3

        // Test removing item (quantity to 0)
        final emptyCart = updatedCart.updateItemQuantity(testCartItem.id, 0);
        expect(emptyCart.items.length, equals(0));
        expect(emptyCart.isEmpty, isTrue);

        // Test clearing cart
        final clearedCart = testCart.clearCart();
        expect(clearedCart.items.length, equals(0));
        expect(clearedCart.isEmpty, isTrue);
      });

      test('should handle restaurant availability', () async {
        // Test restaurant properties
        expect(testRestaurant.isOpen, isTrue);
        expect(testRestaurant.acceptingOrders, isTrue);

        // Test menu item availability
        expect(testMenuItem.isAvailable, isTrue);

        // Simulate checking restaurant status before ordering
        final canOrder =
            testRestaurant.isOpen &&
            testRestaurant.acceptingOrders &&
            testMenuItem.isAvailable;
        expect(canOrder, isTrue);
      });

      test('should handle order cancellation', () async {
        final order = Order(
          id: 'cancellation-test',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.confirmed,
          placedAt: DateTime.now(),
          totalAmount: testCart.total,
          deliveryAddress: 'Test Address',
        );

        orderStorageService.addOrder(order);

        // Cancel order
        final cancelledOrder = order.copyWith(status: OrderStatus.cancelled);
        orderStorageService.updateOrder(cancelledOrder);

        final updatedOrder = orderStorageService.getOrder(order.id);
        expect(updatedOrder?.status, equals(OrderStatus.cancelled));
        expect(updatedOrder?.isActiveOrder, isFalse);
      });
    });

    group('Data Consistency and Storage', () {
      test('should maintain data consistency across operations', () async {
        // Create multiple orders
        final order1 = Order(
          id: 'order-1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.delivered,
          placedAt: DateTime.now().subtract(Duration(days: 1)),
          totalAmount: testCart.total,
          deliveryAddress: 'Address 1',
        );

        final order2 = Order(
          id: 'order-2',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.confirmed,
          placedAt: DateTime.now(),
          totalAmount: testCart.total,
          deliveryAddress: 'Address 2',
        );

        orderStorageService.addOrder(order1);
        orderStorageService.addOrder(order2);

        // Test active orders
        final activeOrders = orderStorageService.getActiveOrders();
        expect(activeOrders.length, equals(1));
        expect(activeOrders.first.id, equals('order-2'));

        // Test order history
        final orderHistory = orderStorageService.getOrderHistory();
        expect(orderHistory.length, equals(1));
        expect(orderHistory.first.id, equals('order-1'));

        // Test all orders
        expect(orderStorageService.orders.length, equals(2));
      });

      test('should handle storage operations correctly', () async {
        // Test adding orders
        expect(orderStorageService.orders.length, equals(0));

        final order = Order(
          id: 'storage-test',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: DateTime.now(),
          totalAmount: testCart.total,
          deliveryAddress: 'Test Address',
        );

        orderStorageService.addOrder(order);
        expect(orderStorageService.orders.length, equals(1));

        // Test getting specific order
        final retrievedOrder = orderStorageService.getOrder(order.id);
        expect(retrievedOrder, isNotNull);
        expect(retrievedOrder?.id, equals(order.id));

        // Test removing order
        orderStorageService.removeOrder(order.id);
        expect(orderStorageService.orders.length, equals(0));

        // Test clearing all orders
        orderStorageService.addOrder(order);
        expect(orderStorageService.orders.length, equals(1));
        orderStorageService.clearAll();
        expect(orderStorageService.orders.length, equals(0));
      });
    });
  });
}
