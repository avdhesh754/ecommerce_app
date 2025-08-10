import '../constants/app_constants.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;
  
  static Environment get currentEnvironment => _currentEnvironment;
  
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
    
    // Update AppConstants environment flags
    AppConstants.setEnvironmentFlags(
      isDevelopment: environment == Environment.development,
      isStaging: environment == Environment.staging,
      isProduction: environment == Environment.production,
    );
  }
  
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  static bool get isStaging => _currentEnvironment == Environment.staging;
  static bool get isProduction => _currentEnvironment == Environment.production;
  
  // API Base URLs - Use AppConstants for consistency
  static String get apiBaseUrl => AppConstants.baseUrl;
  
  // WebSocket URLs - Use AppConstants for consistency
  static String get websocketUrl => AppConstants.websocketUrl;
  
  // App Configuration
  static String get appName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'Cosmetic Store (Dev)';
      case Environment.staging:
        return 'Cosmetic Store (Staging)';
      case Environment.production:
        return 'Cosmetic Store';
    }
  }
  
  static String get appId {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'com.cosmeticstore.app.dev';
      case Environment.staging:
        return 'com.cosmeticstore.app.staging';
      case Environment.production:
        return 'com.cosmeticstore.app';
    }
  }
  
  // Feature Flags - Use AppConstants for consistency
  static bool get enableLogging => AppConstants.enableLogging;
  static bool get enableDebugMode => AppConstants.enableDebugMode;
  static bool get enableAnalytics => AppConstants.enableAnalytics;
  
  // Security Configuration - Use AppConstants for consistency
  static bool get enableSSLPinning => AppConstants.enableSSLPinning;
  static Duration get requestTimeout => AppConstants.requestTimeout;
  
  // Cache Configuration - Use AppConstants for consistency
  static Duration get cacheTimeout => AppConstants.cacheTimeout;
  
  // Database Configuration - Use AppConstants for consistency
  static String get databaseName => AppConstants.databaseName;
  
  // Third-party Service Keys - Use AppConstants for consistency
  static String get googleApiKey => AppConstants.googleApiKey;
  static String get firebaseProjectId => AppConstants.firebaseProjectId;
  
  // Payment Gateway Configuration - Use AppConstants for consistency
  static String get stripePublishableKey => AppConstants.stripePublishableKey;
  
  // Social Media Login - Use AppConstants for consistency
  static String get googleClientId => AppConstants.googleClientId;
  static String get facebookAppId => AppConstants.facebookAppId;
}