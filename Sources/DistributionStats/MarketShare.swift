import Foundation

typealias Version = Float
typealias Percentage = Float

struct MarketShare {

    let version: Version
    let percentage: Percentage

    init?(versionString: String, shareString: String) {
        guard
            let versionStart = versionString.range(of: "iOS ")?.upperBound,
            let version = Version(versionString[versionStart...]),
            let share = Percentage(shareString)
        else {
            return nil
        }

        self.version = version
        self.percentage = share
    }

    init?(csvRow fields: [String]) {
        guard fields.count == 2 else { return nil }
        self.init(versionString: fields[0], shareString: fields[1])
    }
    
}
