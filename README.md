# Sample Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Sample-statistics value types for Swift — a `Sample` namespace of sorted batches, streaming accumulators, averaging witnesses, linear regression, and baseline/current comparison, with zero platform dependencies.

---

## Quick Start

`Sample.Batch` sorts its elements at construction and stores them in sorted order, so percentiles, min, max, and median are O(1) reads. Summary statistics — mean, standard deviation, coefficient of variation, median absolute deviation — are computed over the same sorted buffer.

```swift
import Sample

// A batch of measured latencies; sorted once at construction.
let latencies = Sample.Batch([
    Duration.milliseconds(12),
    Duration.milliseconds(9),
    Duration.milliseconds(31),
    Duration.milliseconds(11),
])

latencies.median                 // 12ms  (nearest-rank)
latencies.p99                    // 31ms
latencies.mean                   // 15.75ms
latencies.standardDeviation      // sample stddev (Bessel's n-1)
latencies.coefficientOfVariation // relative spread, as a percentage
```

A `Sample.Comparison` pairs a `baseline` with a `current` batch and reports the relative change on a chosen `Sample.Metric`, classifying it as a regression or improvement according to `Sample.Polarity`:

```swift
import Sample

let baseline = Sample.Batch([
    Duration.milliseconds(10), Duration.milliseconds(11), Duration.milliseconds(12),
])
let current = Sample.Batch([
    Duration.milliseconds(9), Duration.milliseconds(10), Duration.milliseconds(11),
])

let comparison = Sample.Comparison(
    baseline: baseline,
    current: current,
    metric: .p99,
    polarity: .lowerIsBetter
)

comparison.change(using: .duration)        // negative → current is faster
comparison.isRegression(using: .duration)  // false — p99 improved
```

Batch statistics generalize over the element type through a `Sample.Averaging` witness — value-level operations for zero, addition, division, and projection to/from `Double`. Witnesses ship for `Duration` (`.duration`), `Double` (`.real`), `Int` (`.integer`), and `UInt64` (`.natural`), so the same `mean`/`standardDeviation`/`coefficientOfVariation` work across all of them.

For incremental measurement, `Sample.Accumulator` is a streaming O(1) tally of count, sum, min, and max that forms a commutative monoid under `merged(with:)` — partial results from independent runs combine without loss. `Sample.Regression.linear(x:y:)` fits an ordinary least-squares line and returns a `Sample.Regression.Fit` with slope, intercept, R², and mean squared error.

---

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

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Five library products. The umbrella `Sample Primitives` re-exports the four building blocks; import a single sub-namespace when you need just one.

| Product | Target | Purpose |
|---------|--------|---------|
| `Sample Primitive` | `Sources/Sample Primitive/` | The `Sample` namespace: `Sample.Accumulator` (streaming tally), `Sample.Polarity`, and `Sample.Regression` + `Sample.Regression.Fit` (ordinary least-squares). |
| `Sample Averaging Primitives` | `Sources/Sample Averaging Primitives/` | `Sample.Averaging<Element>` — the value witness generalizing batch statistics over `Duration`, `Double`, `Int`, and `UInt64`. |
| `Sample Accumulator Primitives` | `Sources/Sample Accumulator Primitives/` | The commutative-monoid witness `Sample.Accumulator.monoid` for combining accumulators. |
| `Sample Batch Primitives` | `Sources/Sample Batch Primitives/` | `Sample.Batch` (sorted, `~Copyable`-aware), its percentile/mean/stddev/CV/MAD statistics, `Sample.Metric`, and `Sample.Comparison`. |
| `Sample Primitives` | `Sources/Sample Primitives/` | Umbrella re-exporting all of the above. |
| `Sample Test Support` | `Tests/Support/` | Re-exports the umbrella for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
