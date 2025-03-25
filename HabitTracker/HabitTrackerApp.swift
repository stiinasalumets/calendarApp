import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = DataController.init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
