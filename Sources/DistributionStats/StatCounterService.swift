import CSV
import Foundation

struct StatCounterService {

    struct Period: CustomStringConvertible {
        var year: Int
        var month: Int

        var description: String { stringWithDash }

        static var current: Period {
            let components = Calendar.gregorianGMT.dateComponents([.year, .month], from: Date())
            return .init(year: components.year!, month: components.month!)
        }
    }

    enum ServiceError: Error {
        case invalidResponse
    }

    var region: Region
    var periodFrom: Period
    var periodTo: Period

    init(region: Region, periodFrom: Period, periodTo: Period) {
        self.region = region
        self.periodFrom = periodFrom
        self.periodTo = periodTo
    }

    init(region: Region, period: Period = .current) {
        self.init(region: region, periodFrom: period, periodTo: period)
    }

    func marketShareRecords() async throws -> [MarketShare] {
        let (data, _) = try await URLSession.shared.data(from: csvURL)
        guard let string = String(data: data, encoding: .utf8) else {
            throw ServiceError.invalidResponse
        }
        let reader = try CSVReader(string: string, hasHeaderRow: true)
        return reader.compactMap { MarketShare(csvRow: $0) }
            .sorted(ascending: false, by: \.version)
    }

    // MARK: - Private

    private var csvURL: URL {
        var components = URLComponents(string: "https://gs.statcounter.com/chart.php")!
        components.queryItems = [
            .init(name: "csv", value: "1"),
            .init(name: "bar", value: "1"),
            .init(name: "device_hidden", value: "mobile"),
            .init(name: "statType_hidden", value: "ios_version"),
            .init(name: "region_hidden", value: region.rawValue),
            .init(name: "granularity", value: "monthly"),
            .init(name: "fromInt", value: periodFrom.stringWithoutDash),
            .init(name: "toInt", value: periodTo.stringWithoutDash),
            .init(name: "fromMonthYear", value: periodFrom.stringWithDash),
            .init(name: "toMonthYear", value: periodTo.stringWithDash)
        ]
        return components.url!
    }

}

// MARK: - Private extensions

private extension StatCounterService.Period {

    var dateGMT: Date {
        let components = DateComponents(year: year, month: month)
        return Calendar.gregorianGMT.date(from: components)!
    }

    var stringWithoutDash: String {
        ISO8601DateFormatter.periodWithoutDash.string(from: dateGMT)
    }

    var stringWithDash: String {
        ISO8601DateFormatter.periodWithDash.string(from: dateGMT)
    }

}

private extension ISO8601DateFormatter {

    static let periodWithoutDash: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth]
        return formatter
    }()

    static let periodWithDash: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        return formatter
    }()

}

private extension Calendar {

    static let gregorianGMT: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

}
