//
//  PreferenceKey.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 25/10/22.
//

import SwiftUI

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
