//
//  DataController.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 17.03.2025.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HabitTracker")
    
    init () {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
