//
//  Entry+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/31/22.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var habit: Habit?

}

extension Entry : Identifiable {

}
