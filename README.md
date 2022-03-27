# DistributionStats

This CLI tool queries [Statcounter GlobalStats](https://gs.statcounter.com/ios-version-market-share/mobile) for the market shares of different iOS versions across one or more regions, and aggregates them to determine the cumulative percentage of devices running **at least** the specified version. The aggregated statistics are relative to the total, the reference version, and the previous major iOS version. This information can be useful to choose the minimum deployment target for iOS apps in a particular region based on market penetration.

## Usage

```
USAGE: distribution-stats [--versions <versions> ...] [--reference-version <reference-version>] [<regions> ...]

ARGUMENTS:
  <regions>               (default: Worldwide)

OPTIONS:
  --versions <versions>   (default: 12.2, 13.4, 14.1, 15.0)
  --reference-version <reference-version>
                          (default: 12.0)
  -h, --help              Show help information.
```

For example:
```
distribution-stats ww na
distribution-stats --versions 14.1 15.0 -- eu us
```

## Output Example

```
Loading stats for Worldwide...
Stats for Worldwide:
iOS 12.2+
Share in total: 98.4%
Share in iOS 12.0+: 99.8%
Share in iOS 12.0+: 99.8%

iOS 13.4+
Share in total: 95.1%
Share in iOS 12.0+: 96.4%
Share in iOS 13.0+: 99.2%

iOS 14.1+
Share in total: 93.2%
Share in iOS 12.0+: 94.5%
Share in iOS 14.0+: 99.6%

iOS 15.0+
Share in total: 74.1%
Share in iOS 12.0+: 75.1%
Share in iOS 14.0+: 79.1% 
```
