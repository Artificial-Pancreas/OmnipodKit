import CoreBluetooth
import Foundation

enum PodProtocolError: Error {
    case invalidLTKKey(_ message: String)
    case pairingException(_ message: String)
    case messageIOException(_ message: String)
    case couldNotParseMessageException(_ message: String)
    case incorrectPacketException(_ payload: Data, _ location: Int)
    case invalidCrc(payloadCrc: Data, computedCrc: Data)
}

extension PodProtocolError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .invalidLTKKey(message):
            return String(format: "Invalid LTK Key: %1$@", message)
        case let .pairingException(message):
            return String(format: "Pairing Exception: %1$@", message)
        case let .messageIOException(message):
            return String(format: "Message IO Exception: %1$@", message)
        case let .couldNotParseMessageException(message):
            return String(format: "Could not parse message: %1$@", message)
        case let .incorrectPacketException(payload, location):
            let payloadStr = payload.hexadecimalString
            return String(format: "Incorrect Packet Exception: %1$@ (location=%2$d)", payloadStr, location)
        case let .invalidCrc(payloadCrc, computedCrc):
            return String(
                format: "Payload crc32 %1$@ does not match computed crc32 %2$@",
                payloadCrc.hexadecimalString,
                computedCrc.hexadecimalString
            )
        }
    }

    var failureReason: String? {
        nil
    }

    var recoverySuggestion: String? {
        nil
    }
}
