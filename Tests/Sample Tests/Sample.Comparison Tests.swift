import Sample
import Testing

@Suite
struct `Sample Comparison Tests` {

    @Test
    func `regression detection lower is better`() {
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
    func `improvement detection lower is better`() {
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
    func `regression detection higher is better`() {
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
    func `change percentage`() {
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
    func `exceeds tolerance`() {
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
    func `empty batch comparison`() {
        let baseline = Sample.Batch<Double>([])
        let current = Sample.Batch<Double>([])
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
    func `metric extraction`() {
        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0])
        let minVal = Sample.Metric.min.extract(from: batch, using: .real)
        #expect(minVal == 10.0)
        let maxVal = Sample.Metric.max.extract(from: batch, using: .real)
        #expect(maxVal == 50.0)
        let meanVal = Sample.Metric.mean.extract(from: batch, using: .real)
        #expect(meanVal == 30.0)
    }

    @Test
    func `polarity cases`() {
        let lower: Sample.Polarity = .lowerIsBetter
        let higher: Sample.Polarity = .higherIsBetter
        #expect(lower != higher)
    }
}
