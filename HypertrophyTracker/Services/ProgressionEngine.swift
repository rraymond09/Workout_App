import Foundation
import SwiftData

struct ProgressionEngine {
    let settings: AppSettings
    let context: ModelContext

    func roundToIncrement(_ value: Double) -> Double {
        let inc = settings.roundingIncrement
        guard inc > 0 else { return value }
        return (value / inc).rounded() * inc
    }

    func applyDeloadIfNeeded(_ value: Double, weekNumber: Int) -> Double {
        if weekNumber == settings.deloadWeek {
            return roundToIncrement(value * 0.80)
        }
        return roundToIncrement(value)
    }

    func majorLiftTarget(week1: Double, weekNumber: Int) -> Double {
        let normal = week1 + Double(weekNumber - 1) * 5.0
        return applyDeloadIfNeeded(normal, weekNumber: weekNumber)
    }

    /// Find last logged exercise entry by name (most recent session date).
    func lastExerciseLog(named name: String) -> ExerciseLog? {
        let descriptor = FetchDescriptor<ExerciseLog>(
            predicate: #Predicate { $0.name == name },
            sortBy: [SortDescriptor(\.name), SortDescriptor(\.persistentModelID, order: .reverse)]
        )
        // Note: Sorting by modelID is a lightweight proxy; sessions store their own date,
        // so we’ll compute last by scanning (still fine for MVP scale).
        let logs = (try? context.fetch(descriptor)) ?? []
        return logs.last
    }

    func lastPerformedReference(named name: String) -> (metAllReps: Bool, lastWeight: Double?, lastAddedLoad: Double?)? {
        // Better: fetch sessions and traverse; for MVP we traverse all ExerciseLogs for name.
        let desc = FetchDescriptor<ExerciseLog>(predicate: #Predicate { $0.name == name })
        let logs = (try? context.fetch(desc)) ?? []
        guard let last = logs.last else { return nil }

        // Determine if met all reps: every set completed and reps >= prescribed
        let met = last.sets.count == last.prescribedSets &&
        last.sets.allSatisfy { $0.completed && $0.reps >= last.prescribedReps }

        // Use last session’s stored targets as reference if present; otherwise fall back to first set value.
        let weight = last.targetWeight ?? last.sets.compactMap { $0.weight }.last
        let added = last.targetAddedLoad ?? last.sets.compactMap { $0.addedLoad }.last

        return (met, weight, added)
    }

    func defaultIncrement(for modality: ExerciseModality) -> Double {
        switch modality {
        case .dumbbell:
            return 5 // per hand
        case .bodyweightPlusLoad:
            return 5 // added load
        default:
            return 5
        }
    }

    func nextAccessoryWeight(current: Double, modality: ExerciseModality) -> Double {
        // Dumbbells: +5 per hand, but we track "per hand" in the stored number (e.g., 85 lb DBs).
        return current + defaultIncrement(for: modality)
    }

    func accessoryTarget(from template: TemplateExercise, weekNumber: Int) -> (weight: Double?, addedLoad: Double?) {
        // Determine a base reference:
        // 1) If we have a previous performance, use that (manual override becomes reference).
        // 2) Else use week1Weight/week1AddedLoad from template.
        let ref = lastPerformedReference(named: template.name)

        switch template.modality {
        case .bodyweightPlusLoad:
            let base = ref?.lastAddedLoad ?? template.week1AddedLoad ?? 0
            let progressed = (ref?.metAllReps == true) ? nextAccessoryWeight(current: base, modality: .bodyweightPlusLoad) : base
            let final = applyDeloadIfNeeded(progressed, weekNumber: weekNumber)
            return (nil, final)

        case .barbell, .dumbbell, .machine, .cable:
            let base = ref?.lastWeight ?? template.week1Weight ?? 0
            let progressed = (ref?.metAllReps == true) ? nextAccessoryWeight(current: base, modality: template.modality) : base
            let final = applyDeloadIfNeeded(progressed, weekNumber: weekNumber)
            return (final, nil)

        case .timed:
            return (nil, nil)
        }
    }

    func target(for template: TemplateExercise, weekNumber: Int) -> (weight: Double?, addedLoad: Double?) {
        if template.isMajorLift, let week1 = template.week1Weight {
            return (majorLiftTarget(week1: week1, weekNumber: weekNumber), nil)
        }
        return accessoryTarget(from: template, weekNumber: weekNumber)
    }
}
