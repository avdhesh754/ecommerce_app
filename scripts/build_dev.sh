#!/bin/bash

echo "🚀 Building for Development Environment..."

# Set environment variables for development
export FLAVOR=dev
export ENVIRONMENT=development

# Build for different platforms
echo "📱 Building Android APK (Debug)..."
flutter build apk --debug --target lib/main_dev.dart --flavor dev

echo "📱 Building Android Bundle (Debug)..."
flutter build appbundle --debug --target lib/main_dev.dart --flavor dev

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building iOS (Debug)..."
    flutter build ios --debug --target lib/main_dev.dart --flavor dev
fi

echo "✅ Development build completed!"
echo "📱 APK Location: build/app/outputs/flutter-apk/app-dev-debug.apk"
echo "📱 Bundle Location: build/app/outputs/bundle/devDebug/app-dev-debug.aab"