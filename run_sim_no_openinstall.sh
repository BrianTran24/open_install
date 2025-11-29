#!/usr/bin/env bash
set -e

# ============================================================================
# Run iOS Simulator without OpenInstallSDK
# ============================================================================
# This script builds and runs the Flutter app on iOS simulator without the
# libOpenInstallSDK dependency, which doesn't have simulator architecture slices.
#
# The script:
# 1. Sets SKIP_OPENINSTALL_SDK=1 environment variable
# 2. Runs flutter pub get
# 3. Runs pod install (which will skip libOpenInstallSDK)
# 4. Runs the app on iOS simulator
#
# The plugin's Objective-C code uses TARGET_OS_SIMULATOR preprocessor for
# conditional compilation, so stub implementations are used on simulator.
# ============================================================================

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

# Set environment variable to skip OpenInstallSDK
export SKIP_OPENINSTALL_SDK=1

echo "===> Setting SKIP_OPENINSTALL_SDK=1 for simulator build..."

echo "===> flutter pub get..."
fvm flutter pub get

echo "===> pod install (without libOpenInstallSDK)..."
cd ios
pod install
cd ..

echo "===> Run on iOS simulator (without OpenInstallSDK)..."
fvm flutter run -d "iPhone 16 Pro"

echo "Done."
