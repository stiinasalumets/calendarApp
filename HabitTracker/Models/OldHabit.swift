//
//  Habit.swift
//  HabitTracker
//
//  Created by Sandie Petersen on 09/03/2025.
//

import Foundation
import SwiftUI

struct OldHabit {
    var id: UUID
    var title: String
    var isComplete: Bool = false
    var interval: [WeekDays]
}
