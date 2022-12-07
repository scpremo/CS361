//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 18/10/22.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared
    let habitViewModel = HabitViewModel()
    let statsViewModel = StatsViewModel()
    
    init() {
        UITabBar.appearance().isHidden = true
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(habitViewModel)
                .environmentObject(statsViewModel)
        }
    }
}
