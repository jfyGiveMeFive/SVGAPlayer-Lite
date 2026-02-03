#!/bin/bash

# Build ProtobufObjC.xcframework from source
# This script compiles the Protobuf Objective-C runtime + SVGAProto into an XCFramework

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PROTOBUF_DIR="$PROJECT_ROOT/Protobuf"
SVGAPROTO_DIR="$PROJECT_ROOT/Source/pbobjc"
BUILD_DIR="$PROJECT_ROOT/build"
OUTPUT_DIR="$PROJECT_ROOT/Frameworks"

# Clean previous builds
rm -rf "$BUILD_DIR"
rm -rf "$OUTPUT_DIR/ProtobufObjC.xcframework"
mkdir -p "$BUILD_DIR"
mkdir -p "$OUTPUT_DIR"

echo "📦 Building ProtobufObjC.xcframework..."

# Protobuf source files (excluding GPBProtocolBuffers.m to avoid duplicate symbols)
PROTOBUF_SOURCES=$(find "$PROTOBUF_DIR" -name "*.m" ! -name "GPBProtocolBuffers.m")

# SVGAProto source files
SVGAPROTO_SOURCES=$(find "$SVGAPROTO_DIR" -name "*.m")

# All sources
ALL_SOURCES="$PROTOBUF_SOURCES $SVGAPROTO_SOURCES"

# Header files
PROTOBUF_HEADERS=$(find "$PROTOBUF_DIR" -name "*.h")
SVGAPROTO_HEADERS=$(find "$SVGAPROTO_DIR" -name "*.h")

# Common compiler flags
COMMON_FLAGS="-fno-objc-arc -DGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=0 -fobjc-weak -I$PROTOBUF_DIR -I$SVGAPROTO_DIR -fmodules -w"

# Function to build static library for a specific platform
build_library() {
    local PLATFORM=$1
    local ARCH=$2
    local SDK=$3
    local MIN_VERSION_FLAG=$4
    
    echo "🔨 Building for $PLATFORM ($ARCH)..."
    
    local PLATFORM_BUILD_DIR="$BUILD_DIR/$PLATFORM-$ARCH"
    mkdir -p "$PLATFORM_BUILD_DIR"
    
    local SDK_PATH=$(xcrun --sdk $SDK --show-sdk-path)
    
    # Compile each source file
    for src in $ALL_SOURCES; do
        local filename=$(basename "$src" .m)
        xcrun --sdk $SDK clang -c "$src" \
            -arch $ARCH \
            -isysroot "$SDK_PATH" \
            $MIN_VERSION_FLAG \
            $COMMON_FLAGS \
            -o "$PLATFORM_BUILD_DIR/$filename.o"
    done
    
    # Create static library
    xcrun --sdk $SDK libtool -static -o "$PLATFORM_BUILD_DIR/libProtobufObjC.a" "$PLATFORM_BUILD_DIR"/*.o
    
    echo "✅ Built $PLATFORM_BUILD_DIR/libProtobufObjC.a"
}

# Build for iOS Device (arm64)
build_library "ios" "arm64" "iphoneos" "-mios-version-min=12.0"

# Build for iOS Simulator (arm64)
build_library "ios-simulator" "arm64" "iphonesimulator" "-mios-simulator-version-min=12.0"

# Build for iOS Simulator (x86_64)
build_library "ios-simulator" "x86_64" "iphonesimulator" "-mios-simulator-version-min=12.0"

# Create fat library for simulator (arm64 + x86_64)
echo "🔗 Creating fat library for iOS Simulator..."
mkdir -p "$BUILD_DIR/ios-simulator-universal"
xcrun lipo -create \
    "$BUILD_DIR/ios-simulator-arm64/libProtobufObjC.a" \
    "$BUILD_DIR/ios-simulator-x86_64/libProtobufObjC.a" \
    -output "$BUILD_DIR/ios-simulator-universal/libProtobufObjC.a"

# Create module.modulemap
echo "📝 Creating module map..."
cat > "$BUILD_DIR/module.modulemap" << 'EOF'
framework module ProtobufObjC {
    umbrella header "ProtobufObjC.h"
    
    export *
    module * { export * }
}
EOF

# Create umbrella header
cat > "$BUILD_DIR/ProtobufObjC.h" << 'EOF'
// ProtobufObjC Umbrella Header
// Includes Protobuf runtime and SVGAProto

#import <Foundation/Foundation.h>

// Protobuf Runtime
#import <ProtobufObjC/GPBProtocolBuffers.h>

// SVGA Proto
#import <ProtobufObjC/Svga.pbobjc.h>
EOF

# Function to create framework structure
create_framework() {
    local PLATFORM=$1
    local LIB_PATH=$2
    
    local FRAMEWORK_DIR="$BUILD_DIR/$PLATFORM/ProtobufObjC.framework"
    mkdir -p "$FRAMEWORK_DIR/Headers"
    mkdir -p "$FRAMEWORK_DIR/Modules"
    
    # Copy library
    cp "$LIB_PATH" "$FRAMEWORK_DIR/ProtobufObjC"
    
    # Copy Protobuf headers
    for header in $PROTOBUF_HEADERS; do
        cp "$header" "$FRAMEWORK_DIR/Headers/"
    done
    
    # Copy SVGAProto headers
    for header in $SVGAPROTO_HEADERS; do
        cp "$header" "$FRAMEWORK_DIR/Headers/"
    done
    
    # Copy umbrella header
    cp "$BUILD_DIR/ProtobufObjC.h" "$FRAMEWORK_DIR/Headers/"
    
    # Copy module map
    cp "$BUILD_DIR/module.modulemap" "$FRAMEWORK_DIR/Modules/"
    
    # Create Info.plist
    cat > "$FRAMEWORK_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>ProtobufObjC</string>
    <key>CFBundleIdentifier</key>
    <string>com.svgaplayer.ProtobufObjC</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>ProtobufObjC</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>3.27.2</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>MinimumOSVersion</key>
    <string>12.0</string>
</dict>
</plist>
EOF
    
    echo "✅ Created $FRAMEWORK_DIR"
}

# Create frameworks
echo "📁 Creating framework structures..."
create_framework "ios-device" "$BUILD_DIR/ios-arm64/libProtobufObjC.a"
create_framework "ios-simulator" "$BUILD_DIR/ios-simulator-universal/libProtobufObjC.a"

# Create XCFramework
echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/ios-device/ProtobufObjC.framework" \
    -framework "$BUILD_DIR/ios-simulator/ProtobufObjC.framework" \
    -output "$OUTPUT_DIR/ProtobufObjC.xcframework"

echo "✅ Created $OUTPUT_DIR/ProtobufObjC.xcframework"

# Clean up build directory
rm -rf "$BUILD_DIR"

echo ""
echo "🎉 Done! XCFramework created at: $OUTPUT_DIR/ProtobufObjC.xcframework"
echo "   Includes: Protobuf ObjC Runtime + SVGAProto"
