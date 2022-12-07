//
//  CalendarView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedSchedule: ScheduleType = .daily
    @State var selectedCategory: Category?

    @State var currentDate = Date()
    @State var showFilter = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section {
                        AllHabitsMonthlyCalendar(currentDate: $currentDate)
                            .frame(height: 380, alignment: .top)
                            .padding(8)
                            .background(Color("Tertiary"))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        
                        HStack(alignment: .center, spacing: 10) {
                            Spacer()
                            Text("Week of \(habitVM.extractDate(date: currentDate.startOfWeek!, format: "MMM d")) to \(habitVM.extractDate(date: currentDate.endOfWeek!, format: "MMM d"))")
                                .font(.title2.weight(.semibold))
                            Spacer()
                        }
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(15)
                        .padding([.top, .horizontal])
                        
                        SchedulePickerItem(selectedSchedule: $selectedSchedule)
                            .padding(.top, 15)
                            .padding(.bottom, -10)
                            .padding(.horizontal)
                        
                        HabitsView(selectedSchedule: $selectedSchedule, selectedDate: $currentDate, selectedFilterCategory: $selectedCategory)
                            .hCenter()
                    } header: {
                        HeaderView()
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .onChange(of: habitVM.currentDay) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    habitVM.currentDay = newValue
                }
            }
            
            
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
                Text("Calendar")
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(HabitViewModel())
    }
}
