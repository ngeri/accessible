// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Accessible",
    products: [
        .library(name: "Accessible", targets: ["Accessible"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ngergo100/IBDecodable", .revision("f5323c2231811256e49f5c5fc723467a7965f5fa")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.5.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Accessible",
            dependencies: ["IBDecodable", "StencilSwiftKit", "Yams"]),
        .testTarget(
            name: "AccessibleTests",
            dependencies: ["Accessible"]),
    ]
)
