//
//  SchedulePickerItem.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct SchedulePickerItem: View {
    @Binding var selectedSchedule: ScheduleType
    @Namespace var animation
    //    @Binding var selectedCategory: String

    var padding: CGFloat =  8
    var backgroundColor: Color = Color("Tertiary")
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Button {
                     buttonVibration()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                        selectedSchedule = .daily
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Daily")
                        Spacer()
                    }
                    .font(.title3.bold())
                    .foregroundStyle(selectedSchedule == .daily ? .primary : .secondary)
                    .foregroundColor(selectedSchedule == .daily ? Color("InvertedText") : .primary)
                    .padding(8)
                    .background(
                        ZStack {
                            if selectedSchedule == .daily {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color("ButtonPrimary").gradient)
                                    .matchedGeometryEffect(id: "SELECTEDSCHEDULE", in: animation)
                            }
                        }
                    )
                }
                
                Button {
                    buttonVibration()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                        selectedSchedule = .weekly
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Weekly")
                        Spacer()
                    }
                    .font(.title3.bold())
                    .foregroundStyle(selectedSchedule == .weekly ? .primary : .secondary)
                    .foregroundColor(selectedSchedule == .weekly ? Color("InvertedText") : .primary)
                    .padding(8)
                    .background(
                        ZStack {
                            if selectedSchedule == .weekly {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color("ButtonPrimary").gradient)
                                    .matchedGeometryEffect(id: "SELECTEDSCHEDULE", in: animation)
                            }
                        }
                    )
                    
                    
                }
                
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(20)
//        .padding(.horizontal)
    }
}

struct SchedulePickerItem_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePickerItem(selectedSchedule: .constant(.daily))
    }
}
