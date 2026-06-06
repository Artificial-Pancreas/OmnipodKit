import Foundation

struct AssignAddressCommand: MessageBlock {
    let blockType: MessageBlockType = .assignAddress
    let length: Int = 6

    let address: UInt32

    var data: Data {
        var data = Data([
            blockType.rawValue,
            4
        ])
        data.appendBigEndian(address)
        return data
    }

    init(encodedData: Data) throws {
        if encodedData.count < length {
            throw MessageBlockError.notEnoughData
        }

        address = encodedData[2...].toBigEndian(UInt32.self)
    }

    init(address: UInt32) {
        self.address = address
    }
}

extension AssignAddressCommand: CustomDebugStringConvertible {
    var debugDescription: String {
        "AssignAddressCommand(address:\(Data(bigEndian: address).hexadecimalString))"
    }
}
