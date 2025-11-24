import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ErrorHandler {
  ErrorHandler._privateConstructor();
  static final ErrorHandler instance = ErrorHandler._privateConstructor();

  /// Shows a SnackBar with a user‑friendly message.
  void handleError(BuildContext context, Object error,
      [StackTrace? stackTrace]) {
    // Log the error for debugging (could be sent to Crashlytics later)
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
    final message = _mapErrorToMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Wraps an async action and catches errors, forwarding them to [handleError].
  Future<T> runSafely<T>(
      Future<T> Function() action, BuildContext context) async {
    try {
      return await action();
    } catch (e, st) {
      handleError(context, e, st);
      rethrow; // Propagate so callers can still react if needed
    }
  }

  /// Maps known error types (especially FirebaseAuthException) to friendly messages.
  String _mapErrorToMessage(Object error) {
    // Add more mappings as needed.
    final errorString = error.toString();
    if (errorString.contains('email-already-in-use')) {
      return 'This email is already registered.';
    }
    if (errorString.contains('user-not-found')) {
      return 'No account found for that email.';
    }
    if (errorString.contains('wrong-password')) {
      return 'Incorrect password.';
    }
    if (errorString.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    // Fallback generic message.
    return 'An unexpected error occurred. Please try again.';
  }
}
