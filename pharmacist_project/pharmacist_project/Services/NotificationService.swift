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
import UserNotifications
import SwiftUI

struct DailyNotificationRequest {
    var time: DateComponents
    var title: String
    var body: String
    var sound: UNNotificationSound
}

class NotificationService {
    
    static let shared = NotificationService()
    
    @discardableResult
    func requestPermissionForTheFirstTime() async -> Bool {
        let settings = await getNotificationSettings()
        if settings.authorizationStatus == .notDetermined {
            return await requestNotificationPermission()
        }
        return true
    }
    
    // Request permission if denied using async/await
    @discardableResult
    func requestPermissionIfDenied() async -> Bool {
        let settings = await getNotificationSettings()
        if settings.authorizationStatus == .denied {
            return await requestNotificationPermission()
        }
        return true
    }
    
    func isNotificationPermissionDenied() async -> Bool {
        let settings = await getNotificationSettings()
        return settings.authorizationStatus == .denied
    }
    
    // Request notification permission using async/await
    @discardableResult
    private func requestNotificationPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permission granted.")
                    continuation.resume(returning: true)
                } else {
                    print("Notification permission denied.")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    private func getNotificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
    }
    
    // Schedule daily notifications at specified times
    func scheduleDailyNotifications(dailyNotificationRequests: [DailyNotificationRequest]) {
        // Cancel all previous notifications to avoid duplicates
        cancelAllNotifications()
        
        for notificationRequest in dailyNotificationRequests {
            let content = UNMutableNotificationContent()
            content.title = notificationRequest.title
            content.body = notificationRequest.body
            content.sound = notificationRequest.sound
            
            // Set up trigger to fire notification at specific time every day
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationRequest.time, repeats: true)
            
            // Create a unique identifier for each notification
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled at \(notificationRequest.time). Body: \(notificationRequest.body)")
                }
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications have been canceled.")
    }
    
    static func getStaticDailyNotificationRequests() async throws -> [DailyNotificationRequest] {
        let morningText = try await OpenAIService.shared.sendMessage(text: "write me a health quote about 20 words to help me have a good day start")
        let nightText = try await OpenAIService.shared.sendMessage(text: "write me a health quote about 20 words to help me have a cozy night")
        return [
            DailyNotificationRequest(time: DateComponents(hour: 7), title: "Good morning 🔥", body: morningText, sound: .default),
            DailyNotificationRequest(time: DateComponents(hour: 21), title: "Have a cozy night 🍎", body: nightText, sound: .default),
        ]
    }
}
