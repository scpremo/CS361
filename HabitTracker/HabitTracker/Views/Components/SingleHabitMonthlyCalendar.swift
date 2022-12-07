//
//  SingleHabitMonthlyCalendar.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/15/22.
//

import SwiftUI

struct SingleHabitMonthlyCalendar: View {
    @State var currentDate = Date()
    @State var currentMonth: Int = 0

    @EnvironmentObject var habitVM: HabitViewModel
    @State var calendarValues = [CalendarValue]()
    var habit: Habit
    
    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            VStack(spacing: 35) {
                
                let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                
                HStack(alignment: .bottom, spacing: 20) {
                    HStack(alignment: .bottom, spacing: 2) {
                        //                    Text("\(extraDate().year)")
                        //                    Text("\(String(format: "%0d", extraDate().year))")
                        //                        .font(.caption.weight(.semibold))
                        //                        .offset(y: 5)
                        
                        Text("\(extraDate().month) \(String(format: "%0d", extraDate().year))")
                            .font(.title2.bold())
                            .offset(y: 5)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        buttonVibration()
                        withAnimation {
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    
                    Button {
                        buttonVibration()
                        withAnimation {
                            currentMonth += 1
                        }
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                    
                }
                .padding(.horizontal, 7)
                .foregroundColor(.primary)
                
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.callout.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(extractCalendar()) { value in
                        Button {
                            buttonVibration()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                                currentDate = value.date
                            }
                        } label: {
                            CardView(value: value)
                                .background(
                                    Circle()
                                        .fill(Color("ButtonPrimary"))
                                        .padding(.horizontal, 4)
                                        .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                        .overlay(alignment: .center, content: {
                                            if value.day != -1 {
                                                ProgressRingItem(show: .constant(true),
                                                                 progress: value.percentage,
                                                                 ringRadius: 20,
                                                                 thickness: 3,
                                                                 startColor: Color.blue,
                                                                 endColor: Color.cyan)
                                            }
                                        })
                                )
                            
                        }
                        
                        
                    }
                    .transition(.opacity)
                }
                .padding(.top, -20)
                
                
            }
            .onAppear {
                if calendarValues.isEmpty {
                    calendarValues = extractCalendar()
                }
            }
            .onChange(of: currentMonth) { _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                    currentDate = getCurrentMonth()
                    calendarValues = extractCalendar()
                }
            }
            .frame(height: 380, alignment: .top)
            .padding(8)
            .background(Color("Tertiary"))
            .cornerRadius(25)
            .padding(.horizontal)

            
            if habit.schedule == ScheduleType.daily.rawValue {
                Button {
                    if habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 {
                        habitVM.removeEntry(habit: habit, selectedDate: currentDate)
                    } else {
                        habitVM.addDailyEntry(habit: habit, selectedDate: currentDate)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Label(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? "Completed" : "Not completed", systemImage: habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? "checkmark.square.fill" : "checkmark.square")
                            .font(.title3.bold())
                        Spacer()
                    }
                    .foregroundColor(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color("InvertedText") : Color.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color.green : Color("ButtonPrimary"), lineWidth: 1.5)
                                .background(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color.green : Color("Tertiary"), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        )
                        .padding(.horizontal)
                }
                .disabled(currentDate > Date() ? true : false)
                .opacity(currentDate > Date() ? 0 : 1)
                .id(habitVM.refreshID)

            } else {
                Button {
                    if habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 {
                        habitVM.removeEntry(habit: habit, selectedDate: currentDate)
                    } else {
                        habitVM.addWeeklyEntry(habit: habit, selectedDate: currentDate)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Label(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? "Completed" : "Not completed", systemImage: habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? "checkmark.square.fill" : "checkmark.square")
                            .font(.title3.bold())
                        Spacer()
                    }
                    .foregroundColor(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color("InvertedText") : Color.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color.green : Color("ButtonPrimary"), lineWidth: 1.5)
                                .background(habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 1 ? Color.green : Color("Tertiary"), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        )
                        .padding(.horizontal)
                }
                .id(habitVM.refreshID)
                .disabled(currentDate > Date() ? true : false)
                .opacity(currentDate > Date() || (habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, currentDate)}).count == habit.timesPerWeek && habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 0) ? 0.5 : 1)
                .disabled(habit.entriesArray.filter({Calendar.current.isDateInThisWeek($0.date!, currentDate)}).count == habit.timesPerWeek && habit.entriesArray.filter({ Calendar.current.isDate($0.date!, inSameDayAs: currentDate) }).count == 0 ? true : false)
            }
        }
//        .onChange(of: habitVM.entries.count) { newValue in
//            if habitVM.entries.count != newValue {
//                calendarValues = extractDate()
//            }
//        }

    }
    
    @ViewBuilder
    func CardView(value: CalendarValue) -> some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.body.bold())
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Color("InvertedText") : .primary)
                    .overlay {
                        ZStack {
                            if isSameDay(date1: Date(), date2: value.date) && value.day != -1 {
                                Circle()
                                    .frame(width: 4, height: 4, alignment: .bottom)
                                    .offset(y: 12)
                                    .foregroundColor(isSameDay(date1: Date(), date2: currentDate) ? Color("InvertedText") : .primary)
                            }
                        }
                    }
            }
        }
        .padding(.vertical, 9)
        //        .frame(height: 60, alignment: .top)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> (year: Int, month: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let components = Calendar.current.dateComponents([.year], from: currentDate)
        let date = formatter.string(from: currentDate)
        
        return (year: components.year!, month: date)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractCalendar() -> [CalendarValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> CalendarValue in
            let day = calendar.component(.day, from: date)
            let percentage = habit.entriesArray.contains(where: { Calendar.current.isDate($0.date!, inSameDayAs: date) }) ? 1.0 : 0
            return CalendarValue(day: day, date: date, percentage: percentage)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(CalendarValue(day: -1, date: Date(), percentage: 0), at: 0)
        }
        
        return days
    }

}
