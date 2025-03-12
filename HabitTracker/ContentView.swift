//
//  ContentView.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 04/03/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CurrentHabits.entity(), sortDescriptors: []) var habits: FetchedResults<CurrentHabits>

    
    var body: some View {
        Button("add"){
            let currentHabit = CurrentHabits(context: moc)
            currentHabit.id = UUID()
            currentHabit.title = "Morning Run"
            currentHabit.isActive = true
            currentHabit.interval = "Monday,Wednesday,Friday"
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
