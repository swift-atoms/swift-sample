extension Sample.Batch where Element: Copyable & Sendable {

    @inlinable
    public func coefficientOfVariation(
        using averaging: Sample.Averaging<Element>
    ) -> Double? {
        guard let sd = standardDeviation(using: averaging),
            let m = mean(using: averaging)
        else { return nil }
        let meanDouble = averaging.project(m)
        guard meanDouble != 0 else { return nil }
        return (averaging.project(sd) / meanDouble) * 100.0
    }
}


extension Sample.Batch where Element == Double {

    @inlinable
    public var coefficientOfVariation: Double? {
        coefficientOfVariation(using: .real)
    }
}
