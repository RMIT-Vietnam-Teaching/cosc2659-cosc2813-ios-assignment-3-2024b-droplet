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
import UIKit
import FBSDKCoreKit

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
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        print("FacebookSDK is configured!")
        
        OpenAIService.shared.replaceHistory(OpenAIService.getPharmacistHistoryList())
        print("OpenAI is configured!")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}
