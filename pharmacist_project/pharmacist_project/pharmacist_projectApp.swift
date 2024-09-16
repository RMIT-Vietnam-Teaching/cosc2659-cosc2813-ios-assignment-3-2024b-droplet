//
//  pharmacist_projectApp.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 4/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFunctions
import GoogleSignIn
import GoogleSignInSwift
import UIKit
import FBSDKCoreKit
import Stripe

@main
struct pharmacist_projectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Set up dark light mode
                    DarkLightModeService.shared.updateAppearanceMode(darkLightMode: DarkLightModeService.shared.getDarkLightModePreference())
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase is configured!")
        
        STPAPIClient.shared.publishableKey = "pk_test_51OOwHOADvj1zBNJ9a3T5i1b63iBtAIFT6bl01kSwklXlADIxTKHfruK8PRFia3iVdtfMW7yNUhyfGQs24hsqyIft00ksYsRucF"
        print("Stripe is configured")
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        print("FacebookSDK is configured!")
        
        Task {
            OpenAIService.shared.replaceHistory(try await OpenAIService.getPharmacistHistoryList())
            print("OpenAI is configured!")
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}
