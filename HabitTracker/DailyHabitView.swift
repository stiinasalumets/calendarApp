
import Foundation
import SwiftUI

struct DailyHabitView: View {
    let currentDate: Date
    let dateFormatter = DateFormatter()
   
   var dayOfTheWeek: String {dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: currentDate) - 1]}
   

   //let habits = Habit.sampleData
   //var filteredHabits : [Habit] { filterHabits(habits: habits, day: WeekDays(rawValue: dayOfTheWeek) ?? WeekDays.Monday)}
  
  
    var body: some View {
        VStack {
            Text(dayOfTheWeek)
           
            Spacer()
            
            Text("Habit list here")
            
            //List(filteredHabits, id: \.title) { habit in
                //HabitView(habit: habit)
            //}
        }
        
    }
}

//struct DailyHabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyHabitView()
//    }
//}
