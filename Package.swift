// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessibleStoryboard",
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBDecodable", .revision("bcbbaef6d8daad7001c824b6514362b286e8539e")),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.11.0")
    ],
    targets: [
        .target(
            name: "AccessibleStoryboard",
            dependencies: ["IBDecodable", "Stencil"]),
    ]
)
