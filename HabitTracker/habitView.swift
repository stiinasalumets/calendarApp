
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
            List(allHabits) { habit in
                Text(habit.title ?? "unknown")
            }
            
        }
    }
}

struct habitView_Previews: PreviewProvider {
    static var previews: some View {
        habitView()
    }
}
