import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var navManager = NavigationStackManager()
    
    var body: some View {
        NavigationContainerView()
            .environmentObject(navManager)
    }
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
