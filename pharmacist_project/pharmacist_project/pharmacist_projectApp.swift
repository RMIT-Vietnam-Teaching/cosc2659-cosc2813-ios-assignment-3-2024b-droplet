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
