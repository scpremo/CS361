//
//  HabitVM + Entry.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/1/22.
//

import SwiftUI

extension HabitViewModel {
    func addDailyEntry(habit: Habit, selectedDate: Date) {
        if habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 1 {
            print("SAME DAY")
            return
        }
        
        let newEntry = Entry(context: viewContext)
        newEntry.date = selectedDate
        habit.addToEntry(newEntry)

        do {
            try viewContext.save()
            Task { @MainActor in
                withAnimation { refreshID = UUID() }
            }
            buttonVibration()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
    
    func addWeeklyEntry(habit: Habit, selectedDate: Date) {
        if habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count == habit.timesPerWeek {
            return
        }
            
        let newEntry = Entry(context: viewContext)
        newEntry.date = selectedDate
        habit.addToEntry(newEntry)
        
        do {
            try viewContext.save()
            Task { @MainActor in
                withAnimation { refreshID = UUID() }
            }
            buttonVibration()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func removeEntry(habit: Habit, selectedDate: Date) {
        let entries = habit.entriesArray
        guard let selectedEntry = entries.first(where: { Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }) else { return }
        viewContext.delete(selectedEntry)

        do {
            try viewContext.save()
            Task { @MainActor in
                withAnimation { refreshID = UUID() }
            }
            buttonVibration()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
}
