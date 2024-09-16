/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 05/09/2024
  Last modified: 16/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://rmit.instructure.com/courses/138616/modules/items/6274590
     https://rmit.instructure.com/courses/138616/modules/items/6274591
     https://rmit.instructure.com/courses/138616/modules/items/6274592
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
*/

import Foundation
import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String? = nil
    @Published var signUpButtonState: ButtonState = .active
    
    @Published var isShowHomeView = false
    
    func register() {
        // enforce email, password & name
        let inputError = validateInput()
        if inputError != nil {
            errorMessage = inputError!
            return
        }
        
        Task {
            signUpButtonState = .loading
            
            let (errorMsg, _) = await AuthenticationService.shared.createUserWithName(email: email, password: password, name: name)
            
            if errorMsg != nil {
                print("register error \(errorMsg!)")
                errorMessage = errorMsg!
            } else {
                print("resgister success")
                errorMessage = nil
                isShowHomeView = true
            }
            
            signUpButtonState = .active
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
    
    func signInFacebook() {
        Task {
            let (errorMsg, _) = try await AuthenticationService.shared.signInWithFacebook()
            
            if errorMsg != nil {
                print("sign in with facebook error \(errorMsg!)")
                errorMessage = errorMsg!
            } else {
                print("sign in with facebook succcess")
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
        
        if password != confirmPassword {
            return "Password and password confirmation is not identical"
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
