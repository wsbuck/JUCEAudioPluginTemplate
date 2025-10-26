## Build

All plugins are automatically code-signed after build for local development.

### Debug Build (Recommended for Development)
```bash
# Configure and build in Debug mode
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug

# Run the standalone app
open build/JUCESamplePlugin_artefacts/Debug/Standalone/JUCESamplePlugin.app
```

### Release Build
```bash
# Configure the build
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1

# Build the project
cmake --build build --config Release

# Run the standalone app
open build/JUCESamplePlugin_artefacts/Release/Standalone/JUCESamplePlugin.app
```

### Plugin Locations
After building, plugins are installed to:
- **Standalone**: `build/JUCESamplePlugin_artefacts/Debug|Release/Standalone/JUCESamplePLugin.app`
- **AU**: `~/Library/Audio/Plug-Ins/Components/JUCESamplePlugin.component`
- **VST3**: `~/Library/Audio/Plug-Ins/VST3/JUCESamplePlugin.vst3`

### For Xcode
```bash
cmake -B build -G Xcode
open build/JUCESamplePlugin.xcodeproj
```
