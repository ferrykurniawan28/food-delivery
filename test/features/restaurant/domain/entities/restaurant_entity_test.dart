import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

void main() {
  group('Restaurant Entity Tests', () {
    test('Restaurant should be equal when all properties are the same', () {
      const restaurant1 = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://test.com/image.jpg',
        cuisineTypes: ['Italian', 'Pizza'],
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
        paymentMethods: ['Credit Card', 'Cash'],
        deliveryAreas: ['Downtown', 'Midtown'],
        additionalInfo: {},
      );

      const restaurant2 = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://test.com/image.jpg',
        cuisineTypes: ['Italian', 'Pizza'],
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
        paymentMethods: ['Credit Card', 'Cash'],
        deliveryAreas: ['Downtown', 'Midtown'],
        additionalInfo: {},
      );

      expect(restaurant1, equals(restaurant2));
      expect(restaurant1.hashCode, equals(restaurant2.hashCode));
    });

    test('Restaurant should not be equal when properties differ', () {
      const restaurant1 = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://test.com/image.jpg',
        cuisineTypes: ['Italian', 'Pizza'],
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
        paymentMethods: ['Credit Card', 'Cash'],
        deliveryAreas: ['Downtown', 'Midtown'],
        additionalInfo: {},
      );

      const restaurant2 = Restaurant(
        id: '2',
        name: 'Different Restaurant',
        description: 'A different restaurant',
        imageUrl: 'https://test.com/image2.jpg',
        cuisineTypes: ['Chinese', 'Asian'],
        rating: 4.0,
        reviewCount: 75,
        priceRange: '\$',
        deliveryTime: 25,
        distance: 1.8,
        isOpen: false,
        acceptingOrders: false,
        deliveryFee: 1.99,
        minimumOrder: 12.0,
        menuCategories: [],
        operatingHours: [],
        location: RestaurantLocation(
          address: '456 Another St',
          city: 'Test City',
          state: 'TS',
          zipCode: '12345',
          country: 'USA',
          latitude: 40.7589,
          longitude: -73.9851,
        ),
        contact: RestaurantContact(
          phone: '+1234567891',
          email: 'another@restaurant.com',
          website: 'https://another-restaurant.com',
        ),
        paymentMethods: ['Credit Card', 'PayPal'],
        deliveryAreas: ['Uptown', 'Downtown'],
        additionalInfo: {},
      );

      expect(restaurant1, isNot(equals(restaurant2)));
      expect(restaurant1.hashCode, isNot(equals(restaurant2.hashCode)));
    });

    test('Restaurant should have correct property values', () {
      const restaurant = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://test.com/image.jpg',
        cuisineTypes: ['Italian', 'Pizza'],
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
        paymentMethods: ['Credit Card', 'Cash'],
        deliveryAreas: ['Downtown', 'Midtown'],
        additionalInfo: {},
      );

      expect(restaurant.id, equals('1'));
      expect(restaurant.name, equals('Test Restaurant'));
      expect(restaurant.rating, equals(4.5));
      expect(restaurant.isOpen, isTrue);
      expect(restaurant.acceptingOrders, isTrue);
      expect(restaurant.cuisineTypes, contains('Italian'));
      expect(restaurant.paymentMethods, contains('Credit Card'));
    });
  });

  group('MenuItem Entity Tests', () {
    test('MenuItem should be equal when all properties are the same', () {
      const menuItem1 = MenuItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce and mozzarella',
        price: 12.99,
        imageUrl: 'https://test.com/pizza.jpg',
        category: 'Pizza',
        ingredients: ['Tomato Sauce', 'Mozzarella', 'Basil'],
        isVegetarian: true,
        isVegan: false,
        isGlutenFree: false,
        isSpicy: false,
        isAvailable: true,
        preparationTime: 15,
        calories: 250.0,
        customizations: {},
      );

      const menuItem2 = MenuItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce and mozzarella',
        price: 12.99,
        imageUrl: 'https://test.com/pizza.jpg',
        category: 'Pizza',
        ingredients: ['Tomato Sauce', 'Mozzarella', 'Basil'],
        isVegetarian: true,
        isVegan: false,
        isGlutenFree: false,
        isSpicy: false,
        isAvailable: true,
        preparationTime: 15,
        calories: 250.0,
        customizations: {},
      );

      expect(menuItem1, equals(menuItem2));
      expect(menuItem1.hashCode, equals(menuItem2.hashCode));
    });

    test('MenuItem should not be equal when properties differ', () {
      const menuItem1 = MenuItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce and mozzarella',
        price: 12.99,
        imageUrl: 'https://test.com/pizza.jpg',
        category: 'Pizza',
        ingredients: ['Tomato Sauce', 'Mozzarella', 'Basil'],
        isVegetarian: true,
      );

      const menuItem2 = MenuItem(
        id: '2',
        name: 'Pepperoni Pizza',
        description: 'Pizza with pepperoni and cheese',
        price: 14.99,
        imageUrl: 'https://test.com/pepperoni.jpg',
        category: 'Pizza',
        ingredients: ['Tomato Sauce', 'Mozzarella', 'Pepperoni'],
        isVegetarian: false,
      );

      expect(menuItem1, isNot(equals(menuItem2)));
      expect(menuItem1.hashCode, isNot(equals(menuItem2.hashCode)));
    });

    test('MenuItem should have correct default values', () {
      const menuItem = MenuItem(
        id: '1',
        name: 'Test Item',
        description: 'A test menu item',
        price: 10.99,
        imageUrl: 'https://test.com/item.jpg',
        category: 'Test',
        ingredients: ['Test Ingredient'],
      );

      expect(menuItem.isVegetarian, isFalse);
      expect(menuItem.isVegan, isFalse);
      expect(menuItem.isGlutenFree, isFalse);
      expect(menuItem.isSpicy, isFalse);
      expect(menuItem.isAvailable, isTrue);
      expect(menuItem.preparationTime, equals(15));
      expect(menuItem.calories, equals(0.0));
      expect(menuItem.customizations, isNull);
    });

    test('MenuItem should have correct property values', () {
      const menuItem = MenuItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce and mozzarella',
        price: 12.99,
        imageUrl: 'https://test.com/pizza.jpg',
        category: 'Pizza',
        ingredients: ['Tomato Sauce', 'Mozzarella', 'Basil'],
        isVegetarian: true,
        preparationTime: 20,
        calories: 250.0,
      );

      expect(menuItem.id, equals('1'));
      expect(menuItem.name, equals('Margherita Pizza'));
      expect(menuItem.price, equals(12.99));
      expect(menuItem.isVegetarian, isTrue);
      expect(menuItem.preparationTime, equals(20));
      expect(menuItem.ingredients, contains('Basil'));
    });
  });

  group('MenuCategory Entity Tests', () {
    const testMenuItem = MenuItem(
      id: '1',
      name: 'Test Item',
      description: 'A test item',
      price: 10.99,
      imageUrl: 'https://test.com/item.jpg',
      category: 'Test',
      ingredients: ['Test Ingredient'],
    );

    test('MenuCategory should be equal when all properties are the same', () {
      const category1 = MenuCategory(
        id: '1',
        name: 'Pizza',
        description: 'Delicious pizzas',
        imageUrl: 'https://test.com/pizza-category.jpg',
        items: [testMenuItem],
        isAvailable: true,
      );

      const category2 = MenuCategory(
        id: '1',
        name: 'Pizza',
        description: 'Delicious pizzas',
        imageUrl: 'https://test.com/pizza-category.jpg',
        items: [testMenuItem],
        isAvailable: true,
      );

      expect(category1, equals(category2));
      expect(category1.hashCode, equals(category2.hashCode));
    });

    test('MenuCategory should not be equal when properties differ', () {
      const category1 = MenuCategory(
        id: '1',
        name: 'Pizza',
        description: 'Delicious pizzas',
        imageUrl: 'https://test.com/pizza-category.jpg',
        items: [testMenuItem],
        isAvailable: true,
      );

      const category2 = MenuCategory(
        id: '2',
        name: 'Burgers',
        description: 'Tasty burgers',
        imageUrl: 'https://test.com/burger-category.jpg',
        items: [],
        isAvailable: false,
      );

      expect(category1, isNot(equals(category2)));
      expect(category1.hashCode, isNot(equals(category2.hashCode)));
    });

    test('MenuCategory should have correct default values', () {
      const category = MenuCategory(
        id: '1',
        name: 'Test Category',
        description: 'A test category',
        imageUrl: 'https://test.com/category.jpg',
        items: [],
      );

      expect(category.isAvailable, isTrue);
    });

    test('MenuCategory should have correct property values', () {
      const category = MenuCategory(
        id: '1',
        name: 'Pizza',
        description: 'Delicious pizzas',
        imageUrl: 'https://test.com/pizza-category.jpg',
        items: [testMenuItem],
        isAvailable: true,
      );

      expect(category.id, equals('1'));
      expect(category.name, equals('Pizza'));
      expect(category.description, equals('Delicious pizzas'));
      expect(category.isAvailable, isTrue);
      expect(category.items, hasLength(1));
      expect(category.items.first, equals(testMenuItem));
    });
  });

  group('RestaurantLocation Entity Tests', () {
    test(
      'RestaurantLocation should be equal when all properties are the same',
      () {
        const location1 = RestaurantLocation(
          latitude: 40.7128,
          longitude: -74.0060,
          address: '123 Test St',
          city: 'Test City',
          state: 'TS',
          zipCode: '12345',
          country: 'USA',
        );

        const location2 = RestaurantLocation(
          latitude: 40.7128,
          longitude: -74.0060,
          address: '123 Test St',
          city: 'Test City',
          state: 'TS',
          zipCode: '12345',
          country: 'USA',
        );

        expect(location1, equals(location2));
        expect(location1.hashCode, equals(location2.hashCode));
      },
    );

    test('RestaurantLocation should not be equal when properties differ', () {
      const location1 = RestaurantLocation(
        latitude: 40.7128,
        longitude: -74.0060,
        address: '123 Test St',
        city: 'Test City',
        state: 'TS',
        zipCode: '12345',
        country: 'USA',
      );

      const location2 = RestaurantLocation(
        latitude: 40.7589,
        longitude: -73.9851,
        address: '456 Another St',
        city: 'Another City',
        state: 'AS',
        zipCode: '54321',
        country: 'USA',
      );

      expect(location1, isNot(equals(location2)));
      expect(location1.hashCode, isNot(equals(location2.hashCode)));
    });

    test('RestaurantLocation should have correct property values', () {
      const location = RestaurantLocation(
        latitude: 40.7128,
        longitude: -74.0060,
        address: '123 Test St',
        city: 'Test City',
        state: 'TS',
        zipCode: '12345',
        country: 'USA',
      );

      expect(location.latitude, equals(40.7128));
      expect(location.longitude, equals(-74.0060));
      expect(location.address, equals('123 Test St'));
      expect(location.city, equals('Test City'));
      expect(location.state, equals('TS'));
      expect(location.zipCode, equals('12345'));
      expect(location.country, equals('USA'));
    });
  });

  group('RestaurantContact Entity Tests', () {
    test(
      'RestaurantContact should be equal when all properties are the same',
      () {
        const contact1 = RestaurantContact(
          phone: '+1234567890',
          email: 'test@restaurant.com',
          website: 'https://test-restaurant.com',
        );

        const contact2 = RestaurantContact(
          phone: '+1234567890',
          email: 'test@restaurant.com',
          website: 'https://test-restaurant.com',
        );

        expect(contact1, equals(contact2));
        expect(contact1.hashCode, equals(contact2.hashCode));
      },
    );

    test('RestaurantContact should not be equal when properties differ', () {
      const contact1 = RestaurantContact(
        phone: '+1234567890',
        email: 'test@restaurant.com',
        website: 'https://test-restaurant.com',
      );

      const contact2 = RestaurantContact(
        phone: '+0987654321',
        email: 'another@restaurant.com',
        website: 'https://another-restaurant.com',
      );

      expect(contact1, isNot(equals(contact2)));
      expect(contact1.hashCode, isNot(equals(contact2.hashCode)));
    });

    test('RestaurantContact should have correct property values', () {
      const contact = RestaurantContact(
        phone: '+1234567890',
        email: 'test@restaurant.com',
        website: 'https://test-restaurant.com',
      );

      expect(contact.phone, equals('+1234567890'));
      expect(contact.email, equals('test@restaurant.com'));
      expect(contact.website, equals('https://test-restaurant.com'));
    });
  });
}
