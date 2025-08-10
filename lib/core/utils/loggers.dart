
// lib/core/utils/logger.dart
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static const String _name = 'YourApp';

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void _log(LogLevel level, String message, dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final levelStr = level.name.toUpperCase();

      String logMessage = '[$timestamp] [$_name] [$levelStr] $message';

      if (error != null) {
        logMessage += '\nError: $error';
      }

      if (stackTrace != null) {
        logMessage += '\nStackTrace: $stackTrace';
      }

      debugPrint(logMessage);
    }
  }
}