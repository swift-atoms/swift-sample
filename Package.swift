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
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-order.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-algebra.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-witness.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-time.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Sample",
            dependencies: []
        ),

        .target(
            name: "Sample Averaging",
            dependencies: [
                .target(name: "Sample"),
                .product(name: "Time", package: "swift-time"),
                .product(name: "Witness", package: "swift-witness"),
            ]
        ),
        .target(
            name: "Sample Accumulator",
            dependencies: [
                .target(name: "Sample"),
                .product(name: "Algebra Monoid", package: "swift-algebra"),
            ]
        ),
        .target(
            name: "Sample Batch",
            dependencies: [
                .target(name: "Sample"),
                .target(name: "Sample Averaging"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Order", package: "swift-order"),
            ]
        ),

        .target(
            name: "Sample Test Support",
            dependencies: [
                .target(name: "Sample")
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Sample Tests",
            dependencies: [
                .target(name: "Sample"),
                .target(name: "Sample Test Support"),
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
