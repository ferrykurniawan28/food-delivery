import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';
import 'package:fooddelivery/features/restaurant/domain/usecases/usecases.dart';
import 'package:fooddelivery/features/restaurant/presentation/bloc/bloc.dart';

// Mock classes
class MockGetRestaurantsUseCase extends Mock implements GetRestaurantsUseCase {}

class MockGetRestaurantsByCategoryUseCase extends Mock
    implements GetRestaurantsByCategoryUseCase {}

class MockSearchRestaurantsUseCase extends Mock
    implements SearchRestaurantsUseCase {}

class MockGetRestaurantByIdUseCase extends Mock
    implements GetRestaurantByIdUseCase {}

class MockGetRestaurantsWithFiltersUseCase extends Mock
    implements GetRestaurantsWithFiltersUseCase {}

class MockGetRestaurantsNearbyUseCase extends Mock
    implements GetRestaurantsNearbyUseCase {}

// Test data
const testRestaurant = Restaurant(
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

const testRestaurant2 = Restaurant(
  id: '2',
  name: 'Another Restaurant',
  description: 'Another test restaurant',
  imageUrl: 'https://test.com/image2.jpg',
  cuisineTypes: ['Chinese', 'Asian'],
  rating: 4.0,
  reviewCount: 75,
  priceRange: '\$',
  deliveryTime: 25,
  distance: 1.8,
  isOpen: true,
  acceptingOrders: true,
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

final testRestaurants = [testRestaurant, testRestaurant2];

void main() {
  group('RestaurantBloc Tests', () {
    late RestaurantBloc restaurantBloc;
    late MockGetRestaurantsUseCase mockGetRestaurantsUseCase;
    late MockGetRestaurantsByCategoryUseCase
    mockGetRestaurantsByCategoryUseCase;
    late MockSearchRestaurantsUseCase mockSearchRestaurantsUseCase;
    late MockGetRestaurantByIdUseCase mockGetRestaurantByIdUseCase;
    late MockGetRestaurantsWithFiltersUseCase
    mockGetRestaurantsWithFiltersUseCase;
    late MockGetRestaurantsNearbyUseCase mockGetRestaurantsNearbyUseCase;

    setUp(() {
      mockGetRestaurantsUseCase = MockGetRestaurantsUseCase();
      mockGetRestaurantsByCategoryUseCase =
          MockGetRestaurantsByCategoryUseCase();
      mockSearchRestaurantsUseCase = MockSearchRestaurantsUseCase();
      mockGetRestaurantByIdUseCase = MockGetRestaurantByIdUseCase();
      mockGetRestaurantsWithFiltersUseCase =
          MockGetRestaurantsWithFiltersUseCase();
      mockGetRestaurantsNearbyUseCase = MockGetRestaurantsNearbyUseCase();

      restaurantBloc = RestaurantBloc(
        getRestaurantsUseCase: mockGetRestaurantsUseCase,
        getRestaurantsByCategoryUseCase: mockGetRestaurantsByCategoryUseCase,
        searchRestaurantsUseCase: mockSearchRestaurantsUseCase,
        getRestaurantByIdUseCase: mockGetRestaurantByIdUseCase,
        getRestaurantsWithFiltersUseCase: mockGetRestaurantsWithFiltersUseCase,
        getRestaurantsNearbyUseCase: mockGetRestaurantsNearbyUseCase,
      );
    });

    tearDown(() {
      restaurantBloc.close();
    });

    test('initial state should be RestaurantInitial', () {
      expect(restaurantBloc.state, equals(const RestaurantInitial()));
    });

    group('LoadRestaurantsEvent', () {
      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsLoaded] when restaurants are loaded successfully',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenAnswer((_) async => testRestaurants);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          RestaurantsLoaded(restaurants: testRestaurants),
        ],
        verify: (_) {
          verify(() => mockGetRestaurantsUseCase()).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsEmpty] when no restaurants are found',
        setUp: () {
          when(() => mockGetRestaurantsUseCase()).thenAnswer((_) async => []);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
        expect: () => [const RestaurantLoading(), const RestaurantsEmpty()],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when loading fails',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenThrow(Exception('Failed to load restaurants'));
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(
            message: 'Exception: Failed to load restaurants',
          ),
        ],
      );
    });

    group('LoadRestaurantsByCategoryEvent', () {
      const category = 'Pizza';

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsLoaded] when restaurants by category are loaded successfully',
        setUp: () {
          when(
            () => mockGetRestaurantsByCategoryUseCase(category),
          ).thenAnswer((_) async => [testRestaurant]);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsByCategoryEvent(category)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsLoaded(
            restaurants: [testRestaurant],
            category: category,
          ),
        ],
        verify: (_) {
          verify(() => mockGetRestaurantsByCategoryUseCase(category)).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsEmpty] when no restaurants found for category',
        setUp: () {
          when(
            () => mockGetRestaurantsByCategoryUseCase(category),
          ).thenAnswer((_) async => []);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsByCategoryEvent(category)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsEmpty(message: 'No restaurants found for Pizza'),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when loading by category fails',
        setUp: () {
          when(
            () => mockGetRestaurantsByCategoryUseCase(category),
          ).thenThrow(Exception('Failed to load category'));
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantsByCategoryEvent(category)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(message: 'Exception: Failed to load category'),
        ],
      );
    });

    group('SearchRestaurantsEvent', () {
      const query = 'pizza';

      blocTest<RestaurantBloc, RestaurantState>(
        'emits LoadRestaurantsEvent when query is empty',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenAnswer((_) async => testRestaurants);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const SearchRestaurantsEvent('')),
        expect: () => [
          const RestaurantLoading(),
          RestaurantsLoaded(restaurants: testRestaurants),
        ],
        verify: (_) {
          verify(() => mockGetRestaurantsUseCase()).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsLoaded] when search is successful',
        setUp: () {
          when(
            () => mockSearchRestaurantsUseCase(query),
          ).thenAnswer((_) async => [testRestaurant]);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const SearchRestaurantsEvent(query)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsLoaded(
            restaurants: [testRestaurant],
            searchQuery: query,
          ),
        ],
        verify: (_) {
          verify(() => mockSearchRestaurantsUseCase(query)).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantsEmpty] when no search results found',
        setUp: () {
          when(
            () => mockSearchRestaurantsUseCase(query),
          ).thenAnswer((_) async => []);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const SearchRestaurantsEvent(query)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsEmpty(message: 'No restaurants found for "pizza"'),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when search fails',
        setUp: () {
          when(
            () => mockSearchRestaurantsUseCase(query),
          ).thenThrow(Exception('Search failed'));
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const SearchRestaurantsEvent(query)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(message: 'Exception: Search failed'),
        ],
      );
    });

    group('LoadRestaurantByIdEvent', () {
      const restaurantId = '1';

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantDetailsLoaded] when restaurant is found',
        setUp: () {
          when(
            () => mockGetRestaurantByIdUseCase(restaurantId),
          ).thenAnswer((_) async => testRestaurant);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantByIdEvent(restaurantId)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantDetailsLoaded(testRestaurant),
        ],
        verify: (_) {
          verify(() => mockGetRestaurantByIdUseCase(restaurantId)).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when restaurant is not found',
        setUp: () {
          when(
            () => mockGetRestaurantByIdUseCase(restaurantId),
          ).thenAnswer((_) async => null);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantByIdEvent(restaurantId)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(message: 'Restaurant not found'),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when loading by id fails',
        setUp: () {
          when(
            () => mockGetRestaurantByIdUseCase(restaurantId),
          ).thenThrow(Exception('Failed to load restaurant'));
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const LoadRestaurantByIdEvent(restaurantId)),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(
            message: 'Exception: Failed to load restaurant',
          ),
        ],
      );
    });

    group('RefreshRestaurantsEvent', () {
      blocTest<RestaurantBloc, RestaurantState>(
        'refreshes restaurants when current state is RestaurantsLoaded without category or search',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenAnswer((_) async => testRestaurants);
        },
        build: () => restaurantBloc,
        seed: () => const RestaurantsLoaded(restaurants: []),
        act: (bloc) => bloc.add(const RefreshRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          RestaurantsLoaded(restaurants: testRestaurants),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'refreshes restaurants by category when current state has category',
        setUp: () {
          when(
            () => mockGetRestaurantsByCategoryUseCase('Pizza'),
          ).thenAnswer((_) async => [testRestaurant]);
        },
        build: () => restaurantBloc,
        seed: () => const RestaurantsLoaded(restaurants: [], category: 'Pizza'),
        act: (bloc) => bloc.add(const RefreshRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsLoaded(
            restaurants: [testRestaurant],
            category: 'Pizza',
          ),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'refreshes search results when current state has search query',
        setUp: () {
          when(
            () => mockSearchRestaurantsUseCase('pizza'),
          ).thenAnswer((_) async => [testRestaurant]);
        },
        build: () => restaurantBloc,
        seed: () =>
            const RestaurantsLoaded(restaurants: [], searchQuery: 'pizza'),
        act: (bloc) => bloc.add(const RefreshRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantsLoaded(
            restaurants: [testRestaurant],
            searchQuery: 'pizza',
          ),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'loads all restaurants when current state is not RestaurantsLoaded',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenAnswer((_) async => testRestaurants);
        },
        build: () => restaurantBloc,
        seed: () => const RestaurantInitial(),
        act: (bloc) => bloc.add(const RefreshRestaurantsEvent()),
        expect: () => [
          const RestaurantLoading(),
          RestaurantsLoaded(restaurants: testRestaurants),
        ],
      );
    });

    group('ClearSearchEvent', () {
      blocTest<RestaurantBloc, RestaurantState>(
        'loads all restaurants when search is cleared',
        setUp: () {
          when(
            () => mockGetRestaurantsUseCase(),
          ).thenAnswer((_) async => testRestaurants);
        },
        build: () => restaurantBloc,
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [
          const RestaurantLoading(),
          RestaurantsLoaded(restaurants: testRestaurants),
        ],
        verify: (_) {
          verify(() => mockGetRestaurantsUseCase()).called(1);
        },
      );
    });
  });
}
