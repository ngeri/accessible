// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessibleTool",
    products: [
        .library(name: "AccessibleCore", targets: ["AccessibleCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBDecodable", .revision("c472ff9851f2815f3878bc9ff4edb72f5e63bc67")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.5.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "AccessibleTool", dependencies: ["AccessibleCore"], path: "Sources/AccessibleTool"),
        .target(name: "AccessibleCore", dependencies: ["IBDecodable", "StencilSwiftKit", "Yams"], path: "Sources/AccessibleCore"),
        .testTarget(name: "AccessibleTests", dependencies: ["AccessibleCore"], path: "Tests")
    ]
)
