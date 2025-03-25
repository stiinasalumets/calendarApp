import SwiftUI
import CoreData

struct AddView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var title: String = ""
    @State private var selectedDays: Set<String> = []
    @Binding var selectedTab: BottomBarTabs
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

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
                    addHabit()
                    selectedTab = .habit
                }
                .disabled(title.isEmpty || selectedDays.isEmpty)
            }
        }
        .navigationTitle("Add Habit")
    }

    private func addHabit() {
        let newHabit = AllHabits(context: moc)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.isActive = true
        newHabit.interval = selectedDays.sorted().joined(separator: ",")

        do {
            try moc.save()
        } catch {
            print("❌ Error saving habit: \(error.localizedDescription)")
        }
    }
}
