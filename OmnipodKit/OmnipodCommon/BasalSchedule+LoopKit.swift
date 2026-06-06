import Foundation
import LoopKit

extension BasalSchedule {
    init(repeatingScheduleValues: [RepeatingScheduleValue<Double>], podType: PodType) {
        self
            .init(
                entries: repeatingScheduleValues
                    .map { BasalScheduleEntry(rate: $0.value, startTime: $0.startTime, podType: podType) }
            )
    }
}
