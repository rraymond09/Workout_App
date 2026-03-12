import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var date: Date
    var weekNumber: Int
    var dayIndex: Int
    var title: String

    @Relationship(deleteRule: .cascade) var exercises: [ExerciseLog] = []

    init(date: Date, weekNumber: Int, dayIndex: Int, title: String) {
        self.date = date
        self.weekNumber = weekNumber
        self.dayIndex = dayIndex
        self.title = title
    }
}

@Model
final class ExerciseLog {
    var name: String
    var modalityRaw: String

    var prescribedSets: Int
    var prescribedReps: Int

    /// Stored targets used for that session (so history never changes if logic changes later).
    var targetWeight: Double?
    var targetAddedLoad: Double?

    @Relationship(deleteRule: .cascade) var sets: [SetLog] = []

    init(
        name: String,
        modality: ExerciseModality,
        prescribedSets: Int,
        prescribedReps: Int,
        targetWeight: Double? = nil,
        targetAddedLoad: Double? = nil
    ) {
        self.name = name
        self.modalityRaw = modality.rawValue
        self.prescribedSets = prescribedSets
        self.prescribedReps = prescribedReps
        self.targetWeight = targetWeight
        self.targetAddedLoad = targetAddedLoad
    }

    var modality: ExerciseModality {
        get { ExerciseModality(rawValue: modalityRaw) ?? .barbell }
        set { modalityRaw = newValue.rawValue }
    }
}

@Model
final class SetLog {
    var setNumber: Int
    var reps: Int
    var weight: Double?
    var addedLoad: Double?
    var completed: Bool

    init(setNumber: Int, reps: Int = 0, weight: Double? = nil, addedLoad: Double? = nil, completed: Bool = false) {
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
        self.addedLoad = addedLoad
        self.completed = completed
    }
}

@Model
final class MorningRoutineLog {
    var date: Date
    var mobilityCompleted: Bool
    var cardioCompleted: Bool

    init(date: Date, mobilityCompleted: Bool = false, cardioCompleted: Bool = false) {
        self.date = Calendar.current.startOfDay(for: date)
        self.mobilityCompleted = mobilityCompleted
        self.cardioCompleted = cardioCompleted
    }
}

@Model
final class DailyChecklistLog {
    var date: Date

    // Meals 1-6
    var meal1: Bool
    var meal2: Bool
    var meal3: Bool
    var meal4: Bool
    var meal5: Bool
    var meal6: Bool

    // Supplements
    var creatine: Bool
    var whey: Bool
    var fishOil: Bool
    var magnesium: Bool
    var vitaminD3: Bool
    var electrolytes: Bool
    var citrullineMalate: Bool
    var betaAlanine: Bool

    // Goals met
    var waterGoalMet: Bool
    var sleepGoalMet: Bool

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)

        self.meal1 = false
        self.meal2 = false
        self.meal3 = false
        self.meal4 = false
        self.meal5 = false
        self.meal6 = false

        self.creatine = false
        self.whey = false
        self.fishOil = false
        self.magnesium = false
        self.vitaminD3 = false
        self.electrolytes = false
        self.citrullineMalate = false
        self.betaAlanine = false

        self.waterGoalMet = false
        self.sleepGoalMet = false
    }
}
