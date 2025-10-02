import 'package:flutter/material.dart';

/// Enhanced error handling widget for the food delivery app
class ErrorHandlingWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? title;
  final IconData? icon;
  final bool showDetails;

  const ErrorHandlingWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
    this.icon,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? _getErrorIcon(), size: 80, color: _getErrorColor()),
            const SizedBox(height: 24),
            Text(
              title ?? _getErrorTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getErrorMessage(),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (showDetails) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Technical Details'),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      error,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection')) {
      return Icons.wifi_off;
    } else if (error.toLowerCase().contains('not found')) {
      return Icons.search_off;
    } else if (error.toLowerCase().contains('timeout')) {
      return Icons.timer_off;
    } else if (error.toLowerCase().contains('permission')) {
      return Icons.lock;
    }
    return Icons.error_outline;
  }

  Color _getErrorColor() {
    if (error.toLowerCase().contains('network')) {
      return Colors.orange;
    } else if (error.toLowerCase().contains('not found')) {
      return Colors.blue;
    }
    return Colors.red;
  }

  String _getErrorTitle() {
    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection')) {
      return 'Connection Problem';
    } else if (error.toLowerCase().contains('not found')) {
      return 'Not Found';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Request Timeout';
    } else if (error.toLowerCase().contains('permission')) {
      return 'Permission Required';
    }
    return 'Something Went Wrong';
  }

  String _getErrorMessage() {
    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection')) {
      return 'Please check your internet connection and try again.';
    } else if (error.toLowerCase().contains('not found')) {
      return 'The requested item could not be found. It may have been removed or is temporarily unavailable.';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'The request took too long to complete. Please try again.';
    } else if (error.toLowerCase().contains('permission')) {
      return 'This action requires additional permissions. Please grant the necessary permissions and try again.';
    }
    return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
  }
}

/// Snackbar utility for showing errors
class ErrorSnackBar {
  static void show(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

/// Loading overlay for realistic workflow states
class LoadingOverlay extends StatelessWidget {
  final String message;
  final bool isVisible;

  const LoadingOverlay({
    Key? key,
    required this.message,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
