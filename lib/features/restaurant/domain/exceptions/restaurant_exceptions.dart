/// Custom exceptions for the restaurant feature
class RestaurantException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const RestaurantException(this.message, {this.code, this.cause});

  @override
  String toString() => 'RestaurantException: $message';
}

class RestaurantNotFoundException extends RestaurantException {
  const RestaurantNotFoundException(String restaurantId)
    : super(
        'Restaurant with ID $restaurantId not found',
        code: 'RESTAURANT_NOT_FOUND',
      );
}

class RestaurantClosedException extends RestaurantException {
  const RestaurantClosedException(String restaurantName)
    : super('$restaurantName is currently closed', code: 'RESTAURANT_CLOSED');
}

class MenuItemNotAvailableException extends RestaurantException {
  const MenuItemNotAvailableException(String itemName)
    : super(
        'Menu item "$itemName" is not available',
        code: 'ITEM_NOT_AVAILABLE',
      );
}

class NetworkException extends RestaurantException {
  const NetworkException()
    : super(
        'Network connection failed. Please check your internet connection.',
        code: 'NETWORK_ERROR',
      );
}
