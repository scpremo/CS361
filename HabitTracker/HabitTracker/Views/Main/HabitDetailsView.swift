//
//  HabitDetailsView2.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/17/22.
//

import SwiftUI

struct HabitDetailsView: View {
    var habit: Habit
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var statsVM: StatsViewModel
    @EnvironmentObject var habitVM: HabitViewModel
    
    @State var bestStreak = 0
    @State var currentStreak = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders) {
                
                Section {
                    
                    HStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Times Per Week")
                                .font(.title2.weight(.medium))
                                .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                            
                            VStack(alignment: .center, spacing: 5) {
                                Text(habit.schedule == ScheduleType.daily.rawValue ? "7" : "\(habit.timesPerWeek)")
                                    .font(.title3.weight(.semibold))

                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)

                        VStack(alignment: .center, spacing: 10) {
                            Text("Time")
                                .font(.title2.weight(.medium))
                                .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                            
                            VStack(alignment: .center, spacing: 5) {
                                Text(habit.time == nil ? "Anytime" : habit.time!.formatted(date: .omitted, time: .shortened))
                                    .font(.title3.weight(.semibold))

                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                    }
                    .padding()

                    
                    SingleHabitMonthlyCalendar(habit: habit)
//                        .frame(height: 380, alignment: .top)
//                        .padding(8)
//                        .background(Color("Tertiary"))
//                        .cornerRadius(25)
//                        .padding(.horizontal)

                    HStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Current Streak")
                                .font(.title2.weight(.medium))
                                .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                            
                            VStack(alignment: .center, spacing: 5) {
                                RollingText(font: .title2, weight: .semibold, foregroundColor: .primary, value: $currentStreak)
                                
                                Text(bestStreak == 1 ? "DAY" : "DAYS")
                                    .font(.title3.weight(.semibold))
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)

                        VStack(alignment: .center, spacing: 10) {
                            Text("Best Streak")
                                .font(.title2.weight(.medium))
                                .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                            
                            VStack(alignment: .center, spacing: 5) {
                                RollingText(font: .title2, weight: .semibold, foregroundColor: .primary, value: $bestStreak)
                                
                                Text(bestStreak == 1 ? "DAY" : "DAYS")
                                    .font(.title3.weight(.semibold))
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                    }
                    .padding()

                } header: {
                    HeaderView()
                }
            }
            .padding(.bottom, 140)
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .frame(maxHeight: .infinity)
        .onAppear {
            bestStreak = statsVM.getHabitBestStreak(habit: habit)
            currentStreak = statsVM.getHabitCurrentStreak(habit: habit)
        }

    }
    
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(habit.name ?? "")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                dismiss()
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
                .padding(8)
                .background(Color("Tertiary"))
                .clipShape(Circle())
                .cornerRadius(10)
            }
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color("Primary"))
        
    }
}
