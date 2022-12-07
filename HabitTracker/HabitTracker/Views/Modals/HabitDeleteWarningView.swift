//
//  HabitDeleteWarningView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/15/22.
//

import SwiftUI

struct HabitDeleteWarningView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var habitVM: HabitViewModel
    
    @Binding var selectedHabit: Habit?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color("Primary").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 15) {
                Text("Delete \"\(selectedHabit?.name ?? "")\"?")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                Text("All your progress will be lost and stats will be recalculated to account for this change")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                HStack(alignment: .center, spacing: 15){
                    Button {
                        dismiss()
                    } label: {
                        Spacer()
                        Text("No, keep it")
                        Spacer()
                    }
                    .controlSize(.large)
                    .cornerRadius(15)
                    .tint(.secondary)
                    .buttonStyle(.bordered)

                    Button {
                        habitVM.deleteHabit(habit: selectedHabit!)
                        dismiss()
                    } label: {
                        Spacer()
                        Label("Yes, Delete", systemImage: "trash")
                        Spacer()
                    }
                    .controlSize(.large)
                    .cornerRadius(15)
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }

}
