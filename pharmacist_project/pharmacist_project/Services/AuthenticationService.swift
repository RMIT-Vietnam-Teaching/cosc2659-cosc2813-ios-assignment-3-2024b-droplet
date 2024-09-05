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
    
    func createUser(email: String, password: String) async -> (String?, AppUser?) {
        // prevalidate rules
        let emailErrorMessage = isValidEmail(email: email)
        if emailErrorMessage != nil {
            print(emailErrorMessage!)
            return (emailErrorMessage!, nil)
        }
        
        let passwordErrorMessage = isValidPassword(password: password)
        if passwordErrorMessage != nil {
            print(passwordErrorMessage!)
            return (passwordErrorMessage!, nil)
        }
        
        // create user
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let firebaseUser = FirebaseUser(user: authDataResult.user)
            
            print("Sign in success")
            
            return (nil, getAppUserFromFirebaseUser(firebaseUser: firebaseUser))
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
            
//            print(error.localizedDescription)
//            if let errCode = AuthErrorCode(rawValue: error._code) {
//                switch errCode {
//                case .emailAlreadyInUse:
//                    return ("Email already in use", nil)
//                case .invalidEmail:
//                    return ("Invalid email", nil)
//                case .weakPassword:
//                    return ("Weak password", nil)
//                case .operationNotAllowed:
//                    return ("Account is disabled", nil)
//                default:
//                    return ("Internal server error", nil)
//                }
//            }
//            
//            return ("Internal server error", nil)
        }
    }
    
    func signOut() -> String? {
        do {
            try Auth.auth().signOut()
            return nil
        } catch let error as NSError {
            return error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async -> (String?, AppUser?) {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            let firebaseUser = FirebaseUser(user: authDataResult.user)
            
            return (nil, getAppUserFromFirebaseUser(firebaseUser: firebaseUser))
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
        }
    }
    
    private func getAppUserFromFirebaseUser(firebaseUser: FirebaseUser) -> AppUser {
        // TODO: implement logic to get user's info from firestore
        
        return AppUser(firebaseUser: firebaseUser)
    }
    
    
    private func isValidEmail(email: String) -> String? {
        if GlobalUtils.isValidEmail(email: email) {
            return nil
        }
        return "Invalid email due to.."
    }
    
    private func isValidPassword(password: String) -> String? {
        return nil
    }
}
