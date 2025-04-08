import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>
    
    @State private var currentWeekStart: Date = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
    @State private var selectedDay: Date? = nil  // Track the active day

    var body: some View {
        VStack {
            if selectedDay == nil {
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
                    
                    
                    let isAtPresentOrFuture = currentWeekStart >= (Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date())
                    
                    if !isAtPresentOrFuture {
                        Button(action: {
                            currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding()
            }
            
            NavigationView {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        ForEach(0..<7, id: \.self) { offset in
                            let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart)!
                            let habitsForDay = dailyHabits.filter { $0.date?.isSameDay(as: day) ?? false }
                            let totalHabits = habitsForDay.count
                            let completedHabits = habitsForDay.filter { $0.isCompleted }.count

                            NavigationLink(
                                tag: day,
                                selection: $selectedDay,
                                destination: {
                                    DailyHabitView(currentDate: day)
                                        .navigationBarHidden(true)
                                },
                                label: {
                                    HStack {
                                        Text("\(day.formatAsDayOfWeek()) \(day.formatAsDayNumber())")
                                            .font(.headline)
                                            .foregroundColor(Color("grey"))
                                            .frame(width: geometry.size.width * 0.25,
                                                   alignment: .leading)

                                        
                                        ProgressBarView(moc: moc, totalHabits: totalHabits, completedHabits: completedHabits)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(height: geometry.size.height / 7)
                                }
                            )
                        }

                        Spacer(minLength: 0)
                    }
                }
                .ignoresSafeArea(edges: [.top, .bottom])
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
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
