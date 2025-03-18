//
//  DataController 2.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 18.03.2025.
//


import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "HabitTracker")

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("Core Data loaded successfully")
                if let entities = self.container.managedObjectModel.entities as? [NSEntityDescription] {
                    print("Loaded Entities: \(entities.map { $0.name ?? "Unknown" })")
                }
            }
        }
    }
}
