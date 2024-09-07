//
//  RegistrationViewModel.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation
import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String? = nil
    
    @Published var isShowHomeView = false
    
    func register() {
        // enforce email, password & name
        let inputError = validateInput()
        if inputError != nil {
            errorMessage = inputError!
            return
        }
        
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.createUserWithName(email: email, password: password, name: name)
            
            if errorMsg != nil {
                print("register error \(errorMsg!)")
                errorMessage = errorMsg!
            } else {
                print("resgister success")
                errorMessage = nil
                isShowHomeView = true
            }
        }
    }

    func signInGoogle() {
        Task {
            let (errorMsg, _) = await AuthenticationService.shared.signInWithGoogle()
            
            if errorMsg != nil {
                print("sign in with google error \(errorMsg!)")
                errorMessage = errorMsg!
            } else {
                print("sign in with google succcess")
                errorMessage = nil
                isShowHomeView = true
            }
        }
    }
    
    // TODO: enforce input
    private func validateInput() -> String? {
        let nameErrorMessage = isValidName(name: name)
        if nameErrorMessage != nil {
            return nameErrorMessage
        }
        
        let emailErrorMessage = isValidEmail(email: email)
        if emailErrorMessage != nil {
            return emailErrorMessage!
        }
        
        let passwordErrorMessage = isValidPassword(password: password)
        if passwordErrorMessage != nil {
            return passwordErrorMessage!
        }
        
        return nil
    }
    
    private func isValidName(name: String) -> String? {
        return GlobalUtils.isValidName(name: name)
    }
    
    private func isValidEmail(email: String) -> String? {
        return GlobalUtils.isValidEmail(email: email)
    }
    
    private func isValidPassword(password: String) -> String? {
        return nil
    }
}
