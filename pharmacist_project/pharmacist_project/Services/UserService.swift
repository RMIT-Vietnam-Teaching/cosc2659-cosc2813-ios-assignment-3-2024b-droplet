//
//  UserService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import FirebaseFirestore

final class UserService: CRUDService<AppUser> {
    
    static let shared = UserService()
    
    override var collectionName: String {"users"}
    
    func createNewUser(user: AppUser) async throws {
        try await createDocument(user)
    }
    
    func getUser(userId: String) async throws -> AppUser {
        return try await getDocument(userId)
    }
    
    func isUserExist(userId: String) async -> Bool {
        return await isDocumentExist(userId)
    }
    
    func updateUser(user: AppUser) async throws {
        try await updateDocument(user)
    }
    
    func updateDocumentFields(userId: String, fields: [String: Any]) async throws {
        try await updateDocumentFields(userId, fields: fields)
    }
}
