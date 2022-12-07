//
//  WeeklyHabitItem.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct WeeklyHabitItem: View {
    @EnvironmentObject var habitVM: HabitViewModel
    var habit: Habit
    
    @Binding var selectedDate: Date    
    var body: some View {
        
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 10) {
                Circle()
                    .fill(habit.percentage == 100 ? Color("ButtonPrimary") : Color("Primary"))
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(Color("ButtonPrimary"), lineWidth: 1)
                            .padding(-3)
                    )
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("ButtonPrimary"))
                    .frame(width: 3)
                
            }
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                    HStack(alignment: .center, spacing: 12) {
                        Button {
                            
                        } label: {
                            Text(habit.category?.title ?? "")
                                .font(.callout)
                                .foregroundColor(Color(habit.category?.color ?? ""))
                        }
                        .tint(Color(habit.category?.color ?? ""))
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                        .allowsHitTesting(false)

                        Spacer()
                        
                        if let time = habit.time {
                            Text(time.formatted(date: .omitted, time: .shortened))
                                .font(.callout)
                        } else {
                            Text("Anytime")
                                .font(.callout)
                        }
                        
                        
                    }
                    .hLeading()
                    
                    HStack(alignment: .center, spacing: 12) {
                        Text(habit.name ?? "")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                    }
                    .hLeading()
                    
                    HStack(alignment: .center, spacing: 8) {
                        ProgressView(value: Double(habitVM.getSingleHabitPercentage(habit: habit, selectedDate: selectedDate)), total: 100) {
                            Text("\(habitVM.getSingleHabitPercentage(habit: habit, selectedDate: selectedDate))% Complete")
                                .font(.subheadline)
                        }
                        .tint(.blue)

                       
                        
                        Spacer()
                        
                        Button {
                            if habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 1 {
                                habitVM.removeEntry(habit: habit, selectedDate: selectedDate)
                            } else {
                                habitVM.addWeeklyEntry(habit: habit, selectedDate: selectedDate)
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 1 ? Color("InvertedText") : Color("Tertiary"))
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 1 ? Color.green : Color("ButtonPrimary"), lineWidth: 1.5)
                                        .background(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 1 ? Color.green : Color("Tertiary"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                )
                        }
                        .id(habitVM.refreshID)
                        .disabled(selectedDate > Date() ? true : false)
                        .opacity(selectedDate > Date() || (habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count == habit.timesPerWeek && habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 0) ? 0 : 1)
                        .disabled(habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, selectedDate)}).count == habit.timesPerWeek && habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }).count == 0 ? true : false)
                    }
                }
                
            }
            .foregroundColor(.primary)
            .padding()
            .hLeading()
            .background(
                Color("Tertiary")
                    .cornerRadius(25)
            )
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 25, style: .continuous))
            .contextMenu {
                Button {
                    Task { @MainActor in
                        habitVM.showEditHabit = true
                        habitVM.selectedEditHabit = habit
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    habitVM.showDeleteWarning = true
                    habitVM.selectedEditHabit = habit
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .hLeading()
        
    }
}
