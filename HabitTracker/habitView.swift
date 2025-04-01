
import Foundation
import SwiftUI
import CoreData

struct habitView: View {
    
    @StateObject private var viewModel: ViewModel

        init(moc: NSManagedObjectContext) {
            _viewModel = StateObject(wrappedValue: ViewModel(moc: moc))
        }
        
        var body: some View {
            VStack {
                Text("Habits")
                
                List(viewModel.allHabits, id: \.self) { habit in
                    Text(habit.title ?? "Unknown")
                }
            }
        }
}

//struct habitView_Previews: PreviewProvider {
//    static var previews: some View {
//        habitView()
//    }
//}
