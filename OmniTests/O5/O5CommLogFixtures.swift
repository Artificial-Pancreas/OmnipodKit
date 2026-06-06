import Foundation
@testable import OmnipodKit

enum O5CommLogFixtures {
    private static func hex(_ string: String) -> Data {
        guard let data = Data(hexadecimalString: string) else {
            fatalError("Invalid fixture hex: \(string)")
        }
        return data
    }

    // MARK: - AID activation (2026-05-31 08:06:32 UTC, pod 002A1C6E)

    static let utcSend = hex("53453235352e323d31373830323134373932")
    static let utcRecvBody = hex("30")

    static let tdiSend = hex("53332e323d0003000e002c47332e32")
    static let tdiRecvBody = hex("0003000e00")

    static let diaSend = hex("53332e393d382c47332e39")
    static let diaRecvBody = hex("38")

    static let egvSend = hex("53332e373d333637303031352c47332e37")
    static let egvRecvBody = hex("33363730303135")

    static let insulinHistorySendPrefix = hex("5345322e313d00a8")
    static let insulinHistoryRecvBody = hex("30")

    /// Unix timestamp ASCII embedded in `utcSend` (`SE255.2=…`).
    static let utcTimestamp: UInt64 = 1_780_214_792

    static let egvValue = "3670015"
    static let diaValue = "8"
    static let targetMgdl: UInt32 = 0x6E

    static let targetBgProfileSend: Data = {
        var data = hex("53332e313d00c0")
        for _ in 0 ..< 48 {
            data.appendBigEndian(targetMgdl)
        }
        data.append(hex("2c47332e31"))
        return data
    }()

    static let targetBgProfileRecvBody: Data = {
        var data = hex("00c0")
        for _ in 0 ..< 48 {
            data.appendBigEndian(targetMgdl)
        }
        return data
    }()

    static let algorithmInsulinHistorySend: Data = {
        var data = insulinHistorySendPrefix
        data.append(Data(count: 168))
        return data
    }()

    // MARK: - BolusExtraCommand 0x12 (20-byte block from comm log)

    static let oneUnitBolusExtra = hex("17120000c800030d400000000000000100c80000")
    static let primeBolusExtra = hex("1712000208000186a00000000000000100000000")
    static let cannulaBolusExtra = hex("1712000064000186a00000000000000100000000")
}
