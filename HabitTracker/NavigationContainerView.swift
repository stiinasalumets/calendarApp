import Foundation
import SwiftUI

struct NavigationContainerView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    @State var selectedTab: BottomBarTabs = .calendar
    @Environment(\.managedObjectContext) private var moc
    

    var body: some View {
        ZStack {
            if navManager.stack.isEmpty {
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
                        StatisticsView(moc: moc)
                    }
                    
                    if selectedTab == .settings {
                        SettingView(moc: moc, lnManager: lnManager)
                        
                    }
                }
            } else {
                navManager.stack.last
            }
        }.task {
            try? await lnManager.requestAuthorization()
        }
        
        
        
        Spacer()
        
        if (!keyboardObserver.isKeyboardVisible) {
            BottomBarView(selectedTab: $selectedTab)
        }
        
    }
    
    }
    


