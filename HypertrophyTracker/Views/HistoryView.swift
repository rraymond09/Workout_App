import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions) { s in
                    NavigationLink {
                        WorkoutSessionDetailView(session: s)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(s.title)
                            Text("Week \(s.weekNumber) • Day \(s.dayIndex) • \(s.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

private struct WorkoutSessionDetailView: View {
    @Bindable var session: WorkoutSession

    var body: some View {
        List {
            Section {
                Text(session.date, style: .date)
                Text("Week \(session.weekNumber) • Day \(session.dayIndex)")
            }

            ForEach(session.exercises) { ex in
                Section(ex.name) {
                    ForEach(ex.sets) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                            Spacer()
                            if ex.modality == .bodyweightPlusLoad {
                                Text("+\(Int(set.addedLoad ?? 0)) lb × \(set.reps)")
                            } else {
                                Text("\(Int(set.weight ?? 0)) lb × \(set.reps)")
                            }
                            if set.completed {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Session")
    }
}
