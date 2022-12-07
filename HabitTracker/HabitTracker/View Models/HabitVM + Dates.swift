//
//  HabitVM + Dates.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/1/22.
//

import SwiftUI

extension HabitViewModel {
    func fetchCurrentWeek() {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 11
        dateComponents.day = 8
        dateComponents.timeZone = .autoupdatingCurrent
        dateComponents.hour = 12
        dateComponents.minute = 00
        
        var calendar = Calendar.current
//        let today = calendar.date(from: dateComponents)?.startOfWeek
        var today = Date()
        if Calendar.current.dateComponents([.weekday], from: today).weekday == 7 {
            today = Date.yesterday
        }
                
        calendar.firstWeekday = 7
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekday = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekday) {
                currentWeek.append(weekday)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date, inSameDayAs: currentDay)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}

struct CalendarValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    var percentage: Double
}
