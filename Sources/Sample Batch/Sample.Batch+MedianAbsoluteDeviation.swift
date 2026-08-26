public import Sample_Averaging
public import Sample_Primitive

extension Sample.Batch where Element: Copyable & Sendable {

    @inlinable
    public func medianAbsoluteDeviation(
        using averaging: Sample.Averaging<Element>
    ) -> Element? {
        guard count > 0, let med = median else { return nil }
        let medianDouble = averaging.project(med)

        var deviations: [Double] = []
        deviations.reserveCapacity(count)
        for i in 0..<count {
            let diff = abs(averaging.project(unsafe self._storage.base[i]) - medianDouble)
            deviations.append(diff)
        }
        deviations.sort()

        let madDouble: Double
        if deviations.count % 2 == 1 {
            madDouble = deviations[deviations.count / 2]
        } else {
            madDouble =
                (deviations[deviations.count / 2 - 1]
                    + deviations[deviations.count / 2]) / 2.0
        }
        return averaging.embed(madDouble)
    }

    @inlinable
    public func outlierCount(
        using averaging: Sample.Averaging<Element>,
        threshold k: Double = 3.0
    ) -> Int? {
        guard let med = median,
            let mad = medianAbsoluteDeviation(using: averaging)
        else { return nil }
        let medianDouble = averaging.project(med)
        let madDouble = averaging.project(mad)
        guard madDouble > 0 else { return 0 }

        var outliers = 0
        for i in 0..<self.count {
            let deviation = abs(averaging.project(unsafe self._storage.base[i]) - medianDouble)
            if deviation > k * madDouble {
                outliers += 1
            }
        }
        return outliers
    }
}

extension Sample.Batch where Element == Duration {

    @inlinable
    public var medianAbsoluteDeviation: Duration? {
        medianAbsoluteDeviation(using: .duration)
    }

    @inlinable
    public func outlierCount(threshold k: Double = 3.0) -> Int? {
        outlierCount(using: .duration, threshold: k)
    }
}

extension Sample.Batch where Element == Double {

    @inlinable
    public var medianAbsoluteDeviation: Double? {
        medianAbsoluteDeviation(using: .real)
    }

    @inlinable
    public func outlierCount(threshold k: Double = 3.0) -> Int? {
        outlierCount(using: .real, threshold: k)
    }
}
