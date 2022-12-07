//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 18/10/22.
//

import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    @Published var refreshID = UUID()
    @Published var showTab: Bool = true
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    
    @Published var showNewHabit = false

    @Published var showEditHabit = false
    @Published var selectedEditHabit: Habit?

    @Published var showDeleteWarning = false
    
    @AppStorage("hasCreatedCategories") var hasCreatedCategories = false

    init() {
        fetchCurrentWeek()
        if !hasCreatedCategories {
            createCategories()
        }
    }
    
    func addHabit(name: String, category: Category, time: Date, hasTime: Bool, schedule: String, days: [Int], hasDays: Bool, timesPerWeek: Int) -> Void {
        withAnimation {
            let newHabit = Habit(context: viewContext)
            newHabit.name = name
            category.addToHabit(newHabit)
            newHabit.schedule = schedule
            newHabit.sendsNotifications = true
            
            if schedule == "Weekly" {
                newHabit.timesPerWeek = Int16(timesPerWeek)
            }
            
            if hasTime {
                newHabit.time = time
            }
            
            if days.isNotEmpty && hasDays {
                for day in days {
                    let newDay = Day(context: viewContext)
                    newDay.number = Int16(day)
                    newHabit.addToDays(newDay)
                }
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func updateHabit(habit: Habit, name: String, category: Category, time: Date, hasTime: Bool) -> Void {
        withAnimation {
            habit.name = name
            habit.category = category
                        
            if hasTime {
                habit.time = time
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    
    func deleteHabit(habit: Habit) {
        viewContext.delete(habit)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
    
    func isHabitCompletedforWeekday(habit: Habit, weekday: Int) -> Bool {
//        print(habit.name ?? "")
        var isCompleted = false
        
        let days = habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, Date())})
        days.forEach { day in
            let wday = Calendar.current.dateComponents([.weekday], from: day.date!).weekday
//            print(wday, day.date?.formatted(date: .complete, time: .shortened))
            if wday! == weekday {
                isCompleted = true
            }
        }
        return isCompleted
    }
    
    func getDayHabitsPercentage(habits: [Habit], selectedDate: Date) -> Double {
        let wday = Calendar.current.dateComponents([.weekday], from: selectedDate).weekday
        let filteredHabits = habits.filter({
//            $0.daysArray.isEmpty && $0.timesPerWeek == $0.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count
            ($0.daysArray.contains(where: { $0.number == wday! }) && $0.daysArray.isNotEmpty) ||
            $0.schedule == "Daily"
            || ($0.daysArray.isEmpty && $0.timesPerWeek != $0.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count)
        })
                
        let completedHabitsCount = Double(filteredHabits.filter({ $0.entriesArray.contains(where: { Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }) }).count)
        let totalHabitsCount = Double(filteredHabits.count)
        let percentage = completedHabitsCount/totalHabitsCount

        if percentage >= 0.0 {
            return percentage
        }
        return 0.0
    }
    
    
    func getSingleHabitPercentage(habit: Habit, selectedDate: Date) -> Int {
        var ratio = 0.0
        if habit.schedule == ScheduleType.daily.rawValue {
            ratio = Double(habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count) / 7.0
        } else {
            ratio = Double(habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count) / Double(habit.timesPerWeek)
        }
        let per = ratio * 100
        if per >= 0 {
            return Int(per)
        }
        return 0
    }
    
    func getWeekPercentage(habits: [Habit], week: [Date]) -> Double {
        var sum = 0.0
        var totalPercentage = 0.0
        week.forEach { day in
            let percentage = getDayHabitsPercentage(habits: habits, selectedDate: day)
            sum += percentage
        }
        
        totalPercentage = sum / 7.0
        
        return totalPercentage
    }
}

