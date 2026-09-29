import Sample
import Time
import Testing

@Suite
struct `Duration sampling retains temporal units` {
    @Test func `duration averaging projects and embeds signed fractional seconds`() {
        let averaging = Sample.Averaging<Duration>.duration
        #expect(averaging.zero == .zero)
        #expect(averaging.project(.milliseconds(1250)) == 1.25)
        #expect(averaging.project(.milliseconds(-1250)) == -1.25)
        #expect(averaging.embed(1.25) == .milliseconds(1250))
        #expect(averaging.embed(-1.25) == .milliseconds(-1250))
        #expect(averaging.project(.init(attoseconds: 1)) == 1e-18)
    }

    @Test func `duration samples retain their sum mean and dispersion`() {
        let averaging = Sample.Averaging<Duration>.duration
        let batch = Sample.Batch([
            Duration.milliseconds(-500), .milliseconds(500), .milliseconds(1500),
        ])
        #expect(batch.sum(using: averaging) == .milliseconds(1500))
        #expect(batch.mean(using: averaging) == .milliseconds(500))
        #expect(batch.standardDeviation(using: averaging) == .seconds(1))
    }

    @Test func `duration sampling adopts the lower projection and preserves the scalar conversion`() {
        let averaging = Sample.Averaging<Duration>.duration
        let duration = Duration(
            secondsComponent: 1000,
            attosecondsComponent: 250_000_000_000_000_000
        )
        #expect(averaging.project(duration) == 1000.25)
        #expect(duration.inSeconds.bitPattern == 4_652_009_507_864_444_927)
    }

    @Test func `duration projection accepts the full native storage range`() {
        let averaging = Sample.Averaging<Duration>.duration
        #expect(averaging.project(.init(attoseconds: .max)).bitPattern == 0x4422725dd1d243ac)
        #expect(averaging.project(.init(attoseconds: .min)).bitPattern == 0xc422725dd1d243ac)
    }
}
