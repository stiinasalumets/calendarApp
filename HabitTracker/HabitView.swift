
//
import Foundation
import SwiftUI
//
struct HabitView: View {
    let habit: DailyHabits
    var body: some View {
        HStack {
            //Text(habit.) Change to fetch title
            Text("Some habit")
            Spacer()
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                        
                    }
        }.padding()
        
        
    }
}
//
//
//struct HabitView_Previews: PreviewProvider {
//    static var habit = Habit.sampleData[0]
//    static var previews: some View {
//        HabitView(habit: habit)
//    }
//}
