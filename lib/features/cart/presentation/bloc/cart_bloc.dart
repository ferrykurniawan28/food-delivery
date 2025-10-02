import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/usecases.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC for managing cart state
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddItemToCartUseCase addItemToCartUseCase;
  final RemoveItemFromCartUseCase removeItemFromCartUseCase;
  final UpdateItemQuantityUseCase updateItemQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartItemCountUseCase getCartItemCountUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addItemToCartUseCase,
    required this.removeItemFromCartUseCase,
    required this.updateItemQuantityUseCase,
    required this.clearCartUseCase,
    required this.getCartItemCountUseCase,
  }) : super(const CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
    on<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<ClearRestaurantItemsEvent>(_onClearRestaurantItems);
    on<RefreshCartEvent>(_onRefreshCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    try {
      final cart = await getCartUseCase();

      if (cart == null || cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartItemAdding(event.item));

    try {
      final updatedCart = await addItemToCartUseCase(event.item);

      emit(CartItemAdded(cart: updatedCart, addedItem: event.item));

      // Immediately transition to CartLoaded state
      emit(CartLoaded(updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));

      // Try to reload cart state
      add(const LoadCartEvent());
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      final updatedCart = await removeItemFromCartUseCase(event.cartItemId);

      if (updatedCart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(updatedCart));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));

      // Try to reload cart state
      add(const LoadCartEvent());
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      CartItemUpdating(
        cartItemId: event.cartItemId,
        newQuantity: event.quantity,
      ),
    );

    try {
      final updatedCart = await updateItemQuantityUseCase(
        event.cartItemId,
        event.quantity,
      );

      if (updatedCart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(updatedCart));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));

      // Try to reload cart state
      add(const LoadCartEvent());
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartClearing());

    try {
      await clearCartUseCase();
      emit(const CartEmpty());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearRestaurantItems(
    ClearRestaurantItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      // This would need to be implemented in the use cases
      // For now, just reload the cart
      add(const LoadCartEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRefreshCart(
    RefreshCartEvent event,
    Emitter<CartState> emit,
  ) async {
    add(const LoadCartEvent());
  }
}
