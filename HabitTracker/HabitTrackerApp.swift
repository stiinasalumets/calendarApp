//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 04/03/2025.
//

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
