
import Foundation
import SwiftUI
import CoreData

struct habitView: View {
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
}

struct habitView_Previews: PreviewProvider {
    static var previews: some View {
        habitView()
    }
}
