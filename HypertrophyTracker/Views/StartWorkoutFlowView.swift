import SwiftUI
import SwiftData

struct StartWorkoutFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppSettings.createdAt, order: .forward) private var settings: [AppSettings]

    let templateDay: TemplateDay
    let weekNumber: Int
    let dayIndex: Int

    @State private var session: WorkoutSession?

    var body: some View {
        NavigationStack {
            Group {
                if let session {
                    WorkoutSessionView(session: session)
                } else {
                    ProgressView("Creating session…")
                        .task { createSession() }
                }
            }
            .navigationTitle(templateDay.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func createSession() {
        let appSettings = settings.first ?? AppSettings()
        let engine = ProgressionEngine(settings: appSettings, context: modelContext)

        let newSession = WorkoutSession(
            date: .now,
            weekNumber: weekNumber,
            dayIndex: dayIndex,
            title: templateDay.title
        )

        var exerciseLogs: [ExerciseLog] = []
        for te in templateDay.exercises {
            let target = engine.target(for: te, weekNumber: weekNumber)
            let log = ExerciseLog(
                name: te.name,
                modality: te.modality,
                prescribedSets: te.sets,
                prescribedReps: te.reps,
                targetWeight: target.weight,
                targetAddedLoad: target.addedLoad
            )
            log.sets = (1...te.sets).map { idx in
                SetLog(
                    setNumber: idx,
                    reps: 0,
                    weight: target.weight,
                    addedLoad: target.addedLoad,
                    completed: false
                )
            }
            exerciseLogs.append(log)
        }

        newSession.exercises = exerciseLogs
        modelContext.insert(newSession)
        session = newSession
    }
}
