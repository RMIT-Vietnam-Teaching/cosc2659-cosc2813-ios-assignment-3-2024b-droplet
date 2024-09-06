//
//  pharmacist_projectApp.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 4/9/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

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
