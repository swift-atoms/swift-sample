extension Sample {

    public enum Metric: Swift.String, Sendable, Hashable {
        case min
        case max
        case median
        case mean
        case p50
        case p75
        case p90
        case p95
        case p99
        case p999
    }
}

extension Sample.Metric {

    @inlinable
    public func extract<T: Comparable & Sendable>(
        from batch: Sample.Batch<T>,
        using averaging: Sample.Averaging<T>
    ) -> T? {
        switch self {
        case .min: batch.min
        case .max: batch.max
        case .median: batch.median
        case .mean: batch.mean(using: averaging)
        case .p50: batch.p50
        case .p75: batch.p75
        case .p90: batch.p90
        case .p95: batch.p95
        case .p99: batch.p99
        case .p999: batch.p999
        }
    }
}
