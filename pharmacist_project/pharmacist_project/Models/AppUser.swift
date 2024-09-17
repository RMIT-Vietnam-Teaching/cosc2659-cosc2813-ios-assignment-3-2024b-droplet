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
