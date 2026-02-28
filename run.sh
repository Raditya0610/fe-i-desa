#!/bin/bash

# Apps I-Desa - Run Script
# This script runs the Flutter desktop app on macOS

echo "🚀 Starting Apps I-Desa..."
echo ""

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev"
    exit 1
fi

# Navigate to project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
builtin cd "$SCRIPT_DIR"

echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Building and running on macOS..."
echo ""

flutter run -d macos

echo ""
echo "✅ App closed"
