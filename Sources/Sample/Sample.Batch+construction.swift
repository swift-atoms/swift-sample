extension Sample.Batch where Element: Copyable {

    @inlinable
    public init(
        _ values: [Element],
        sortedBy areInIncreasingOrder: (Element, Element) -> Bool
    ) {
        let sorted = values.sorted(by: areInIncreasingOrder)
        let count = sorted.count
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for index in 0..<count {
            unsafe (pointer + index).initialize(to: sorted[index])
        }
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }
}

extension Sample.Batch where Element: Comparable & Copyable {

    @inlinable
    public init(_ values: [Element]) {
        self.init(values, sortedBy: <)
    }
}

extension Sample.Batch where Element: ~Copyable {

    @inlinable
    public init(
        count: Int,
        sortedBy areInIncreasingOrder: (borrowing Element, borrowing Element) -> Bool,
        initializingWith body: (Int) -> Element
    ) {
        precondition(count >= 0)
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for index in 0..<count {
            unsafe (pointer + index).initialize(to: body(index))
        }
        unsafe Self._insertionSort(
            pointer,
            count: count,
            by: areInIncreasingOrder
        )
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }

    @inlinable
    public borrowing func withPercentile<Result: ~Copyable>(
        _ percentile: Double,
        _ body: (borrowing Element) -> Result
    ) -> Result? {
        guard count > 0 else { return nil }
        let index = Int(Double(count) * percentile)
        let clamped = Swift.min(index, count - 1)
        return unsafe body((self._storage.base + clamped).pointee)
    }

    @inlinable
    public borrowing func withMin<Result: ~Copyable>(
        _ body: (borrowing Element) -> Result
    ) -> Result? {
        guard count > 0 else { return nil }
        return unsafe body(self._storage.base.pointee)
    }

    @inlinable
    public borrowing func withMax<Result: ~Copyable>(
        _ body: (borrowing Element) -> Result
    ) -> Result? {
        guard count > 0 else { return nil }
        return unsafe body((self._storage.base + count - 1).pointee)
    }

    @inlinable
    public borrowing func withMedian<Result: ~Copyable>(
        _ body: (borrowing Element) -> Result
    ) -> Result? {
        withPercentile(0.5, body)
    }

    @usableFromInline
    static func _insertionSort(
        _ base: UnsafeMutablePointer<Element>,
        count: Int,
        by areInIncreasingOrder: (borrowing Element, borrowing Element) -> Bool
    ) {
        guard count > 1 else { return }
        for index in 1..<count {
            var position = index
            while position > 0 {
                let shouldSwap = unsafe areInIncreasingOrder(
                    (base + position).pointee,
                    (base + position - 1).pointee
                )
                guard shouldSwap else { break }
                let temporary = unsafe (base + position).move()
                unsafe (base + position).initialize(to: (base + position - 1).move())
                unsafe (base + position - 1).initialize(to: temporary)
                position -= 1
            }
        }
    }
}
