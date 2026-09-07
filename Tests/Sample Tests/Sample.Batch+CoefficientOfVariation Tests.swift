import Sample
import Testing

@Suite
struct `Sample variation coefficients express relative dispersion` {

    @Test
    func `Empty sample batches have no coefficient of variation`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func `A single sample has no coefficient of variation`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func `Uniform samples have zero coefficient of variation`() {
        let batch = Sample.Batch([5.0, 5.0, 5.0, 5.0, 5.0])
        #expect(batch.coefficientOfVariation == 0.0)
    }

    @Test
    func `Sample variation coefficients match the expected relative dispersion`() {

        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0])
        let cv = batch.coefficientOfVariation!
        #expect(abs(cv - 52.705) < 0.01)
    }

    @Test
    func `Closely grouped samples have a small coefficient of variation`() {

        let batch = Sample.Batch([100.0, 101.0, 99.0, 100.5, 99.5])
        let cv = batch.coefficientOfVariation!
        #expect(cv < 5.0)
    }

    @Test
    func `Equal duration samples have zero coefficient of variation`() {
        let batch = Sample.Batch<Duration>([.seconds(1), .seconds(1), .seconds(1)])
        #expect(batch.coefficientOfVariation == 0.0)
    }

    @Test
    func `Varying duration samples have a positive coefficient of variation`() {
        let batch = Sample.Batch<Duration>([
            .seconds(10), .seconds(20), .seconds(30), .seconds(40), .seconds(50),
        ])
        let cv = batch.coefficientOfVariation!
        #expect(cv > 20.0)
    }

    @Test
    func `Samples with a zero mean have no coefficient of variation`() {
        let batch = Sample.Batch([-1.0, 0.0, 1.0])
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func `Integer averaging witnesses support coefficients of variation`() {
        let batch = Sample.Batch([100, 200, 300, 400, 500])
        let cv = batch.coefficientOfVariation(using: .integer)
        #expect(cv != nil)
        #expect(cv! > 0)
    }
}
