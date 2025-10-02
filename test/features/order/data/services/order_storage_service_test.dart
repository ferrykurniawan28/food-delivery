import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery/features/order/data/services/order_storage_service.dart';
import 'package:fooddelivery/features/order/domain/entities/order.dart';
import 'package:fooddelivery/features/cart/domain/entities/entities.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

void main() {
  group('OrderStorageService Tests', () {
    late OrderStorageService orderStorageService;
    late Order testOrder1;
    late Order testOrder2;
    late Order testOrder3;

    setUp(() {
      orderStorageService = OrderStorageService();
      // Clear all orders before each test
      orderStorageService.clearAll();

      // Create test data
      final testPlacedAt = DateTime(2025, 10, 2, 12, 0);
      final testEstimatedDelivery = DateTime(2025, 10, 2, 12, 30);

      const testCartItem = CartItem(
        id: 'cart_item_1',
        menuItemId: 'menu_1',
        name: 'Test Pizza',
        description: 'A test pizza',
        price: 12.99,
        imageUrl: 'https://test.com/pizza.jpg',
        quantity: 2,
        restaurantId: 'restaurant_1',
        restaurantName: 'Test Restaurant',
        ingredients: ['Cheese', 'Tomato'],
        category: 'Pizza',
        isVegetarian: true,
        isVegan: false,
        calories: 250,
        preparationTime: 15,
      );

      final testCart = Cart(
        id: 'cart_1',
        items: const [testCartItem],
        createdAt: testPlacedAt,
        updatedAt: testPlacedAt,
      );

      const testRestaurant = Restaurant(
        id: 'restaurant_1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://test.com/restaurant.jpg',
        cuisineTypes: ['Italian'],
        rating: 4.5,
        reviewCount: 100,
        priceRange: '\$\$',
        deliveryTime: 30,
        distance: 2.5,
        isOpen: true,
        acceptingOrders: true,
        deliveryFee: 2.99,
        minimumOrder: 15.0,
        menuCategories: [],
        operatingHours: [],
        location: RestaurantLocation(
          address: '123 Test St',
          city: 'Test City',
          state: 'TS',
          zipCode: '12345',
          country: 'USA',
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        contact: RestaurantContact(
          phone: '+1234567890',
          email: 'test@restaurant.com',
          website: 'https://test-restaurant.com',
        ),
        paymentMethods: ['Credit Card'],
        deliveryAreas: ['Downtown'],
        additionalInfo: {},
      );

      // Create test orders with different statuses
      testOrder1 = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        estimatedDeliveryTime: testEstimatedDelivery,
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
        isPaid: true,
      );

      testOrder2 = Order(
        id: 'order_2',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.delivered,
        placedAt: testPlacedAt.subtract(const Duration(hours: 2)),
        totalAmount: 25.99,
        deliveryAddress: '789 Another St',
        isPaid: true,
      );

      testOrder3 = Order(
        id: 'order_3',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.preparing,
        placedAt: testPlacedAt.subtract(const Duration(minutes: 30)),
        totalAmount: 18.50,
        deliveryAddress: '321 Third St',
        isPaid: true,
      );
    });

    test('should be a singleton', () {
      final service1 = OrderStorageService();
      final service2 = OrderStorageService();

      expect(service1, same(service2));
    });

    test('should start with empty orders', () {
      expect(orderStorageService.orders, isEmpty);
    });

    group('addOrder', () {
      test('should add order to storage', () {
        orderStorageService.addOrder(testOrder1);

        expect(orderStorageService.orders, hasLength(1));
        expect(orderStorageService.orders.containsKey('order_1'), isTrue);
        expect(orderStorageService.orders['order_1'], equals(testOrder1));
      });

      test('should replace existing order with same id', () {
        orderStorageService.addOrder(testOrder1);

        final updatedOrder = testOrder1.copyWith(status: OrderStatus.confirmed);
        orderStorageService.addOrder(updatedOrder);

        expect(orderStorageService.orders, hasLength(1));
        expect(
          orderStorageService.orders['order_1']?.status,
          equals(OrderStatus.confirmed),
        );
      });

      test('should add multiple orders', () {
        orderStorageService.addOrder(testOrder1);
        orderStorageService.addOrder(testOrder2);
        orderStorageService.addOrder(testOrder3);

        expect(orderStorageService.orders, hasLength(3));
        expect(orderStorageService.orders.containsKey('order_1'), isTrue);
        expect(orderStorageService.orders.containsKey('order_2'), isTrue);
        expect(orderStorageService.orders.containsKey('order_3'), isTrue);
      });
    });

    group('getOrder', () {
      test('should return order when it exists', () {
        orderStorageService.addOrder(testOrder1);

        final retrievedOrder = orderStorageService.getOrder('order_1');

        expect(retrievedOrder, isNotNull);
        expect(retrievedOrder, equals(testOrder1));
      });

      test('should return null when order does not exist', () {
        final retrievedOrder = orderStorageService.getOrder(
          'nonexistent_order',
        );

        expect(retrievedOrder, isNull);
      });
    });

    group('getActiveOrders', () {
      test('should return only active orders', () {
        orderStorageService.addOrder(testOrder1); // placed (active)
        orderStorageService.addOrder(testOrder2); // delivered (inactive)
        orderStorageService.addOrder(testOrder3); // preparing (active)

        final activeOrders = orderStorageService.getActiveOrders();

        expect(activeOrders, hasLength(2));
        expect(
          activeOrders.map((o) => o.id),
          containsAll(['order_1', 'order_3']),
        );
        expect(activeOrders.any((o) => o.id == 'order_2'), isFalse);
      });

      test('should return empty list when no active orders', () {
        orderStorageService.addOrder(testOrder2); // delivered (inactive)

        final activeOrders = orderStorageService.getActiveOrders();

        expect(activeOrders, isEmpty);
      });

      test(
        'should sort active orders by placedAt descending (newest first)',
        () {
          orderStorageService.addOrder(testOrder1); // placed now
          orderStorageService.addOrder(testOrder3); // placed 30 min ago

          final activeOrders = orderStorageService.getActiveOrders();

          expect(activeOrders, hasLength(2));
          expect(activeOrders[0].id, equals('order_1')); // newest first
          expect(activeOrders[1].id, equals('order_3')); // older second
        },
      );
    });

    group('getOrderHistory', () {
      test('should return only completed orders', () {
        orderStorageService.addOrder(testOrder1); // placed (active)
        orderStorageService.addOrder(testOrder2); // delivered (inactive)

        final cancelledOrder = testOrder3.copyWith(
          status: OrderStatus.cancelled,
        );
        orderStorageService.addOrder(cancelledOrder); // cancelled (inactive)

        final orderHistory = orderStorageService.getOrderHistory();

        expect(orderHistory, hasLength(2));
        expect(
          orderHistory.map((o) => o.id),
          containsAll(['order_2', 'order_3']),
        );
        expect(orderHistory.any((o) => o.id == 'order_1'), isFalse);
      });

      test('should return empty list when no completed orders', () {
        orderStorageService.addOrder(testOrder1); // placed (active)
        orderStorageService.addOrder(testOrder3); // preparing (active)

        final orderHistory = orderStorageService.getOrderHistory();

        expect(orderHistory, isEmpty);
      });

      test(
        'should sort order history by placedAt descending (newest first)',
        () {
          final deliveredOrder1 = testOrder1.copyWith(
            status: OrderStatus.delivered,
          );
          final deliveredOrder2 = testOrder3.copyWith(
            status: OrderStatus.delivered,
          );

          orderStorageService.addOrder(deliveredOrder2); // placed 30 min ago
          orderStorageService.addOrder(deliveredOrder1); // placed now

          final orderHistory = orderStorageService.getOrderHistory();

          expect(orderHistory, hasLength(2));
          expect(orderHistory[0].id, equals('order_1')); // newest first
          expect(orderHistory[1].id, equals('order_3')); // older second
        },
      );
    });

    group('updateOrder', () {
      test('should update existing order', () {
        orderStorageService.addOrder(testOrder1);

        final updatedOrder = testOrder1.copyWith(
          status: OrderStatus.confirmed,
          driverName: 'John Driver',
        );
        orderStorageService.updateOrder(updatedOrder);

        final retrievedOrder = orderStorageService.getOrder('order_1');
        expect(retrievedOrder?.status, equals(OrderStatus.confirmed));
        expect(retrievedOrder?.driverName, equals('John Driver'));
      });

      test('should add order if it does not exist', () {
        orderStorageService.updateOrder(testOrder1);

        expect(orderStorageService.orders, hasLength(1));
        expect(orderStorageService.orders.containsKey('order_1'), isTrue);
      });
    });

    group('removeOrder', () {
      test('should remove existing order', () {
        orderStorageService.addOrder(testOrder1);
        orderStorageService.addOrder(testOrder2);

        expect(orderStorageService.orders, hasLength(2));

        orderStorageService.removeOrder('order_1');

        expect(orderStorageService.orders, hasLength(1));
        expect(orderStorageService.orders.containsKey('order_1'), isFalse);
        expect(orderStorageService.orders.containsKey('order_2'), isTrue);
      });

      test('should do nothing when order does not exist', () {
        orderStorageService.addOrder(testOrder1);

        expect(orderStorageService.orders, hasLength(1));

        orderStorageService.removeOrder('nonexistent_order');

        expect(orderStorageService.orders, hasLength(1));
      });
    });

    group('clearAll', () {
      test('should remove all orders', () {
        orderStorageService.addOrder(testOrder1);
        orderStorageService.addOrder(testOrder2);
        orderStorageService.addOrder(testOrder3);

        expect(orderStorageService.orders, hasLength(3));

        orderStorageService.clearAll();

        expect(orderStorageService.orders, isEmpty);
      });

      test('should do nothing when already empty', () {
        expect(orderStorageService.orders, isEmpty);

        orderStorageService.clearAll();

        expect(orderStorageService.orders, isEmpty);
      });
    });

    group('orders getter', () {
      test('should return unmodifiable map', () {
        orderStorageService.addOrder(testOrder1);

        final ordersMap = orderStorageService.orders;

        expect(() => ordersMap['order_2'] = testOrder2, throwsUnsupportedError);
      });

      test('should reflect current state of storage', () {
        expect(orderStorageService.orders, isEmpty);

        orderStorageService.addOrder(testOrder1);
        expect(orderStorageService.orders, hasLength(1));

        orderStorageService.addOrder(testOrder2);
        expect(orderStorageService.orders, hasLength(2));

        orderStorageService.removeOrder('order_1');
        expect(orderStorageService.orders, hasLength(1));
      });
    });

    group('integration scenarios', () {
      test('should handle complete order lifecycle', () {
        // Start with active order
        orderStorageService.addOrder(testOrder1);

        expect(orderStorageService.getActiveOrders(), hasLength(1));
        expect(orderStorageService.getOrderHistory(), isEmpty);

        // Update order status to delivered
        final deliveredOrder = testOrder1.copyWith(
          status: OrderStatus.delivered,
        );
        orderStorageService.updateOrder(deliveredOrder);

        expect(orderStorageService.getActiveOrders(), isEmpty);
        expect(orderStorageService.getOrderHistory(), hasLength(1));
      });

      test('should handle multiple orders across different statuses', () {
        // Add mix of active and completed orders
        orderStorageService.addOrder(testOrder1); // placed (active)
        orderStorageService.addOrder(testOrder2); // delivered (completed)
        orderStorageService.addOrder(testOrder3); // preparing (active)

        final cancelledOrder = testOrder1.copyWith(
          id: 'order_4',
          status: OrderStatus.cancelled,
        );
        orderStorageService.addOrder(cancelledOrder); // cancelled (completed)

        expect(orderStorageService.orders, hasLength(4));
        expect(orderStorageService.getActiveOrders(), hasLength(2));
        expect(orderStorageService.getOrderHistory(), hasLength(2));

        // Update active order to completed
        final confirmedOrder = testOrder3.copyWith(
          status: OrderStatus.delivered,
        );
        orderStorageService.updateOrder(confirmedOrder);

        expect(orderStorageService.getActiveOrders(), hasLength(1));
        expect(orderStorageService.getOrderHistory(), hasLength(3));
      });
    });
  });
}
