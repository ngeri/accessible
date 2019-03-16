// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessibleTool",
    products: [
        .library(name: "AccessibleCore", targets: ["AccessibleCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBDecodable", .revision("3f1289222c5323605dede3e616e0f549bcb7c335")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.7.2"),
        .package(url: "https://github.com/jpsim/Yams", from: "1.0.1")
    ],
    targets: [
        .target(name: "AccessibleTool", dependencies: ["AccessibleCore"], path: "Sources/AccessibleTool"),
        .target(name: "AccessibleCore", dependencies: ["IBDecodable", "StencilSwiftKit", "Yams"], path: "Sources/AccessibleCore"),
        .testTarget(name: "AccessibleTests", dependencies: ["AccessibleCore"], path: "Tests")
    ]
)
