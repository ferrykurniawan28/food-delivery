import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery/features/order/domain/entities/order.dart';
import 'package:fooddelivery/features/cart/domain/entities/entities.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

void main() {
  group('Order Entity Tests', () {
    late Cart testCart;
    late Restaurant testRestaurant;
    late DateTime testPlacedAt;
    late DateTime testEstimatedDelivery;

    setUp(() {
      testPlacedAt = DateTime(2025, 10, 2, 12, 0);
      testEstimatedDelivery = DateTime(2025, 10, 2, 12, 30);

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

      testCart = Cart(
        id: 'cart_1',
        items: const [testCartItem],
        createdAt: testPlacedAt,
        updatedAt: testPlacedAt,
      );

      testRestaurant = const Restaurant(
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
    });

    test('Order should be equal when all properties are the same', () {
      final order1 = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        estimatedDeliveryTime: testEstimatedDelivery,
        driverName: 'John Driver',
        driverPhone: '+1234567890',
        trackingCode: 'TRACK123',
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
        statusHistory: const [],
        specialInstructions: 'Ring the bell',
        isPaid: true,
      );

      final order2 = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        estimatedDeliveryTime: testEstimatedDelivery,
        driverName: 'John Driver',
        driverPhone: '+1234567890',
        trackingCode: 'TRACK123',
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
        statusHistory: const [],
        specialInstructions: 'Ring the bell',
        isPaid: true,
      );

      expect(order1, equals(order2));
      expect(order1.hashCode, equals(order2.hashCode));
    });

    test('Order should not be equal when properties differ', () {
      final order1 = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
      );

      final order2 = Order(
        id: 'order_2',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.confirmed,
        placedAt: testPlacedAt,
        totalAmount: 25.00,
        deliveryAddress: '789 Different St',
      );

      expect(order1, isNot(equals(order2)));
      expect(order1.hashCode, isNot(equals(order2.hashCode)));
    });

    test('Order should have correct default values', () {
      final order = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
      );

      expect(order.estimatedDeliveryTime, isNull);
      expect(order.driverName, isNull);
      expect(order.driverPhone, isNull);
      expect(order.trackingCode, isNull);
      expect(order.statusHistory, isEmpty);
      expect(order.specialInstructions, isNull);
      expect(order.isPaid, isFalse);
    });

    test('Order copyWith should create new instance with updated values', () {
      final originalOrder = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.placed,
        placedAt: testPlacedAt,
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
        isPaid: false,
      );

      final updatedOrder = originalOrder.copyWith(
        status: OrderStatus.confirmed,
        driverName: 'Jane Driver',
        isPaid: true,
      );

      expect(updatedOrder.id, equals(originalOrder.id));
      expect(updatedOrder.cart, equals(originalOrder.cart));
      expect(updatedOrder.restaurant, equals(originalOrder.restaurant));
      expect(updatedOrder.status, equals(OrderStatus.confirmed));
      expect(updatedOrder.driverName, equals('Jane Driver'));
      expect(updatedOrder.isPaid, isTrue);
      expect(
        updatedOrder.deliveryAddress,
        equals(originalOrder.deliveryAddress),
      );
    });

    group('statusDisplayText getter', () {
      test('should return correct display text for each status', () {
        final baseOrder = Order(
          id: 'order_1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: testPlacedAt,
          totalAmount: 31.57,
          deliveryAddress: '456 Delivery St',
        );

        expect(
          baseOrder.copyWith(status: OrderStatus.placed).statusDisplayText,
          equals('Order Placed'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.confirmed).statusDisplayText,
          equals('Order Confirmed'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.preparing).statusDisplayText,
          equals('Preparing Your Food'),
        );
        expect(
          baseOrder
              .copyWith(status: OrderStatus.driverAssigned)
              .statusDisplayText,
          equals('Driver Assigned'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.pickedUp).statusDisplayText,
          equals('Order Picked Up'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.enRoute).statusDisplayText,
          equals('On the Way'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.delivered).statusDisplayText,
          equals('Delivered'),
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.cancelled).statusDisplayText,
          equals('Cancelled'),
        );
      });
    });

    group('estimatedMinutesRemaining getter', () {
      test('should return 0 when estimatedDeliveryTime is null', () {
        final order = Order(
          id: 'order_1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: testPlacedAt,
          totalAmount: 31.57,
          deliveryAddress: '456 Delivery St',
        );

        expect(order.estimatedMinutesRemaining, equals(0));
      });

      test('should return 0 when estimated delivery time has passed', () {
        final pastTime = DateTime.now().subtract(const Duration(minutes: 30));
        final order = Order(
          id: 'order_1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: testPlacedAt,
          estimatedDeliveryTime: pastTime,
          totalAmount: 31.57,
          deliveryAddress: '456 Delivery St',
        );

        expect(order.estimatedMinutesRemaining, equals(0));
      });

      test(
        'should return correct minutes remaining for future delivery time',
        () {
          final futureTime = DateTime.now().add(const Duration(minutes: 25));
          final order = Order(
            id: 'order_1',
            cart: testCart,
            restaurant: testRestaurant,
            status: OrderStatus.placed,
            placedAt: testPlacedAt,
            estimatedDeliveryTime: futureTime,
            totalAmount: 31.57,
            deliveryAddress: '456 Delivery St',
          );

          // Allow for some variance due to test execution time
          expect(order.estimatedMinutesRemaining, greaterThanOrEqualTo(24));
          expect(order.estimatedMinutesRemaining, lessThanOrEqualTo(26));
        },
      );
    });

    group('isActiveOrder getter', () {
      test('should return true for active order statuses', () {
        final baseOrder = Order(
          id: 'order_1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: testPlacedAt,
          totalAmount: 31.57,
          deliveryAddress: '456 Delivery St',
        );

        expect(
          baseOrder.copyWith(status: OrderStatus.placed).isActiveOrder,
          isTrue,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.confirmed).isActiveOrder,
          isTrue,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.preparing).isActiveOrder,
          isTrue,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.driverAssigned).isActiveOrder,
          isTrue,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.pickedUp).isActiveOrder,
          isTrue,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.enRoute).isActiveOrder,
          isTrue,
        );
      });

      test('should return false for completed order statuses', () {
        final baseOrder = Order(
          id: 'order_1',
          cart: testCart,
          restaurant: testRestaurant,
          status: OrderStatus.placed,
          placedAt: testPlacedAt,
          totalAmount: 31.57,
          deliveryAddress: '456 Delivery St',
        );

        expect(
          baseOrder.copyWith(status: OrderStatus.delivered).isActiveOrder,
          isFalse,
        );
        expect(
          baseOrder.copyWith(status: OrderStatus.cancelled).isActiveOrder,
          isFalse,
        );
      });
    });

    test('Order should have correct property values', () {
      final order = Order(
        id: 'order_1',
        cart: testCart,
        restaurant: testRestaurant,
        status: OrderStatus.confirmed,
        placedAt: testPlacedAt,
        estimatedDeliveryTime: testEstimatedDelivery,
        driverName: 'John Driver',
        driverPhone: '+1234567890',
        trackingCode: 'TRACK123',
        totalAmount: 31.57,
        deliveryAddress: '456 Delivery St',
        specialInstructions: 'Ring the bell',
        isPaid: true,
      );

      expect(order.id, equals('order_1'));
      expect(order.cart, equals(testCart));
      expect(order.restaurant, equals(testRestaurant));
      expect(order.status, equals(OrderStatus.confirmed));
      expect(order.placedAt, equals(testPlacedAt));
      expect(order.estimatedDeliveryTime, equals(testEstimatedDelivery));
      expect(order.driverName, equals('John Driver'));
      expect(order.driverPhone, equals('+1234567890'));
      expect(order.trackingCode, equals('TRACK123'));
      expect(order.totalAmount, equals(31.57));
      expect(order.deliveryAddress, equals('456 Delivery St'));
      expect(order.specialInstructions, equals('Ring the bell'));
      expect(order.isPaid, isTrue);
    });
  });

  group('OrderStatusUpdate Entity Tests', () {
    test(
      'OrderStatusUpdate should be equal when all properties are the same',
      () {
        final timestamp = DateTime(2025, 10, 2, 12, 0);

        final update1 = OrderStatusUpdate(
          status: OrderStatus.confirmed,
          timestamp: timestamp,
          message: 'Order confirmed by restaurant',
        );

        final update2 = OrderStatusUpdate(
          status: OrderStatus.confirmed,
          timestamp: timestamp,
          message: 'Order confirmed by restaurant',
        );

        expect(update1, equals(update2));
        expect(update1.hashCode, equals(update2.hashCode));
      },
    );

    test('OrderStatusUpdate should not be equal when properties differ', () {
      final timestamp1 = DateTime(2025, 10, 2, 12, 0);
      final timestamp2 = DateTime(2025, 10, 2, 12, 5);

      final update1 = OrderStatusUpdate(
        status: OrderStatus.confirmed,
        timestamp: timestamp1,
        message: 'Order confirmed by restaurant',
      );

      final update2 = OrderStatusUpdate(
        status: OrderStatus.preparing,
        timestamp: timestamp2,
        message: 'Order is being prepared',
      );

      expect(update1, isNot(equals(update2)));
      expect(update1.hashCode, isNot(equals(update2.hashCode)));
    });

    test('OrderStatusUpdate should have correct default values', () {
      final timestamp = DateTime(2025, 10, 2, 12, 0);

      final update = OrderStatusUpdate(
        status: OrderStatus.confirmed,
        timestamp: timestamp,
      );

      expect(update.status, equals(OrderStatus.confirmed));
      expect(update.timestamp, equals(timestamp));
      expect(update.message, isNull);
    });

    test('OrderStatusUpdate should have correct property values', () {
      final timestamp = DateTime(2025, 10, 2, 12, 0);

      final update = OrderStatusUpdate(
        status: OrderStatus.preparing,
        timestamp: timestamp,
        message: 'Chef is preparing your order',
      );

      expect(update.status, equals(OrderStatus.preparing));
      expect(update.timestamp, equals(timestamp));
      expect(update.message, equals('Chef is preparing your order'));
    });
  });

  group('OrderStatus Enum Tests', () {
    test('OrderStatus should contain all expected values', () {
      const expectedStatuses = [
        OrderStatus.placed,
        OrderStatus.confirmed,
        OrderStatus.preparing,
        OrderStatus.driverAssigned,
        OrderStatus.pickedUp,
        OrderStatus.enRoute,
        OrderStatus.delivered,
        OrderStatus.cancelled,
      ];

      expect(OrderStatus.values, containsAll(expectedStatuses));
      expect(OrderStatus.values.length, equals(8));
    });

    test('OrderStatus values should have correct string representation', () {
      expect(OrderStatus.placed.toString(), equals('OrderStatus.placed'));
      expect(OrderStatus.confirmed.toString(), equals('OrderStatus.confirmed'));
      expect(OrderStatus.preparing.toString(), equals('OrderStatus.preparing'));
      expect(
        OrderStatus.driverAssigned.toString(),
        equals('OrderStatus.driverAssigned'),
      );
      expect(OrderStatus.pickedUp.toString(), equals('OrderStatus.pickedUp'));
      expect(OrderStatus.enRoute.toString(), equals('OrderStatus.enRoute'));
      expect(OrderStatus.delivered.toString(), equals('OrderStatus.delivered'));
      expect(OrderStatus.cancelled.toString(), equals('OrderStatus.cancelled'));
    });
  });
}
