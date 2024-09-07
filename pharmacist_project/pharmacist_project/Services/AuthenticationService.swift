//
//  AuthenticationService.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 5/9/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthProvider: String {
    case email = "password"
    case google = "google.com"
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
                // create new user in db
                try await UserService.shared.createNewUser(user: AppUser(authDataResultUser: authDataResult.user))
            }
            
            return (nil, await getUserFromFileStore(userId: authDataResult.user.uid))
        } catch let error as NSError {
            return (error.localizedDescription, nil)
        }
    }
}

// MARK: Sign in Apple
extension AuthenticationService {
    
}



// DO NOT DELETE
//            print(error.localizedDescription)
//            if let errCode = AuthErrorCode(rawValue: error._code) {
//                switch errCode {
//                case .emailAlreadyInUse:
//                    return ("Email already in use", nil)
//                case .invalidEmail:
//                    return ("Invalid email", nil)
//                case .weakPassword:
//                    return ("Weak password", nil)
//                case .operationNotAllowed:
//                    return ("Account is disabled", nil)
//                default:
//                    return ("Internal server error", nil)
//                }
//            }
//
//            return ("Internal server error", nil)




// DO NOT DELETE
//struct AuthenView: View {
//    @StateObject private var authVM = AuthenticationViewModel()
//    
//    var body: some View {
//        TextField("email...", text: $authVM.email)
//        
//        SecureField("password...", text: $authVM.password)
//        
//        Button {
//            authVM.register()
//        } label: {
//            Text("register")
//        }
//        
//        Button {
//            authVM.signIn()
//        } label: {
//            Text("sign in")
//        }
//        
//        Button {
//            authVM.signOut()
//        } label: {
//            Text("log out")
//        }
//        
//        Button {
//            authVM.resetPassword()
//        } label: {
//            Text("reset password")
//        }
//        
//        Button {
//            authVM.resetPassword()
//        } label: {
//            Text("update password")
//        }
//        
//        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
//            authVM.signInGoogle()
//        }
//        
//        Button {
//            authVM.printCurrentUser()
//        } label: {
//            Text("Print user info")
//        }
//    }
//}
