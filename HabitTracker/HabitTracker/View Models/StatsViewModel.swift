//
//  StatsViewModel.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/1/22.
//

import SwiftUI
import CoreData

class StatsViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
//        getCurrentStreak()
    }
    
    final func getCurrentStreak() -> Int {
        let oneDay: Double = 86_400
        var filtered = getHabitsByDate().filter({ $0.percent == 1 })
        filtered.sort(by: { $0.date < $1.date })
        
        if filtered.isEmpty { return 0 }
        
        var currentDate = filtered.first?.date
        var count = 1
        
        filtered.forEach { date, entries, percent in
            if currentDate?.noon.timeIntervalSince(date.noon) == -oneDay {
                count += 1
//                print("1 day ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
            } else if currentDate!.noon != filtered.last?.date.noon {
                count = 1
//                print("Reset ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
            } else {
//                print("More than 1 day ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
                count = 0
            }
            
            currentDate = date
        }
        
        if ((currentDate?.noon.timeIntervalSinceNow)! <= -oneDay) {
            count = 0
        }
            

        return count
    }
    
    final func getBestStreak() -> Int {
        var filtered = getHabitsByDate().filter({ $0.percent == 1 })
        filtered.sort(by: { $0.date < $1.date })
        if filtered.isEmpty { return 0 }

        let referenceDate = Calendar.current.startOfDay(for: filtered.first!.date)


        let dayDiffs = filtered.map { (date, entries, percent) in
            Calendar.current.dateComponents([.day], from: referenceDate, to: date).day!
        }
        let consecutiveDaysCount = maximalConsecutiveNumbers(in: dayDiffs)
//        print(dayDiffs, consecutiveDaysCount)
        
        return consecutiveDaysCount
    }
    
    final func getHabitCurrentStreak(habit: Habit) -> Int {
        let oneDay: Double = 86_400
        let entries = habit.entriesArray.sorted(by: { $0.date! < $1.date! })
        if entries.isEmpty { return 0 }
        
        var currentDate = entries.first?.date!
        var count = 1
        
        entries.forEach { entry in
            if currentDate?.noon.timeIntervalSince(entry.date!.noon) == -oneDay {
                count += 1
//                print("1 day ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
            } else if currentDate!.noon != entries.last?.date!.noon {
                count = 1
//                print("Reset ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
            } else {
//                print("More than 1 day ", currentDate, date, count, currentDate?.noon.timeIntervalSince(date.noon))
                count = 0
            }
            
            currentDate = entry.date!
        }
        
        if ((currentDate?.noon.timeIntervalSinceNow)! <= -oneDay) {
            count = 0
        }

        return count
    }
    
    func getHabitBestStreak(habit: Habit) -> Int {
        let entries = habit.entriesArray.sorted(by: { $0.date! < $1.date! })
        if entries.isEmpty { return 0 }
        
        let referenceDate = Calendar.current.startOfDay(for: entries.first!.date!)
        let dayDiffs = entries.map { entry in
            Calendar.current.dateComponents([.day], from: referenceDate, to: entry.date!).day!
        }
        
        let consecutiveDaysCount = maximalConsecutiveNumbers(in: dayDiffs)
//        print(dayDiffs, consecutiveDaysCount)
        
        return consecutiveDaysCount
    }
    
    final func getHabitsByDate() ->  [(date: Date, entries: [Entry], percent: Double)] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        fetchRequest.includesPropertyValues = false
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        fetchRequest.includesPropertyValues = false
        var tuple: [(date: Date, entries: [Entry], percent: Double)] = []
        
        do {
            let entries = try viewContext.fetch(fetchRequest) as! [Entry]
            let habits = try viewContext.fetch(fetchRequest2) as! [Habit]
            
            let groupedEntries = Dictionary(grouping: entries, by: { $0.date?.noon })
            groupedEntries.forEach { date, entries in
                tuple.append((date: date!, entries: entries, percent: getDayHabitsPercentage(habits: habits, selectedDate: date!)))
            }
            return tuple
        } catch {
            print("Error getting habit groups ", error)
        }
        return tuple
    }
    
    final func getDayHabitsPercentage(habits: [Habit], selectedDate: Date) -> Double {
        let wday = Calendar.current.dateComponents([.weekday], from: selectedDate).weekday
        let filteredHabits = habits.filter({ $0.daysArray.contains(where: { $0.number == wday! }) || $0.schedule == "Daily" })
        
        let completedHabitsCount = Double(filteredHabits.filter({ $0.entriesArray.contains(where: { Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }) }).count)
        let totalHabitsCount = Double(filteredHabits.count)
        let percentage = completedHabitsCount/totalHabitsCount

        if percentage >= 0.0 {
            return percentage * 100
        }
        return 0.0
    }

}

func maximalConsecutiveNumbers(in array: [Int]) -> Int {
    var longest = 0 // length of longest subsequence of consecutive numbers
    var current = 1 // length of current subsequence of consecutive numbers

    for (prev, next) in zip(array, array.dropFirst()) {
        if next > prev + 1 {
            // Numbers are not consecutive, start a new subsequence.
            current = 1
        } else if next == prev + 1 {
            // Numbers are consecutive, increase current length
            current += 1
        }
        if current > longest {
            longest = current
        }
    }
    return longest
}
