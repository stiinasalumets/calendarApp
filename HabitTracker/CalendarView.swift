import SwiftUI

struct CalendarView: View {
    @State private var currentWeekStart: Date = Date().startOfWeek()
    
    var body: some View {
        VStack {
            HStack {
                let localDate = Date()
                let localWeekStart = localDate.startOfWeek()
                Button(action: {
                    currentWeekStart = localWeekStart
                }) {
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
                
                Spacer()
                
                Button(action: {
                    // ToDo
                }) {
                    Text("New Habit")
                        .font(.headline)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    let habitsData = (0..<7).map { _ in
                        let totalHabits = Int.random(in: 0...50)
                        let completedHabits = Int.random(in: 0...totalHabits)
                        return (totalHabits, completedHabits)
                    }
                    
                    ForEach(0..<7, id: \.self) { offset in
                        let (totalHabits, completedHabits) = habitsData[offset]
                        let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart)!
                        
                        HStack(spacing: 0) {
                            Text("\(day.formatAsDayOfWeek()) \(day.formatAsDayNumber())")
                                .font(.headline)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height / 7)

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
                    }
                }
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
}

#Preview {
    CalendarView()
}
