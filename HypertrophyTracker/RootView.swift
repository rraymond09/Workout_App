import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppSettings.createdAt, order: .forward) private var settings: [AppSettings]
    @Query(sort: \TemplateDay.dayIndex, order: .forward) private var templateDays: [TemplateDay]

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            ProgramView()
                .tabItem { Label("Program", systemImage: "calendar") }

            HistoryView()
                .tabItem { Label("History", systemImage: "clock") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .task {
            // Ensure settings exists
            if settings.isEmpty {
                modelContext.insert(AppSettings())
            }
            // Seed templates once
            if templateDays.isEmpty {
                TemplateSeeder.seed(in: modelContext)
            }
        }
    }
}
