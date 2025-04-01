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
    }
}
