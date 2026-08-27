extension Sample.Batch where Element: Copyable & Sendable {

    @inlinable
    public func standardDeviation(
        using averaging: Sample.Averaging<Element>
    ) -> Element? {
        guard count > 1, let m = mean(using: averaging) else { return nil }
        let meanDouble = averaging.project(m)
        var sumSquares: Double = 0
        for i in 0..<count {
            let diff = averaging.project(unsafe self._storage.base[i]) - meanDouble
            sumSquares += diff * diff
        }

        let variance = sumSquares / Double(count - 1)
        return averaging.embed(variance.squareRoot())
    }
}


extension Sample.Batch where Element == Double {

    @inlinable
    public var standardDeviation: Double? {
        standardDeviation(using: .real)
    }
}

extension Sample.Batch where Element == Duration {

    @inlinable
    public var standardDeviation: Duration? {
        standardDeviation(using: .duration)
    }
}
