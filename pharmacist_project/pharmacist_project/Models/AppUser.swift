//
//  AppUser.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 5/9/24.
//

import Foundation
import FirebaseAuth

struct AppUser: FirebaseModel {
    let id: String
    let email: String?
    var name: String?
    var dob: Date?
    var address: String?
    var phoneNumber: String?
    var photoURL: String?
    let createdData: Date?
    
    // only for new created user
    init(authDataResultUser: User) {
        self.id = authDataResultUser.uid
        self.email = authDataResultUser.email
        self.name = authDataResultUser.displayName
        self.dob = nil
        self.address = nil
        self.phoneNumber = nil
        self.photoURL = authDataResultUser.photoURL?.absoluteString
        self.createdData = Date()
    }
    
    init(
        id: String,
        email: String?,
        name: String,
        dob: Date?,
        address: String?,
        phoneNumber: String?,
        photoURL: String?,
        createdData: Date?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.dob = dob
        self.address = address
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.createdData = createdData
    }
    
    init(
        email: String?,
        name: String,
        dob: Date?,
        address: String?,
        phoneNumber: String?,
        photoURL: String?,
        createdData: Date?
    ) {
        self.id = CRUDService<AppUser>.generateUniqueId(collection: UserService.shared.collection)
        self.email = email
        self.name = name
        self.dob = dob
        self.address = address
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.createdData = createdData
    }
}
