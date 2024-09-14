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
    
    private var authService: AuthenticationService = AuthenticationService.shared
    private var userService: UserService = UserService.shared
    
    init() {}
    
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
    
    func updateUser(name: String? = nil, dob: Date? = nil, phoneNumber: String? = nil, address: String? = nil, photoURL: URL? = nil) {
        guard let currentUser = user else { return }
        
        let newName = name ?? currentUser.name
        let newDob = dob ?? currentUser.dob
        let newPhoneNumber = phoneNumber ?? currentUser.phoneNumber
        let newAddress = address ?? currentUser.address
        let newPhotoURL = photoURL?.absoluteString ?? currentUser.photoURL
        
        //print(newPhotoURL!)
        
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
                    photoURL: newPhotoURL,
                    type: currentUser.type,
                    bio: "",
                    createdDate: currentUser.createdDate
                )
                
                try await userService.updateUser(user: updatedUser)
                
                self.user = updatedUser
                self.isLoading = false
                print("updated user")
            } catch {
                self.errorMessage = "Error updating user"
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
