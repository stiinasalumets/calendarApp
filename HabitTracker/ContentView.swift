import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab: BottomBarTabs = .calendar
    
    var body: some View {
        VStack {
            if selectedTab == .calendar {
                CalendarView()
            }
            
            if selectedTab == .habit {
                habitView()
            }
            
            if selectedTab == .add {
                AddView(selectedTab: $selectedTab)
            }
            
            if selectedTab == .statistics {
                Text("Statistics")
            }
            
            if selectedTab == .settings {
                Text("Settings")
            }
            
            Spacer()
            BottomBarView(selectedTab: $selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
