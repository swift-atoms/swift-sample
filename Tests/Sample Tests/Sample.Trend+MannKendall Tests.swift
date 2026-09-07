import Sample
import Testing

@Suite
struct `Mann Kendall trends quantify ordered evidence with tie correction` {
    @Suite struct `Mann Kendall evidence distinguishes increasing decreasing and flat observations` {}
    @Suite struct `Mann Kendall evidence handles nonfinite and short observation sequences` {}
    @Suite struct `Mann Kendall projections support generic ordered samples` {}
}

extension `Mann Kendall trends quantify ordered evidence with tie correction`.`Mann Kendall evidence distinguishes increasing decreasing and flat observations` {
    @Test
    func `Increasing observations produce positive Mann Kendall evidence`() {
        let trend = Sample.Trend.mannKendall([1.0, 2.0, 3.0, 4.0, 5.0], value: { $0 })

        #expect(trend.statistic == 10)
        #expect(abs(trend.variance - (50.0 / 3.0)) < 1e-12)
        #expect(abs(trend.standardized - 2.2045407685048604) < 1e-12)
        #expect(trend.included == 5)
        #expect(trend.excluded == 0)
        #expect(trend.ties == 0)
    }

    @Test
    func `Decreasing observations produce negative Mann Kendall evidence`() {
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

extension `Mann Kendall trends quantify ordered evidence with tie correction`.`Mann Kendall evidence handles nonfinite and short observation sequences` {
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

extension `Mann Kendall trends quantify ordered evidence with tie correction`.`Mann Kendall projections support generic ordered samples` {
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
