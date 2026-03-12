import Foundation
import SwiftData

@Model
final class AppSettings {
    var createdAt: Date
    var programStartDate: Date
    var roundingIncrement: Double
    var deloadWeek: Int

    init(
        createdAt: Date = .now,
        programStartDate: Date = Calendar.current.startOfDay(for: .now),
        roundingIncrement: Double = 5,
        deloadWeek: Int = 7
    ) {
        self.createdAt = createdAt
        self.programStartDate = programStartDate
        self.roundingIncrement = roundingIncrement
        self.deloadWeek = deloadWeek
    }
}
