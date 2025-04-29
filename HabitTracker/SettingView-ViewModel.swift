import SwiftUI
import CoreData

extension SettingView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        var lnManager: LocalNotificationManager
        @Published var setting: [Settings] = []
        @State private var hasInitialized = false
        
        init(moc: NSManagedObjectContext, lnManeger: LocalNotificationManager) {
            self.moc = moc
            self.lnManager = lnManeger
            fetchSettings()
            Task {
                await lnManager.initializeNotificationsIfNeeded()
            }
        }
        
        func initializeNotificationsIfNeeded()  {
            
            print("initializeNotifications")
            print("hasInitializedNotifications \(hasInitialized)")
            
             
            Task {
                let count = await lnManager.getPendingNotificationCount()
                print("pending in init: \(String(count))")
                if count == 0 {
                    let count = await lnManager.getPendingNotificationCount()
                    if (count == 0) {
                        let dateComponents = DateComponents(hour: 8, minute: 0) //Initial time for notifications
                        let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Remember to complete your habits", body: "You have uncompleted habits, lets get it done", dateComponents: dateComponents, repeats: true)
                        await lnManager.schedule(localNotification: localNotification)
                    }
                }
            }
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
