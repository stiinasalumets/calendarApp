import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var lnManager = LocalNotificationManager()
    @StateObject private var navManager = NavigationStackManager()
    
    var body: some View {
        NavigationContainerView()
            .environmentObject(lnManager)
            .environmentObject(navManager)
            
            
    }
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
