import Foundation
import OSLog

class Omni {
    var manager: PeripheralManager
    var advertisement: PodAdvertisement?

    init(peripheralManager: PeripheralManager, advertisement: PodAdvertisement?) {
        manager = peripheralManager
        self.advertisement = advertisement
    }
}

extension Omni: CustomDebugStringConvertible {
    var debugDescription: String {
        "Omni - advertisement: \(String(describing: advertisement))"
    }
}
