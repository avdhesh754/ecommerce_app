# Environment Configuration

This project supports three environments: **Development**, **Staging**, and **Production**. Each environment has its own configuration, API endpoints, and build settings.

## 🏗️ Environment Setup

### Development Environment
- **Purpose**: Local development and testing
- **API URL**: `http://localhost:3000`
- **WebSocket URL**: `ws://localhost:3000`
- **Features**: 
  - Debug logging enabled
  - Debug mode enabled
  - Analytics disabled
  - SSL pinning disabled
- **App Name**: Cosmetic Store (Dev)
- **App ID**: com.cosmeticstore.app.dev

### Staging Environment
- **Purpose**: Testing with production-like data
- **API URL**: `https://staging-api.cosmeticstore.com`
- **WebSocket URL**: `wss://staging-ws.cosmeticstore.com`
- **Features**:
  - Debug logging enabled
  - Debug mode disabled
  - Analytics enabled
  - SSL pinning enabled
- **App Name**: Cosmetic Store (Staging)
- **App ID**: com.cosmeticstore.app.staging

### Production Environment
- **Purpose**: Live production app
- **API URL**: `https://api.cosmeticstore.com`
- **WebSocket URL**: `wss://ws.cosmeticstore.com`
- **Features**:
  - Debug logging disabled
  - Debug mode disabled
  - Analytics enabled
  - SSL pinning enabled
- **App Name**: Cosmetic Store
- **App ID**: com.cosmeticstore.app

## 🚀 Running the App

### Development
```bash
# Run with development configuration
flutter run --target lib/main_dev.dart --flavor dev

# Or simply run the default main.dart (uses dev by default)
flutter run
```

### Staging
```bash
# Run with staging configuration
flutter run --target lib/main_staging.dart --flavor staging
```

### Production
```bash
# Run with production configuration
flutter run --target lib/main_prod.dart --flavor prod
```

## 📦 Building the App

### Using Build Scripts (Recommended)
```bash
# Development build
./scripts/build_dev.sh

# Staging build
./scripts/build_staging.sh

# Production build (requires environment variables)
export GOOGLE_API_KEY="your_google_api_key"
export STRIPE_PUBLISHABLE_KEY="your_stripe_key"
export GOOGLE_CLIENT_ID="your_google_client_id"
export FACEBOOK_APP_ID="your_facebook_app_id"
./scripts/build_prod.sh
```

### Manual Build Commands

#### Development
```bash
# Android APK
flutter build apk --debug --target lib/main_dev.dart --flavor dev

# Android Bundle
flutter build appbundle --debug --target lib/main_dev.dart --flavor dev

# iOS (macOS only)
flutter build ios --debug --target lib/main_dev.dart --flavor dev
```

#### Staging
```bash
# Android APK
flutter build apk --release --target lib/main_staging.dart --flavor staging

# Android Bundle
flutter build appbundle --release --target lib/main_staging.dart --flavor staging

# iOS (macOS only)
flutter build ios --release --target lib/main_staging.dart --flavor staging
```

#### Production
```bash
# Android APK
flutter build apk --release --target lib/main_prod.dart --flavor prod \
    --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY"

# Android Bundle
flutter build appbundle --release --target lib/main_prod.dart --flavor prod \
    --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY"

# iOS (macOS only)
flutter build ios --release --target lib/main_prod.dart --flavor prod \
    --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY"
```

## 🔧 Configuration Details

### Environment Variables for Production
Create a `.env.prod` file or set these environment variables:

```bash
GOOGLE_API_KEY=your_google_api_key_here
STRIPE_PUBLISHABLE_KEY=pk_live_your_stripe_key_here
GOOGLE_CLIENT_ID=your_google_oauth_client_id
FACEBOOK_APP_ID=your_facebook_app_id
```

### Timeout Settings
- **Development**: 30 seconds
- **Staging**: 15 seconds
- **Production**: 10 seconds

### Cache Settings
- **Development**: 5 minutes
- **Staging**: 15 minutes
- **Production**: 1 hour

### Database Names
- **Development**: `cosmetic_store_dev.db`
- **Staging**: `cosmetic_store_staging.db`
- **Production**: `cosmetic_store.db`

## 📱 Android Flavors

The project includes Android flavors for each environment:

- **dev**: Development flavor with debug features
- **staging**: Staging flavor for testing
- **prod**: Production flavor for release

Each flavor has:
- Different application ID suffixes
- Different app names
- Environment-specific configurations

## 🛠️ Development Workflow

1. **Development**: Use `main_dev.dart` for daily development
2. **Testing**: Deploy to staging using `main_staging.dart`
3. **Release**: Build production using `main_prod.dart` with proper environment variables

## 🔍 Environment Detection

You can check the current environment in your code:

```dart
import 'package:cosmetic_ecommerce_app/core/config/environment.dart';

// Check current environment
if (EnvironmentConfig.isDevelopment) {
  // Development-specific code
}

if (EnvironmentConfig.isStaging) {
  // Staging-specific code
}

if (EnvironmentConfig.isProduction) {
  // Production-specific code
}

// Get environment-specific values
final apiUrl = EnvironmentConfig.apiBaseUrl;
final enableLogging = EnvironmentConfig.enableLogging;
```

## 🚨 Important Notes

1. **Never commit production secrets** to version control
2. **Always test in staging** before deploying to production
3. **Use environment variables** for sensitive data in production
4. **Enable SSL pinning** in staging and production
5. **Disable debug logging** in production for security

## 📋 Checklist Before Release

- [ ] All environment variables are set for production
- [ ] SSL pinning is enabled
- [ ] Debug logging is disabled
- [ ] Analytics are properly configured
- [ ] App signing is set up for release builds
- [ ] Testing completed in staging environment
- [ ] Performance testing completed
- [ ] Security review completed