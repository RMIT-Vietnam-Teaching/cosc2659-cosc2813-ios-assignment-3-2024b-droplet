//
//  UserProfileViewModel.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 10/9/24.
//

import Foundation
import SwiftUI

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var authService: AuthenticationService
    private var userService: UserService
    
    init(authService: AuthenticationService = AuthenticationService.shared, userService: UserService = UserService.shared) {
        self.authService = authService
        self.userService = userService
    }
    
    func loadAuthenticatedUser() {
        isLoading = true
        errorMessage = nil
        
        Task {
            if let offlineUser = authService.getAuthenticatedUserOffline() {
                self.user = offlineUser
                print(offlineUser)
            }
            
            if let onlineUser = await authService.getAuthenticatedUser() {
                self.user = onlineUser
                print(onlineUser)
                self.isLoading = false
            } else {
                self.errorMessage = "please login"
                print("please login")
                self.isLoading = false
            }
        }
    }

    func updateUser(name: String?, dob: Date?, phoneNumber: String?, address: String?) {
        guard let currentUser = user else { return }
        
        let newName = name ?? currentUser.name
        let newDob = dob ?? currentUser.dob
        let newPhoneNumber = phoneNumber ?? currentUser.phoneNumber
        let newAddress = address ?? currentUser.address
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let updatedUser = AppUser(
                    id: currentUser.id,
                    email: currentUser.email,
                    name: newName,
                    dob: newDob,
                    address: newAddress,
                    phoneNumber: newPhoneNumber,
                    photoURL: currentUser.photoURL,
                    type: currentUser.type,
                    createdDate: currentUser.createdDate
                )
                
                try await userService.updateUser(user: updatedUser)
                
                self.user = updatedUser
                self.isLoading = false
            } catch {
                self.errorMessage = "error updating user"
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
        let errorMsg = AuthenticationService.shared.signOut()
        if errorMsg != nil {
            print("Sign out error: \(errorMsg!)")
        } else {
            print("Sign out successful")
            toLoginPage()
        }
    }
    

    func toLoginPage() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        windowScene.windows.first?.rootViewController = UIHostingController(rootView: LoginScreenView())
        windowScene.windows.first?.makeKeyAndVisible()
    }

}
