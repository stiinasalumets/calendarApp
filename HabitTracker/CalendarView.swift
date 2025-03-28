import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    @State private var currentWeekStart: Date = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()

    var body: some View {
        VStack {
            // Navigation Controls
            HStack {
                let localDate = Date()
                let localWeekStart = Calendar.current.date(byAdding: .day, value: -6, to: localDate) ?? localDate
                

                Button(action: { currentWeekStart = localWeekStart }) {
                    Text("Present")
                        .font(.headline)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart) ?? currentWeekStart
                }) {
                    Image(systemName: "chevron.left")
                }

                Text(currentWeekStart.formatAsWeekRange())
                    .font(.headline)

                if localWeekStart != currentWeekStart {
                    Button(action: {
                        currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding()

            NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    
                        ForEach(0..<7, id: \.self) { offset in
                            
                            let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart)!
                            let habitsForDay = dailyHabits.filter { $0.date?.isSameDay(as: day) ?? false }
                            let totalHabits = habitsForDay.count
                            let completedHabits = habitsForDay.filter { $0.isCompleted }.count
                            
                            NavigationLink(destination: DailyHabitView(currentDate: day)) {
                                HStack(spacing: 0) {
                                    
                                    Text("\(day.formatAsDayOfWeek()) \(day.formatAsDayNumber())")
                                        .font(.headline)
                                        .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height / 15)
                                        //.frame(width: geometry.size.width * 0.15, height: geometry.size.height / 7)
                                    
                                    if totalHabits > 0 {
                                        ForEach(0..<totalHabits, id: \.self) { index in
                                            Rectangle()
                                                .fill(index < completedHabits ? Color(red: 1.0, green: 0.78, blue: 0.86) : Color.white)
                                                .frame(width: (geometry.size.width * 0.85) / CGFloat(totalHabits), height: geometry.size.height / 14)
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: (geometry.size.width * 0.85), height: geometry.size.height / 14)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                        }
                        
                    }
                    
                }
                .ignoresSafeArea(edges: .bottom)
                
            }
            .padding()
        }
    }
}

extension Date {
    func startOfWeek() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    func formatAsWeekRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: self)
        let end = formatter.string(from: Calendar.current.date(byAdding: .day, value: 6, to: self)!)
        return "\(start) - \(end)"
    }

    func formatAsDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }

    func formatAsDayNumber() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: other)
    }
}
