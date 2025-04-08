//
//  Settings+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Andreas Petersen on 08/04/2025.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var notificationInterval: String?
    @NSManaged public var dogPerson: Bool
    @NSManaged public var catPerson: Bool

}

extension Settings : Identifiable {

}
