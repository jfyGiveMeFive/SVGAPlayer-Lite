// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGAPlayerLite",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SVGAPlayerLite",
            targets: ["SVGAPlayerLite"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", exact: "2.4.3")
    ],
    targets: [
        // Protobuf Objective-C Runtime + SVGAProto (precompiled XCFramework)
        .binaryTarget(
            name: "ProtobufObjC",
            path: "Frameworks/ProtobufObjC.xcframework"
        ),
        // Main SVGAPlayerLite target
        .target(
            name: "SVGAPlayerLite",
            dependencies: [
                "ProtobufObjC",
                .product(name: "ZipArchive", package: "ZipArchive"),
            ],
            path: "Source",
            exclude: [
                "pbobjc",
                "include",
            ],
            publicHeadersPath: "include",
            cSettings: [
                .define("SVGA_USE_SPM", to: "1"),
                .headerSearchPath("."),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("QuartzCore"),
            ]
        ),
    ]
)
