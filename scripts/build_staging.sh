#!/bin/bash

echo "🚀 Building for Staging Environment..."

# Set environment variables for staging
export FLAVOR=staging
export ENVIRONMENT=staging

# Build for different platforms
echo "📱 Building Android APK (Release)..."
flutter build apk --release --target lib/main_staging.dart --flavor staging

echo "📱 Building Android Bundle (Release)..."
flutter build appbundle --release --target lib/main_staging.dart --flavor staging

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building iOS (Release)..."
    flutter build ios --release --target lib/main_staging.dart --flavor staging
fi

echo "✅ Staging build completed!"
echo "📱 APK Location: build/app/outputs/flutter-apk/app-staging-release.apk"
echo "📱 Bundle Location: build/app/outputs/bundle/stagingRelease/app-staging-release.aab"