public import Witness

extension Sample {

    @frozen
    public struct Averaging<Element>: Witness.`Protocol` {

        public var zero: Element

        public var adding: @Sendable (Element, Element) -> Element

        public var dividing: @Sendable (Element, Int) -> Element

        public var project: @Sendable (Element) -> Double

        public var embed: @Sendable (Double) -> Element

        @inlinable
        public init(
            zero: Element,
            adding: @escaping @Sendable (Element, Element) -> Element,
            dividing: @escaping @Sendable (Element, Int) -> Element,
            project: @escaping @Sendable (Element) -> Double,
            embed: @escaping @Sendable (Double) -> Element
        ) {
            self.zero = zero
            self.adding = adding
            self.dividing = dividing
            self.project = project
            self.embed = embed
        }
    }
}

extension Sample.Averaging: Sendable where Element: Sendable {}

extension Sample.Averaging where Element == Duration {

    @inlinable
    public static var duration: Self {
        .init(
            zero: .zero,
            adding: { $0 + $1 },
            dividing: { $0 / $1 },
            project: {
                let components = $0.components
                return Double(components.seconds)
                    + Double(components.attoseconds) / 1_000_000_000_000_000_000
            },
            embed: {
                let seconds = Int64($0)
                let attoseconds = Int64(
                    ($0 - Double(seconds)) * 1_000_000_000_000_000_000
                )
                return Duration(
                    secondsComponent: seconds,
                    attosecondsComponent: attoseconds
                )
            }
        )
    }
}

extension Sample.Averaging where Element == Double {

    @inlinable
    public static var real: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / Double($1) },
            project: { $0 },
            embed: { $0 }
        )
    }
}

extension Sample.Averaging where Element == Int {

    @inlinable
    public static var integer: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / $1 },
            project: { Double($0) },
            embed: { Int($0) }
        )
    }
}

extension Sample.Averaging where Element == UInt64 {

    @inlinable
    public static var natural: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / UInt64($1) },
            project: { Double($0) },
            embed: { UInt64($0) }
        )
    }
}
