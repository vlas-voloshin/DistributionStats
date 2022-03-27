import ArgumentParser
import Foundation

@main
struct DistributionStats: AsyncParsableCommand {

    @Option(parsing: .upToNextOption)
    var versions: [Version] = [12.2, 13.4, 14.1, 15.0]

    @Option
    var referenceVersion: Version = 12.0

    @Argument
    var regions: [Region] = [.worldwide]

    func run() async throws {
        for region in regions {
            print("Loading stats for \(region)...")
            let shares = try await StatCounterService(region: region).marketShareRecords()
            let results = MarketShareProcessor(region: region, shares: shares)
                .results(versions: versions, referenceVersion: referenceVersion)
            print(results, "\n\n")
        }
    }

}
