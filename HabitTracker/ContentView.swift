//
//  ContentView.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 04/03/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var allHabits: FetchedResults<AllHabits>
    
    
    
    var body: some View {
        var habits: [AllHabits] = []
        
        VStack {
            if let model = moc.persistentStoreCoordinator?.managedObjectModel {
                let entityNames = model.entities.map { $0.name ?? "Unknown" }.joined(separator: ", ")
                Text("Loaded Entities: \(entityNames)")
            } else {
                Text("No Core Data Model Found")
            }

            List(habits) { habit in
                Text(habit.title ?? "unknown")
            }
            Button("Add"){
                let habit = AllHabits(context: moc)
                habit.id = UUID()
                habit.interval = "Monday,Tuesday"
                habit.title = "drink water"
                habit.isActive = true
                habits.append(habit)
                
                try? moc.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
