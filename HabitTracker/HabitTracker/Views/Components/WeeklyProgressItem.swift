//
//  WeeklyProgressItem.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/17/22.
//

import SwiftUI

struct WeeklyProgressItem: View {
    var progress: Double
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text("Your progress this week")
                .font(.title.weight(.bold))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            
            Spacer()
            
            ProgressRingItem(show: .constant(true), progress: progress, ringRadius: 40, thickness: 10, startColor: Color.white.opacity(0.7), endColor: Color.white, showText: true)
                
        }
        .padding(20)
        .background(
            LinearGradient(colors: [Color.indigo, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

struct WeeklyProgressItem_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyProgressItem(progress: 0.5)
    }
}
