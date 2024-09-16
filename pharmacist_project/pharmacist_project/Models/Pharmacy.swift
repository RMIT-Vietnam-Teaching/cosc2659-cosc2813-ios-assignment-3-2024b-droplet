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

struct Pharmacy: FirebaseModel {
    let id: String
    var name: String?
    var address: String?
    var description: String?
    var createdDate: Date?
    
    init(id: String, name: String?, address: String?, description: String?, createdDate: Date?) {
        self.id = id
        self.name = name
        self.address = address
        self.description = description
        self.createdDate = createdDate
    }
    
    init(name: String?, address: String?, description: String?, createdDate: Date?) {
        self.id = CRUDService<Pharmacy>.generateUniqueId(collection: PharmacyService.shared.collection)
        self.name = name
        self.address = address
        self.description = description
        self.createdDate = createdDate
    }
}
