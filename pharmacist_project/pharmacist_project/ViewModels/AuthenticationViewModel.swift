//
//  AuthenticationViewModel.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 5/9/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        let emailErrorMessage = isValidEmail(emai: email)
        if emailErrorMessage != nil {
            print(emailErrorMessage!)
            return
        }
        
        let passwordErrorMessage = isValidPassword(password: password)
        if passwordErrorMessage != nil {
            print(passwordErrorMessage!)
            return
        }
        
        // create user
        Task {
            do {
                let returnedUserData = try await AuthenticationService.shared.createUser(email: email, password: password)
                print("Sign in success")
                print("User data: \(returnedUserData)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func signOut() throws {
        try AuthenticationService.shared.signOut()
    }
    
    private func isValidEmail(emai: String) -> String? {
        if GlobalUtils.isValidEmail(email: email) {
            return nil
        }
        return "Invalid email due to.."
    }
    
    private func isValidPassword(password: String) -> String? {
        return nil
    }
}
