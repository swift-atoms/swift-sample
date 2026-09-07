@_exported public import Algebra

extension Sample.Accumulator {

    @inlinable
    public static var monoid: Algebra.Monoid<Self>.Commutative {
        .init(
            monoid: .init(
                identity: .empty,
                combining: { $0.merged(with: $1) }
            )
        )
    }
}
