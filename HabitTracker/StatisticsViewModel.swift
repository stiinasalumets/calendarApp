import SwiftUI
import CoreData

extension StatisticsView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        @Published var habitStats: [AllHabits: Int] = [:]
        @Published var habitStatsActive: [AllHabits: Int] = [:]
        @Published var habitStreak: Int = 0
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
            habitStats = calculateDailyHabitCompletionPercentage(isActive: false)
            habitStatsActive = calculateDailyHabitCompletionPercentage(isActive: true)
            habitStreak = calculateStreak()
        }
        
        func calculateStreak() -> Int {
            
            let calendar = Calendar.current
            var currentDate = calendar.date(byAdding: .day, value: -1, to: Date())!
            
            var result = 0
            
            var counting = true
            while (counting) {
                var habitCount = fetchDailyHabitsCountOnDate(date: currentDate)
                var habitCountCompleted = fetchCompletedDailyHabitsCountOnDate(date: currentDate)
                
                print("habitCount: \(String(habitCount))")
                print("habitCountCompleted: \(String(habitCountCompleted))")
                
                if (habitCount == habitCountCompleted) {
                    result = result+1
                    currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
                } else {
                    counting = false
                }
            }
            return result
        }
        
        
        
        func calculateDailyHabitCompletionPercentage(isActive: Bool) -> [AllHabits: Int] {
            var result: [AllHabits: Int] = [:]
            
            var allHabits = fetchAllHabits(isActive: isActive)

            for habit in allHabits {
                let count = fetchDailyHabitCount(for: habit)
                let completedCount = fetchDailyHabitCompletedCount(for: habit)
                
                let percentage = calculateCompletionPercentage(completed: completedCount, total: count)
                
                print("habit: \(habit.title), %: \(percentage)")
                result[habit] = percentage
            }

            return result
        }
        
        
        
        func fetchAllHabits(isActive: Bool) -> [AllHabits] {
            let request: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()
            request.sortDescriptors = []
            request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: isActive))
            
            do {
                let allHabits = try moc.fetch(request)
                return allHabits
            } catch {
                let allHabits: [AllHabits] = []
                print("Failed to fetch habits: \(error)")
                return allHabits
            }
        }
        
        
        func fetchDailyHabitsCountOnDate(date: Date) -> Int {
            let request: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
            
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
            
            do {
                let count = try moc.count(for: request)
                return count
            } catch {
                print("Failed to count DailyHabits for streek: \(error)")
                return 0
            }
        }
        
        func fetchCompletedDailyHabitsCountOnDate(date: Date) -> Int {
            let request: NSFetchRequest<DailyHabits> = DailyHabits.fetchRequest()
            
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            request.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND isCompleted == YES", startOfDay as NSDate, endOfDay as NSDate)
            
            do {
                let count = try moc.count(for: request)
                return count
            } catch {
                print("Failed to count DailyHabits for streek: \(error)")
                return 0
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
        
        
        
        
    }
}
