import Order
import Comparison
import Sample
import Sample
import Order
import Comparison
import Testing

@Suite
struct `Sample Order Tests` {

    @Test
    func `order comparator constructs a sorted sample batch`() {
        let values = [4, 1, 3, 2]
        let comparator: Order.Comparator<Int> = .ascending
        let batch = Sample.Batch(
            count: values.count,
            sortedBy: comparator,
            initializingWith: { values[$0] }
        )

        #expect(batch.withMin { $0 } == 1)
        #expect(batch.withMedian { $0 } == 3)
        #expect(batch.withMax { $0 } == 4)
    }
}
