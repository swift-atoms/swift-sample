public import Witness

extension Sample.Accumulator {

    @frozen
    public struct Monoid: Witness.`Protocol`, Sendable {

        public let identity: Sample.Accumulator

        @inlinable
        public init(identity: Sample.Accumulator = .empty) {
            self.identity = identity
        }

        @inlinable
        public func callAsFunction(
            _ lhs: Sample.Accumulator,
            _ rhs: Sample.Accumulator
        ) -> Sample.Accumulator {
            lhs.merged(with: rhs)
        }
    }

    @inlinable
    public static var monoid: Monoid {
        Monoid()
    }
}
