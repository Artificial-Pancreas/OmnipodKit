import Foundation
import LoopKitUI
import OmnipodKit
import os.log

class OmnipodKitPlugin: NSObject, PumpManagerUIPlugin {
    private let log = OSLog(__subsystem: "OmnipodKitPlugin", category: "com.loopkit.omnipodkit")

    public var pumpManagerType: PumpManagerUI.Type? {
        OmniPumpManager.self
    }

    public var cgmManagerType: CGMManagerUI.Type? {
        nil
    }

    override init() {
        super.init()
        log.default("OmnipodKitPlugin Instantiated")
    }
}
