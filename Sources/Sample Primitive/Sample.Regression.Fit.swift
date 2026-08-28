extension Sample.Regression {

    public struct Fit: Sendable, Hashable {

        public let slope: Double

        public let intercept: Double

        public let rSquared: Double

        public let meanSquaredError: Double

        public init(
            slope: Double,
            intercept: Double,
            rSquared: Double,
            meanSquaredError: Double
        ) {
            self.slope = slope
            self.intercept = intercept
            self.rSquared = rSquared
            self.meanSquaredError = meanSquaredError
        }
    }
}
