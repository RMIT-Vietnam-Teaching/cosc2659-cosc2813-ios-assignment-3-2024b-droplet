//
//  GlobalUtils.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 5/9/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class GlobalUtils {
    static func isValidEmail(email: String) -> String? {
        return nil
    }
    
    static func isValidName(name: String) -> String? {
        return nil
    }
    
    static func getNoImageImageString() -> String {
        return "no-image"
    }
    
    static func getLoadingImageString() -> String {
        return "loading-image"
    }
    
    static func getFallbackImage() -> Image {
        return Image("no-image")
    }
}
