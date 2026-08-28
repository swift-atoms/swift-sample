extension Sample {

    @frozen
    public struct Accumulator: Sendable, Hashable {

        public var count: UInt64

        public var sum: UInt64

        public var minimum: UInt64

        public var maximum: UInt64

        @inlinable
        public init(count: UInt64, sum: UInt64, minimum: UInt64, maximum: UInt64) {
            self.count = count
            self.sum = sum
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}

extension Sample.Accumulator {

    @inlinable
    public static var empty: Self {
        .init(count: 0, sum: 0, minimum: .max, maximum: 0)
    }

    @inlinable
    public mutating func record(_ value: UInt64) {
        count &+= 1
        sum &+= value
        minimum = Swift.min(minimum, value)
        maximum = Swift.max(maximum, value)
    }

    @inlinable
    public func merged(with other: Self) -> Self {
        .init(
            count: count &+ other.count,
            sum: sum &+ other.sum,
            minimum: Swift.min(minimum, other.minimum),
            maximum: Swift.max(maximum, other.maximum)
        )
    }

    @inlinable
    public var mean: UInt64? {
        guard count > 0 else { return nil }
        return sum / count
    }
}
