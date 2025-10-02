/// Custom exceptions for the cart feature
class CartException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const CartException(this.message, {this.code, this.cause});

  @override
  String toString() => 'CartException: $message';
}

class CartItemNotFoundException extends CartException {
  const CartItemNotFoundException(String itemId)
    : super('Cart item with ID $itemId not found', code: 'ITEM_NOT_FOUND');
}

class CartEmptyException extends CartException {
  const CartEmptyException() : super('Cart is empty', code: 'CART_EMPTY');
}

class InvalidQuantityException extends CartException {
  const InvalidQuantityException(int quantity)
    : super(
        'Invalid quantity: $quantity. Must be greater than 0',
        code: 'INVALID_QUANTITY',
      );
}

class CartStorageException extends CartException {
  const CartStorageException(String operation)
    : super('Failed to $operation cart data', code: 'STORAGE_ERROR');
}
