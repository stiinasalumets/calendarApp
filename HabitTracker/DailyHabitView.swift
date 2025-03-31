
import Foundation
import SwiftUI
import CoreData

struct DailyHabitView: View {
    @Environment(\.managedObjectContext) var moc
    
    let currentDate: Date

    let dateFormatter = DateFormatter()
    
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: currentDate)
    }
    
    var fetchRequest: FetchRequest<DailyHabits>
    var dailyHabits: FetchedResults<DailyHabits> { fetchRequest.wrappedValue }
    
    init(currentDate: Date) {
        self.currentDate = currentDate
        
        self.fetchRequest = FetchRequest(
            entity: DailyHabits.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "date == %@", currentDate as CVarArg)
        )
    }
    
    
    
    

   

   //let habits = Habit.sampleData
   //var filteredHabits : [Habit] { filterHabits(habits: habits, day: WeekDays(rawValue: dayOfTheWeek) ?? WeekDays.Monday)}
  
  
    var body: some View {
        VStack {
            Text(dayOfTheWeek)
           
            Spacer()
            
            Text("Habit list here")
            
            //List(dailyHabits, id: \.title) { habit in
                //HabitView(habit: habit)
            //}
            List(dailyHabits) {habit in Text("Some habit")}
        }
        
    }
}

//struct DailyHabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyHabitView()
//    }
//}
