import SwiftUI
import SwiftData

@main
struct HypertrophyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            AppSettings.self,
            TemplateDay.self,
            TemplateExercise.self,
            WorkoutSession.self,
            ExerciseLog.self,
            SetLog.self,
            MorningRoutineLog.self,
            DailyChecklistLog.self
        ])
    }
}
