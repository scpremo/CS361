//
//  Day+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/31/22.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var number: Int16
    @NSManaged public var habit: Habit?

}

extension Day : Identifiable {

}
