public import Algebra

extension Sample.Accumulator {

    /// The commutative monoid for merging sample accumulators.
    @inlinable
    public static var commutativeMonoid: Algebra.Monoid<Self>.Commutative {
        Self.monoid
    }
}
