import Foundation

extension Sequence {

    func sorted<C: Comparable>(ascending: Bool = true, by selector: (Element) throws -> C) rethrows -> [Element] {
        try sorted { first, second in
            let firstComparable = try selector(first)
            let secondComparable = try selector(second)
            if ascending {
                return firstComparable < secondComparable
            } else {
                return firstComparable > secondComparable
            }
        }
    }

}
