import Sample
import Testing

@Suite
struct `Sample averaging projects values into sums means and deviations` {

    @Test
    func `Floating point sample means average every observation`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.mean == 3.0)
    }

    @Test
    func `Integer sample means average every observation`() {
        let batch = Sample.Batch([10, 20, 30])
        #expect(batch.mean == 20)
    }

    @Test
    func `Empty sample batches have no mean`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.mean == nil)
    }

    @Test
    func `Floating point sample sums include every observation`() {
        let batch = Sample.Batch([1.0, 2.0, 3.0])
        #expect(batch.sum == 6.0)
    }

    @Test
    func `Explicit averaging witnesses determine the sample mean`() {
        let batch = Sample.Batch([10.0, 20.0, 30.0])
        let result = batch.mean(using: .real)
        #expect(result == 20.0)
    }

    @Test
    func `Sample standard deviation uses the sample variance denominator`() {
        let batch = Sample.Batch([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
        let stddev = batch.standardDeviation
        #expect(stddev != nil)

        let expected = (32.0 / 7.0).squareRoot()
        #expect(abs(stddev! - expected) < 0.001)
    }

    @Test
    func `A single sample has no sample standard deviation`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.standardDeviation == nil)
    }

    @Test
    func `Empty sample batches have no standard deviation`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.standardDeviation == nil)
    }

    @Test
    func `Real averaging witnesses provide addition division and zero`() {
        let averaging = Sample.Averaging<Double>.real
        let sum = averaging.adding(3.0, 4.0)
        #expect(sum == 7.0)
        let divided = averaging.dividing(10.0, 2)
        #expect(divided == 5.0)
        #expect(averaging.zero == 0.0)
    }

    @Test
    func `Natural averaging witnesses compute means of UInt64 samples`() {
        let batch = Sample.Batch<UInt64>([10, 20, 30], sortedBy: .ascending)
        let result = batch.mean(using: .natural)
        #expect(result == 20)
    }
}

extension `Sample averaging projects values into sums means and deviations` {
    @Test(arguments: [-1.25, -0.25, 0.0, 0.25, 1.25])
    func `duration projection preserves fractional seconds`(_ seconds: Double) {
        let averaging = Sample.Averaging<Duration>.duration
        #expect(averaging.project(.seconds(seconds)) == seconds)
    }
}
