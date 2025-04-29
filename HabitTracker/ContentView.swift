import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var lnManager = LocalNotificationManager()
    @StateObject private var navManager = NavigationStackManager()
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    
    var body: some View {
        NavigationContainerView()
            .environmentObject(lnManager)
            .environmentObject(navManager)
            .environmentObject(keyboardObserver)
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
