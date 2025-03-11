//
//  HabitView.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 09/03/2025.
//

import Foundation
import SwiftUI

struct HabitView: View {
    let habit: Habit
    var body: some View {
        HStack {
            Text(habit.title)
            
            Spacer()
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                        
                    }
        }.padding()
        
        
    }
}


struct HabitView_Previews: PreviewProvider {
    static var habit = Habit.sampleData[0]
    static var previews: some View {
        HabitView(habit: habit)
    }
}
