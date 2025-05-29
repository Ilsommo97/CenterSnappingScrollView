// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "CenterSnappingScrollView",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CenterSnappingScrollView",
            targets: ["CenterSnappingScrollView"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CenterSnappingScrollView",
            dependencies: []
        ),
        .testTarget(
            name: "CenterSnappingScrollViewTests",
            dependencies: ["CenterSnappingScrollView"]
        ),
    ]
)
