import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Cosmetic Ecommerce';
  
  // Environment Configuration - Will be set dynamically by EnvironmentConfig
  static bool _isDevelopment = true;
  static bool _isStaging = false; 
  static bool _isProduction = false;
  
  // Getters for environment flags
  static bool get isDevelopment => _isDevelopment;
  static bool get isStaging => _isStaging;
  static bool get isProduction => _isProduction;
  
  // Method to set environment (called by EnvironmentConfig)
  static void setEnvironmentFlags({
    required bool isDevelopment,
    required bool isStaging,
    required bool isProduction,
  }) {
    _isDevelopment = isDevelopment;
    _isStaging = isStaging;
    _isProduction = isProduction;
  }
  
  // Development URLs (Platform-specific)
  static const String _developmentWebUrl = 'http://localhost:8880';
  static const String _developmentMobileUrl = 'http://192.168.31.99:8880';
  
  // Staging URLs
  static const String _stagingUrl = 'https://staging-api.cosmeticstore.com';
  
  // Production URLs
  static const String _productionUrl = 'https://codeasthetics.com/api';
  
  // Base URL selection logic
  static String get baseUrl {
    if (isDevelopment) {
      // Development environment - choose based on platform
      if (kIsWeb) {
        return _developmentWebUrl;
      } else {
        return _developmentMobileUrl;
      }
    } else if (isStaging) {
      return _stagingUrl;
    } else {
      return _productionUrl;
    }
  }
  
  // WebSocket URLs
  static String get websocketUrl {
    if (isDevelopment) {
      if (kIsWeb) {
        return 'ws://localhost:8880';
      } else {
        return 'ws://localhost:8880';
      }
    } else if (isStaging) {
      return 'wss://staging-ws.cosmeticstore.com';
    } else {
      return 'wss://codeasthetics.com/api';
    }
  }
  
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  
  static const Duration tokenRefreshInterval = Duration(minutes: 55);
  static const Duration requestTimeout = Duration(seconds: 30);
  
  static const String defaultLanguage = 'en';
  static const String defaultCurrency = 'USD';
  
  static const int itemsPerPage = 20;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Feature Flags
  static bool get enableLogging => isDevelopment;
  static bool get enableDebugMode => isDevelopment;
  static bool get enableAnalytics => !isDevelopment;
  
  // Security Configuration
  static bool get enableSSLPinning => !isDevelopment;
  
  // Cache Configuration
  static Duration get cacheTimeout {
    if (isDevelopment) {
      return const Duration(minutes: 5);
    } else if (isStaging) {
      return const Duration(minutes: 15);
    } else {
      return const Duration(hours: 1);
    }
  }
  
  // Database Configuration
  static String get databaseName {
    if (isDevelopment) {
      return 'cosmetic_store_dev.db';
    } else if (isStaging) {
      return 'cosmetic_store_staging.db';
    } else {
      return 'cosmetic_store.db';
    }
  }
  
  // Third-party Service Keys (use environment variables in production)
  static String get googleApiKey {
    if (isDevelopment) {
      return 'dev_google_api_key';
    } else if (isStaging) {
      return 'staging_google_api_key';
    } else {
      return const String.fromEnvironment('GOOGLE_API_KEY', defaultValue: '');
    }
  }
  
  static String get firebaseProjectId {
    if (isDevelopment) {
      return 'cosmetic-store-dev';
    } else if (isStaging) {
      return 'cosmetic-store-staging';
    } else {
      return 'cosmetic-store-prod';
    }
  }
  
  // Payment Gateway Configuration
  static String get stripePublishableKey {
    if (isDevelopment) {
      return 'pk_test_dev_key';
    } else if (isStaging) {
      return 'pk_test_staging_key';
    } else {
      return const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
    }
  }
  
  // Social Media Login
  static String get googleClientId {
    if (isDevelopment) {
      return 'dev_google_client_id';
    } else if (isStaging) {
      return 'staging_google_client_id';
    } else {
      return const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
    }
  }
  
  static String get facebookAppId {
    if (isDevelopment) {
      return 'dev_facebook_app_id';
    } else if (isStaging) {
      return 'staging_facebook_app_id';
    } else {
      return const String.fromEnvironment('FACEBOOK_APP_ID', defaultValue: '');
    }
  }

}

