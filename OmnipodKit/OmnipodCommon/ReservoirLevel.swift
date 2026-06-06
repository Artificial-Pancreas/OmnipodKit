import Foundation

enum ReservoirLevel: RawRepresentable, Equatable {
    typealias RawValue = Double

    case valid(Double)
    case aboveThreshold

    var percentage: Double {
        switch self {
        case .aboveThreshold:
            return 1
        case let .valid(value):
            // Set 50U as the halfway mark, even though pods can hold 200U.
            return min(1, max(0, value / 100))
        }
    }

    init(rawValue: RawValue) {
        if rawValue > Pod.maximumReservoirReading {
            self = .aboveThreshold
        } else {
            self = .valid(rawValue)
        }
    }

    var rawValue: RawValue {
        switch self {
        case let .valid(value):
            return value
        case .aboveThreshold:
            return Pod.reservoirLevelAboveThresholdMagicNumber
        }
    }
}
