import SwiftUI
import CoreData

struct deleteView: View {
    @Binding var selectedTab: BottomBarTabs
    private var moc: NSManagedObjectContext
    @State private var viewModel: ViewModel
    @State private var habitID: NSManagedObjectID
    
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext, habitID: NSManagedObjectID ) {
        self._selectedTab = selectedTab
        self.moc = moc
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
        self._habitID = State(initialValue: habitID)
    }
    
    var body: some View {
        Text("Are you sure you want to delete the habit")
        Text("This action cannot be un done")
        
        Button("Delete") {
            viewModel.deleteHabit(habitID: habitID)
            selectedTab = .habit
        }
        
        Button("Cancel") {
            
            selectedTab = .habit
        }
        
    }

    
}
