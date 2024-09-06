//
//  UserService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import FirebaseFirestore

final class UserService {
    
    static let shared = UserService()
    private init() {}
    
    var collectionName: String {"users"}
    
    func createNewUser(user: FirebaseUser) async throws {
        let userData: [String: Any] = [
            "id": user.id,
            "dateCreated": Timestamp(),
            "email": user.email ?? "",
            "phone": "123"
            
        ]
        try await Firestore.firestore().collection(collectionName).document(user.id).setData(userData, merge: false)
    }
}
