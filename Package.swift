// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: []
        ),
        .testTarget(
                name: "NetworkLayerTests",
                dependencies: ["NetworkLayer"]
            )
    ]
)
