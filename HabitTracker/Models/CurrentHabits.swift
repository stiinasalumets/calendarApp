//
//  CurrentHabit.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 11.03.2025.
//

import Foundation
import SwiftUI

struct CurrentHabits {
    var id: UUID
    var title: String
    var isActive: Bool = true
    var interval: [String]
}


enum WeekDays: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
}
