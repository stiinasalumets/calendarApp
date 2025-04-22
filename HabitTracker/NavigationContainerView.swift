import Foundation
import SwiftUI

struct NavigationContainerView: View {
    @EnvironmentObject var navManager: NavigationStackManager
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
                                Text("Statistics")
                            }
                            
                            if selectedTab == .settings {
                                SettingView(moc: moc)
                                
                            }
                        }
                    } else {
                        navManager.stack.last
                    }
                }
        
        
            
            Spacer()
            BottomBarView(selectedTab: $selectedTab)
        }
    }
    


