extension Sample.Regression {

    /// Why a regression has no fit.
    public enum Error: Swift.Error, Sendable, Hashable {

        /// Fewer than two points were given.
        case insufficientPoints

        /// Every x value is equal, so no line through the points has a defined slope.
        case constantX
    }
}
