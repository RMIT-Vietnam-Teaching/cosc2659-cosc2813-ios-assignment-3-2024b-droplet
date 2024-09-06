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
    
    func createNewUser(user: AppUser) async throws {
        var data: [String: Any] = [:]
        let mirrored_object = Mirror(reflecting: user)
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String? {
                data[attr.label!] = attr.value
            }
        }
        try await Firestore.firestore().collection(collectionName).document(user.id).setData(data)
    }
    
    func getUser(userId: String) async throws -> AppUser {
        let user = try await Firestore.firestore().collection(collectionName).document(userId).getDocument(as: AppUser.self)
        return user
    }
}
