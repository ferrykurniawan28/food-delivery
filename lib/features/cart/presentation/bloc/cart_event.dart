import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';

/// Base class for all cart events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the current cart
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

/// Event to add an item to the cart
class AddItemToCartEvent extends CartEvent {
  final CartItem item;

  const AddItemToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to remove an item from the cart
class RemoveItemFromCartEvent extends CartEvent {
  final String cartItemId;

  const RemoveItemFromCartEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

/// Event to update item quantity in the cart
class UpdateItemQuantityEvent extends CartEvent {
  final String cartItemId;
  final int quantity;

  const UpdateItemQuantityEvent(this.cartItemId, this.quantity);

  @override
  List<Object?> get props => [cartItemId, quantity];
}

/// Event to clear the entire cart
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

/// Event to clear items from a specific restaurant
class ClearRestaurantItemsEvent extends CartEvent {
  final String restaurantId;

  const ClearRestaurantItemsEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

/// Event to refresh cart data
class RefreshCartEvent extends CartEvent {
  const RefreshCartEvent();
}
