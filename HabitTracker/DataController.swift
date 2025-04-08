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
                self.populateHabitsIfNeeded() // Call method to load JSON data
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
                print("Settings loaded into Core Data")
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
            try populateDailyHabits(context: context, habit: habit)
        }
        print("✅ Habits loaded into Core Data")
    }
    
    func populateDailyHabits(context: NSManagedObjectContext, habit: AllHabits) throws {
        let calendar = Calendar.current
        let today = Date()
        
        for dayOffset in 0..<14 {  // Loop for the past 14 days
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let dailyHabit = DailyHabits(context: context)
                dailyHabit.id = UUID()
                dailyHabit.isCompleted = [true, true, false].randomElement() ?? false
                dailyHabit.date = date
                dailyHabit.habit = habit // Assuming DailyHabits has a relationship to AllHabits
            }
        }
        
        try context.save()
    }

}
