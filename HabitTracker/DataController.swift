//
//  DataController.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 11.03.2025.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CurrentHabits")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("coreData failed to load \(error.localizedDescription)")
            }
        }
    }
}
