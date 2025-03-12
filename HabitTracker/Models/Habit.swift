//
//  Habit.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 11.03.2025.
//

import Foundation

struct Habit {
    var id: UUID
    var date: Date
    var isComplete: Bool = false
    var currentHabit: CurrentHabit
}
