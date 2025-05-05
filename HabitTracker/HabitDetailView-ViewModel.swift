import Foundation

class HabitDetailViewModel: ObservableObject {
    @Published var selectedDays: Set<String> = []
    @Published var sortedDays: [String] = []

    private let weekDaysOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    func configureDays(from intervalString: String?) {
        guard let intervalString = intervalString else {
            selectedDays = []
            sortedDays = []
            return
        }

        let intervalDaysArray = intervalString
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        let sorted = intervalDaysArray.sorted {
            guard let first = weekDaysOrder.firstIndex(of: $0),
                  let second = weekDaysOrder.firstIndex(of: $1) else { return false }
            return first < second
        }

        selectedDays = Set(sorted)
        sortedDays = sorted
    }
}
