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
            print("sign out error \(errorMsg!)")
        } else {
            print("sign out success")
        }
    }
    
    func resetPassword() {
        Task {
            let errorMsg = await AuthenticationService.shared.resetPassword(email: email)
            if errorMsg != nil {
                print("reset password error \(errorMsg!)")
            } else {
                print("reset password succcess")
            }
        }
    }
    
    func updatePassword() {
        Task {
            let errorMsg = await AuthenticationService.shared.updatePassword(password: password)
            if errorMsg != nil {
                print("update password error \(errorMsg!)")
            } else {
                print("update password succcess")
            }
        }
    }
    
    func signInGoogle() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.signInWithGoogle()
            
            if errorMsg != nil {
                print("sign in with google error \(errorMsg!)")
            } else {
                print("sign in with google succcess")
            }
        }
    }
    
    func printCurrentUser() {
        let user = AuthenticationService.shared.getAuthenticatedUserOffline()
        if user == nil {
            print("Please login first")
        } else {
            print(user!)
        }
    }
}
