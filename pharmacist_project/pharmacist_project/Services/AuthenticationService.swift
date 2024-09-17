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
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FacebookLogin

enum AuthProvider: String {
    case email = "password"
    case google = "google.com"
    case facebook = "facebook.com"
}

final class AuthenticationService {
    static let shared = AuthenticationService()
    private init() { }
    
    func getAuthenticatedUser() async -> AppUser? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return await getUserFromFileStore(userId: user.uid)
    }
    
    func getAuthenticatedUserOffline() -> AppUser? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return AppUser(authDataResultUser: user)
    }
    
    func signOut() -> String? {
        do {
            try Auth.auth().signOut()
            
            DarkLightModeService.shared.removeDarkLightModePreference()
            DarkLightModeService.shared.updateAppearanceMode(darkLightMode: DarkLightModeService.shared.defaultMode)
            NotificationService.shared.cancelAllNotifications()
            return nil
        } catch let error as NSError {
            return error.localizedDescription
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return self.getAuthenticatedUserOffline() != nil
    }
    
    func getUserAvailableAuthProviders() -> [AuthProvider] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            return []
        }
        
        var providers: [AuthProvider] = []
        for provider in providerData {
            if let option = AuthProvider(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Auth provider not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    private func getUserFromFileStore(userId: String) async -> AppUser? {
        do {
            let user = try await UserService.shared.getUser(userId: userId)
            return user
        } catch {
            return nil
        }
    }
}

// MARK: Sign in email
extension AuthenticationService {
    func createUserWithName(email: String, password: String, name: String) async -> (String?, AppUser?) {
        do {
            // create user in auth
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            authDataResult.user.displayName = name
            
            let appUser = AppUser(authDataResultUser: authDataResult.user)
            
            // create user in db
            try await UserService.shared.createNewUser(user: appUser)
            
            // create cart for user
            try await CartService.shared.createEmptyCart(for: appUser.id)
            
            return (nil, appUser)
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
        }
    }
    
    func createUser(email: String, password: String) async -> (String?, AppUser?) {
        do {
            // create user in auth
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let appUser = AppUser(authDataResultUser: authDataResult.user)
            
            // create user in db
            try await UserService.shared.createNewUser(user: appUser)
            
            // create cart for user
            try await CartService.shared.createEmptyCart(for: appUser.id)
            
            return (nil, appUser)
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
        }
    }
    
    func signIn(email: String, password: String) async -> (String?, AppUser?) {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)

            return (nil, await getUserFromFileStore(userId: authDataResult.user.uid))
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
        }
    }
    
    func resetPassword(email: String) async -> String? {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            return error.localizedDescription
        }
        return nil
    }
    
    func updatePassword(password: String) async -> String? {
        guard let appUser = Auth.auth().currentUser else {
            return "Please login first before update password"
        }
        
        do {
            try await appUser.updatePassword(to: password)
        } catch let error as NSError  {
            return error.localizedDescription
        }
        return nil
    }
}

// MARK: Sign in Google
extension AuthenticationService {
    func signInWithGoogle() async -> (String?, AppUser?) {
        guard let topVC = await TopViewControllerUtil.shared.topViewController() else {
            return ("Can not find top view controller", nil)
        }
        
        do {
            // Get GG credential
            let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            
            guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
                return ("Can not get ID token from GID result", nil)
            }
            let accessToken: String = gidSignInResult.user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: accessToken)
            
            // Sign in new account with credential
            return await self.signInWithCredential(credential: credential)
        } catch let error as NSError  {
            return (error.localizedDescription, nil)
        }
    }
    
    func signInWithCredential(credential: AuthCredential) async -> (String?, AppUser?) {
        do {
            let authDataResult = try await Auth.auth().signIn(with: credential)
            
            if await !UserService.shared.isUserExist(userId: authDataResult.user.uid) {
                let appUser = AppUser(authDataResultUser: authDataResult.user)
                
                // create new user in db
                try await UserService.shared.createNewUser(user: appUser)
                
                // create cart for user
                try await CartService.shared.createEmptyCart(for: appUser.id)
            }
            
            return (nil, await getUserFromFileStore(userId: authDataResult.user.uid))
        } catch let error as NSError {
            return (error.localizedDescription, nil)
        }
    }
}

// MARK: Sign in Facebook
extension AuthenticationService {
    func signInWithFacebook() async throws -> (String?, AppUser?) {
        let loginManager = LoginManager()
        
        // Use Swift Concurrency's continuation to bridge the gap between asynchronous closure and async function.
        return try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                if let error = error {
                    continuation.resume(returning: (error.localizedDescription, nil))
                } else if let result = result, let token = result.token {
                    Task {
                        do {
                            let (errorMsg, appUser) = try await self.handleFacebookAccessToken(token: token)
                            continuation.resume(returning: (errorMsg, appUser))
                        } catch {
                            continuation.resume(returning: (error.localizedDescription, nil))
                        }
                    }
                } else {
                    continuation.resume(returning: ("Facebook login failed: can not get token or result", nil))
                }
            }
        }
    }

    func handleFacebookAccessToken(token: AccessToken) async throws -> (String?, AppUser?) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        // Assume signInWithCredential is an async function within your Firebase setup
        return await signInWithCredential(credential: credential)
    }
}
