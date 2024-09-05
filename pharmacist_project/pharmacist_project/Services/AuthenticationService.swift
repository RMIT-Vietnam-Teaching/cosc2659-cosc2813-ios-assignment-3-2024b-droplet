//
//  AuthenticationService.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 5/9/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationService {
    static let shared = AuthenticationService()
    private init() { }
    
    func getAuthenticatedUser() throws -> AppUser {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        let firebaseUser = FirebaseUser(user: user)
        
        return getAppUserFromFirebaseUser(firebaseUser: firebaseUser)
    }
    
    func createUser(email: String, password: String) async throws -> AppUser {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let firebaseUser = FirebaseUser(user: authDataResult.user)
        
        return getAppUserFromFirebaseUser(firebaseUser: firebaseUser)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    private func getAppUserFromFirebaseUser(firebaseUser: FirebaseUser) -> AppUser {
        // TODO: implement logic to get user's info from firestore
        return AppUser(firebaseUser: firebaseUser)
    }
}
