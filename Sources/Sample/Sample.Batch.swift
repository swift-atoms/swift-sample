extension Sample {

    public struct Batch<Element: ~Copyable>: ~Copyable {

        @usableFromInline
        let _storage: _SampleBatchStorage<Element>

        @inlinable
        public var count: Int { _storage.count }

        @inlinable
        public var isEmpty: Bool { count == 0 }
    }
}

extension Sample.Batch: Swift.Copyable where Element: Swift.Copyable {}
