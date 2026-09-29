public import Algebra

extension Sample.Accumulator {

    @inlinable
    public static var commutativeMonoid: Algebra.Monoid<Self>.Commutative {
        Self.monoid
    }
}
