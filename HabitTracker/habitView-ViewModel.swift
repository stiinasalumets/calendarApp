import Foundation
import SwiftUI
import CoreData

extension habitView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        
        @Published var allHabits: [AllHabits] = []  // Store fetched results here
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
            fetchHabits()  // Fetch habits when ViewModel is initialized
        }
        
        func fetchHabits() {
            let request = NSFetchRequest<AllHabits>(entityName: "AllHabits")
            request.sortDescriptors = []
            
            do {
                allHabits = try moc.fetch(request)
            } catch {
                print("Failed to fetch habits: \(error)")
            }
        }
    }
}
