import SwiftUI
import CoreData

struct AddView: View {
    @Binding var selectedTab: BottomBarTabs
    private var moc: NSManagedObjectContext
    
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self._selectedTab = selectedTab
        self.moc = moc
    }
    
    var body: some View {
        HabitForm(selectedTab: $selectedTab, moc: moc)
    }

    
}
