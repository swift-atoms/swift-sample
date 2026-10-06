extension Sample.Batch where Element: Copyable {

    @inlinable
    public func percentile(_ p: Double) -> Element? {
        guard count > 0, (0.0...1.0).contains(p) else { return nil }
        let scaled = Double(count) * p
        let index = scaled >= Double(count) ? count - 1 : Swift.min(Int(scaled), count - 1)
        return unsafe self._storage.base[index]
    }

    @inlinable
    public var min: Element? {
        guard count > 0 else { return nil }
        return unsafe self._storage.base[0]
    }

    @inlinable
    public var max: Element? {
        guard count > 0 else { return nil }

        return unsafe self._storage.base[count - 1]
    }

    @inlinable
    public var median: Element? { percentile(0.5) }

    @inlinable
    public var p50: Element? { percentile(0.50) }

    @inlinable
    public var p75: Element? { percentile(0.75) }

    @inlinable
    public var p90: Element? { percentile(0.90) }

    @inlinable
    public var p95: Element? { percentile(0.95) }

    @inlinable
    public var p99: Element? { percentile(0.99) }

    @inlinable
    public var p999: Element? { percentile(0.999) }
}
