import SwiftUI
import SwiftData

struct ProgramView: View {
    @Query(sort: \TemplateDay.dayIndex, order: .forward) private var days: [TemplateDay]

    var body: some View {
        NavigationStack {
            List {
                ForEach(days) { day in
                    NavigationLink {
                        TemplateDayDetailView(day: day)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Day \(day.dayIndex) – \(day.title)")
                            Text(day.kindRaw.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Program")
        }
    }
}

private struct TemplateDayDetailView: View {
    @Bindable var day: TemplateDay

    var body: some View {
        List {
            if day.isTrainingDay {
                ForEach(day.exercises) { ex in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ex.name)
                            .font(.headline)
                        Text("\(ex.sets)×\(ex.reps)")
                            .foregroundStyle(.secondary)

                        switch ex.modality {
                        case .bodyweightPlusLoad:
                            Text("Week 1 added load: +\(Int(ex.week1AddedLoad ?? 0)) lb")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        default:
                            Text("Week 1: \(Int(ex.week1Weight ?? 0)) lb")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            } else if day.isActiveRecovery {
                Text("Active recovery: keep it light—steps, mobility, easy movement.")
            } else {
                Text("Rest day: focus on recovery, sleep, hydration, and nutrition.")
            }
        }
        .navigationTitle("Day \(day.dayIndex)")
    }
}
