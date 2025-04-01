
import Foundation
import SwiftUI
import CoreData

struct habitView: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var selectedHabitID: NSManagedObjectID? = nil
    @Binding var selectedTab: BottomBarTabs

        init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
            self._selectedTab = selectedTab
            _viewModel = StateObject(wrappedValue: ViewModel(moc: moc))
        }
        
        var body: some View {
            
            VStack {
                Text("Habits")
                
                GeometryReader { geometry in
                    NavigationView {
                        ScrollView {
                            ForEach(viewModel.allHabits, id: \.objectID) { (habit: AllHabits) in
                                let habitID = habit.objectID
                                //Text(habit.title ?? "Unknown")
                                NavigationLink(
                                    tag: habitID,
                                    selection: $selectedHabitID,
                                    destination: {
                                        HabitDetailView(
                                            habit: habit,
                                            habitID: habitID,
                                            selectedTab: $selectedTab,
                                            moc: viewModel.moc
                                        )
                                        .navigationBarHidden(true)
                                    },
                                    label: {
                                        HabitViewCard(title: habit.title ?? "Unknown")
                                    }
                                )
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: geometry.size.height)
                }
            }
        }
}

//struct habitView_Previews: PreviewProvider {
//    static var previews: some View {
//        habitView()
//    }
//}
