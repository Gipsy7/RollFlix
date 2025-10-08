import 'package:flutter/foundation.dart';

/// Lightweight logger that avoids shipping `print` statements in release builds
/// while keeping debug output available during development.
class AppLogger {
  const AppLogger._();

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('❌ $message');
      if (error != null) {
        debugPrint('   ↳ $error');
      }
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
