extension Sample {

    public enum Regression {}
}

extension Sample.Regression {

    public static func linear(
        _ points: [(x: Double, y: Double)]
    ) throws(Sample.Regression.Error) -> Fit {
        guard points.count >= 2 else { throw .insufficientPoints }

        let n = Double(points.count)
        let firstX = points[0].x
        var sumX: Double = 0
        var sumY: Double = 0
        var sumXY: Double = 0
        var sumXX: Double = 0
        var allXEqual = true

        for point in points {
            sumX += point.x
            sumY += point.y
            sumXY += point.x * point.y
            sumXX += point.x * point.x
            if point.x != firstX { allXEqual = false }
        }

        let denominator = n * sumXX - sumX * sumX
        guard denominator != 0, !allXEqual else { throw .constantX }

        let slope = (n * sumXY - sumX * sumY) / denominator
        let intercept = (sumY - slope * sumX) / n

        let yMean = sumY / n
        var ssRes: Double = 0
        var ssTot: Double = 0

        for point in points {
            let residual = point.y - (slope * point.x + intercept)
            ssRes += residual * residual
            let deviation = point.y - yMean
            ssTot += deviation * deviation
        }

        let rSquared = ssTot > 0 ? 1.0 - ssRes / ssTot : 0.0

        let mse = points.count > 2 ? ssRes / Double(points.count - 2) : ssRes

        return Fit(
            slope: slope,
            intercept: intercept,
            rSquared: rSquared,
            meanSquaredError: mse
        )
    }
}
