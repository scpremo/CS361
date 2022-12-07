//
//  DailyHabitsList.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/17/22.
//

import SwiftUI

struct DailyHabitsList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true), NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>

    @State var selectedHabit: Habit?
    @State var showHabitDetails = false
    @Binding var selectedFilterCategory: Category?
    @Binding var selectedDate: Date

    var body: some View {
        ForEach(selectedFilterCategory != nil ? habits.filter({ $0.schedule == ScheduleType.daily.rawValue && $0.category == selectedFilterCategory }) : habits.filter({ $0.schedule == ScheduleType.daily.rawValue })) { habit in
            Button {
                selectedHabit = habit
                showHabitDetails = true
            } label: {
                DailyHabitItem(habit: habit, selectedDate: $selectedDate)
            }
            .navigationDestination(isPresented: $showHabitDetails) {
                if let selectedHabit {
                    HabitDetailsView(habit: selectedHabit)
                }
            }
        }
    }
}
