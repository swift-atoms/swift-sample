public import Sample_Averaging
public import Sample

extension Sample.Batch where Element: Copyable & Sendable {

    @inlinable
    public func sum(using averaging: Sample.Averaging<Element>) -> Element? {
        guard count > 0 else { return nil }
        var result = averaging.zero
        for i in 0..<count {
            result = averaging.adding(result, unsafe self._storage.base[i])
        }
        return result
    }

    @inlinable
    public func mean(using averaging: Sample.Averaging<Element>) -> Element? {
        guard let total = sum(using: averaging) else { return nil }
        return averaging.dividing(total, count)
    }
}

extension Sample.Batch where Element == Duration {

    @inlinable
    public var mean: Duration? { mean(using: .duration) }

    @inlinable
    public var sum: Duration? { sum(using: .duration) }
}

extension Sample.Batch where Element == Double {

    @inlinable
    public var mean: Double? { mean(using: .real) }

    @inlinable
    public var sum: Double? { sum(using: .real) }
}

extension Sample.Batch where Element == Int {

    @inlinable
    public var mean: Int? { mean(using: .integer) }

    @inlinable
    public var sum: Int? { sum(using: .integer) }
}
