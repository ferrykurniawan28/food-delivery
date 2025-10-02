import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';

/// Base class for all cart states
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state
class CartLoading extends CartState {
  const CartLoading();
}

/// Success state with cart data
class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];

  /// Create a copy with updated cart
  CartLoaded copyWith({Cart? cart}) {
    return CartLoaded(cart ?? this.cart);
  }
}

/// Empty cart state
class CartEmpty extends CartState {
  const CartEmpty();
}

/// Error state
class CartError extends CartState {
  final String message;
  final String? errorCode;

  const CartError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

/// State when item is being added to cart
class CartItemAdding extends CartState {
  final CartItem item;

  const CartItemAdding(this.item);

  @override
  List<Object?> get props => [item];
}

/// State when item was successfully added to cart
class CartItemAdded extends CartState {
  final Cart cart;
  final CartItem addedItem;

  const CartItemAdded({required this.cart, required this.addedItem});

  @override
  List<Object?> get props => [cart, addedItem];
}

/// State when item quantity is being updated
class CartItemUpdating extends CartState {
  final String cartItemId;
  final int newQuantity;

  const CartItemUpdating({required this.cartItemId, required this.newQuantity});

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

/// State when cart is being cleared
class CartClearing extends CartState {
  const CartClearing();
}
