import SwiftUI
import Foundation

extension CalendarView {
    class ViewModel: ObservableObject {
        @Published var currentWeekStart: Date = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        @Published var weekDayColorPairs: [DayColorPair] = []

        private let colorController = ThemeColorController()

        struct DayColorPair: Identifiable {
            let date: Date
            let color: String
            var id: Date { date }
        }

        func initializeWeek() {
            currentWeekStart = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
            generateWeekColors()
        }

        func goToPresent() {
            currentWeekStart = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
            generateWeekColors()
        }

        func goToPreviousWeek() {
            currentWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStart) ?? currentWeekStart
            generateWeekColors()
        }

        func goToNextWeek() {
            currentWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: currentWeekStart) ?? currentWeekStart
            generateWeekColors()
        }

        var isShowingCurrentWeek: Bool {
            let endOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 6, to: currentWeekStart)!
            return Calendar.current.isDateInToday(endOfCurrentWeek)
        }

        func habits(for date: Date, in habits: FetchedResults<DailyHabits>) -> [DailyHabits] {
            habits.filter { $0.date?.isSameDay(as: date) ?? false }
        }

        private func generateWeekColors() {
            var results: [DayColorPair] = []
            var prevColor = ""

            for offset in 0..<7 {
                let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart)!
                let newColor = colorController.randomColorInList(prevColor: prevColor)
                results.append(DayColorPair(date: day, color: newColor))
                prevColor = newColor
            }

            weekDayColorPairs = results
        }
    }
}

extension Date {
    func startOfWeek() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    func formatAsWeekRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: self)
        let end = formatter.string(from: Calendar.current.date(byAdding: .day, value: 6, to: self)!)
        return "\(start) - \(end)"
    }

    func formatAsDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }

    func formatAsDayNumber() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
