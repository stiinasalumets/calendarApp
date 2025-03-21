//
//  ContentView.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 04/03/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab:BottomBarTabs = .calendar
    var body: some View {
        VStack {
            if selectedTab == .calendar{
                CalendarView()
            }
            
            if selectedTab == .habit{
                habitView()
            }
            
            if selectedTab == .add{
                Text("Add")
            }
            if selectedTab == .statistics{
                Text("Statistics")
            }
            if selectedTab == .settings{
                Text("Settings")
            }
            Spacer()
            BottomBarView(selectedTab: $selectedTab)
        }
        
    }
}

/*struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: AllHabits.entity(),
        sortDescriptors: []
    ) var allHabits: FetchedResults<AllHabits>

    var body: some View {
        VStack {
            if let model = moc.persistentStoreCoordinator?.managedObjectModel {
                let entityNames = model.entities.map { $0.name ?? "Unknown" }.joined(separator: ", ")
                Text("Loaded Entities: \(entityNames)")
            } else {
                Text("No Core Data Model Found")
            }

            List(allHabits) { habit in
                Text(habit.title ?? "unknown")
            }

            Button("Add") {
                let habit = AllHabits(context: moc)
                habit.id = UUID()
                habit.interval = "Monday,Tuesday"
                habit.title = "Drink Water"
                habit.isActive = true

                try? moc.save()
            }
        }
    }
}*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
