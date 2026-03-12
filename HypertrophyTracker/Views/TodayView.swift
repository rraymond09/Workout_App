import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \AppSettings.createdAt, order: .forward) private var settings: [AppSettings]
    @Query(sort: \TemplateDay.dayIndex, order: .forward) private var templateDays: [TemplateDay]
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    @State private var showStartWorkout = false
    @State private var showMorning = false
    @State private var showChecklist = false

    var body: some View {
        NavigationStack {
            let appSettings = settings.first ?? AppSettings()
            let clock = ProgramClock(startDate: appSettings.programStartDate)
            let todayInfo = clock.weekAndDay(for: .now)

            let todayTemplate = templateDays.first(where: { $0.dayIndex == todayInfo.dayIndex })

            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(todayInfo.week) • Day \(todayInfo.dayIndex)")
                            .font(.headline)
                        Text(todayTemplate?.title ?? "Loading…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if todayInfo.week == appSettings.deloadWeek {
                            Text("Deload Week: -20% (rounded to nearest 5 lb)")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Morning (20 min)") {
                    Button("Morning Mobility + Cardio") { showMorning = true }
                }

                Section("Evening Workout") {
                    if let day = todayTemplate, day.isTrainingDay {
                        Button("Start \(day.title)") { showStartWorkout = true }
                    } else if todayTemplate?.isActiveRecovery == true {
                        Text("Active Recovery Day")
                        Text("Keep it light: steps, mobility, easy movement.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Rest Day")
                        Text("Focus on sleep, hydration, and food.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Daily Checklists") {
                    Button("Meals • Supplements • Water • Sleep") { showChecklist = true }
                }

                if let last = sessions.first {
                    Section("Last Session") {
                        Text(last.title)
                        Text(last.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Today")
            .sheet(isPresented: $showMorning) {
                MorningRoutineView(date: Calendar.current.startOfDay(for: .now))
            }
            .sheet(isPresented: $showChecklist) {
                DailyChecklistView(date: Calendar.current.startOfDay(for: .now))
            }
            .sheet(isPresented: $showStartWorkout) {
                if let day = todayTemplate {
                    StartWorkoutFlowView(templateDay: day, weekNumber: todayInfo.week, dayIndex: todayInfo.dayIndex)
                } else {
                    Text("No template found.")
                        .padding()
                }
            }
        }
    }
}
