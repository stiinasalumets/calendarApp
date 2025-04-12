import SwiftUI
import CoreData

extension SettingView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        @Published var setting: [Settings] = []
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
            fetchSettings()
        }
        
        func fetchSettings() {
            let request: NSFetchRequest<Settings> = Settings.fetchRequest()
            request.sortDescriptors = []
            do {
                 setting = try moc.fetch(request)
            } catch {
                setting = []
                print("Failed to fetch habits: \(error)")
            }
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
