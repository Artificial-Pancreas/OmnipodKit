import Foundation

struct PodInfoResponse: MessageBlock {
    let blockType: MessageBlockType = .podInfoResponse
    let podInfoResponseSubType: PodInfoResponseSubType
    let podInfo: PodInfo
    let data: Data

    init(encodedData: Data) throws {
        guard let subType = PodInfoResponseSubType(rawValue: encodedData[2]) else {
            throw MessageError.unknownValue(value: encodedData[2], typeDescription: "PodInfoResponseSubType")
        }
        podInfoResponseSubType = subType
        let len = encodedData.count
        podInfo = try podInfoResponseSubType.podInfoType.init(encodedData: encodedData.subdata(in: 2 ..< len))
        data = encodedData
    }
}

extension PodInfoResponse: CustomDebugStringConvertible {
    var debugDescription: String {
        "PodInfoResponse(\(blockType), \(podInfoResponseSubType), \(podInfo)"
    }
}
