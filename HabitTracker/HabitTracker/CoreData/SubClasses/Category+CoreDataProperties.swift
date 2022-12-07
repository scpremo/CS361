//
//  Category+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/31/22.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var color: String?
    @NSManaged public var habit: NSSet?

}

// MARK: Generated accessors for habit
extension Category {

    @objc(addHabitObject:)
    @NSManaged public func addToHabit(_ value: Habit)

    @objc(removeHabitObject:)
    @NSManaged public func removeFromHabit(_ value: Habit)

    @objc(addHabit:)
    @NSManaged public func addToHabit(_ values: NSSet)

    @objc(removeHabit:)
    @NSManaged public func removeFromHabit(_ values: NSSet)

}

extension Category : Identifiable {

}
