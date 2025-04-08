import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab: BottomBarTabs = .calendar
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        VStack {
            Group {
                switch selectedTab {
                case .calendar:
                    NavigationView {
                        CalendarView()
                            
                    }

                case .habit:
                    NavigationView {
                        habitView(selectedTab: $selectedTab, moc: moc)
                    }

                case .add:
                    NavigationView {
                        AddView(selectedTab: $selectedTab, moc: moc)
                    }

                case .statistics:
                    NavigationView {
                        Text("Statistics")
                    }

                case .settings:
                    NavigationView {
                        Text("Settings")
                    }
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
