//
//  HabitsView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct HabitsView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true), NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @Binding var selectedSchedule: ScheduleType
    @State private var showEmptyState = false
    @Binding var selectedDate: Date
    
    // New Habit View variables
    @State private var name = ""
    @State private var selectedCategory: Category?
    @State private var schedule: ScheduleType = .daily
    
    @State private var timesPerWeek = 1
    @State private var hasDays = false
    
    @State private var days = [Int]()
    @State private var time = Date()
    @State private var hasTime = false
    
    @State var selectedHabit: Habit?
    @Binding var selectedFilterCategory: Category?
    
    @State var showHabitDetails = false
    
    var body: some View {
        NavigationStack {
            LazyVStack(spacing: 25) {
                if selectedSchedule == .daily {
                    DailyHabitsList(selectedFilterCategory: $selectedFilterCategory, selectedDate: $selectedDate)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    WeeklyHabitsList(selectedFilterCategory: $selectedFilterCategory, selectedDate: $selectedDate)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
            }
            .padding()
            .padding(.top)
            .padding(.bottom, 140)
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
            .sheet(isPresented: $habitVM.showNewHabit) {
                NavigationStack {
                    NewHabitView(name: $name, selectedCategory: $selectedCategory, schedule: $schedule, timesPerWeek: $timesPerWeek, hasDays: $hasDays, days: $days, time: $time, hasTime: $hasTime)
                }
                .navigationViewStyle(.stack)
            }
        }
        //        .background(
        //            ZStack {
        //                if let selectedHabit {
        //                    NavigationLink(
        //                        destination: HabitDetailsView(habit: selectedHabit),
        //                        tag: true,
        //                        selection: $showHabitDetails,
        //                        label: { EmptyView() }
        //                    )
        //                }
        //            }
        //        )
        

    }
}
