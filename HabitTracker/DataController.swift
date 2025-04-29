import CoreData
import Foundation

struct HabitJSON: Codable {
    let title: String
    let isActive: Bool
    let interval: String
    let id: String
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HabitTracker")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("❌ Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("✅ Core Data loaded successfully: \(description.url?.absoluteString ?? "Unknown URL")")
                self.populateHabitsIfNeeded()
                self.populateSettingsIfNeeded()
            }
        }
    }

    func populateHabitsIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                try loadHabitsFromJSON(context: context)
            } else {
                try
                populateDailyHabits(context: context)
            }
        } catch {
            print("❌ Error checking Core Data: \(error.localizedDescription)")
        }
    }
    
    func populateSettingsIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let setting = Settings(context: context)
                setting.catPerson = false;
                setting.dogPerson = true;
                setting.notificationInterval = "8:00"
                
                try context.save()
                print("✅ Settings loaded into Core Data")
            }
        } catch {
            print("❌ Error checking Core Data: \(error.localizedDescription)")
        }
    }

    func loadHabitsFromJSON(context: NSManagedObjectContext) throws {
        guard let url = Bundle.main.url(forResource: "habitData", withExtension: "json") else {
            print("❌ JSON file not found")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let habits = try decoder.decode([HabitJSON].self, from: data)

        for habitData in habits {
            let habit = AllHabits(context: context)
            habit.id = UUID(uuidString: habitData.id)
            habit.title = habitData.title
            habit.isActive = habitData.isActive
            habit.interval = habitData.interval
            try context.save()
            try populateDailyHabitsForAllHabits(context: context, habit: habit)
        }
        print("✅ Habits loaded into Core Data")
    }
    
    func populateDailyHabitsForAllHabits(context: NSManagedObjectContext, habit: AllHabits) throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let fetchRequest: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@", habit)

        let existingDailyHabits = try context.fetch(fetchRequest)
        let count = try context.count(for: fetchRequest)

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"

        for dayOffset in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let day = calendar.startOfDay(for: date)

            let weekdayName = weekdayFormatter.string(from: day).lowercased()

            let alreadyExists = existingDailyHabits.contains { dh in
                if let dhDate = dh.date {
                    return calendar.isDate(dhDate, inSameDayAs: day)
                }
                return false
            }

            if !alreadyExists,
               let interval = habit.interval?.lowercased() {
                
                let allowedDays = interval
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                

                if allowedDays.contains(weekdayName) && habit.isActive {
                    let dailyHabit = DailyHabits(context: context)
                    dailyHabit.id = UUID()
                    if day == today || count != 0 {
                        dailyHabit.isCompleted = false
                    } else {
                        dailyHabit.isCompleted = [true, false, false].randomElement() ?? false
                    }
                    dailyHabit.date = day
                    dailyHabit.habit = habit
                }
            }
        }

        try context.save()
    }

    
    func populateDailyHabits(context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()
        let habits = try context.fetch(fetchRequest)
        for habit in habits {
            try populateDailyHabitsForAllHabits(context: context, habit: habit)
        }
    }
}
