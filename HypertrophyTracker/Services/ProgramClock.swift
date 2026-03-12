import Foundation

struct ProgramClock {
    let startDate: Date

    func weekAndDay(for date: Date) -> (week: Int, dayIndex: Int, daysSinceStart: Int) {
        let cal = Calendar.current
        let start = cal.startOfDay(for: startDate)
        let today = cal.startOfDay(for: date)

        let days = cal.dateComponents([.day], from: start, to: today).day ?? 0
        let clampedDays = max(0, days)

        let week = min(12, (clampedDays / 7) + 1)
        let dayIndex = (clampedDays % 7) + 1

        return (week, dayIndex, clampedDays)
    }
}
