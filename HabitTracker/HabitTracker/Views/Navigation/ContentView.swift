//
//  ContentView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 18/10/22.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var habitVM: HabitViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>

    @State private var showNewHabit = false
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @Namespace var animation

    @State var color: Color = Color("ButtonPrimary")
    @State var selectedX: CGFloat = 0
    @State var x: [CGFloat] = [0, 0, 0, 0, 0]

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tag(Tab.home)
                .navigationViewStyle(.stack)
                
                NavigationStack {
                    CalendarView()
                }
                .tag(Tab.calendar)
                .navigationViewStyle(.stack)

                NavigationStack {
                    StatsView()
                }
                .tag(Tab.stats)
                .navigationViewStyle(.stack)

            }
            
            VStack(alignment: .trailing, spacing: 10) {
                Button {
                    buttonVibration()
                    Task { @MainActor in
                        habitVM.showNewHabit.toggle()
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle( Color("Primary"), Color("ButtonPrimary").gradient)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [7]
                                    )
                                )
                                .foregroundColor(Color("ButtonPrimary"))
                        )
                        .padding(.horizontal)
                        .padding(.bottom, -20)

                }

                TabBar(color: $color, selectedX: $selectedX, x: $x)
                    .frame(height: 80)
                
            }
            
            
            
        }
        .sheet(isPresented: $habitVM.showEditHabit) {
            NavigationStack {
                EditHabitView(selectedHabit: $habitVM.selectedEditHabit)
            }
        }
        .sheet(isPresented: $habitVM.showDeleteWarning) {
            HabitDeleteWarningView(selectedHabit: $habitVM.selectedEditHabit)
                .presentationDetents([.fraction(0.25)])
        }

    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(HabitViewModel())
        
    }
}
