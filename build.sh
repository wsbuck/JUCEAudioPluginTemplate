#!/bin/bash

# Build script for JUCE project
# Usage: ./build.sh [debug|release|clean]

set -e  # Exit on error

PROJ_NAME="JUCEAudioPluginName"
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
cmake -B build -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=1

# Create symlink for LSP (clangd, etc.)
if [ ! -L "compile_commands.json" ]; then
    ln -sf build/compile_commands.json compile_commands.json
fi

echo ""
echo "🔨 Building project..."
cmake --build build --config $BUILD_TYPE

echo ""
echo "✅ Build complete!"
echo ""
echo "📦 Installing VST3 plugin..."

# Copy VST3 plugin if it exists
if [ -d "build/${PROJ_NAME}_artefacts/$BUILD_TYPE/VST3/$PROJ_NAME.vst3" ]; then
    cp -R "build/${PROJ_NAME}_artefacts/$BUILD_TYPE/VST3/$PROJ_NAME.vst3" ~/Library/Audio/Plug-Ins/VST3/
    echo "  ✓ VST3 installed to ~/Library/Audio/Plug-Ins/VST3/$PROJ_NAME.vst3"
fi

echo ""
echo "📦 Plugin locations:"
echo "  Standalone: build/${PROJ_NAME}_artefacts/$BUILD_TYPE/Standalone/$PROJ_NAME.app"
echo "  AU:         ~/Library/Audio/Plug-Ins/Components/$PROJ_NAME.component"
echo "  VST3:       ~/Library/Audio/Plug-Ins/VST3/$PROJ_NAME.vst3"

if [ "$OPEN_APP" = true ]; then
    echo ""
    echo "🚀 Launching standalone app..."
    open build/${PROJ_NAME}_artefacts/$BUILD_TYPE/Standalone/$PROJ_NAME.app
fi
