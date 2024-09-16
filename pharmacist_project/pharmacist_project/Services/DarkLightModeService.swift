/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 05/09/2024
  Last modified: 16/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://rmit.instructure.com/courses/138616/modules/items/6274590
     https://rmit.instructure.com/courses/138616/modules/items/6274591
     https://rmit.instructure.com/courses/138616/modules/items/6274592
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
*/

import Foundation
import SwiftUI

enum DarkLightMode: String {
    case light
    case dark
    case system
}

class DarkLightModeService {
    static let shared = DarkLightModeService()
    @Environment(\.colorScheme) private var colorScheme
    
    private init() {}
    
    private let darkLightModeKey = "darkLightModePreference"
    let defaultMode: DarkLightMode = .system

    func saveDarkLightModePreference(darkLightMode: DarkLightMode) {
        UserDefaults.standard.set(darkLightMode.rawValue, forKey: darkLightModeKey)
    }
    
    func getDarkLightModePreference() -> DarkLightMode {
        let savedValue = UserDefaults.standard.string(forKey: darkLightModeKey)
        if savedValue != nil {
            return DarkLightMode(rawValue: savedValue!)!
        } else {
            return defaultMode
        }
    }
    
    func removeDarkLightModePreference() {
        UserDefaults.standard.removeObject(forKey: darkLightModeKey)
    }
    
    func updateAppearanceMode(darkLightMode: DarkLightMode) {
        let mode: ColorSchemeMode = {
            switch darkLightMode {
            case .dark: return .dark
            case .light: return .light
            case .system: return .automatic
            }
        }()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let window = windowScene.windows.first else {
            return
        }
        
        switch mode {
        case .automatic:
            window.overrideUserInterfaceStyle = .unspecified
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func getColorSchemeModeFrom(darkLightMode: DarkLightMode) -> ColorSchemeMode {
        switch darkLightMode {
        case .dark: return .dark
        case .light: return .light
        case .system: return .automatic
        }
    }
    
    func isDarkMode() -> Bool {
        let currentMode = getDarkLightModePreference()
        switch currentMode {
        case .dark: return true
        case .light: return false
        case .system: return colorScheme == .dark ? true : false
        }
    }
}
