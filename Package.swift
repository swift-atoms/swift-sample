// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-sample",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Sample Primitive",
            targets: ["Sample Primitive"]
        ),

        .library(
            name: "Sample Averaging",
            targets: ["Sample Averaging"]
        ),
        .library(
            name: "Sample Accumulator",
            targets: ["Sample Accumulator"]
        ),
        .library(
            name: "Sample Batch",
            targets: ["Sample Batch"]
        ),

        .library(
            name: "Sample",
            targets: ["Sample"]
        ),

        .library(
            name: "Sample Test Support",
            targets: ["Sample Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-order.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-algebra.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-witness.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-time.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Sample Primitive",
            dependencies: []
        ),

        .target(
            name: "Sample Averaging",
            dependencies: [
                "Sample Primitive",
                .product(name: "Time Primitive", package: "swift-time"),
                .product(name: "Witness", package: "swift-witness"),
            ]
        ),
        .target(
            name: "Sample Accumulator",
            dependencies: [
                "Sample Primitive",
                .product(name: "Algebra Monoid", package: "swift-algebra"),
            ]
        ),
        .target(
            name: "Sample Batch",
            dependencies: [
                "Sample Primitive",
                "Sample Averaging",
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Order", package: "swift-order"),
            ]
        ),

        .target(
            name: "Sample",
            dependencies: [
                "Sample Primitive",
                "Sample Averaging",
                "Sample Accumulator",
                "Sample Batch",
            ]
        ),

        .target(
            name: "Sample Test Support",
            dependencies: [
                "Sample"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Sample Tests",
            dependencies: [
                "Sample",
                "Sample Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
