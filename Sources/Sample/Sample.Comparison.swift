extension Sample {

    public struct Comparison<Element: Comparable & Sendable>: Sendable {

        public let baseline: Sample.Batch<Element>

        public let current: Sample.Batch<Element>

        public let metric: Sample.Metric

        public let polarity: Sample.Polarity

        @inlinable
        public init(
            baseline: Sample.Batch<Element>,
            current: Sample.Batch<Element>,
            metric: Sample.Metric,
            polarity: Sample.Polarity
        ) {
            self.baseline = baseline
            self.current = current
            self.metric = metric
            self.polarity = polarity
        }

        @inlinable
        public func change(
            using averaging: Sample.Averaging<Element>
        ) -> Double? {
            guard let baseValue = metric.extract(from: baseline, using: averaging),
                let curValue = metric.extract(from: current, using: averaging)
            else {
                return nil
            }
            let baseDouble = averaging.project(baseValue)
            guard baseDouble != 0 else { return nil }
            return (averaging.project(curValue) - baseDouble) / baseDouble
        }

        @inlinable
        public func isRegression(
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            switch polarity {
            case .lowerIsBetter: return delta > 0
            case .higherIsBetter: return delta < 0
            }
        }

        @inlinable
        public func isImprovement(
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            switch polarity {
            case .lowerIsBetter: return delta < 0
            case .higherIsBetter: return delta > 0
            }
        }

        @inlinable
        public func exceedsTolerance(
            _ tolerance: Double,
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            return Swift.abs(delta) > tolerance
        }
    }
}


extension Sample.Comparison where Element == Double {

    @inlinable
    public var change: Double? {
        change(using: .real)
    }

    @inlinable
    public var isRegression: Bool {
        isRegression(using: .real)
    }

    @inlinable
    public var isImprovement: Bool {
        isImprovement(using: .real)
    }

    @inlinable
    public func exceedsTolerance(_ tolerance: Double) -> Bool {
        exceedsTolerance(tolerance, using: .real)
    }
}
