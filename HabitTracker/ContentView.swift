import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab: BottomBarTabs = .calendar
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        VStack {
            if selectedTab == .calendar {
                CalendarView()
            }
            
            if selectedTab == .habit {
                habitView(selectedTab: $selectedTab, moc: moc)
            }
            
            if selectedTab == .add {
                AddView(selectedTab: $selectedTab, moc: moc)
            }
            
            if selectedTab == .statistics {
                Text("Statistics")
            }
            
            if selectedTab == .settings {
                Text("Settings")
                
                Text(fetchSettings().first?.notificationInterval ?? "default value")
                
                
                
            }
            
            Spacer()
            BottomBarView(selectedTab: $selectedTab)
        }
    }
    func fetchSettings() -> [Settings] {
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        request.sortDescriptors = []
        var setting: [Settings]
        do {
             setting = try moc.fetch(request)
        } catch {
            setting = []
            print("Failed to fetch habits: \(error)")
        }
        
        print(setting.count)
        return setting
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
