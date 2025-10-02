import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery/features/restaurant/domain/usecases/usecases.dart';
import 'package:fooddelivery/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

// Mock repository
class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late MockRestaurantRepository mockRepository;

  // Test data
  final testRestaurant1 = Restaurant(
    id: 'restaurant1',
    name: 'Test Restaurant 1',
    description: 'A great restaurant',
    imageUrl: 'test1.jpg',
    cuisineTypes: ['Italian'],
    rating: 4.5,
    reviewCount: 100,
    priceRange: '\$\$',
    deliveryTime: 30,
    distance: 2.5,
    isOpen: true,
    acceptingOrders: true,
    deliveryFee: 5.0,
    minimumOrder: 15.0,
    menuCategories: [],
    operatingHours: [],
    location: RestaurantLocation(
      address: '123 Main St',
      latitude: 40.7128,
      longitude: -74.0060,
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'USA',
    ),
    contact: RestaurantContact(phone: '1234567890', email: 'test1@example.com'),
    paymentMethods: ['card', 'cash'],
    deliveryAreas: ['downtown'],
  );

  final testRestaurant2 = Restaurant(
    id: 'restaurant2',
    name: 'Test Restaurant 2',
    description: 'Another great restaurant',
    imageUrl: 'test2.jpg',
    cuisineTypes: ['Mexican'],
    rating: 4.2,
    reviewCount: 85,
    priceRange: '\$',
    deliveryTime: 25,
    distance: 1.8,
    isOpen: true,
    acceptingOrders: true,
    deliveryFee: 3.0,
    minimumOrder: 12.0,
    menuCategories: [],
    operatingHours: [],
    location: RestaurantLocation(
      address: '456 Oak Ave',
      latitude: 40.7589,
      longitude: -73.9851,
      city: 'New York',
      state: 'NY',
      zipCode: '10002',
      country: 'USA',
    ),
    contact: RestaurantContact(phone: '0987654321', email: 'test2@example.com'),
    paymentMethods: ['card'],
    deliveryAreas: ['uptown'],
  );

  final testRestaurants = [testRestaurant1, testRestaurant2];

  setUp(() {
    mockRepository = MockRestaurantRepository();
  });

  group('GetRestaurantsUseCase', () {
    late GetRestaurantsUseCase useCase;

    setUp(() {
      useCase = GetRestaurantsUseCase(mockRepository);
    });

    test('should get restaurants from repository', () async {
      // Arrange
      when(
        () => mockRepository.getRestaurants(),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(testRestaurants));
      verify(() => mockRepository.getRestaurants()).called(1);
    });

    test('should return empty list when no restaurants available', () async {
      // Arrange
      when(() => mockRepository.getRestaurants()).thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getRestaurants()).called(1);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.getRestaurants(),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
      verify(() => mockRepository.getRestaurants()).called(1);
    });
  });

  group('GetRestaurantsByCategoryUseCase', () {
    late GetRestaurantsByCategoryUseCase useCase;

    setUp(() {
      useCase = GetRestaurantsByCategoryUseCase(mockRepository);
    });

    test('should get restaurants by category from repository', () async {
      // Arrange
      final category = 'Italian';
      final expectedRestaurants = [testRestaurant1];
      when(
        () => mockRepository.getRestaurantsByCategory(category),
      ).thenAnswer((_) async => expectedRestaurants);

      // Act
      final result = await useCase(category);

      // Assert
      expect(result, equals(expectedRestaurants));
      verify(() => mockRepository.getRestaurantsByCategory(category)).called(1);
    });

    test('should return empty list when no restaurants in category', () async {
      // Arrange
      final category = 'Nonexistent';
      when(
        () => mockRepository.getRestaurantsByCategory(category),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(category);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getRestaurantsByCategory(category)).called(1);
    });

    test('should handle empty category string', () async {
      // Arrange
      final category = '';
      when(
        () => mockRepository.getRestaurantsByCategory(category),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(category);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getRestaurantsByCategory(category)).called(1);
    });
  });

  group('SearchRestaurantsUseCase', () {
    late SearchRestaurantsUseCase useCase;

    setUp(() {
      useCase = SearchRestaurantsUseCase(mockRepository);
    });

    test('should search restaurants by query', () async {
      // Arrange
      final query = 'Test Restaurant';
      when(
        () => mockRepository.findRestaurants(query),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, equals(testRestaurants));
      verify(() => mockRepository.findRestaurants(query)).called(1);
    });

    test('should return empty list when no restaurants match query', () async {
      // Arrange
      final query = 'Nonexistent Restaurant';
      when(
        () => mockRepository.findRestaurants(query),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.findRestaurants(query)).called(1);
    });

    test('should handle empty search query', () async {
      // Arrange
      final query = '';
      when(
        () => mockRepository.findRestaurants(query),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, equals(testRestaurants));
      verify(() => mockRepository.findRestaurants(query)).called(1);
    });

    test('should handle special characters in search query', () async {
      // Arrange
      final query = 'Test & Restaurant!';
      when(
        () => mockRepository.findRestaurants(query),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.findRestaurants(query)).called(1);
    });
  });

  group('GetRestaurantByIdUseCase', () {
    late GetRestaurantByIdUseCase useCase;

    setUp(() {
      useCase = GetRestaurantByIdUseCase(mockRepository);
    });

    test('should get restaurant by id from repository', () async {
      // Arrange
      final restaurantId = 'restaurant1';
      when(
        () => mockRepository.getRestaurantById(restaurantId),
      ).thenAnswer((_) async => testRestaurant1);

      // Act
      final result = await useCase(restaurantId);

      // Assert
      expect(result, equals(testRestaurant1));
      verify(() => mockRepository.getRestaurantById(restaurantId)).called(1);
    });

    test('should return null when restaurant not found', () async {
      // Arrange
      final restaurantId = 'nonexistent';
      when(
        () => mockRepository.getRestaurantById(restaurantId),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase(restaurantId);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getRestaurantById(restaurantId)).called(1);
    });

    test('should handle empty id string', () async {
      // Arrange
      final restaurantId = '';
      when(
        () => mockRepository.getRestaurantById(restaurantId),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase(restaurantId);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getRestaurantById(restaurantId)).called(1);
    });
  });

  group('GetRestaurantsNearbyUseCase', () {
    late GetRestaurantsNearbyUseCase useCase;

    setUp(() {
      useCase = GetRestaurantsNearbyUseCase(mockRepository);
    });

    test('should get nearby restaurants with default radius', () async {
      // Arrange
      final latitude = 40.7128;
      final longitude = -74.0060;
      final params = GetRestaurantsNearbyParams(
        latitude: latitude,
        longitude: longitude,
      );
      when(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: 5.0,
        ),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(testRestaurants));
      verify(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: 5.0,
        ),
      ).called(1);
    });

    test('should get nearby restaurants with custom radius', () async {
      // Arrange
      final latitude = 40.7128;
      final longitude = -74.0060;
      final radius = 2.0;
      final params = GetRestaurantsNearbyParams(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radius,
      );
      when(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: radius,
        ),
      ).thenAnswer((_) async => [testRestaurant1]);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals([testRestaurant1]));
      verify(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: radius,
        ),
      ).called(1);
    });

    test('should return empty list when no restaurants nearby', () async {
      // Arrange
      final latitude = 0.0;
      final longitude = 0.0;
      final params = GetRestaurantsNearbyParams(
        latitude: latitude,
        longitude: longitude,
      );
      when(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: 5.0,
        ),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isEmpty);
      verify(
        () => mockRepository.getRestaurantsNearby(
          latitude: latitude,
          longitude: longitude,
          radiusInKm: 5.0,
        ),
      ).called(1);
    });
  });

  group('GetRestaurantsWithFiltersUseCase', () {
    late GetRestaurantsWithFiltersUseCase useCase;

    setUp(() {
      useCase = GetRestaurantsWithFiltersUseCase(mockRepository);
    });

    test('should get restaurants with category filter', () async {
      // Arrange
      final category = 'Italian';
      final params = GetRestaurantsWithFiltersParams(category: category);
      when(
        () => mockRepository.getRestaurantsWithFilters(category: category),
      ).thenAnswer((_) async => [testRestaurant1]);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals([testRestaurant1]));
      verify(
        () => mockRepository.getRestaurantsWithFilters(category: category),
      ).called(1);
    });

    test('should get restaurants with rating filter', () async {
      // Arrange
      final minRating = 4.0;
      final params = GetRestaurantsWithFiltersParams(minRating: minRating);
      when(
        () => mockRepository.getRestaurantsWithFilters(minRating: minRating),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(testRestaurants));
      verify(
        () => mockRepository.getRestaurantsWithFilters(minRating: minRating),
      ).called(1);
    });

    test('should get restaurants with multiple filters', () async {
      // Arrange
      final category = 'Italian';
      final minRating = 4.0;
      final priceRange = '\$\$';
      final isOpen = true;
      final maxDeliveryTime = 45;
      final params = GetRestaurantsWithFiltersParams(
        category: category,
        minRating: minRating,
        priceRange: priceRange,
        isOpen: isOpen,
        maxDeliveryTime: maxDeliveryTime,
      );

      when(
        () => mockRepository.getRestaurantsWithFilters(
          category: category,
          minRating: minRating,
          priceRange: priceRange,
          isOpen: isOpen,
          maxDeliveryTime: maxDeliveryTime,
        ),
      ).thenAnswer((_) async => [testRestaurant1]);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals([testRestaurant1]));
      verify(
        () => mockRepository.getRestaurantsWithFilters(
          category: category,
          minRating: minRating,
          priceRange: priceRange,
          isOpen: isOpen,
          maxDeliveryTime: maxDeliveryTime,
        ),
      ).called(1);
    });

    test('should get restaurants with no filters (all restaurants)', () async {
      // Arrange
      final params = GetRestaurantsWithFiltersParams();
      when(
        () => mockRepository.getRestaurantsWithFilters(),
      ).thenAnswer((_) async => testRestaurants);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(testRestaurants));
      verify(() => mockRepository.getRestaurantsWithFilters()).called(1);
    });

    test(
      'should return empty list when no restaurants match filters',
      () async {
        // Arrange
        final minRating = 5.0;
        final params = GetRestaurantsWithFiltersParams(minRating: minRating);
        when(
          () => mockRepository.getRestaurantsWithFilters(minRating: minRating),
        ).thenAnswer((_) async => []);

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, isEmpty);
        verify(
          () => mockRepository.getRestaurantsWithFilters(minRating: minRating),
        ).called(1);
      },
    );
  });

  group('Use Case Integration', () {
    test('all use cases should work with same repository instance', () {
      // Arrange
      final getRestaurantsUseCase = GetRestaurantsUseCase(mockRepository);
      final getByCategoryUseCase = GetRestaurantsByCategoryUseCase(
        mockRepository,
      );
      final searchUseCase = SearchRestaurantsUseCase(mockRepository);
      final getByIdUseCase = GetRestaurantByIdUseCase(mockRepository);
      final getNearbyUseCase = GetRestaurantsNearbyUseCase(mockRepository);
      final getWithFiltersUseCase = GetRestaurantsWithFiltersUseCase(
        mockRepository,
      );

      // Act & Assert
      expect(getRestaurantsUseCase.repository, equals(mockRepository));
      expect(getByCategoryUseCase.repository, equals(mockRepository));
      expect(searchUseCase.repository, equals(mockRepository));
      expect(getByIdUseCase.repository, equals(mockRepository));
      expect(getNearbyUseCase.repository, equals(mockRepository));
      expect(getWithFiltersUseCase.repository, equals(mockRepository));
    });
  });
}
