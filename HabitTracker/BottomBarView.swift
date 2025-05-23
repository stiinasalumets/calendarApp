import Foundation
import SwiftUI

enum BottomBarTabs: Int {
    case calendar = 0
    case habit = 1
    case add = 2
    case statistics = 3
    case settings = 4
}

struct BottomBarView: View {
   
    @Binding var selectedTab:BottomBarTabs
    @EnvironmentObject var navManager: NavigationStackManager
    
    
    var body: some View {
        
        HStack(spacing: 10){
            //Calendar
            Button {
                navManager.clear()
                selectedTab = .calendar
            } label: {
                ZStack{
                    BottombarButtonView(image: "Calendar", isActive: selectedTab == .calendar)
                }
            }
            
            //Habits
            Button {
                navManager.clear()
                selectedTab = .habit
            } label: {
                ZStack{
                    BottombarButtonView(image: "Habit", isActive: selectedTab == .habit)
                }
            }
            
            //Add
            Button {
                navManager.clear()
                selectedTab = .add

                    } label: {
                                VStack{
                                    ZStack{
                                        VStack(spacing: 3){
                                            RoundedRectangle(cornerRadius: 30)
                                                .frame(width: 60,height: 60)
                                                .foregroundColor(.purple)
                                            
                                        }
                                        VStack(spacing: 3){
                                            Image(systemName: "plus").font(.title).foregroundColor(.white)
                                            
                                        }
                                    }.padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                                        Spacer()
                                }
                            }
            
            //Stats
            Button {
                navManager.clear()
                selectedTab = .statistics
            } label: {
                ZStack{
                    BottombarButtonView(image: "Stats",  isActive: selectedTab == .statistics)
                }
            }
            
            //Settings
            Button {
                navManager.clear()
                selectedTab = .settings
            } label: {
                ZStack{
                    BottombarButtonView(image: "Settings",  isActive: selectedTab == .settings)
                }
            }
        }
        .frame(height: 90)
        .background(Color("purple"))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: .constant(.calendar))
    }
}
