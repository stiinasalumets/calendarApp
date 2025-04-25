import SwiftUI
import CoreData

struct deleteView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @Binding var selectedTab: BottomBarTabs
    private var moc: NSManagedObjectContext
    @State private var viewModel: ViewModel
    @State private var habitID: NSManagedObjectID
    @State private var title: String
    
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext, habitID: NSManagedObjectID, title: String ) {
        self._selectedTab = selectedTab
        self.moc = moc
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
        self._habitID = State(initialValue: habitID)
        self._title = State(initialValue: title)
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            (
                Text("Are you sure you want to ") +
                Text("delete ").fontWeight(.bold) +
                Text(title)
            )
            .font(.title2)
            .multilineTextAlignment(.center)
            .foregroundColor(Color("grey"))
            
            (
                Text("This action ") +
                Text("cannot ").fontWeight(.bold) +
                Text("be un done")
            )
            .font(.title2)
            .multilineTextAlignment(.center)
            .foregroundColor(Color("grey"))
            
            Spacer()
            
            
            HStack {
                Spacer()
                Button("Delete") {
                    viewModel.deleteHabit(habitID: habitID)
                    navManager.clear()
                }.foregroundColor(.red)
                
                Spacer()
                
                Button("Cancel") {
                    
                    navManager.pop()
                }.foregroundColor(Color("grey"))
                
                Spacer()
            }
            
        }
    }

    
}
