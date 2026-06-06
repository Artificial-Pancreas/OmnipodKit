import Foundation
import LoopKit

class DeliveryUncertaintyRecoveryViewModel: PumpManagerStatusObserver {
    let appName: String
    let uncertaintyStartedAt: Date
    var podTypeDependentRecoveryActions = ""

    var onDismiss: (() -> Void)?
    var didRecover: (() -> Void)?
    var onDeactivate: (() -> Void)?

    private var finished = false

    init(appName: String, uncertaintyStartedAt: Date, usesRileyLink: Bool) {
        self.appName = appName
        self.uncertaintyStartedAt = uncertaintyStartedAt
        if usesRileyLink {
            podTypeDependentRecoveryActions = LocalizedString(
                " or select a different RileyLink; power the RileyLink device off and on",
                comment: "delivery uncertainty recovery phrase when using a RileyLink"
            )
        }
    }

    func pumpManager(_: PumpManager, didUpdate status: PumpManagerStatus, oldStatus _: PumpManagerStatus) {
        if !finished {
            if !status.deliveryIsUncertain {
                didRecover?()
            }
        }
    }

    func podDeactivationChosen() {
        finished = true
        onDeactivate?()
    }
}
