import Sample
import Testing

@Suite
struct `Sample Trend Mann Kendall Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Sample Trend Mann Kendall Tests`.Unit {
    @Test
    func `strictly increasing observations`() {
        let trend = Sample.Trend.mannKendall([1.0, 2.0, 3.0, 4.0, 5.0], value: { $0 })

        #expect(trend.statistic == 10)
        #expect(abs(trend.variance - (50.0 / 3.0)) < 1e-12)
        #expect(abs(trend.standardized - 2.2045407685048604) < 1e-12)
        #expect(trend.included == 5)
        #expect(trend.excluded == 0)
        #expect(trend.ties == 0)
    }

    @Test
    func `strictly decreasing observations`() {
        let trend = Sample.Trend.mannKendall([5.0, 4.0, 3.0, 2.0, 1.0], value: { $0 })

        #expect(trend.statistic == -10)
        #expect(abs(trend.standardized + 2.2045407685048604) < 1e-12)
    }

    @Test
    func `ties correct the variance`() {
        let trend = Sample.Trend.mannKendall([1.0, 1.0, 2.0, 2.0], value: { $0 })

        #expect(trend.statistic == 4)
        #expect(abs(trend.variance - (20.0 / 3.0)) < 1e-12)
        #expect(abs(trend.standardized - 1.161895003862225) < 1e-12)
        #expect(trend.ties == 2)
    }

    @Test
    func `flat observations have no variance`() {
        let trend = Sample.Trend.mannKendall([7.0, 7.0, 7.0, 7.0], value: { $0 })

        #expect(trend.statistic == 0)
        #expect(trend.variance == 0)
        #expect(trend.standardized == 0)
        #expect(trend.ties == 1)
    }
}

extension `Sample Trend Mann Kendall Tests`.`Edge Case` {
    @Test
    func `non-finite observations are explicitly excluded`() {
        let trend = Sample.Trend.mannKendall(
            [1.0, .nan, 2.0, .infinity, 3.0],
            value: { $0 }
        )

        #expect(trend.statistic == 3)
        #expect(abs(trend.variance - (11.0 / 3.0)) < 1e-12)
        #expect(trend.included == 3)
        #expect(trend.excluded == 2)
    }

    @Test(arguments: [[], [1.0]])
    func `short observations produce neutral evidence`(_ observations: [Double]) {
        let trend = Sample.Trend.mannKendall(observations, value: { $0 })

        #expect(trend.statistic == 0)
        #expect(trend.variance == 0)
        #expect(trend.standardized == 0)
        #expect(trend.included == observations.count)
    }
}

extension `Sample Trend Mann Kendall Tests`.Integration {
    @Test
    func `projection supports generic ordered samples`() {
        struct Observation {
            let measurement: Double
        }

        let observations = [Observation(measurement: 1), Observation(measurement: 3)]
        let trend = Sample.Trend.mannKendall(observations, value: \.measurement)

        #expect(trend.statistic == 1)
        #expect(trend.included == 2)
    }
}
