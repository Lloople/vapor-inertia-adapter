// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "vapor-inertia-adapter",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "VaporInertiaAdapter", targets: ["VaporInertiaAdapter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "VaporInertiaAdapter", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Leaf", package: "leaf"),
        ]),
        .testTarget(name: "VaporInertiaAdapterTests", dependencies: [
            .target(name: "VaporInertiaAdapter"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
    ]
)
