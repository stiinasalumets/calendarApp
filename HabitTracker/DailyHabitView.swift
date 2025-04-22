import SwiftUI
import CoreData

struct DailyHabitView: View {
    
    //@Environment(\.presentationMode) var presentationMode  // For back button
    @EnvironmentObject var navManager: NavigationStackManager
    
    let currentDate: Date
    
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: currentDate)
    }
    
    var fetchRequest: FetchRequest<DailyHabits>
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>
    
    init(currentDate: Date) {
        self.currentDate = currentDate
        
        self.fetchRequest = FetchRequest(
            entity: DailyHabits.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "date == %@", currentDate as CVarArg)
        )
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
                // Styled List
                List(habitsForDay, id: \.id) { habit in
                    Text(habit.habit?.title ?? "Unknown Habit")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listStyle(PlainListStyle()) // Cleaner look
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand list
                .background(Color.white) // White background
                .cornerRadius(12) // Smooth edges
                .shadow(radius: 4) // Subtle shadow
                .padding(.horizontal, 16)
            }
        }
        .padding(.top)
    }
}
