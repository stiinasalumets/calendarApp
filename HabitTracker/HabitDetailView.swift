import SwiftUI
import CoreData

struct HabitDetailView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    
    var habit: AllHabits
    var habitID: NSManagedObjectID
    var moc: NSManagedObjectContext
    @Binding var selectedTab: BottomBarTabs
    @State private var selectedDays: Set<String> = []
    
    init(habit: AllHabits, habitID: NSManagedObjectID, selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self.habit = habit
        self.habitID = habitID
        self.moc = moc
        self._selectedTab = selectedTab
        
        if let intervalString = habit.interval {
                    let intervalDaysArray = intervalString.components(separatedBy: ",")
                    self._selectedDays = State(initialValue: Set(intervalDaysArray.map { $0.trimmingCharacters(in: .whitespaces) }))
                }
    }
    
    
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Button(action: { navManager.pop() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text(habit.title ?? "Unknown")
                    
                    Spacer()
                }.padding(.vertical)
                
            }
            
            VStack {
                
                if let intervalString = habit.interval {
                    let intervalDays = intervalString.components(separatedBy: ",")
                    
                    List(intervalDays, id: \.self) { day in
                        Text(day)
                    }
                }
                
            }
            
            HStack {
                let title = habit.title ?? ""
                
                Button(action: {
                    navManager.push(
                        EditView(selectedTab: $selectedTab, moc: moc, title: title, selectedDays: selectedDays, habitID: habitID
                                )
                    )
                }) {
                    Text("Edit")
                }
                
                Spacer()
                
                Button(action: {
                    navManager.push(deleteView(selectedTab: $selectedTab, moc: moc, habitID: habitID, title: title))
                }) {
                    Text("Delete")
                }
                
                
                
                
            }.padding()
        }
        
    }
}
