//
//  CustomDatePicker.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 27/10/22.
//

import SwiftUI

struct AllHabitsMonthlyCalendar: View {
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true), NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<Entry>

    @EnvironmentObject var habitVM: HabitViewModel
    @State var calendarValues = [CalendarValue]()

    var body: some View {
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
            return CalendarValue(day: day, date: date, percentage: habitVM.getDayHabitsPercentage(habits: habits.map({ habit in
                return habit
            }), selectedDate: date))
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(CalendarValue(day: -1, date: Date(), percentage: 0), at: 0)
        }
        
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        AllHabitsMonthlyCalendar(currentDate: .constant(Date()))
    }
}

