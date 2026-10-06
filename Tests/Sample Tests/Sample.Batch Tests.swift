import Sample
import Testing

@Suite
struct `Sample batches expose ordered statistics and borrowed observations` {

    @Test
    func `Empty sample batches have no ordered statistics`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.count == 0)
        #expect(batch.isEmpty)
        #expect(batch.min == nil)
        #expect(batch.max == nil)
        #expect(batch.median == nil)
        #expect(batch.p99 == nil)
    }

    @Test
    func `A single sample defines the minimum maximum and median`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.count == 1)
        #expect(!batch.isEmpty)
        #expect(batch.min == 42.0)
        #expect(batch.max == 42.0)
        #expect(batch.median == 42.0)
    }

    @Test
    func `Sample batches expose extrema in sorted order`() {
        let batch = Sample.Batch([5, 3, 1, 4, 2])
        #expect(batch.min == 1)
        #expect(batch.max == 5)
    }

    @Test
    func `Named sample percentiles select the expected ordered observations`() {
        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0])
        #expect(batch.p50 == 60.0)
        #expect(batch.p90 == 100.0)
        #expect(batch.p99 == 100.0)
        #expect(batch.min == 10.0)
        #expect(batch.max == 100.0)
    }

    @Test
    func `Sample percentile lookup clamps endpoints and selects indexed observations`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])

        #expect(batch.percentile(0.5) == 3.0)

        #expect(batch.percentile(0.25) == 2.0)

        #expect(batch.percentile(0.0) == 1.0)

        #expect(batch.percentile(1.0) == 4.0)
    }

    @Test
    func `Borrowed sample accessors expose the minimum maximum and median`() {
        let batch = Sample.Batch(count: 3, sortedBy: .ascending) { i in
            [30, 10, 20][i]
        }
        let minVal = batch.withMin { $0 }
        #expect(minVal == 10)

        let maxVal = batch.withMax { $0 }
        #expect(maxVal == 30)

        let medVal = batch.withMedian { $0 }
        #expect(medVal == 20)
    }

    @Test
    func `Sample batch statistics follow the supplied comparator`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0], sortedBy: .descending)

        #expect(batch.min == 5.0)
        #expect(batch.max == 1.0)
        #expect(batch.percentile(0.0) == 5.0)
        #expect(batch.percentile(1.0) == 1.0)
    }

    @Test
    func `Percentiles below zero have no observation`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])
        #expect(batch.percentile(-1.0) == nil)
        #expect(batch.percentile(-0.5) == nil)
        #expect(batch.percentile(-Double.ulpOfOne) == nil)
        #expect(batch.percentile(-Double.leastNonzeroMagnitude) == nil)
        #expect(batch.percentile(-Double.greatestFiniteMagnitude) == nil)
    }

    @Test
    func `Percentiles above one have no observation`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])
        #expect(batch.percentile(1.0.nextUp) == nil)
        #expect(batch.percentile(1.5) == nil)
        #expect(batch.percentile(2.0) == nil)
        #expect(batch.percentile(Double.greatestFiniteMagnitude) == nil)
    }

    @Test
    func `Non-finite percentiles have no observation`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])
        #expect(batch.percentile(.nan) == nil)
        #expect(batch.percentile(.signalingNaN) == nil)
        #expect(batch.percentile(.infinity) == nil)
        #expect(batch.percentile(-.infinity) == nil)
    }

    @Test
    func `Empty batches have no percentile for any input`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.percentile(0.0) == nil)
        #expect(batch.percentile(0.5) == nil)
        #expect(batch.percentile(1.0) == nil)
        #expect(batch.percentile(-1.0) == nil)
        #expect(batch.percentile(.nan) == nil)
        #expect(batch.percentile(.infinity) == nil)
    }

    @Test
    func `Percentile endpoints select the minimum and the maximum`() {
        let single = Sample.Batch([42.0])
        #expect(single.percentile(0.0) == 42.0)
        #expect(single.percentile(-0.0) == 42.0)
        #expect(single.percentile(1.0) == 42.0)

        let batch = Sample.Batch([5.0, 3.0, 1.0, 4.0, 2.0])
        #expect(batch.percentile(0.0) == batch.min)
        #expect(batch.percentile(-0.0) == batch.min)
        #expect(batch.percentile(1.0) == batch.max)

        let descending = Sample.Batch([1.0, 2.0, 3.0], sortedBy: .descending)
        #expect(descending.percentile(0.0) == 3.0)
        #expect(descending.percentile(1.0) == 1.0)
    }

    @Test
    func `Interior percentiles keep their truncating selection`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])
        #expect(batch.percentile(Double.leastNonzeroMagnitude) == 1.0)
        #expect(batch.percentile(0.25) == 2.0)
        #expect(batch.percentile(0.49) == 2.0)
        #expect(batch.percentile(0.5) == 3.0)
        #expect(batch.percentile(0.74) == 3.0)
        #expect(batch.percentile(0.75) == 4.0)
        #expect(batch.percentile(1.0.nextDown) == 4.0)
    }

    @Test
    func `Percentiles just below one select the maximum of a large batch`() {
        let batch = Sample.Batch(count: 1000, sortedBy: .ascending) { i in Double(i) }
        #expect(batch.percentile(0.999) == 999.0)
        #expect(batch.percentile(1.0.nextDown) == 999.0)
        #expect(batch.percentile(1.0) == 999.0)
        #expect(batch.percentile(0.5) == 500.0)
    }

    @Test
    func `Every valid percentile selects the truncated index of a small batch`() {
        for count in 1...9 {
            let batch = Sample.Batch(count: count, sortedBy: .ascending) { i in i }
            let percentiles = (0...64).map { Double($0) / 64 } + [Double.leastNonzeroMagnitude, 1.0.nextDown]
            for p in percentiles {
                let expected = Swift.min(Int(Double(count) * p), count - 1)
                #expect(batch.percentile(p) == expected)
            }
        }
    }

    @Test
    func `Copied sample batches preserve their count and extrema`() {
        let batch1 = Sample.Batch([1.0, 2.0, 3.0])
        let batch2 = batch1
        #expect(batch1.count == batch2.count)
        #expect(batch1.min == batch2.min)
        #expect(batch1.max == batch2.max)
    }
}
