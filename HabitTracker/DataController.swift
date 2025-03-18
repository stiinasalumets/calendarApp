import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HabitTracker")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("❌ Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("✅ Core Data loaded successfully: \(description.url?.absoluteString ?? "Unknown URL")")
            }
        }
    }
}
