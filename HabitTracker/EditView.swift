import SwiftUI
import CoreData

struct EditView: View {
    @Binding var selectedTab: BottomBarTabs
    @State private var title: String
    @State private var selectedDays: Set<String> = []
    @State private var habitID: NSManagedObjectID
    private var moc: NSManagedObjectContext
    
    
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext, title: String = "", selectedDays: Set<String> = [], habitID: NSManagedObjectID) {
        self._selectedTab = selectedTab
        self.moc = moc
        self._title = State(initialValue: title)
        self._selectedDays = State(initialValue: selectedDays)
        self._habitID = State(initialValue: habitID)
        print("Edit: title: \(State(initialValue: title)), selectedDays: \(State(initialValue: selectedDays))")
        
    }
    
    var body: some View {
        HabitForm(selectedTab: $selectedTab, moc: moc, title: title, selectedDays: selectedDays, habitID: habitID)
    }

    
}
