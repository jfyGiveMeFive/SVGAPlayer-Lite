// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGAPlayerLite",
    platforms: [
        .iOS("15.5"),
        .macOS(.v10_15),
        .macCatalyst("15.5"),
    ],
    products: [
        .library(
            name: "SVGAPlayerLite",
            targets: ["SVGAPlayerLite"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.5.0")
    ],
    targets: [
        // Protobuf Objective-C Runtime (non-ARC) - Third-party library
        .target(
            name: "ProtobufObjC",
            path: "Protobuf",
            exclude: [
                // GPBProtocolBuffers.m uses #import to include all other .m files,
                // which causes duplicate symbol errors when SPM also compiles them separately.
                // Exclude this file and let SPM compile each .m file individually.
                "GPBProtocolBuffers.m"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .define("GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS", to: "0"),
                .unsafeFlags(["-fno-objc-arc"]),
            ]
        ),
        // SVGA Proto Files (non-ARC)
        .target(
            name: "SVGAProto",
            dependencies: ["ProtobufObjC"],
            path: "Source/pbobjc",
            publicHeadersPath: ".",
            cSettings: [
                .define("GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS", to: "0"),
                .headerSearchPath("../../Protobuf"),
                .unsafeFlags(["-fno-objc-arc"]),
            ]
        ),
        // Main SVGAPlayerLite target
        .target(
            name: "SVGAPlayerLite",
            dependencies: [
                "ProtobufObjC",
                "SVGAProto",
                .product(name: "ZipArchive", package: "ZipArchive"),
            ],
            path: "Source",
            exclude: [
                "pbobjc",
                "include",
            ],
            publicHeadersPath: "include",
            cSettings: [
                .define("GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS", to: "0"),
                .headerSearchPath("."),
                .headerSearchPath("pbobjc"),
                .headerSearchPath("../Protobuf"),
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
