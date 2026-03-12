import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppSettings.createdAt, order: .forward) private var settings: [AppSettings]

    var body: some View {
        NavigationStack {
            Form {
                if let s = settings.first {
                    Section("Program") {
                        DatePicker("Start Date", selection: Bindable(s).programStartDate, displayedComponents: .date)
                        Text("Week 7 deload: -20%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Section("Rounding") {
                        Stepper(value: Bindable(s).roundingIncrement, in: 5...10, step: 5) {
                            Text("Round to nearest \(Int(s.roundingIncrement)) lb")
                        }
                        .disabled(true) // fixed per requirements; kept visible for future
                    }

                    Section("Accessories") {
                        Text("Auto-progress is enabled.\nDumbbells increase +5 lb per hand.\nPull-ups/dips increase +5 lb added load.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Button("Create Settings") {
                        modelContext.insert(AppSettings())
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
