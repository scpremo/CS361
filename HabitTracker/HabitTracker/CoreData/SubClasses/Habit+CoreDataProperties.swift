//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/31/22.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var name: String?
    @NSManaged public var schedule: String?
    @NSManaged public var time: Date?
    @NSManaged public var timesPerWeek: Int16
    @NSManaged public var sendsNotifications: Bool
    @NSManaged public var days: NSSet?
    @NSManaged public var entry: NSSet?
    @NSManaged public var category: Category?

    
    public var daysArray: [Day] {
        let set = days as? Set<Day> ?? []
        
        return set.sorted {
            $0.number < $1.number
        }
    }

    public var entriesArray: [Entry] {
        let set = entry as? Set<Entry> ?? []
        
        return set.sorted {
            $0.date ?? Date.now < $1.date ?? Date.now
        }
    }
    
    public var percentage: Int {
        var ratio = 0.0
        if schedule == ScheduleType.daily.rawValue {
            ratio = Double(entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, Date())}).count) / 7.0
        } else {
            ratio = Double(entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, Date())}).count) / Double(timesPerWeek)
        }
        let per = ratio * 100
        if per >= 0 {
            return Int(per)
        }
        return 0
    }
}

// MARK: Generated accessors for days
extension Habit {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

// MARK: Generated accessors for entry
extension Habit {

    @objc(addEntryObject:)
    @NSManaged public func addToEntry(_ value: Entry)

    @objc(removeEntryObject:)
    @NSManaged public func removeFromEntry(_ value: Entry)

    @objc(addEntry:)
    @NSManaged public func addToEntry(_ values: NSSet)

    @objc(removeEntry:)
    @NSManaged public func removeFromEntry(_ values: NSSet)

}

extension Habit : Identifiable {

}
