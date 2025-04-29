
import Foundation
import SwiftUI
import CoreData

struct habitView: View {
    @StateObject private var viewModel: ViewModel
    @State private var selectedHabitID: NSManagedObjectID? = nil
    @Binding var selectedTab: BottomBarTabs
    
    
    @EnvironmentObject var navManager: NavigationStackManager
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self._selectedTab = selectedTab
        _viewModel = StateObject(wrappedValue: ViewModel(moc: moc))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("Habits")
                    .font(.largeTitle)
                    .padding([.top, .bottom])
                    .foregroundColor(Color("grey"))
            }
            
            GeometryReader { geometry in
                ScrollView {
                    ForEach(viewModel.allHabits, id: \.objectID) { habit in
                        let habitID = habit.objectID
                        
                        Button(action: {
                            navManager.push(
                                HabitDetailView(
                                    habit: habit,
                                    habitID: habitID,
                                    selectedTab: $selectedTab,
                                    moc: viewModel.moc
                                )
                            )
                        }) {
                            HabitViewCard(title: habit.title ?? "Unknown", color: viewModel.chooseListColor())
                                .padding(.vertical, 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height)
            }
        }
        .padding(0)
    }
}

//struct habitView_Previews: PreviewProvider {
//    static var previews: some View {
//        habitView()
//    }
//}
