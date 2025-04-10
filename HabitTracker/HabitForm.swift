import SwiftUI
import CoreData

struct HabitForm: View {
    //@State private var title: String = ""
    //@State private var selectedDays: Set<String> = []
    @State private var title: String
    @State private var selectedDays: Set<String> = []
    @State private var habitID: NSManagedObjectID? = nil
    @Binding var selectedTab: BottomBarTabs
    @State private var viewModel: ViewModel
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext, title: String = "", selectedDays: Set<String> = [], habitID: NSManagedObjectID? = nil) {
        self._selectedTab = selectedTab
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
        self._title = State(initialValue: title)                     
        self._selectedDays = State(initialValue: selectedDays)
        self._habitID = State(initialValue: habitID)
        print("Form: title: \(State(initialValue: title)), selectedDays: \(State(initialValue: selectedDays))")
    }
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Habit Details")) {
                TextField("Title", text: $title)
            }

            Section(header: Text("Select Days")) {
                ForEach(daysOfWeek, id: \.self) { day in
                    HStack {
                        Text(day)
                        Spacer()
                        Image(systemName: selectedDays.contains(day) ? "checkmark.square.fill" : "square")
                            .onTapGesture {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }
                    }
                    .contentShape(Rectangle())
                }
            }

            Section {
                Button("Add Habit") {
                    if ((habitID) != nil) {
                        if let id = habitID {
                            viewModel.updateHabit(title: title, selectedDays: selectedDays, habitID: id)
                        } else {
                            print("❌ No habitID available to update")
                        }
                    } else {
                        viewModel.addHabit(title: title, selectedDays: selectedDays)
                    }
                    selectedTab = .habit
                }
                .disabled(title.isEmpty || selectedDays.isEmpty)
            }
        }
        .navigationTitle("Add Habit")
    }

    
}
