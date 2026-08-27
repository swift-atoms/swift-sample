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
            name: "Sample",
            targets: ["Sample"]
        ),
        .library(
            name: "Sample Standard Library Integration",
            targets: ["Sample Standard Library Integration"]
        ),
        .library(
            name: "Sample Apple Foundation Integration",
            targets: ["Sample Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-witness.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: [
                .product(name: "Witness", package: "swift-witness")
            ]
        ),
        .target(
            name: "Sample Standard Library Integration",
            dependencies: ["Sample"]
        ),
        .target(
            name: "Sample Apple Foundation Integration",
            dependencies: [
                "Sample",
                "Sample Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Sample Tests",
            dependencies: ["Sample"],
            path: "Tests/Sample Tests"
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
