//
//  DailyHabits.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 09/03/2025.
//

import Foundation
import SwiftUI

struct DailyHabits {
    var id: UUID
    var date: Date
    var weekDay: WeekDays
    var allHabits : [OldHabit]
    var habits : [OldHabit] { filterHabits(habits: allHabits, day: weekDay)}
}

func filterHabits (habits: [OldHabit], day: WeekDays) -> [OldHabit] {
    var returnArray = Array<OldHabit>()
    
    habits.forEach { element in
        if element.interval.contains(WeekDays.Tuesday) {
            returnArray.append(element)
        }
    }
    
    return returnArray
}
 




