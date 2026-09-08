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
        .library(name: "Sample", targets: ["Sample"]),

        .library(name: "Sample Foundation Integration", targets: ["Sample Foundation Integration"]),
        .library(name: "Sample Test Support", targets: ["Sample Test Support"]),
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
            dependencies: [
                .product(name: "Time", package: "swift-time"),
                .product(name: "Witness", package: "swift-witness"),
                .product(name: "Algebra", package: "swift-algebra"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Order", package: "swift-order"),
            ],
            path: "Sources/Sample"
        ),
        
        .target(
            name: "Sample Foundation Integration",
            dependencies: [
                .target(name: "Sample"),
            ],
            path: "Sources/Sample Foundation Integration"
        ),
        .target(
            name: "Sample Test Support",
            dependencies: [
                .target(name: "Sample"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Sample Tests",
            dependencies: [
                .target(name: "Sample"),
                .target(name: "Sample Test Support"),
                .target(name: "Sample Foundation Integration"),
            ],
            path: "Tests/Sample Tests"
        ),
        .testTarget(
            name: "Consolidated Sample Comparison Tests",
            dependencies: [

                .target(name: "Sample"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Order", package: "swift-order"),
            ],
            path: "Tests/Consolidated swift-sample-comparison"
        ),
        .testTarget(
            name: "Consolidated Sample Order Tests",
            dependencies: [.target(name: "Sample"), .product(name: "Order", package: "swift-order"), .product(name: "Comparison", package: "swift-comparison")],
            path: "Tests/Consolidated swift-sample-order"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
