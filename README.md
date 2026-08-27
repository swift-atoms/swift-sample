# Sample

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Sample-statistics value types for Swift: sorted batches, streaming accumulators,
averaging witnesses, linear regression, and baseline/current comparison.

## Quick Start

`Sample.Batch` sorts its elements at construction, making percentile, minimum,
maximum, and median reads constant-time operations.

```swift
import Sample

let latencies = Sample.Batch([
    Duration.milliseconds(12),
    Duration.milliseconds(9),
    Duration.milliseconds(31),
    Duration.milliseconds(11),
])

latencies.median
latencies.p99
latencies.mean
latencies.standardDeviation
latencies.coefficientOfVariation
```

Use a native Swift comparison closure when a custom ordering is needed:

```swift
let descending = Sample.Batch([1, 3, 2], sortedBy: >)
```

Batch statistics generalize over the element type through a
`Sample.Averaging` witness. Witnesses are provided for `Duration`, `Double`,
`Int`, and `UInt64`. `Sample.Accumulator` is a streaming tally whose
`Sample.Accumulator.monoid` witness combines independent partial results.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-sample.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Sample", package: "swift-sample"),
    ]
)
```

The package uses Swift tools 6.4 and declares Apple platform version 27.

## Products

| Product | Purpose |
|---------|---------|
| `Sample` | Foundation-free sample types, statistics, and witnesses. |
| `Sample Standard Library Integration` | Standard-library conformances such as `Codable`, gated out of Embedded builds. |
| `Sample Apple Foundation Integration` | Apple Foundation integration and the package's only Foundation dependency. |

The core product depends only on the canonical
[`swift-witness`](https://github.com/swift-atoms/swift-witness) atom. It keeps
Foundation isolated to the Apple Foundation integration target.

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
