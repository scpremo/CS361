//
//  WeekCalendarItem.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct WeekCalendarItem: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @Namespace var animation

    var body: some View {
        HStack(spacing: 10) {
            Spacer(minLength: 18)
            ForEach(habitVM.currentWeek, id: \.self) { day in
                Button {
                    buttonVibration()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                        let components = Calendar.current.dateComponents(
                            [.hour, .minute, .second], from: Date())
                        let calendar = Calendar.current

                        _ = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: components.second!, of: habitVM.currentWeek.first(where: { $0 == day})!)
//                                            print(components)
//                                            print(habitVM.currentWeek.first(where: { $0 == day})!)
                        habitVM.currentDay = day
                    }
                } label: {
                    VStack(spacing: 10) {
                        Text(habitVM.extractDate(date: day, format: "dd"))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        
                        Text(habitVM.extractDate(date: day, format: "EEE"))
                            .font(.system(size: 14))
                        
                        Circle()
                            .fill(Calendar.current.isDateInToday(day) && !Calendar.current.isDate(day, inSameDayAs: habitVM.currentDay) ? Color.primary : Color("InvertedText"))
                            .frame(width: 8, height: 8)
                            .opacity(habitVM.isToday(date: day) || Calendar.current.isDateInToday(day) ? 1 : 0)
                            
                    }
                    .foregroundStyle(habitVM.isToday(date: day) ? .primary : .secondary)
                    .foregroundColor(habitVM.isToday(date: day) ? Color("InvertedText") : .primary)
                    .frame(width: 40, height: 90)
                    .background(
                        ZStack {
                            if habitVM.isToday(date: day) {
                                Capsule()
                                    .fill(Color("ButtonPrimary").gradient)
                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                            }
                        }
                    )
                    .contentShape(Capsule())

                }
            }
            
        }
        .padding(.horizontal)
        

    }
}

struct WeekCalendarItem_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarItem()
            .environmentObject(HabitViewModel())
    }
}
