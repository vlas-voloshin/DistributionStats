import Foundation

struct MarketShareProcessor {

    struct Results: CustomStringConvertible {
        struct Item: CustomStringConvertible {
            let version: Version
            let previousMajorVersion: Version
            let referenceVersion: Version

            let cumulativeShare: Percentage
            let shareOfPreviousMajorVersion: Percentage
            let shareOfReferenceVersion: Percentage

            var description: String {
                """
                iOS \(version)+
                Share in total: \(String(format: "%.1f", cumulativeShare))%
                Share in iOS \(referenceVersion)+: \(String(format: "%.1f", shareOfReferenceVersion))%
                Share in iOS \(previousMajorVersion)+: \(String(format: "%.1f", shareOfPreviousMajorVersion))%
                """
            }
        }

        let region: Region
        let items: [Item]

        var description: String {
            "Stats for \(region):\n" +
            items.map(\.description).joined(separator: "\n\n")
        }
    }

    let region: Region
    let shares: [MarketShare]

    func results(versions: [Version], referenceVersion: Version) -> Results {
        Results(region: region, items: versions.map { version in
            let isFirstMinorVersion = version.remainder(dividingBy: 1) <= .ulpOfOne
            let previousMajorVersion = isFirstMinorVersion ? version - 1 : version.rounded(.towardZero)
            return .init(
                version: version,
                previousMajorVersion: previousMajorVersion,
                referenceVersion: referenceVersion,

                cumulativeShare: shares.cumulativeShare(ofVersion: version),
                shareOfPreviousMajorVersion: shares.cumulativeShare(ofVersion: version, relativeToVersion: previousMajorVersion),
                shareOfReferenceVersion: shares.cumulativeShare(ofVersion: version, relativeToVersion: referenceVersion)
            )
        })
    }

}

// MARK: - Private extensions

private extension Collection where Element == MarketShare {

    func shares(atOrAboveVersion version: Version) -> [MarketShare] {
        filter { $0.version >= version }
    }

    func cumulativeShare(ofVersion version: Version) -> Percentage {
        shares(atOrAboveVersion: version).map(\.percentage).reduce(0, +)
    }

    func cumulativeShare(ofVersion version: Version, relativeToVersion referenceVersion: Version) -> Percentage {
        cumulativeShare(ofVersion: version) / cumulativeShare(ofVersion: referenceVersion) * 100
    }

}
