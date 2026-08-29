import Sample
import Sample_Batch
import Testing

@Suite
struct `Sample Batch Median Absolute Deviation Tests` {

    @Test
    func `empty batch`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.medianAbsoluteDeviation == nil)
    }

    @Test
    func `single element`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `uniform values`() {
        let batch = Sample.Batch([7.0, 7.0, 7.0, 7.0, 7.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `known distribution`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `with outlier`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `duration convenience`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(5),
        ])
        #expect(batch.medianAbsoluteDeviation == .seconds(1))
    }

    @Test
    func `outlier count empty`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.outlierCount() == nil)
    }

    @Test
    func `outlier count uniform`() {
        let batch = Sample.Batch([5.0, 5.0, 5.0, 5.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `outlier count no outliers`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `outlier count with outlier`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.outlierCount() == 1)
    }

    @Test
    func `outlier count custom threshold`() {

        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount(threshold: 1.5) == 2)
    }

    @Test
    func `outlier count duration`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(100),
        ])
        #expect(batch.outlierCount() == 1)
    }
}
