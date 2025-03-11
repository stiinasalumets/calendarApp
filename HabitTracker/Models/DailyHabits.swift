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
    var allHabits : [Habit]
    var habits : [Habit] { filterHabits(habits: allHabits, day: weekDay)}
}

func filterHabits (habits: [Habit], day: WeekDays) -> [Habit] {
    var returnArray = Array<Habit>()
    
    habits.forEach { element in
        if element.interval.contains(WeekDays.Tuesday) {
            returnArray.append(element)
        }
    }
    
    return returnArray
}
 




