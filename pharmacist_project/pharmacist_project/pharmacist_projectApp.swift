//
//  pharmacist_projectApp.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 4/9/24.
//

import SwiftUI
import FirebaseCore

@main
struct pharmacist_projectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase is configured!")

    return true
  }
}

struct AuthenView: View {
    @StateObject private var authVM = AuthenticationViewModel()
    
    var body: some View {
        TextField("email...", text: $authVM.email)
        
        SecureField("password...", text: $authVM.password)
        
        Button {
            authVM.register()
        } label: {
            Text("register")
        }
        
        Button {
            authVM.signIn()
        } label: {
            Text("sign in")
        }
        
        Button {
            authVM.signOut()
        } label: {
            Text("log out")
        }
    }
}
