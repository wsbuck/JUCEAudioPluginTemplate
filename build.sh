#!/bin/bash

# Build script for JUCESamplePlugin JUCE project
# Usage: ./build.sh [debug|release|clean]

set -e  # Exit on error

BUILD_TYPE="Debug"
OPEN_APP=false

# Parse command line arguments
case "${1:-debug}" in
    debug)
        BUILD_TYPE="Debug"
        OPEN_APP=false
        ;;
    release)
        BUILD_TYPE="Release"
        OPEN_APP=false
        ;;
    clean)
        echo "🧹 Cleaning build directory..."
        rm -rf build
        echo "✅ Clean complete"
        exit 0
        ;;
    *)
        echo "Usage: $0 [debug|release|clean]"
        echo "  debug   - Build in Debug mode (default)"
        echo "  release - Build in Release mode"
        echo "  clean   - Remove build directory"
        exit 1
        ;;
esac

echo "🔧 Configuring CMake for $BUILD_TYPE build..."
if [ "$BUILD_TYPE" = "Release" ]; then
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1
else
    cmake -B build -DCMAKE_BUILD_TYPE=Debug
fi

echo ""
echo "🔨 Building project..."
cmake --build build --config $BUILD_TYPE

echo ""
echo "✅ Build complete!"
echo ""
echo "📦 Plugin locations:"
echo "  Standalone: build/JUCESamplePlugin_artefacts/$BUILD_TYPE/Standalone/JUCESamplePlugin.app"
echo "  AU:         ~/Library/Audio/Plug-Ins/Components/JUCESamplePlugin.component"
echo "  VST3:       ~/Library/Audio/Plug-Ins/VST3/JUCESamplePlugin.vst3"

if [ "$OPEN_APP" = true ]; then
    echo ""
    echo "🚀 Launching standalone app..."
    open build/JUCESamplePlugin_artefacts/$BUILD_TYPE/Standalone/JUCESamplePlugin.app
fi
