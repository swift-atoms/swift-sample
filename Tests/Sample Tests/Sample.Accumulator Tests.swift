import Sample
import Testing

@Suite
struct `Sample Accumulator Tests` {

    @Test
    func `empty accumulator`() {
        let acc = Sample.Accumulator.empty
        #expect(acc.count == 0)
        #expect(acc.sum == 0)
        #expect(acc.minimum == .max)
        #expect(acc.maximum == 0)
        #expect(acc.mean == nil)
    }

    @Test
    func `record values`() {
        var acc = Sample.Accumulator.empty
        acc.record(10)
        acc.record(20)
        acc.record(30)
        #expect(acc.count == 3)
        #expect(acc.sum == 60)
        #expect(acc.minimum == 10)
        #expect(acc.maximum == 30)
        #expect(acc.mean == 20)
    }

    @Test
    func `single record`() {
        var acc = Sample.Accumulator.empty
        acc.record(42)
        #expect(acc.count == 1)
        #expect(acc.sum == 42)
        #expect(acc.minimum == 42)
        #expect(acc.maximum == 42)
        #expect(acc.mean == 42)
    }

    @Test
    func `monoid identity left`() {
        var acc = Sample.Accumulator.empty
        acc.record(10)
        acc.record(20)
        let result = Sample.Accumulator.empty.merged(with: acc)
        #expect(result.count == acc.count)
        #expect(result.sum == acc.sum)
        #expect(result.minimum == acc.minimum)
        #expect(result.maximum == acc.maximum)
    }

    @Test
    func `monoid identity right`() {
        var acc = Sample.Accumulator.empty
        acc.record(10)
        acc.record(20)
        let result = acc.merged(with: .empty)
        #expect(result.count == acc.count)
        #expect(result.sum == acc.sum)
        #expect(result.minimum == acc.minimum)
        #expect(result.maximum == acc.maximum)
    }

    @Test
    func `monoid associativity`() {
        var a = Sample.Accumulator.empty
        a.record(1)
        a.record(2)

        var b = Sample.Accumulator.empty
        b.record(3)
        b.record(4)

        var c = Sample.Accumulator.empty
        c.record(5)
        c.record(6)

        let left = a.merged(with: b).merged(with: c)
        let right = a.merged(with: b.merged(with: c))

        #expect(left.count == right.count)
        #expect(left.sum == right.sum)
        #expect(left.minimum == right.minimum)
        #expect(left.maximum == right.maximum)
    }

    @Test
    func `monoid commutativity`() {
        var a = Sample.Accumulator.empty
        a.record(10)
        a.record(50)

        var b = Sample.Accumulator.empty
        b.record(20)
        b.record(30)

        let ab = a.merged(with: b)
        let ba = b.merged(with: a)

        #expect(ab.count == ba.count)
        #expect(ab.sum == ba.sum)
        #expect(ab.minimum == ba.minimum)
        #expect(ab.maximum == ba.maximum)
    }

    @Test
    func `monoid witness`() {
        let monoid = Sample.Accumulator.monoid

        var a = Sample.Accumulator.empty
        a.record(5)

        let combined = monoid(a, monoid.identity)
        #expect(combined.count == a.count)
        #expect(combined.sum == a.sum)
    }
}
