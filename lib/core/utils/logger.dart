import 'package:flutter/foundation.dart';
import '../config/environment.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static String _name = 'CosmeticStore';
  static LogLevel _currentLevel = LogLevel.debug;
  static bool _isInitialized = false;

  static void init({
    String? appName,
    LogLevel level = LogLevel.debug,
  }) {
    _name = appName ?? EnvironmentConfig.appName;
    _currentLevel = level;
    _isInitialized = true;
    
    info('Logger initialized for ${EnvironmentConfig.currentEnvironment.name} environment');
  }

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

  static void apiRequest(String method, String url, {Map<String, dynamic>? data}) {
    if (EnvironmentConfig.enableLogging) {
      debug('API Request: $method $url${data != null ? ' with data: $data' : ''}');
    }
  }

  static void apiResponse(String method, String url, int statusCode, {dynamic data}) {
    if (EnvironmentConfig.enableLogging) {
      final level = statusCode >= 400 ? LogLevel.error : LogLevel.debug;
      _log(level, 'API Response: $method $url -> $statusCode${data != null ? ' data: $data' : ''}', null, null);
    }
  }

  static void performance(String operation, Duration duration) {
    if (EnvironmentConfig.enableLogging) {
      info('Performance: $operation took ${duration.inMilliseconds}ms');
    }
  }

  static void userAction(String action, {Map<String, dynamic>? properties}) {
    if (EnvironmentConfig.enableAnalytics) {
      info('User Action: $action${properties != null ? ' with properties: $properties' : ''}');
      // TODO: Send to analytics service
    }
  }

  // Utility methods for different contexts
  static void auth(String message, [dynamic error, StackTrace? stackTrace]) {
    info('[AUTH] $message', error, stackTrace);
  }

  static void network(String message, [dynamic error, StackTrace? stackTrace]) {
    debug('[NETWORK] $message', error, stackTrace);
  }

  static void storage(String message, [dynamic error, StackTrace? stackTrace]) {
    debug('[STORAGE] $message', error, stackTrace);
  }

  static void websocket(String message, [dynamic error, StackTrace? stackTrace]) {
    debug('[WEBSOCKET] $message', error, stackTrace);
  }

  static void _log(LogLevel level, String message, dynamic error, StackTrace? stackTrace) {
    // Skip logging if not initialized or if logging is disabled for environment
    if (!_isInitialized || !EnvironmentConfig.enableLogging) {
      return;
    }
    
    // Skip if log level is below current threshold
    if (level.index < _currentLevel.index) {
      return;
    }

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final environment = EnvironmentConfig.currentEnvironment.name.toUpperCase();

    String logMessage = '[$timestamp] [$environment] [$_name] [$levelStr] $message';

    if (error != null) {
      logMessage += '\nError: $error';
    }

    if (stackTrace != null) {
      logMessage += '\nStackTrace: $stackTrace';
    }

    // Use different output methods based on environment and log level
    if (EnvironmentConfig.isDevelopment || level == LogLevel.error) {
      debugPrint(logMessage);
    } else {
      // In production, you might want to send logs to a service like Firebase Crashlytics
      // or other logging services
      print(logMessage);
    }
    
    // In production, send errors to crash reporting service
    if (EnvironmentConfig.isProduction && level == LogLevel.error && error != null) {
      _sendToCrashReporting(message, error, stackTrace);
    }
  }

  static void _sendToCrashReporting(String message, dynamic error, StackTrace? stackTrace) {
    // TODO: Implement crash reporting service integration
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
  }
}