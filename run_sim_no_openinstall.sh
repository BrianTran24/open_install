#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

PLUGIN_PODSPEC="plugins/openinstall_flutter_plugin/ios/openinstall_flutter_plugin.podspec"
BACKUP_PODSPEC="${PLUGIN_PODSPEC}.backup_for_sim"

restore_podspec() {
  if [ -f "$BACKUP_PODSPEC" ]; then
    echo "===> Restoring original openinstall_flutter_plugin.podspec..."
    mv "$BACKUP_PODSPEC" "$PLUGIN_PODSPEC"
  fi
}

trap restore_podspec EXIT

echo "===> flutter pub get..."
fvm flutter pub get

if [ -f "$PLUGIN_PODSPEC" ]; then
  echo "===> Backup podspec..."
  cp "$PLUGIN_PODSPEC" "$BACKUP_PODSPEC"

  echo "===> Patch podspec to remove libOpenInstallSDK..."
  sed '/libOpenInstallSDK/d' "$PLUGIN_PODSPEC" > "${PLUGIN_PODSPEC}.tmp"
  mv "${PLUGIN_PODSPEC}.tmp" "$PLUGIN_PODSPEC"
fi

echo "===> pod install (without deintegrate)..."
cd ios
pod install
cd ..

echo "===> Run on iOS simulator (without OpenInstallSDK)..."
fvm flutter run -d "iPhone 16 Pro"

echo "Done. Podspec will be restored."
