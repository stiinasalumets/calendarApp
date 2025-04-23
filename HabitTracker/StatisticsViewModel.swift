import SwiftUI
import CoreData

extension StatisticsView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        @Published var habitStats: [AllHabits: Int] = [:]
        @Published var habitStreak: Int = 0
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
            habitStats = calculateDailyHabitCompletionPercentage()
            habitStreak = calculateStreak()
        }
        
        func calculateStreak() -> Int {
            var result = 0
            
            return result
        }
        
        func calculateDailyHabitCompletionPercentage() -> [AllHabits: Int] {
            var result: [AllHabits: Int] = [:]
            
            var allHabits = fetchAllHabits()

            for habit in allHabits {
                let count = fetchDailyHabitCount(for: habit)
                let completedCount = fetchDailyHabitCompletedCount(for: habit)
                
                let percentage = calculateCompletionPercentage(completed: completedCount, total: count)
                
                print("habit: \(habit.title), %: \(percentage)")
                result[habit] = percentage
            }

            return result
        }
        
        func fetchAllHabits() -> [AllHabits] {
            let request: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()
            request.sortDescriptors = []
            do {
                let allHabits = try moc.fetch(request)
                return allHabits
            } catch {
                let allHabits: [AllHabits] = []
                print("Failed to fetch habits: \(error)")
                return allHabits
            }
        }
        
        func fetchDailyHabitCount(for habit: AllHabits) -> Int {
            let request: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
            request.predicate = NSPredicate(format: "habit == %@", habit)
            
            do {
                let count = try moc.count(for: request)
                return count
            } catch {
                print("Failed to count DailyHabits: \(error)")
                return 0
            }
        }
        
        func fetchDailyHabitCompletedCount(for habit: AllHabits) -> Int {
            let request: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
            
            // Match both the habit relationship and the isCompleted flag
            request.predicate = NSPredicate(format: "habit == %@ AND isCompleted == YES", habit)
            
            do {
                let count = try moc.count(for: request)
                return count
            } catch {
                print("Failed to count DailyHabits: \(error)")
                return 0
            }
        }
        
        func calculateCompletionPercentage(completed: Int, total: Int) -> Int {
            guard total > 0 else { return 0 }
            let percentage = (Double(completed) / Double(total)) * 100
            return Int(percentage.rounded())
        }
        
        
        
        
        
        func deleteAllHabits(context: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Settings.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
                print("✅ All habits deleted.")
            } catch {
                print("❌ Failed to delete all habits: \(error)")
            }
        }
        
        
    }
}
