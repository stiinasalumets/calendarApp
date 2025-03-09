//
//  Habit.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 09/03/2025.
//

import Foundation
import SwiftUI

struct Habit {
    var id: UUID
    var title: String
    var isComplete: Bool = false
    var interval: [WeekDays]
}

enum WeekDays {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

extension Habit {
    static let sampleData: [Habit] =
    [
        Habit(  id: UUID(),
                title: "Workout",
                isComplete: false,
                interval: [WeekDays.Monday, WeekDays.Wednesday, WeekDays.Friday]),
        Habit(  id: UUID(),
                title: "Drink water",
                isComplete: false,
                interval: [WeekDays.Monday, WeekDays.Tuesday, WeekDays.Wednesday, WeekDays.Thursday, WeekDays.Friday, WeekDays.Saturday, WeekDays.Sunday]),
        Habit(  id: UUID(),
                title: "Water plants",
                interval: [WeekDays.Monday])
    ]
}
