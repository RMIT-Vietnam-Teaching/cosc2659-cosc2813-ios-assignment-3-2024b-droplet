//
//  AppUser.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 5/9/24.
//

import Foundation
import FirebaseAuth

struct AppUser {
    let id: String
    let email: String?
    let photoUrl: String?
    
    init(firebaseUser: FirebaseUser) {
        self.id = firebaseUser.id
        self.email = firebaseUser.email
        self.photoUrl = firebaseUser.photoUrl
    }
}
