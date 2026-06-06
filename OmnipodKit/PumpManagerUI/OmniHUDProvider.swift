import LoopKit
import LoopKitUI
import SwiftUI
import UIKit

enum ReservoirAlertState {
    case ok
    case lowReservoir
    case empty
}

internal class OmniHUDProvider: NSObject, HUDProvider {
    var managerIdentifier: String {
        pumpManager.pluginIdentifier
    }

    private let pumpManager: OmniPumpManager

    private var reservoirView: OmniReservoirView?

    private let bluetoothProvider: BluetoothProvider

    private let colorPalette: LoopUIColorPalette

    private let allowedInsulinTypes: [InsulinType]

    var visible: Bool = false {
        didSet {
            if oldValue != visible, visible {
                hudDidAppear()
            }
        }
    }

    init(
        pumpManager: OmniPumpManager,
        bluetoothProvider: BluetoothProvider,
        colorPalette: LoopUIColorPalette,
        allowedInsulinTypes: [InsulinType]
    ) {
        self.pumpManager = pumpManager
        self.bluetoothProvider = bluetoothProvider
        self.colorPalette = colorPalette
        self.allowedInsulinTypes = allowedInsulinTypes
        super.init()
        self.pumpManager.addPodStateObserver(self, queue: .main)
    }

    func createHUDView() -> BaseHUDView? {
        reservoirView = OmniReservoirView.instantiate()
        updateReservoirView()

        return reservoirView
    }

    func didTapOnHUDView(_: BaseHUDView, allowDebugFeatures: Bool) -> HUDTapAction? {
        let vc = pumpManager.settingsViewController(
            bluetoothProvider: bluetoothProvider,
            colorPalette: colorPalette,
            allowDebugFeatures: allowDebugFeatures,
            allowedInsulinTypes: allowedInsulinTypes
        )
        return HUDTapAction.presentViewController(vc)
    }

    func hudDidAppear() {
        updateReservoirView()
        refresh()
    }

    var hudViewRawState: HUDProvider.HUDViewRawState {
        var rawValue: HUDProvider.HUDViewRawState = [:]

        rawValue["lastStatusDate"] = pumpManager.lastStatusDate

        if let reservoirLevel = pumpManager.reservoirLevel {
            rawValue["reservoirLevel"] = reservoirLevel.rawValue
        }

        if let reservoirLevelHighlightState = pumpManager.reservoirLevelHighlightState {
            rawValue["reservoirLevelHighlightState"] = reservoirLevelHighlightState.rawValue
        }

        return rawValue
    }

    static func createHUDView(rawValue: HUDProvider.HUDViewRawState) -> BaseHUDView? {
        guard let rawReservoirLevel = rawValue["reservoirLevel"] as? ReservoirLevel.RawValue,
              let rawReservoirLevelHighlightState = rawValue["reservoirLevelHighlightState"] as? ReservoirLevelHighlightState
              .RawValue,
              let reservoirLevelHighlightState = ReservoirLevelHighlightState(rawValue: rawReservoirLevelHighlightState)
        else {
            return nil
        }

        let reservoirView: OmniReservoirView?

        let reservoirLevel = ReservoirLevel(rawValue: rawReservoirLevel)

        if let lastStatusDate = rawValue["lastStatusDate"] as? Date {
            reservoirView = OmniReservoirView.instantiate()
            reservoirView!.update(
                level: reservoirLevel,
                at: lastStatusDate,
                reservoirLevelHighlightState: reservoirLevelHighlightState
            )
        } else {
            reservoirView = nil
        }

        return reservoirView
    }

    private func refresh() {
        pumpManager.getPodStatus { _ in
            DispatchQueue.main.async {
                self.updateReservoirView()
            }
        }
    }

    private func updateReservoirView() {
        guard let reservoirView = reservoirView,
              let lastStatusDate = pumpManager.lastStatusDate,
              let reservoirLevelHighlightState = pumpManager.reservoirLevelHighlightState
        else {
            return
        }

        reservoirView.update(
            level: pumpManager.reservoirLevel,
            at: lastStatusDate,
            reservoirLevelHighlightState: reservoirLevelHighlightState
        )
    }
}

extension OmniHUDProvider: PodStateObserver {
    func podConnectionStateDidChange(isConnected _: Bool) {
        // ignore for now
    }

    func podStateDidUpdate(_: PodState?) {
        updateReservoirView()
    }
}
