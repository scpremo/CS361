//
//  ButtonVibrations.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 25/10/22.
//

import SwiftUI

func buttonVibration(intensity: CGFloat = 0.7) {
    let generator = UIImpactFeedbackGenerator()
    generator.impactOccurred(intensity: intensity)
}

func successVibration() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}
