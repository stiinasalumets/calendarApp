import SwiftUI
import CoreData

struct HabitForm: View {
    @EnvironmentObject var navManager: NavigationStackManager
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
                    .onChange(of: title) { newValue in
                        if newValue.count > 16 {
                            title = String(newValue.prefix(16))
                        }
                    }
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
                Button("Save") {
                    if ((habitID) != nil) {
                        if let id = habitID {
                            viewModel.updateHabit(title: title, selectedDays: selectedDays, habitID: id)
                        } else {
                            print("❌ No habitID available to update")
                        }
                        navManager.pop()
                    } else {
                        viewModel.addHabit(title: title, selectedDays: selectedDays)
                        
                        selectedTab = .habit
                    }
                }
                .disabled(title.isEmpty || selectedDays.isEmpty)
            }
        }
        .navigationTitle("Add Habit")
        .onTapGesture {
            self.hideKeyboard()
        }
        
        
    }
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                         to: nil, from: nil, for: nil)
    }
}
