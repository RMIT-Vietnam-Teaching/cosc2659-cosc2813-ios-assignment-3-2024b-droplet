//
//  AppUser.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 5/9/24.
//

import Foundation
import FirebaseAuth

enum UserType: String, Codable {
    case customer
    case pharmacist
    case admin
    case shipper
}

struct AppUser: FirebaseModel {
    let id: String
    let email: String?
    var name: String?
    var dob: Date?
    var address: String?
    var phoneNumber: String?
    var photoURL: String?
    var type: UserType?
    var bio: String?
    let createdDate: Date?
    
    // only for new created user
    init(authDataResultUser: User) {
        self.id = authDataResultUser.uid
        self.email = authDataResultUser.email
        self.name = authDataResultUser.displayName
        self.dob = nil
        self.address = nil
        self.phoneNumber = nil
        self.photoURL = authDataResultUser.photoURL?.absoluteString
        self.type = .customer
        self.createdDate = Date()
    }
    
    init(
        id: String,
        email: String?,
        name: String? = nil,
        dob: Date? = nil,
        address: String? = nil,
        phoneNumber: String? = nil,
        photoURL: String? = nil, 
        type: UserType?,
        bio: String?,
        createdDate: Date?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.dob = dob
        self.address = address
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.type = type
        self.bio = bio
        self.createdDate = createdDate
    }
    
    init(
        email: String?,
        name: String? = nil,
        dob: Date? = nil,
        address: String? = nil,
        phoneNumber: String? = nil,
        photoURL: String? = nil,
        type: UserType?,
        bio: String?,
        createdDate: Date?
    ) {
        self.id = CRUDService<AppUser>.generateUniqueId(collection: UserService.shared.collection)
        self.email = email
        self.name = name
        self.dob = dob
        self.address = address
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.type = type
        self.bio = bio
        self.createdDate = createdDate
    }
    
    func isAdmin() -> Bool {
        return self.type! == .admin
    }
    
    func isCustomer() -> Bool {
        return self.type! == .customer
    }
}
