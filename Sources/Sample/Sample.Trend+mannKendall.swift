extension Sample.Trend {

    public static func mannKendall<Observations: Swift.Sequence>(
        _ observations: Observations,
        value: (Observations.Element) -> Double
    ) -> Self {
        var values: [Double] = []
        var excludedCount = 0

        for observation in observations {
            let projected = value(observation)
            if projected.isFinite {
                values.append(projected)
            } else {
                excludedCount += 1
            }
        }

        var statistic = 0
        if values.count > 1 {
            for earlierIndex in values.indices.dropLast() {
                for later in values[values.index(after: earlierIndex)...] {
                    if later > values[earlierIndex] {
                        statistic += 1
                    } else if later < values[earlierIndex] {
                        statistic -= 1
                    }
                }
            }
        }

        var frequencies: [Double: Int] = [:]
        for value in values {
            frequencies[value, default: 0] += 1
        }

        let sampleCount = values.count
        let count = Double(sampleCount)
        let uncorrected = count * (count - 1) * (2 * count + 5)
        let tieCorrection = frequencies.values.reduce(into: 0.0) { correction, frequency in
            guard frequency > 1 else { return }
            let count = Double(frequency)
            correction += count * (count - 1) * (2 * count + 5)
        }
        let variance = sampleCount > 1 ? (uncorrected - tieCorrection) / 18 : 0

        let standardized: Double
        if variance > 0, statistic > 0 {
            standardized = Double(statistic - 1) / variance.squareRoot()
        } else if variance > 0, statistic < 0 {
            standardized = Double(statistic + 1) / variance.squareRoot()
        } else {
            standardized = 0
        }

        return Self(
            statistic: statistic,
            variance: variance,
            standardized: standardized,
            included: sampleCount,
            excluded: excludedCount,
            ties: frequencies.values.count { $0 > 1 }
        )
    }
}
