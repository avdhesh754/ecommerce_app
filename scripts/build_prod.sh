#!/bin/bash

echo "🚀 Building for Production Environment..."

# Set environment variables for production
export FLAVOR=prod
export ENVIRONMENT=production

# Ensure environment variables are set for production secrets
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "⚠️  Warning: GOOGLE_API_KEY not set"
fi

if [ -z "$STRIPE_PUBLISHABLE_KEY" ]; then
    echo "⚠️  Warning: STRIPE_PUBLISHABLE_KEY not set"
fi

if [ -z "$GOOGLE_CLIENT_ID" ]; then
    echo "⚠️  Warning: GOOGLE_CLIENT_ID not set"
fi

if [ -z "$FACEBOOK_APP_ID" ]; then
    echo "⚠️  Warning: FACEBOOK_APP_ID not set"
fi

# Build for different platforms
echo "📱 Building Android APK (Release)..."
flutter build apk --release --target lib/main_prod.dart --flavor prod \
    --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
    --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID"

echo "📱 Building Android Bundle (Release)..."
flutter build appbundle --release --target lib/main_prod.dart --flavor prod \
    --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
    --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building iOS (Release)..."
    flutter build ios --release --target lib/main_prod.dart --flavor prod \
        --dart-define=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
        --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
        --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
        --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID"
fi

echo "✅ Production build completed!"
echo "📱 APK Location: build/app/outputs/flutter-apk/app-prod-release.apk"
echo "📱 Bundle Location: build/app/outputs/bundle/prodRelease/app-prod-release.aab"
echo ""
echo "🔒 Production build includes:"
echo "   - SSL Pinning enabled"
echo "   - Debug logging disabled"
echo "   - Analytics enabled"
echo "   - Environment-specific API endpoints"