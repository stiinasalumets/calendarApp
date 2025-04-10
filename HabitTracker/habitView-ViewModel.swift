import Foundation
import SwiftUI
import CoreData

extension habitView {
    class ViewModel: ObservableObject {
            @Published var allHabits: [AllHabits] = []  
            var moc: NSManagedObjectContext
            
            init(moc: NSManagedObjectContext) {
                self.moc = moc
                fetchHabits(isActive: true)
            }
            
            func fetchHabits(isActive: Bool) {
                let request: NSFetchRequest<AllHabits> = AllHabits.fetchRequest()
                request.sortDescriptors = []
                request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: isActive))
                
                do {
                    self.allHabits = try moc.fetch(request)
                } catch {
                    print("Failed to fetch habits: \(error)")
                }
            }
        }
}
