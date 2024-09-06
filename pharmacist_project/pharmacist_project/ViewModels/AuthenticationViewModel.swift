//
//  AuthenticationViewModel.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 5/9/24.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    func register() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.createUser(email: email, password: password)
            
            if errorMsg != nil {
                // display error
                print(errorMsg!)
                errorMessage = errorMsg!
            } else {
                // register success => home view
                print("resgister un success")
            }
        }
    }
    
    func signIn() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.signIn(email: email, password: password)
            if errorMsg != nil {
                // display error
                print(errorMsg!)
                errorMessage = errorMsg!
            } else {
                // sign in success => home view
                print("sign in success")
            }
        }
    }
    
    func signOut() {
        let errorMsg = AuthenticationService.shared.signOut()
        if errorMsg != nil {
            print("sign out error")
        } else {
            print("sign out success")
        }
    }
}
