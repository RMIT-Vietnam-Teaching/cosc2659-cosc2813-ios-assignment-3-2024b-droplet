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
    
    func register() async -> (String?) {
        let (errorMsg, _) = await AuthenticationService.shared.createUser(email: email, password: password)
        return errorMsg
    }
    
    func signIn() async -> (String?) {
        let (errorMsg, _) = await AuthenticationService.shared.signIn(email: email, password: password)
        return errorMsg
    }
    
    func signOut() -> String? {
        return AuthenticationService.shared.signOut()
    }
}
