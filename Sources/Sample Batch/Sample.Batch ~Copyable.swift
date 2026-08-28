@_exported public import Order
public import Sample

extension Sample.Batch where Element: ~Copyable {

    @inlinable
    public init(
        count: Int,
        sortedBy comparator: Order.Comparator<Element>,
        initializingWith body: (Int) -> Element
    ) {
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for i in 0..<count {
            unsafe (pointer + i).initialize(to: body(i))
        }
        unsafe Self._insertionSort(pointer, count: count, comparator: comparator)
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }

    @inlinable
    public borrowing func withPercentile<R: ~Copyable>(
        _ p: Double,
        _ body: (borrowing Element) -> R
    ) -> R? {
        guard count > 0 else { return nil }
        let index = Int(Double(count) * p)

        let clamped = Swift.min(index, count - 1)
        return unsafe body((self._storage.base + clamped).pointee)
    }

    @inlinable
    public borrowing func withMin<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        guard count > 0 else { return nil }
        return unsafe body(self._storage.base.pointee)
    }

    @inlinable
    public borrowing func withMax<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        guard count > 0 else { return nil }

        return unsafe body((self._storage.base + count - 1).pointee)
    }

    @inlinable
    public borrowing func withMedian<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        withPercentile(0.5, body)
    }
}

extension Sample.Batch where Element: ~Copyable {

    @usableFromInline
    static func _insertionSort(
        _ base: UnsafeMutablePointer<Element>,
        count: Int,
        comparator: Order.Comparator<Element>
    ) {
        guard count > 1 else { return }
        for i in 1..<count {
            var j = i
            while j > 0 {
                let shouldSwap = unsafe comparator(
                    (base + j - 1).pointee,
                    (base + j).pointee
                ).isGreater
                guard shouldSwap else { break }
                let temp = unsafe (base + j).move()
                unsafe (base + j).initialize(to: (base + j - 1).move())
                unsafe (base + j - 1).initialize(to: temp)
                j -= 1
            }
        }
    }
}
