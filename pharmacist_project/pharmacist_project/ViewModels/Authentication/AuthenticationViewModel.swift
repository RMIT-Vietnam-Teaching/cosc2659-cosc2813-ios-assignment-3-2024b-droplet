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
