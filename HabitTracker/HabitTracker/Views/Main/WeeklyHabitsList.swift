//
//  WeeklyHabitsList.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/17/22.
//

import SwiftUI

struct WeeklyHabitsList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true), NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>

    @State var selectedHabit: Habit?
    @State var showHabitDetails = false
    @Binding var selectedFilterCategory: Category?
    @Binding var selectedDate: Date

    var body: some View {
        ForEach(selectedFilterCategory != nil ? habits.filter({ $0.schedule == ScheduleType.weekly.rawValue && $0.category == selectedFilterCategory }) : habits.filter({ $0.schedule == ScheduleType.weekly.rawValue })) { habit in
            if habit.daysArray.isEmpty {
                if habit.timesPerWeek != habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count {
                    WeeklyHabitButton(selectedDate: $selectedDate, selectedHabit: $selectedHabit, showHabitDetails: $showHabitDetails, habit: habit)
                } else if habit.timesPerWeek == habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count && habit.entriesArray.first(where: { $0.date == selectedDate }) != nil {
                    WeeklyHabitButton(selectedDate: $selectedDate, selectedHabit: $selectedHabit, showHabitDetails: $showHabitDetails, habit: habit)
                }
                //                            Text("\(habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count)")
            } else if habit.schedule == ScheduleType.weekly.rawValue && habit.daysArray.contains(where: { Calendar.current.dateComponents([.weekday], from: selectedDate).weekday == Int($0.number) }) {
                WeeklyHabitButton(selectedDate: $selectedDate, selectedHabit: $selectedHabit, showHabitDetails: $showHabitDetails, habit: habit)
            }
        }
    }
}

struct WeeklyHabitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedHabit: Habit?
    @Binding var showHabitDetails: Bool
    var habit: Habit
    
    var body: some View {
        Button {
            selectedHabit = habit
            showHabitDetails = true
        } label: {
            WeeklyHabitItem(habit: habit, selectedDate: $selectedDate)
        }
        .navigationDestination(isPresented: $showHabitDetails) {
            if let selectedHabit {
                HabitDetailsView(habit: selectedHabit)
            }
        }
    }
}
