import Foundation
import SwiftData

enum ExerciseModality: String, Codable, CaseIterable {
    case barbell
    case dumbbell
    case machine
    case cable
    case bodyweightPlusLoad
    case timed
}

@Model
final class TemplateDay {
    var dayIndex: Int // 1...7
    var title: String
    var kindRaw: String // "training" | "activeRecovery" | "rest"

    @Relationship(deleteRule: .cascade) var exercises: [TemplateExercise] = []

    init(dayIndex: Int, title: String, kindRaw: String) {
        self.dayIndex = dayIndex
        self.title = title
        self.kindRaw = kindRaw
    }

    var isTrainingDay: Bool { kindRaw == "training" }
    var isActiveRecovery: Bool { kindRaw == "activeRecovery" }
    var isRest: Bool { kindRaw == "rest" }
}

@Model
final class TemplateExercise {
    var name: String
    var sets: Int
    var reps: Int

    var modalityRaw: String
    var isMajorLift: Bool

    /// For weighted lifts: week 1 working weight target.
    var week1Weight: Double?

    /// For bodyweight+load lifts: week 1 added load target.
    var week1AddedLoad: Double?

    init(
        name: String,
        sets: Int,
        reps: Int,
        modality: ExerciseModality,
        isMajorLift: Bool = false,
        week1Weight: Double? = nil,
        week1AddedLoad: Double? = nil
    ) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.modalityRaw = modality.rawValue
        self.isMajorLift = isMajorLift
        self.week1Weight = week1Weight
        self.week1AddedLoad = week1AddedLoad
    }

    var modality: ExerciseModality {
        get { ExerciseModality(rawValue: modalityRaw) ?? .barbell }
        set { modalityRaw = newValue.rawValue }
    }
}
