//
//  AppUser.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 5/9/24.
//

import Foundation
import FirebaseAuth

struct AppUser: Codable {
    let id: String
    let email: String?
    let photoURL: String?
    
    init(authDataResultUser: User) {
        self.id = authDataResultUser.uid
        self.email = authDataResultUser.email
        self.photoURL = authDataResultUser.photoURL?.absoluteString
    }
}
