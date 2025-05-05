import CoreData
import Foundation

// MARK: - Codable Struct

struct HabitJSON: Codable {
    let title: String
    let isActive: Bool
    let interval: String
    let id: String
}

// MARK: - DataController

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HabitTracker")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("❌ Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("✅ Core Data loaded successfully: \(description.url?.absoluteString ?? "Unknown URL")")
                self.seedInitialData()
            }
        }
    }

    // MARK: - Seeding

    private func seedInitialData() {
        populateHabitsIfNeeded()
        populateSettingsIfNeeded()
    }

    private func populateHabitsIfNeeded() {
        let context = container.viewContext
        let request: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()

        do {
            let count = try context.count(for: request)
            if count == 0 {
                try loadHabitsFromJSON(into: context)
            } else {
                try generateDailyHabits(for: context)
            }
        } catch {
            print("❌ Error checking habits: \(error.localizedDescription)")
        }
    }

    private func populateSettingsIfNeeded() {
        let context = container.viewContext
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()

        do {
            let count = try context.count(for: request)
            if count == 0 {
                let setting = Settings(context: context)
                setting.catPerson = false
                setting.dogPerson = true
                setting.notificationInterval = "8:00"
                try context.save()
                print("✅ Settings seeded into Core Data")
            }
        } catch {
            print("❌ Error checking settings: \(error.localizedDescription)")
        }
    }

    // MARK: - JSON Loader

    private func loadHabitsFromJSON(into context: NSManagedObjectContext) throws {
        guard let url = Bundle.main.url(forResource: "habitData", withExtension: "json") else {
            print("❌ habitData.json not found")
            return
        }

        let data = try Data(contentsOf: url)
        let habits = try JSONDecoder().decode([HabitJSON].self, from: data)

        for habitData in habits {
            let habit = AllHabits(context: context)
            habit.id = UUID(uuidString: habitData.id)
            habit.title = habitData.title
            habit.isActive = habitData.isActive
            habit.interval = habitData.interval
        }

        try context.save()
        try generateDailyHabits(for: context)

        print("✅ Habits seeded into Core Data")
    }

    // MARK: - Daily Habits Generator

    private func generateDailyHabits(for context: NSManagedObjectContext) throws {
        let habits = try context.fetch(AllHabits.fetchRequest()) as? [AllHabits] ?? []

        for habit in habits {
            try generateDailyHabits(for: habit, in: context)
        }
    }

    private func generateDailyHabits(for habit: AllHabits, in context: NSManagedObjectContext) throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let existingDailyHabits = try fetchExistingDailyHabits(for: habit, in: context)

        for dayOffset in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let day = calendar.startOfDay(for: date)

            if shouldCreateDailyHabit(on: day, for: habit, existingHabits: existingDailyHabits) {
                createDailyHabit(on: day, for: habit, today: today, in: context)
            }
        }

        try context.save()
    }

    private func fetchExistingDailyHabits(for habit: AllHabits, in context: NSManagedObjectContext) throws -> [DailyHabits] {
        let request: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
        request.predicate = NSPredicate(format: "habit == %@", habit)
        return try context.fetch(request)
    }

    private func shouldCreateDailyHabit(on day: Date, for habit: AllHabits, existingHabits: [DailyHabits]) -> Bool {
        let calendar = Calendar.current
        let weekdayName = day.formatted(as: "EEEE").lowercased()

        let alreadyExists = existingHabits.contains { $0.date.map { calendar.isDate($0, inSameDayAs: day) } ?? false }
        let allowedDays = (habit.interval ?? "")
            .lowercased()
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        return !alreadyExists && allowedDays.contains(weekdayName) && habit.isActive
    }

    private func createDailyHabit(on day: Date, for habit: AllHabits, today: Date, in context: NSManagedObjectContext) {
        let dailyHabit = DailyHabits(context: context)
        dailyHabit.id = UUID()
        dailyHabit.date = day
        dailyHabit.habit = habit

        if day == today {
            dailyHabit.isCompleted = false
        } else {
            dailyHabit.isCompleted = [true, false, false].randomElement() ?? false
        }
    }
}

// MARK: - Date Helper Extension

private extension Date {
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
