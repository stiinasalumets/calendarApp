import SwiftUI
import CoreData

struct DailyHabitView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>
    
    let currentDate: Date
    
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: currentDate)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: { navManager.pop() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .padding(.leading)

                Spacer()

                Text(dayOfTheWeek)
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()
            }
            .padding(.vertical)

            let habitsForDay = dailyHabits.filter { $0.date?.isSameDay(as: currentDate) ?? false }

            if habitsForDay.isEmpty {
                Text("No habits for today.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(habitsForDay, id: \.id) { habit in
                        HStack {
                            Text(habit.habit?.title ?? "Unknown Habit")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Toggle("", isOn: Binding(
                                get: { habit.isCompleted },
                                set: { newValue in
                                    habit.isCompleted = newValue
                                    saveContext()
                                }
                            ))
                            .labelsHidden()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
        }
        .padding(.top)
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save habit completion: \(error)")
        }
    }
}
