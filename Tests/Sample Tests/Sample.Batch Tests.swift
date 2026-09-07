import Sample
import Testing

@Suite
struct `Sample Batch Tests` {

    @Test
    func `empty batch`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.count == 0)
        #expect(batch.isEmpty)
        #expect(batch.min == nil)
        #expect(batch.max == nil)
        #expect(batch.median == nil)
        #expect(batch.p99 == nil)
    }

    @Test
    func `single element`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.count == 1)
        #expect(!batch.isEmpty)
        #expect(batch.min == 42.0)
        #expect(batch.max == 42.0)
        #expect(batch.median == 42.0)
    }

    @Test
    func `sorted order`() {
        let batch = Sample.Batch([5, 3, 1, 4, 2])
        #expect(batch.min == 1)
        #expect(batch.max == 5)
    }

    @Test
    func percentile() {
        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0])
        #expect(batch.p50 == 60.0)
        #expect(batch.p90 == 100.0)
        #expect(batch.p99 == 100.0)
        #expect(batch.min == 10.0)
        #expect(batch.max == 100.0)
    }

    @Test
    func `percentile nearest rank`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0])

        #expect(batch.percentile(0.5) == 3.0)

        #expect(batch.percentile(0.25) == 2.0)

        #expect(batch.percentile(0.0) == 1.0)

        #expect(batch.percentile(1.0) == 4.0)
    }

    @Test
    func `borrowing accessors`() {
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
    func `custom comparator`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0], sortedBy: .descending)

        #expect(batch.min == 5.0)
        #expect(batch.max == 1.0)
        #expect(batch.percentile(0.0) == 5.0)
        #expect(batch.percentile(1.0) == 1.0)
    }

    @Test
    func `copyable sharing`() {
        let batch1 = Sample.Batch([1.0, 2.0, 3.0])
        let batch2 = batch1
        #expect(batch1.count == batch2.count)
        #expect(batch1.min == batch2.min)
        #expect(batch1.max == batch2.max)
    }
}
