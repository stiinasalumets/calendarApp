import SwiftUI
import CoreData

struct HabitDetailView: View {
    @Environment(\.presentationMode) var presentationMode  // For back button
    
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
        VStack{
            HStack{
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                
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
            var title = habit.title ?? ""
            
            NavigationLink(destination: EditView(selectedTab: $selectedTab, moc: moc, title: title, selectedDays: selectedDays, habitID: habitID )) {
                Text("Edit")
            }
            
            Spacer()
            
            NavigationLink(destination: deleteView(selectedTab: $selectedTab, moc: moc, habitID: habitID, title: title)) {
                Text("Delete")
            }
            
            
        }.padding()
        
        
    }
}
