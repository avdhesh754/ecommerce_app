# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a unified Flutter cosmetic ecommerce app with both admin and customer interfaces built using GetX for state management and clean architecture principles.

## Development Commands

### Environment-Specific Commands

#### Development (Default)
- `flutter run` - Run with development configuration
- `flutter run --target lib/main_dev.dart --flavor dev`
- `./scripts/build_dev.sh` - Build development version

#### Staging
- `flutter run --target lib/main_staging.dart --flavor staging`
- `./scripts/build_staging.sh` - Build staging version

#### Production
- `flutter run --target lib/main_prod.dart --flavor prod`
- `./scripts/build_prod.sh` - Build production version (requires env vars)

### Build & Run
- `flutter run` - Run the app in debug mode (development)
- `flutter build apk` - Build APK for Android
- `flutter build ios` - Build for iOS
- `flutter build web` - Build for web

### Analysis & Linting
- `flutter analyze` - Run static analysis (uses analysis_options.yaml with flutter_lints)
- `dart format .` - Format all Dart files
- `dart fix --apply` - Apply automated fixes

### Testing
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file

### Dependencies
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies

## Architecture

### Clean Architecture Structure
The app follows clean architecture with feature-based organization:

```
lib/
├── app/                     # App-level configuration
│   ├── app.dart            # Main app widget
│   └── routes/             # Navigation routes and middleware
├── core/                   # Shared core functionality
│   ├── constants/          # API endpoints, app constants
│   ├── network/           # HTTP client configuration
│   ├── storage/           # Local storage service
│   ├── theme/             # App theming
│   └── utils/             # Utilities and validators
├── features/              # Feature modules
│   ├── auth/              # Authentication (clean arch layers)
│   ├── admin/             # Admin dashboard, products, users, orders
│   ├── customer/          # Customer interface
│   └── splash/            # Splash screen
└── shared/                # Shared models and widgets
```

### Key Architecture Patterns
- **GetX State Management**: Used for dependency injection, state management, and routing
- **Clean Architecture**: Each feature has data/domain/presentation layers (auth feature fully implemented)
- **Repository Pattern**: Data abstraction layer with local/remote data sources
- **Dependency Injection**: Services initialized in main.dart and managed by GetX

### Key Services
- **StorageService**: SharedPreferences wrapper for local storage
- **WebSocketService**: Real-time communication service
- **AuthController**: Global authentication state management
- **ApiClient**: HTTP client with interceptors (in core/network/)

### User Roles
The app supports multiple user roles defined in `core/enums/user_role.dart`:
- Admin users access admin dashboard with product/user/order management
- Customer users access shopping interface with cart and orders

### Authentication Flow
- JWT-based authentication with token storage
- Auth middleware for route protection
- Automatic token refresh and logout handling

### Responsive Design
- Custom responsive breakpoints in `core/utils/responsive_breakpoints.dart`
- Separate admin and customer responsive layouts
- Responsive text and sizing utilities in shared/widgets/

### Backend Integration
- REST API integration with Dio HTTP client
- WebSocket integration for real-time features
- API endpoints centralized in `core/constants/api_endpoints.dart`
- Environment-specific API URLs configured in `core/config/environment.dart`
- Postman collection available: `Cosmetic-Ecommerce-Backend.postman_collection.json`

### Environment Configuration
- **Development**: `http://localhost:3000` - Local development server
- **Staging**: `https://staging-api.cosmeticstore.com` - Staging server
- **Production**: `https://api.cosmeticstore.com` - Production server

### Multi-Environment Support
- Three separate entry points: `main_dev.dart`, `main_staging.dart`, `main_prod.dart`
- Environment-specific configurations for timeouts, logging, analytics
- Android flavors: dev, staging, prod with different app IDs
- Environment variables support for production secrets
- Comprehensive logging system with environment-based levels