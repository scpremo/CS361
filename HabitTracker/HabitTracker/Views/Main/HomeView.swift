//
//  HomeView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 20/10/22.
//

import SwiftUI

enum ScheduleType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
}

struct HomeView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedSchedule: ScheduleType = .daily
    
    @State var showFilter = false
    @State var selectedCategory: Category?
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            WeekCalendarItem()
                        }
                        
                        WeeklyProgressItem(progress: habitVM.getWeekPercentage(habits: habits.map({ habit in
                            habit
                        }), week: habitVM.currentWeek))
                        .padding(.top, 15)
                    

                        
                        SchedulePickerItem(selectedSchedule: $selectedSchedule)
                            .padding(.top, 15)
                            .padding(.bottom, -5)
                            .padding(.horizontal)
                        
                        HabitsView(selectedSchedule: $selectedSchedule, selectedDate: $habitVM.currentDay, selectedFilterCategory: $selectedCategory)
                            .hCenter()
                    } header: {
                        HeaderView()
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            
            
            
        }
        .background(Color("Primary").ignoresSafeArea())
        .sheet(isPresented: $showFilter) {
            CategoryFilterView(selectedCategory: $selectedCategory)
                .presentationDetents([.fraction(CGFloat(Double(categories.count + 2) * 0.04))])
        }
    }
    
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.secondary)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                showFilter = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    if selectedCategory != nil {
                        Text((selectedCategory?.title!)!)
                            .font(.title2)
                            .foregroundColor(selectedCategory != nil ? Color(selectedCategory?.color ?? "") : .primary)
                    }
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(selectedCategory != nil ? Color(selectedCategory?.color ?? "") : .primary)
                }
                .padding(selectedCategory != nil ? 5 : 0)
                .background(selectedCategory != nil ? Color(selectedCategory?.color ?? "").opacity(0.2) : Color("Primary"))
                .cornerRadius(10)
            }
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color("Primary"))
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HabitViewModel())
    }
}
