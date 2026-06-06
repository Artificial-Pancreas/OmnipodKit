func optionalString(_ object: Any?) -> String {
    if object == nil {
        return "nil"
    }
    return String(describing: object!)
}

func optionalInsulinString(_ amount: Double?) -> String {
    if amount == nil {
        return "- U"
    }
    return amount!.twoDecimals + " U"
}

func optionalReservoirString(_ amount: Double?) -> String {
    if amount == nil || amount! == Pod.reservoirLevelAboveThresholdMagicNumber {
        return "50+ U"
    }
    return amount!.twoDecimals + " U"
}
