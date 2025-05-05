import Foundation
import SwiftUI
import CoreData

extension deleteView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
        }
        
        
        
        func deleteHabit(habitID: NSManagedObjectID) {
            do {
                if let habit = try moc.existingObject(with: habitID) as? AllHabits {
                    habit.isActive = false
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
