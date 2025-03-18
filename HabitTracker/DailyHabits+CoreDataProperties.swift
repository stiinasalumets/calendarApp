//
//  DailyHabits+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 17.03.2025.
//
//

import Foundation
import CoreData


extension DailyHabits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyHabits> {
        return NSFetchRequest<DailyHabits>(entityName: "DailyHabits")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var habit: AllHabits?

}

extension DailyHabits : Identifiable {

}
