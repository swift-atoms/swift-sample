import Sample
import Testing

@Suite
struct `Sample comparisons classify metric changes using the requested polarity` {

    @Test
    func `Increasing sample means indicate regression when lower values are preferred`() {
        let baseline = Sample.Batch([10.0, 20.0, 30.0])
        let current = Sample.Batch([15.0, 25.0, 35.0])
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .lowerIsBetter
        )
        #expect(comparison.isRegression)
        #expect(!comparison.isImprovement)
    }

    @Test
    func `Decreasing sample means indicate improvement when lower values are preferred`() {
        let baseline = Sample.Batch([10.0, 20.0, 30.0])
        let current = Sample.Batch([5.0, 15.0, 25.0])
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .lowerIsBetter
        )
        #expect(!comparison.isRegression)
        #expect(comparison.isImprovement)
    }

    @Test
    func `Decreasing sample means indicate regression when higher values are preferred`() {
        let baseline = Sample.Batch([100.0, 200.0, 300.0])
        let current = Sample.Batch([50.0, 150.0, 250.0])
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .higherIsBetter
        )
        #expect(comparison.isRegression)
        #expect(!comparison.isImprovement)
    }

    @Test
    func `Sample comparisons report relative metric change`() {
        let baseline = Sample.Batch([100.0])
        let current = Sample.Batch([110.0])
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .lowerIsBetter
        )
        let change = comparison.change
        #expect(change != nil)
        #expect(abs(change! - 0.1) < 0.001)
    }

    @Test
    func `Sample comparisons test relative change against the requested tolerance`() {
        let baseline = Sample.Batch([100.0])
        let current = Sample.Batch([115.0])
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .lowerIsBetter
        )
        #expect(comparison.exceedsTolerance(0.10))
        #expect(!comparison.exceedsTolerance(0.20))
    }

    @Test
    func `Empty sample comparisons report neither change nor improvement or regression`() {
        let baseline = Sample.Batch<Double>([], sortedBy: .ascending)
        let current = Sample.Batch<Double>([], sortedBy: .ascending)
        let comparison = Sample.Comparison(
            baseline: baseline,
            current: current,
            metric: .mean,
            polarity: .lowerIsBetter
        )
        #expect(comparison.change == nil)
        #expect(!comparison.isRegression)
        #expect(!comparison.isImprovement)
    }

    @Test
    func `Sample metric extraction returns the requested minimum maximum or mean`() {
        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0])
        let minVal = Sample.Metric.min.extract(from: batch, using: .real)
        #expect(minVal == 10.0)
        let maxVal = Sample.Metric.max.extract(from: batch, using: .real)
        #expect(maxVal == 50.0)
        let meanVal = Sample.Metric.mean.extract(from: batch, using: .real)
        #expect(meanVal == 30.0)
    }

    @Test
    func `Sample polarity distinguishes preferences for lower and higher values`() {
        let lower: Sample.Polarity = .lowerIsBetter
        let higher: Sample.Polarity = .higherIsBetter
        #expect(lower != higher)
    }
}
