import SwiftUI
import SwiftData

struct MorningRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let date: Date

    @Query private var logs: [MorningRoutineLog]

    @State private var mobility = false
    @State private var cardio = false

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        _logs = Query(filter: #Predicate { $0.date == Calendar.current.startOfDay(for: date) })
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Mobility (10 min)") {
                    Toggle("Completed mobility", isOn: $mobility)
                    Text("Deep squat hold – 2 min\nHip flexor – 1 min each side\nHamstring – 2 min\nThoracic rotations – 2 min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Cardio (10 min)") {
                    Toggle("Completed incline walk", isOn: $cardio)
                    Text("3.5 mph • 10–12% incline • HR 120–130 bpm")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Morning Routine")
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
                    mobility = existing.mobilityCompleted
                    cardio = existing.cardioCompleted
                }
            }
        }
    }

    private func save() {
        if let existing = logs.first {
            existing.mobilityCompleted = mobility
            existing.cardioCompleted = cardio
        } else {
            let log = MorningRoutineLog(date: date, mobilityCompleted: mobility, cardioCompleted: cardio)
            modelContext.insert(log)
        }
        dismiss()
    }
}
