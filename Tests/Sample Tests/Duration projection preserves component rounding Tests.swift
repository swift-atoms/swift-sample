import Sample
import Testing

@Suite struct `Duration projection preserves component rounding` {
    @Test func `projection matches native components throughout their representable domain`() {
        let averaging = Sample.Averaging<Duration>.duration

        func verify(seconds: Int64, attoseconds: Int64) {
            let duration = Duration(secondsComponent: seconds, attosecondsComponent: attoseconds)
            let components = duration.components
            let expected = Double(components.seconds) + Double(components.attoseconds) / 1e18
            #expect(averaging.project(duration).bitPattern == expected.bitPattern)
        }

        let seconds: [Int64] = [
            .min, .min + 1, -(1 << 53), -1000, -2, -1, 0, 1, 2, 1000,
            1 << 53, .max - 1, .max,
        ]
        let fractions: [Int64] = [
            -999_999_999_999_999_999, -500_000_000_000_000_000,
            -250_000_000_000_000_000, -1_000_000_000, -1, 0, 1, 1_000_000_000,
            250_000_000_000_000_000, 500_000_000_000_000_000, 999_999_999_999_999_999,
        ]
        for second in seconds {
            for fraction in fractions {
                verify(seconds: second, attoseconds: fraction)
            }
        }

        var state: UInt64 = 0x91a3_7bc8_456d_20ef
        for index in 0..<8192 {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            let second =
                index.isMultiple(of: 2)
                ? Int64(bitPattern: state)
                : Int64(state % 2_000_001) - 1_000_000
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            let fraction = Int64(state % 2_000_000_000_000_000_000) - 1_000_000_000_000_000_000
            verify(seconds: second, attoseconds: fraction)
        }
    }

    @Test(arguments: [Int128.min, .min + 1, .max - 1, .max])
    func `projection accepts durations beyond the native component extent`(attoseconds: Int128) {
        let projected = Sample.Averaging<Duration>.duration.project(.init(attoseconds: attoseconds))
        let expected: UInt64 = attoseconds < 0 ? 0xc422_725d_d1d2_43ac : 0x4422_725d_d1d2_43ac
        #expect(projected.bitPattern == expected)
        #expect(projected.isFinite)
    }

    @Test func `sampling and scalar conversions retain their distinct fractional rounding`() {
        let duration = Duration(
            secondsComponent: 1000,
            attosecondsComponent: 250_000_000_000_000_000
        )
        #expect(Sample.Averaging<Duration>.duration.project(duration) == 1000.25)
        #expect(duration.inSeconds.bitPattern == 4_652_009_507_864_444_927)
    }
}
