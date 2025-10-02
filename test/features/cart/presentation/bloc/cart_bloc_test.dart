import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery/features/cart/domain/entities/entities.dart';
import 'package:fooddelivery/features/cart/domain/usecases/usecases.dart';
import 'package:fooddelivery/features/cart/presentation/bloc/bloc.dart';

// Mock classes
class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockAddItemToCartUseCase extends Mock implements AddItemToCartUseCase {}

class MockRemoveItemFromCartUseCase extends Mock
    implements RemoveItemFromCartUseCase {}

class MockUpdateItemQuantityUseCase extends Mock
    implements UpdateItemQuantityUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

class MockGetCartItemCountUseCase extends Mock
    implements GetCartItemCountUseCase {}

void main() {
  group('CartBloc Tests', () {
    late CartBloc cartBloc;
    late MockGetCartUseCase mockGetCartUseCase;
    late MockAddItemToCartUseCase mockAddItemToCartUseCase;
    late MockRemoveItemFromCartUseCase mockRemoveItemFromCartUseCase;
    late MockUpdateItemQuantityUseCase mockUpdateItemQuantityUseCase;
    late MockClearCartUseCase mockClearCartUseCase;
    late MockGetCartItemCountUseCase mockGetCartItemCountUseCase;

    late CartItem testItem;
    late Cart testCart;

    setUp(() {
      mockGetCartUseCase = MockGetCartUseCase();
      mockAddItemToCartUseCase = MockAddItemToCartUseCase();
      mockRemoveItemFromCartUseCase = MockRemoveItemFromCartUseCase();
      mockUpdateItemQuantityUseCase = MockUpdateItemQuantityUseCase();
      mockClearCartUseCase = MockClearCartUseCase();
      mockGetCartItemCountUseCase = MockGetCartItemCountUseCase();

      cartBloc = CartBloc(
        getCartUseCase: mockGetCartUseCase,
        addItemToCartUseCase: mockAddItemToCartUseCase,
        removeItemFromCartUseCase: mockRemoveItemFromCartUseCase,
        updateItemQuantityUseCase: mockUpdateItemQuantityUseCase,
        clearCartUseCase: mockClearCartUseCase,
        getCartItemCountUseCase: mockGetCartItemCountUseCase,
      );

      testItem = const CartItem(
        id: '1',
        menuItemId: 'menu1',
        name: 'Test Burger',
        description: 'Test Description',
        price: 10.99,
        imageUrl: 'test.jpg',
        quantity: 1,
        restaurantId: 'rest1',
        restaurantName: 'Test Restaurant',
        ingredients: ['beef'],
        category: 'Main',
        isVegetarian: false,
        isVegan: false,
        calories: 500,
        preparationTime: 15,
      );

      testCart = Cart(
        id: 'cart1',
        items: [testItem],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state should be CartInitial', () {
      expect(cartBloc.state, equals(const CartInitial()));
    });

    group('LoadCartEvent', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when cart is loaded successfully',
        setUp: () {
          when(() => mockGetCartUseCase()).thenAnswer((_) async => testCart);
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const LoadCartEvent()),
        expect: () => [const CartLoading(), CartLoaded(testCart)],
        verify: (_) {
          verify(() => mockGetCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartEmpty] with empty cart when cart is null',
        setUp: () {
          when(() => mockGetCartUseCase()).thenAnswer((_) async => null);
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const LoadCartEvent()),
        expect: () => [const CartLoading(), const CartEmpty()],
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError] when loading fails',
        setUp: () {
          when(
            () => mockGetCartUseCase(),
          ).thenThrow(Exception('Failed to load cart'));
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const LoadCartEvent()),
        expect: () => [
          const CartLoading(),
          const CartError(message: 'Exception: Failed to load cart'),
        ],
      );
    });

    group('AddItemToCartEvent', () {
      blocTest<CartBloc, CartState>(
        'emits [CartItemAdding, CartItemAdded, CartLoaded] when item is added successfully',
        setUp: () {
          when(
            () => mockAddItemToCartUseCase(testItem),
          ).thenAnswer((_) async => testCart);
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(AddItemToCartEvent(testItem)),
        expect: () => [
          CartItemAdding(testItem),
          CartItemAdded(cart: testCart, addedItem: testItem),
          CartLoaded(testCart),
        ],
        verify: (_) {
          verify(() => mockAddItemToCartUseCase(testItem)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartItemAdding, CartError, CartLoading, CartError] when adding item fails',
        setUp: () {
          when(
            () => mockAddItemToCartUseCase(testItem),
          ).thenThrow(Exception('Failed to add item'));
          // Mock the getCartUseCase that gets called after error
          when(
            () => mockGetCartUseCase(),
          ).thenThrow(Exception('Failed to reload cart'));
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(AddItemToCartEvent(testItem)),
        expect: () => [
          CartItemAdding(testItem),
          const CartError(message: 'Exception: Failed to add item'),
          const CartLoading(),
          const CartError(message: 'Exception: Failed to reload cart'),
        ],
      );
    });

    group('RemoveItemFromCartEvent', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when item is removed successfully',
        setUp: () {
          when(
            () => mockRemoveItemFromCartUseCase('1'),
          ).thenAnswer((_) async => testCart);
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const RemoveItemFromCartEvent('1')),
        expect: () => [const CartLoading(), CartLoaded(testCart)],
        verify: (_) {
          verify(() => mockRemoveItemFromCartUseCase('1')).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError, CartLoading, CartError] when removing item fails',
        setUp: () {
          when(
            () => mockRemoveItemFromCartUseCase('1'),
          ).thenThrow(Exception('Failed to remove item'));
          // Mock the getCartUseCase that gets called after error
          when(
            () => mockGetCartUseCase(),
          ).thenThrow(Exception('Failed to reload cart'));
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const RemoveItemFromCartEvent('1')),
        expect: () => [
          const CartLoading(),
          const CartError(message: 'Exception: Failed to remove item'),
          const CartLoading(),
          const CartError(message: 'Exception: Failed to reload cart'),
        ],
      );
    });

    group('UpdateItemQuantityEvent', () {
      blocTest<CartBloc, CartState>(
        'emits [CartItemUpdating, CartLoaded] when quantity is updated successfully',
        setUp: () {
          when(
            () => mockUpdateItemQuantityUseCase('1', 3),
          ).thenAnswer((_) async => testCart);
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const UpdateItemQuantityEvent('1', 3)),
        expect: () => [
          const CartItemUpdating(cartItemId: '1', newQuantity: 3),
          CartLoaded(testCart),
        ],
        verify: (_) {
          verify(() => mockUpdateItemQuantityUseCase('1', 3)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartItemUpdating, CartError, CartLoading, CartError] when updating quantity fails',
        setUp: () {
          when(
            () => mockUpdateItemQuantityUseCase('1', 3),
          ).thenThrow(Exception('Failed to update quantity'));
          // Mock the getCartUseCase that gets called after error
          when(
            () => mockGetCartUseCase(),
          ).thenThrow(Exception('Failed to reload cart'));
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const UpdateItemQuantityEvent('1', 3)),
        expect: () => [
          const CartItemUpdating(cartItemId: '1', newQuantity: 3),
          const CartError(message: 'Exception: Failed to update quantity'),
          const CartLoading(),
          const CartError(message: 'Exception: Failed to reload cart'),
        ],
      );
    });

    group('ClearCartEvent', () {
      blocTest<CartBloc, CartState>(
        'emits [CartClearing, CartEmpty] when cart is cleared successfully',
        setUp: () {
          when(() => mockClearCartUseCase()).thenAnswer((_) async {});
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const ClearCartEvent()),
        expect: () => [const CartClearing(), const CartEmpty()],
        verify: (_) {
          verify(() => mockClearCartUseCase()).called(1);
          verifyNever(() => mockGetCartUseCase());
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartClearing, CartError] when clearing cart fails',
        setUp: () {
          when(
            () => mockClearCartUseCase(),
          ).thenThrow(Exception('Failed to clear cart'));
        },
        build: () => cartBloc,
        act: (bloc) => bloc.add(const ClearCartEvent()),
        expect: () => [
          const CartClearing(),
          const CartError(message: 'Exception: Failed to clear cart'),
        ],
        verify: (_) {
          verify(() => mockClearCartUseCase()).called(1);
        },
      );
    });
  });
}
