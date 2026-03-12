import SwiftUI
import SwiftData

struct WorkoutSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var session: WorkoutSession

    var body: some View {
        List {
            Section {
                Text("Week \(session.weekNumber) • Day \(session.dayIndex)")
                Text(session.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(session.exercises) { ex in
                Section(ex.name) {
                    HStack {
                        Text("\(ex.prescribedSets)×\(ex.prescribedReps)")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(targetText(for: ex))
                            .font(.headline)
                    }

                    ForEach(ex.sets) { set in
                        SetRow(exercise: ex, set: set)
                    }
                }
            }

            Section {
                Button("Finish & Save") {
                    // SwiftData autosaves changes in context; this just dismisses.
                    dismiss()
                }
                .font(.headline)
            }
        }
    }

    private func targetText(for ex: ExerciseLog) -> String {
        switch ex.modality {
        case .bodyweightPlusLoad:
            let added = ex.targetAddedLoad ?? 0
            return "+\(Int(added)) lb"
        default:
            let w = ex.targetWeight ?? 0
            return "\(Int(w)) lb"
        }
    }
}

private struct SetRow: View {
    @Bindable var exercise: ExerciseLog
    @Bindable var set: SetLog

    var body: some View {
        HStack(spacing: 12) {
            Text("Set \(set.setNumber)")
                .frame(width: 60, alignment: .leading)

            if exercise.modality == .bodyweightPlusLoad {
                HStack {
                    Text("+")
                    TextField("Load", value: $set.addedLoad, format: .number)
                        .keyboardType(.numberPad)
                        .frame(width: 70)
                    Text("lb")
                        .foregroundStyle(.secondary)
                }
            } else {
                TextField("Weight", value: $set.weight, format: .number)
                    .keyboardType(.numberPad)
                    .frame(width: 90)
                Text("lb")
                    .foregroundStyle(.secondary)
            }

            TextField("Reps", value: $set.reps, format: .number)
                .keyboardType(.numberPad)
                .frame(width: 60)

            Toggle("", isOn: $set.completed)
                .labelsHidden()
        }
    }
}
