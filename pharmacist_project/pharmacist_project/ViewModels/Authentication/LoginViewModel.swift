//
//  LoginViewModel.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var isShowHomeView: Bool = false
    
    func signIn() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.signIn(email: email, password: password)
            errorMessage = errorMsg
            if errorMsg != nil {
                print("sign in error \(errorMsg!)")
            } else {
                print("sign in success")
                isShowHomeView = true
            }
        }
    }
    
    func isUserLoggedIn() -> Bool {
        let user = AuthenticationService.shared.getAuthenticatedUserOffline()
        if user != nil {
            print("success get previous authenticated user \(user?.email ?? "")")
        } else {
            print("need to sign in")
        }
        return user != nil
    }
    
    func signInGoogle() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.signInWithGoogle()
            
            if errorMsg != nil {
                print("sign in with google error \(errorMsg!)")
            } else {
                print("sign in with google succcess")
                isShowHomeView = true
            }
        }
    }
}
