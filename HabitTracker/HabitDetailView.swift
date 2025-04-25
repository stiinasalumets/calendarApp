import SwiftUI
import CoreData

struct HabitDetailView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    
    var habit: AllHabits
    var habitID: NSManagedObjectID
    var moc: NSManagedObjectContext
    @Binding var selectedTab: BottomBarTabs
    @State private var selectedDays: Set<String> = []
    @State private var sortedDays: [String] = []
    
    init(habit: AllHabits, habitID: NSManagedObjectID, selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self.habit = habit
        self.habitID = habitID
        self.moc = moc
        self._selectedTab = selectedTab
        
    }
    
    
    var body: some View {
        VStack {
            VStack{
                HStack {
                    Button(action: { navManager.pop() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("grey"))
                            .font(.title2)
                    }
                    .padding([.leading, .top])

                    Spacer()
                }
                .overlay(
                    Text(habit.title ?? "Unknown")
                        .font(.largeTitle)
                        .foregroundColor(Color("grey"))
                        .padding(.top),
                    alignment: .center
                )
                .padding(.vertical)
                
            }
            
            VStack {
                List(Array(selectedDays), id: \.self) { day in
                    Text(day)
                }
                
            }
                
            HStack {
                let title = habit.title ?? ""
                
                Button(action: {
                    navManager.push(deleteView(selectedTab: $selectedTab, moc: moc, habitID: habitID, title: title))
                }) {
                    HStack {
                        Text("Delete")
                            .foregroundColor(Color("grey"))
                            .font(.body)
                        Image(systemName: "trash")
                            .foregroundColor(Color("grey"))
                            .font(.body)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    navManager.push(
                        EditView(selectedTab: $selectedTab, moc: moc, title: title, selectedDays: selectedDays, habitID: habitID
                                )
                    )
                }) {
                    HStack {
                        Text("Edit")
                            .foregroundColor(Color("grey"))
                            .font(.body)
                        Image(systemName: "pencil")
                            .foregroundColor(Color("grey"))
                            .font(.body)
                    }
                }
            }.padding()
        }.onAppear {
            createWeekdaysArray(intervalString: habit.interval ?? "")
        }
    }
    
    func createWeekdaysArray(intervalString: String) {
        let intervalDaysArray = intervalString
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        let weekDaysOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        let sorted = intervalDaysArray.sorted {
            guard let firstIndex = weekDaysOrder.firstIndex(of: $0),
                  let secondIndex = weekDaysOrder.firstIndex(of: $1) else {
                return false
            }
            return firstIndex < secondIndex
        }

        selectedDays = Set(sorted)
        sortedDays = sorted
    }
}

