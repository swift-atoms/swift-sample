@safe
@usableFromInline

final class _SampleBatchStorage<Element: ~Copyable>: @unchecked Sendable {

    @usableFromInline
    let base: UnsafeMutablePointer<Element>

    @usableFromInline
    let count: Int

    @usableFromInline
    init(base: UnsafeMutablePointer<Element>, count: Int) {
        unsafe self.base = base
        self.count = count
    }

    deinit {
        unsafe base.deinitialize(count: count)
        unsafe base.deallocate()
    }
}
