#!/bin/bash
# ============================================================================
# Xcode Pre-Build Script for OpenInstall SDK Simulator Support
# ============================================================================
#
# This script can be added as a Pre-action in your Xcode Build Scheme to
# automatically detect simulator builds and run pod install with the correct
# configuration.
#
# How to add this script to Xcode:
# 1. Open Xcode
# 2. Go to Product > Scheme > Edit Scheme
# 3. Select "Build" in the left sidebar
# 4. Click "Pre-actions" at the bottom
# 5. Click "+" and select "New Run Script Action"
# 6. Set "Provide build settings from" to your target
# 7. Paste the contents of this script (or source this file)
#
# Alternatively, use the environment variable approach documented in the Podfile.
# ============================================================================

set -e

echo "=== OpenInstall SDK Build Configuration ==="

# Check if this is a simulator build
if [[ "${SDK_NAME}" == *"simulator"* ]] || [[ "${PLATFORM_NAME}" == *"simulator"* ]]; then
    echo "🔧 Detected simulator build"
    
    # Navigate to ios directory
    cd "${SRCROOT}"
    
    # Check if we need to re-run pod install
    if [ ! -f ".simulator_pods_installed" ]; then
        echo "📦 Running pod install with SKIP_OPENINSTALL_SDK=1..."
        export SKIP_OPENINSTALL_SDK=1
        pod install
        touch ".simulator_pods_installed"
        # Remove device marker if exists
        rm -f ".device_pods_installed"
        echo "✅ Pods installed for simulator"
    else
        echo "✅ Simulator pods already installed"
    fi
else
    echo "🔧 Detected device build"
    
    # Navigate to ios directory
    cd "${SRCROOT}"
    
    # Check if we need to re-run pod install
    if [ ! -f ".device_pods_installed" ]; then
        echo "📦 Running pod install with full SDK..."
        unset SKIP_OPENINSTALL_SDK
        pod install
        touch ".device_pods_installed"
        # Remove simulator marker if exists
        rm -f ".simulator_pods_installed"
        echo "✅ Pods installed for device"
    else
        echo "✅ Device pods already installed"
    fi
fi

echo "=== Build Configuration Complete ==="
