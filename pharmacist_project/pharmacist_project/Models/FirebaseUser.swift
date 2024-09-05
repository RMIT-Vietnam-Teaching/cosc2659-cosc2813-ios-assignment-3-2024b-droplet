//
//  FirebaseUser.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 6/9/24.
//

import Foundation
import FirebaseAuth

struct FirebaseUser {
    let id: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}
