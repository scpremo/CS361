//
//  Tab.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 24/10/22.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
    TabItem(name: "Home", icon: "list.bullet.below.rectangle", color: Color("ButtonPrimary"), selection: .home),
    TabItem(name: "Calendar", icon: "calendar", color: Color("ButtonPrimary"), selection: .calendar),
    TabItem(name: "Stats", icon: "chart.pie", color: Color("ButtonPrimary"), selection: .stats),
]

enum Tab: String {
    case home
    case calendar
    case stats
}
