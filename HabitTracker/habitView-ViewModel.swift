import SwiftUI
import CoreData

final class HabitViewModel: ObservableObject {
    @Published var allHabits: [AllHabits] = []
    private var habitColors: [NSManagedObjectID: String] = [:]
    let moc: NSManagedObjectContext

    private let colorController = ThemeColorController()

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchHabits(isActive: true)
        assignColors()
    }

    func fetchHabits(isActive: Bool) {
        let request: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: isActive))

        do {
            self.allHabits = try moc.fetch(request)
        } catch {
            print("Failed to fetch habits: \(error)")
            self.allHabits = []
        }
    }

    private func assignColors() {
        var previousColor = ""

        for habit in allHabits {
            let color = colorController.randomColorInList(prevColor: previousColor)
            habitColors[habit.objectID] = color
            previousColor = color
        }
    }

    func color(for habit: AllHabits) -> String {
        return habitColors[habit.objectID] ?? "blue"
    }
}
