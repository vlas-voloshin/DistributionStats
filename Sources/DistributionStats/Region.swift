import ArgumentParser
import Foundation

struct Region: RawRepresentable, Hashable, ExpressibleByArgument {
    let rawValue: String
}

// MARK: - Common values

extension Region {

    init(_ rawValue: String) { self.rawValue = rawValue }

    static let worldwide = Self("ww")

    // Global regions
    static let africa = Self("af")
    static let antarctica = Self("an")
    static let asia = Self("as")
    static let europe = Self("eu")
    static let northAmerica = Self("na")
    static let oceania = Self("oc")
    static let southAmerica = Self("sa")

    // Featured countries
    static let australia = Self("AU")
    static let canada = Self("CA")
    static let india = Self("IN")
    static let unitedKingdom = Self("GB")
    static let unitedStatesOfAmerica = Self("US")

}

// MARK: - CustomStringConvertible

extension Region: CustomStringConvertible {

    var description: String {
        switch self {
        case .worldwide: return "Worldwide"
        case .africa: return "Africa"
        case .antarctica: return "Antarctica"
        case .asia: return "Asia"
        case .europe: return "Europe"
        case .northAmerica: return "North America"
        case .oceania: return "Oceania"
        case .southAmerica: return "South America"
        default:
            return Locale.current.localizedString(forRegionCode: rawValue) ?? rawValue.uppercased()
        }
    }

}
