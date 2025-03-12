//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 04/03/2025.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
