import Foundation
import SwiftUI
import CoreData

extension HabitForm {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
        }
        
        func addHabit(title: String, selectedDays: Set<String>) {
            let newHabit = AllHabits(context: moc)
            newHabit.id = UUID()
            newHabit.title = title
            newHabit.isActive = true
            newHabit.interval = selectedDays.sorted().joined(separator: ",")
            
            do {
                try moc.save()
            } catch {
                print("❌ Error saving habit: \(error.localizedDescription)")
            }
        }
        
        func updateHabit(title: String, selectedDays: Set<String>, habitID: NSManagedObjectID) {
            do {
                if let habit = try moc.existingObject(with: habitID) as? AllHabits {
                    habit.title = title
                    habit.interval = selectedDays.sorted().joined(separator: ",")
                    habit.isActive = true

                    try moc.save()
                    print("✅ Habit updated successfully.")
                } else {
                    print("❌ Failed to cast to AllHabits.")
                }
            } catch {
                print("❌ Error updating habit: \(error.localizedDescription)")
            }
        }
    }
}
