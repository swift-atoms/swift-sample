extension Sample {

    public struct Trend: Sendable, Hashable {

        public let statistic: Int

        public let variance: Double

        public let standardized: Double

        public let included: Int

        public let excluded: Int

        public let ties: Int

        init(
            statistic: Int,
            variance: Double,
            standardized: Double,
            included: Int,
            excluded: Int,
            ties: Int
        ) {
            self.statistic = statistic
            self.variance = variance
            self.standardized = standardized
            self.included = included
            self.excluded = excluded
            self.ties = ties
        }
    }
}
