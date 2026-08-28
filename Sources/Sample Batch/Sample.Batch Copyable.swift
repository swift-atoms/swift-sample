@_exported public import Comparison
@_exported public import Order
public import Sample

extension Sample.Batch where Element: Copyable {

    @inlinable
    public init(_ values: [Element], sortedBy comparator: Order.Comparator<Element>) {
        let sorted = values.sorted { comparator($0, $1).isLess }
        let count = sorted.count
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for i in 0..<count {
            unsafe (pointer + i).initialize(to: sorted[i])
        }
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }
}

extension Sample.Batch where Element: Comparison.`Protocol` & SendableMetatype & Copyable {

    @inlinable
    public init(_ values: [Element]) {
        self.init(values, sortedBy: Order.Comparator<Element>.ascending)
    }
}
