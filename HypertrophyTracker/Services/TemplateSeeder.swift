import Foundation
import SwiftData

enum TemplateSeeder {
    static func seed(in context: ModelContext) {
        // Day 1 – Heavy Legs (Quad Power)
        let d1 = TemplateDay(dayIndex: 1, title: "Heavy Legs (Quad Power)", kindRaw: "training")
        d1.exercises = [
            .init(name: "Back Squat", sets: 5, reps: 5, modality: .barbell, isMajorLift: true, week1Weight: 260),
            .init(name: "Romanian Deadlift", sets: 4, reps: 6, modality: .barbell, week1Weight: 225),
            .init(name: "Leg Press", sets: 4, reps: 8, modality: .machine, week1Weight: 450),
            .init(name: "Walking Lunges", sets: 3, reps: 10, modality: .dumbbell, week1Weight: 60),
            .init(name: "Leg Extension", sets: 3, reps: 10, modality: .machine, week1Weight: 170),
            .init(name: "Standing Calf Raise", sets: 4, reps: 12, modality: .machine, week1Weight: 220)
        ]

        // Day 2 – Heavy Chest
        let d2 = TemplateDay(dayIndex: 2, title: "Heavy Chest", kindRaw: "training")
        d2.exercises = [
            .init(name: "Bench Press", sets: 5, reps: 5, modality: .barbell, isMajorLift: true, week1Weight: 235),
            .init(name: "Incline Dumbbell Press", sets: 4, reps: 6, modality: .dumbbell, week1Weight: 85),
            .init(name: "Weighted Dips", sets: 4, reps: 6, modality: .bodyweightPlusLoad, week1AddedLoad: 45),
            .init(name: "Flat Dumbbell Press", sets: 3, reps: 8, modality: .dumbbell, week1Weight: 90),
            .init(name: "Cable Fly", sets: 3, reps: 12, modality: .cable, week1Weight: 50)
        ]

        // Day 3 – Back + Biceps
        let d3 = TemplateDay(dayIndex: 3, title: "Back + Heavy Biceps", kindRaw: "training")
        d3.exercises = [
            .init(name: "Deadlift", sets: 5, reps: 4, modality: .barbell, isMajorLift: true, week1Weight: 315),
            .init(name: "Pull-ups", sets: 4, reps: 8, modality: .bodyweightPlusLoad, week1AddedLoad: 25),
            .init(name: "Barbell Row", sets: 4, reps: 6, modality: .barbell, week1Weight: 205),
            .init(name: "Lat Pulldown", sets: 3, reps: 10, modality: .machine, week1Weight: 180),
            .init(name: "Barbell Curl", sets: 4, reps: 6, modality: .barbell, week1Weight: 115),
            .init(name: "Incline Curl", sets: 3, reps: 10, modality: .dumbbell, week1Weight: 40),
            .init(name: "Hammer Curl", sets: 3, reps: 10, modality: .dumbbell, week1Weight: 50)
        ]

        // Day 4 – Active recovery
        let d4 = TemplateDay(dayIndex: 4, title: "Active Recovery", kindRaw: "activeRecovery")

        // Day 5 – Posterior Chain + Legs
        let d5 = TemplateDay(dayIndex: 5, title: "Posterior Chain + Legs", kindRaw: "training")
        d5.exercises = [
            .init(name: "Front Squat", sets: 4, reps: 5, modality: .barbell, week1Weight: 225),
            .init(name: "Hip Thrust", sets: 4, reps: 6, modality: .barbell, week1Weight: 315),
            .init(name: "Bulgarian Split Squat", sets: 3, reps: 8, modality: .dumbbell, week1Weight: 70),
            .init(name: "Leg Curl", sets: 4, reps: 10, modality: .machine, week1Weight: 140),
            .init(name: "Hack Squat", sets: 3, reps: 8, modality: .machine, week1Weight: 270),
            .init(name: "Seated Calf Raise", sets: 4, reps: 12, modality: .machine, week1Weight: 180)
        ]

        // Day 6 – Shoulders + Arms
        let d6 = TemplateDay(dayIndex: 6, title: "Shoulders + Arms", kindRaw: "training")
        d6.exercises = [
            .init(name: "Overhead Barbell Press", sets: 5, reps: 5, modality: .barbell, isMajorLift: true, week1Weight: 155),
            .init(name: "Lateral Raises", sets: 4, reps: 12, modality: .dumbbell, week1Weight: 30),
            .init(name: "Rear Delt Fly", sets: 4, reps: 12, modality: .dumbbell, week1Weight: 25),
            .init(name: "EZ Bar Curl", sets: 4, reps: 8, modality: .barbell, week1Weight: 95),
            .init(name: "Preacher Curl", sets: 3, reps: 10, modality: .machine, week1Weight: 80),
            .init(name: "Cable Curl", sets: 3, reps: 12, modality: .cable, week1Weight: 70),
            .init(name: "Close Grip Bench Press", sets: 4, reps: 6, modality: .barbell, week1Weight: 205),
            .init(name: "Overhead Tricep Extension", sets: 3, reps: 10, modality: .cable, week1Weight: 90)
        ]

        // Day 7 – Rest
        let d7 = TemplateDay(dayIndex: 7, title: "Rest", kindRaw: "rest")

        [d1, d2, d3, d4, d5, d6, d7].forEach { context.insert($0) }
    }
}
