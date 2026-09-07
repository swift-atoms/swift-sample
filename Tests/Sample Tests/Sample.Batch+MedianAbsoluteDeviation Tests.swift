import Sample
import Testing

@Suite
struct `Sample median deviations measure robust dispersion and outliers` {

    @Test
    func `Empty sample batches have no median absolute deviation`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.medianAbsoluteDeviation == nil)
    }

    @Test
    func `A single sample has zero median absolute deviation`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `Uniform samples have zero median absolute deviation`() {
        let batch = Sample.Batch([7.0, 7.0, 7.0, 7.0, 7.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `Sample median absolute deviation matches the expected dispersion`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `Median absolute deviation resists a distant outlier`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `Duration samples preserve the duration unit of median absolute deviation`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(5),
        ])
        #expect(batch.medianAbsoluteDeviation == .seconds(1))
    }

    @Test
    func `Empty sample batches have no outlier count`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.outlierCount() == nil)
    }

    @Test
    func `Uniform sample batches contain no outliers`() {
        let batch = Sample.Batch([5.0, 5.0, 5.0, 5.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `Evenly spaced samples remain within the default outlier threshold`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `Sample outlier counting identifies a distant observation`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.outlierCount() == 1)
    }

    @Test
    func `Sample outlier counting applies the requested threshold`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount(threshold: 1.5) == 2)
    }

    @Test
    func `Duration sample outlier counting identifies a distant duration`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(100),
        ])
        #expect(batch.outlierCount() == 1)
    }
}
