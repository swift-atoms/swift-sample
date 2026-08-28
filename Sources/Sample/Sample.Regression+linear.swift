extension Sample.Regression {

    public static func linear(x: [Double], y: [Double]) -> Fit {
        precondition(x.count == y.count, "x and y must have the same length")
        precondition(x.count >= 2, "Need at least 2 data points for linear regression")

        let n = Double(x.count)
        var sumX: Double = 0
        var sumY: Double = 0
        var sumXY: Double = 0
        var sumXX: Double = 0

        for i in 0..<x.count {
            sumX += x[i]
            sumY += y[i]
            sumXY += x[i] * y[i]
            sumXX += x[i] * x[i]
        }

        let denominator = n * sumXX - sumX * sumX
        guard denominator != 0 else {

            return Fit(
                slope: 0,
                intercept: sumY / n,
                rSquared: 0,
                meanSquaredError: .infinity
            )
        }

        let slope = (n * sumXY - sumX * sumY) / denominator
        let intercept = (sumY - slope * sumX) / n

        let yMean = sumY / n
        var ssRes: Double = 0
        var ssTot: Double = 0

        for i in 0..<x.count {
            let predicted = slope * x[i] + intercept
            let residual = y[i] - predicted
            ssRes += residual * residual
            let deviation = y[i] - yMean
            ssTot += deviation * deviation
        }

        let rSquared = ssTot > 0 ? 1.0 - ssRes / ssTot : 0.0

        let mse = x.count > 2 ? ssRes / Double(x.count - 2) : ssRes

        return Fit(
            slope: slope,
            intercept: intercept,
            rSquared: rSquared,
            meanSquaredError: mse
        )
    }
}
