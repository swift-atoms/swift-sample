import Algebra
import Sample
import Testing

@Suite
struct `Sample Algebra Tests` {

    @Test
    func `commutative monoid delegates to the sample accumulator`() {
        var lhs = Sample.Accumulator.empty
        lhs.record(10)
        lhs.record(30)

        var rhs = Sample.Accumulator.empty
        rhs.record(20)

        let monoid = Sample.Accumulator.commutativeMonoid

        #expect(monoid.identity == .empty)
        #expect(monoid(lhs, rhs) == lhs.merged(with: rhs))
        #expect(monoid(lhs, rhs) == monoid(rhs, lhs))
    }
}
