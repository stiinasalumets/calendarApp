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
        ScrollView {
            VStack(spacing: 24) {
                // Section: Habit Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Title")
                        .font(.headline)
                        .foregroundColor(Color("grey"))
                        .padding(.horizontal)

                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Color("grey"))
                        .padding(.horizontal)
                        .onChange(of: title) { newValue in
                            if newValue.count > 16 {
                                title = String(newValue.prefix(16))
                            }
                        }
                }

                // Section: Select Days
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Days")
                        .font(.headline)
                        .foregroundColor(Color("grey"))
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                    
                        ForEach(daysOfWeek.indices, id: \.self) { index in
                            let day = daysOfWeek[index]
                            HStack {
                                Text(day)
                                    .foregroundStyle(Color("grey"))
                                Spacer()
                                Image(systemName: selectedDays.contains(day) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(Color("grey"))
                                    .accessibilityIdentifier("\(day)Checkbox")
                                    .onTapGesture {
                                        if selectedDays.contains(day) {
                                            selectedDays.remove(day)
                                        } else {
                                            selectedDays.insert(day)
                                        }
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)

                            // Add divider except after the last item
                            if index < daysOfWeek.count - 1 {
                                Divider()
                                    .padding(.leading)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("grey").opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                

                // Section: Save Button
                Button(action: {
                    print("save button pressed")
                    if let id = habitID {
                        print("updating")
                        viewModel.updateHabit(title: title, selectedDays: selectedDays, habitID: id)
                        navManager.pop()
                    } else {
                        print("saving")
                        viewModel.addHabit(title: title, selectedDays: selectedDays)
                        selectedTab = .habit
                    }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty || selectedDays.isEmpty ? Color.gray.opacity(0.3) : Color("green"))
                        .foregroundColor(Color("grey"))
                        .cornerRadius(8)
                }
                .disabled(title.isEmpty || selectedDays.isEmpty)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Add Habit")
        .simultaneousGesture(
            TapGesture().onEnded {
                self.hideKeyboard()
            }
        )
    }


}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                         to: nil, from: nil, for: nil)
    }
}
