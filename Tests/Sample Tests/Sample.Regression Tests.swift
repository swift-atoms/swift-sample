import Sample
import Testing

@Suite
struct `Sample regression fits linear relationships and reports degeneracy` {

    @Suite struct `Linear regression recovers slopes intercepts and fit quality` {}
    @Suite struct `Linear regression handles sparse degenerate and large observations` {}
}

extension `Sample regression fits linear relationships and reports degeneracy`.`Linear regression recovers slopes intercepts and fit quality` {

    @Test
    func `Linear regression recovers an exact slope intercept and perfect fit`() {

        let x = [1.0, 2.0, 3.0, 4.0, 5.0]
        let y = [3.0, 5.0, 7.0, 9.0, 11.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope - 2.0) < 1e-10)
        #expect(abs(fit.intercept - 1.0) < 1e-10)
        #expect(abs(fit.rSquared - 1.0) < 1e-10)
        #expect(fit.meanSquaredError < 1e-10)
    }

    @Test
    func `Linear regression recovers an exact line through the origin`() {

        let x = [1.0, 2.0, 3.0, 4.0]
        let y = [3.0, 6.0, 9.0, 12.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope - 3.0) < 1e-10)
        #expect(abs(fit.intercept) < 1e-10)
        #expect(abs(fit.rSquared - 1.0) < 1e-10)
    }

    @Test
    func `Linear regression recovers a negative slope and its intercept`() {

        let x = [1.0, 2.0, 3.0, 4.0, 5.0]
        let y = [8.0, 6.0, 4.0, 2.0, 0.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope - (-2.0)) < 1e-10)
        #expect(abs(fit.intercept - 10.0) < 1e-10)
        #expect(abs(fit.rSquared - 1.0) < 1e-10)
    }

    @Test
    func `imperfect fit has R squared below 1`() {
        let x = [1.0, 2.0, 3.0, 4.0, 5.0]
        let y = [2.1, 3.9, 6.2, 7.8, 10.1]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(fit.rSquared > 0.99)
        #expect(fit.rSquared < 1.0)
        #expect(fit.meanSquaredError > 0)
    }

    @Test
    func `Constant observations produce a zero regression slope`() {
        let x = [1.0, 2.0, 3.0, 4.0, 5.0]
        let y = [7.0, 7.0, 7.0, 7.0, 7.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope) < 1e-10)
        #expect(abs(fit.intercept - 7.0) < 1e-10)
    }
}

extension `Sample regression fits linear relationships and reports degeneracy`.`Linear regression handles sparse degenerate and large observations` {

    @Test
    func `Two distinct points determine an exact linear fit`() {
        let x = [1.0, 2.0]
        let y = [3.0, 5.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope - 2.0) < 1e-10)
        #expect(abs(fit.intercept - 1.0) < 1e-10)
        #expect(abs(fit.rSquared - 1.0) < 1e-10)
    }

    @Test
    func `all x identical returns degenerate fit`() {
        let x = [5.0, 5.0, 5.0, 5.0]
        let y = [1.0, 2.0, 3.0, 4.0]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(fit.slope == 0)
        #expect(fit.rSquared == 0)
        #expect(fit.meanSquaredError == .infinity)
    }

    @Test
    func `large values do not overflow`() {
        let x = [1e6, 2e6, 3e6, 4e6, 5e6]
        let y = [2e6, 4e6, 6e6, 8e6, 10e6]
        let fit = Sample.Regression.linear(x: x, y: y)

        #expect(abs(fit.slope - 2.0) < 1e-4)
        #expect(abs(fit.rSquared - 1.0) < 1e-10)
    }
}
