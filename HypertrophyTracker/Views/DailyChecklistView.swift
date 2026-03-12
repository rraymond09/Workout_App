import SwiftUI
import SwiftData

struct DailyChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let date: Date

    @Query private var logs: [DailyChecklistLog]

    @State private var log: DailyChecklistLog?

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        _logs = Query(filter: #Predicate { $0.date == Calendar.current.startOfDay(for: date) })
    }

    var body: some View {
        NavigationStack {
            Form {
                if let log {
                    Section("Meals") {
                        Toggle("Meal 1", isOn: binding(\.meal1))
                        Toggle("Meal 2", isOn: binding(\.meal2))
                        Toggle("Meal 3", isOn: binding(\.meal3))
                        Toggle("Meal 4", isOn: binding(\.meal4))
                        Toggle("Meal 5 (post-workout)", isOn: binding(\.meal5))
                        Toggle("Meal 6 (pre-sleep)", isOn: binding(\.meal6))
                    }

                    Section("Supplements") {
                        Toggle("Creatine (5g)", isOn: binding(\.creatine))
                        Toggle("Whey protein", isOn: binding(\.whey))
                        Toggle("Fish oil", isOn: binding(\.fishOil))
                        Toggle("Magnesium", isOn: binding(\.magnesium))
                        Toggle("Vitamin D3", isOn: binding(\.vitaminD3))
                        Toggle("Electrolytes", isOn: binding(\.electrolytes))
                        Toggle("Citrulline malate (optional)", isOn: binding(\.citrullineMalate))
                        Toggle("Beta alanine (optional)", isOn: binding(\.betaAlanine))
                    }

                    Section("Recovery goals") {
                        Toggle("Water goal met (1 gallon)", isOn: binding(\.waterGoalMet))
                        Toggle("Sleep goal met (8+ hours)", isOn: binding(\.sleepGoalMet))
                    }
                } else {
                    ProgressView("Loading…")
                }
            }
            .navigationTitle("Daily Checklist")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear {
                if let existing = logs.first {
                    log = existing
                } else {
                    let created = DailyChecklistLog(date: date)
                    modelContext.insert(created)
                    log = created
                }
            }
        }
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<DailyChecklistLog, Bool>) -> Binding<Bool> {
        Binding(
            get: { log?[keyPath: keyPath] ?? false },
            set: { newValue in log?[keyPath: keyPath] = newValue }
        )
    }

    private func save() {
        // SwiftData persists changes; just dismiss.
        dismiss()
    }
}
