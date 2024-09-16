/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Long Hoang Pham
  ID: s3938007
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

enum ColorSchemeMode: String, Codable {
    case automatic
    case light
    case dark
}

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var userPreference: UserPreference?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isShowNotificationPermissionAlert = false
    
    @State private var appearanceMode: ColorSchemeMode = DarkLightModeService.shared.getColorSchemeModeFrom(darkLightMode: DarkLightModeService.shared.getDarkLightModePreference())
    
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
            
            if self.user != nil {
                self.userPreference = try await UserPreferenceService.shared.getUserPreference(userId: user!.id)
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
        
        if newPhotoURL != nil {
            print(newPhotoURL!)
        } else {
            print("no new photo uploaded")
        }
        
        
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
    
    func updateAppearanceMode(_ mode: ColorSchemeMode) {
        appearanceMode = mode
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let window = windowScene.windows.first else {
            return
        }
        
        switch mode {
        case .automatic:
            window.overrideUserInterfaceStyle = .unspecified
            DarkLightModeService.shared.saveDarkLightModePreference(darkLightMode: .system)
        case .light:
            window.overrideUserInterfaceStyle = .light
            DarkLightModeService.shared.saveDarkLightModePreference(darkLightMode: .light)
        case .dark:
            window.overrideUserInterfaceStyle = .dark
            DarkLightModeService.shared.saveDarkLightModePreference(darkLightMode: .dark)
        }
    }
    
    func toggleReceiveHealthTip(_ newValue: Bool) {
        Task {
            if var userPreference = self.userPreference {
                do {
                    if newValue == true {
                        let isNotificationPermissionDenied = await NotificationService.shared.isNotificationPermissionDenied()
                        if isNotificationPermissionDenied {
                            isShowNotificationPermissionAlert = true
                        }
                    }
                    try await updateNotificationSetting(newValue)
                } catch {
                    print("Failed to update user preference: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateNotificationSetting(_ newValue: Bool) async throws {
        if var userPreference = self.userPreference {
            userPreference.receiveDailyHealthTip = newValue
            try await UserPreferenceService.shared.updateDocument(userPreference)
            DispatchQueue.main.async {
                self.userPreference = userPreference
                print(userPreference)
            }
        }
    }
    
    func toggleReceiveDeliveryStatus(_ newValue: Bool) {
        Task {
            if var userPreference = self.userPreference {
                do {
                    userPreference.receiveDeliveryStatus = newValue
                    try await UserPreferenceService.shared.updateDocument(userPreference)
                    DispatchQueue.main.async {
                        self.userPreference = userPreference
                        print(userPreference)
                    }
                } catch {
                    print("Failed to update user preference: \(error.localizedDescription)")
                }
            }
        }
    }
}


