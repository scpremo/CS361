//
//  SystemThemeManager.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 25/10/22.
//

import SwiftUI

class SystemThemeManager {
    @Environment(\.colorScheme) var colorScheme
    
    static let shared = SystemThemeManager()
    
    private init() {}
    
    func handleTheme(darkMode: Bool, system: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first

        guard !system else {
            window?.overrideUserInterfaceStyle = .unspecified
            return
        }
        window?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
