// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DistributionStats",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "DistributionStats",
            targets: ["DistributionStats"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "git@github.com:yaslab/CSV.swift", from: "2.4.3")
    ],
    targets: [
        .executableTarget(
            name: "DistributionStats",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CSV", package: "CSV.swift")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
