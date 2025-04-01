import SwiftUI
import CoreData

struct HabitDetailView: View {
    @Environment(\.presentationMode) var presentationMode  // For back button
    
    var habit: AllHabits
    var habitID: NSManagedObjectID
    var moc: NSManagedObjectContext
    @Binding var selectedTab: BottomBarTabs
    
    init(habit: AllHabits, habitID: NSManagedObjectID, selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self.habit = habit
        self.habitID = habitID
        self.moc = moc
        self._selectedTab = selectedTab
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
            Button("Edit") {
                EditView(selectedTab: $selectedTab, moc: moc)
            }
            
            Spacer()
            
            Button("Delete") {
            }
        }.padding()
        
        
    }
}
