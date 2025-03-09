//
//  DailyHabitView.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 09/03/2025.
//

import Foundation
import SwiftUI

struct DailyHabitView: View {
    let habits: [Habit]
    
    var body: some View {
        
        List(habits, id: \.title) { habit in
            HabitView(habit: habit)
        }
    }
}

struct DailyHabitView_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitView(habits: Habit.sampleData)
    }
}
