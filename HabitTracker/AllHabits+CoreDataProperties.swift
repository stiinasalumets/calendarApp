//
//  AllHabits+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Stiina Salumets on 17.03.2025.
//
//

import Foundation
import CoreData


extension AllHabits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllHabits> {
        return NSFetchRequest<AllHabits>(entityName: "AllHabits")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var interval: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var title: String?
    @NSManaged public var dailyHabits: NSSet?

}

// MARK: Generated accessors for dailyHabits
extension AllHabits {

    @objc(addDailyHabitsObject:)
    @NSManaged public func addToDailyHabits(_ value: DailyHabits)

    @objc(removeDailyHabitsObject:)
    @NSManaged public func removeFromDailyHabits(_ value: DailyHabits)

    @objc(addDailyHabits:)
    @NSManaged public func addToDailyHabits(_ values: NSSet)

    @objc(removeDailyHabits:)
    @NSManaged public func removeFromDailyHabits(_ values: NSSet)

}

extension AllHabits : Identifiable {

}
