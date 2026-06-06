import Foundation

extension NumberFormatter {
    func decibleString(from decibles: Int?) -> String? {
        if let decibles = decibles, let formatted = string(from: NSNumber(value: decibles)) {
            return String(format: "%@ dB", formatted)
        } else {
            return nil
        }
    }

    func string(from number: Double) -> String? {
        string(from: NSNumber(value: number))
    }
}
