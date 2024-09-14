//
//  NotificationService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 15/9/24.
//

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
                    print("Notification scheduled at \(notificationRequest.time).")
                }
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications have been canceled.")
    }
    
    static func getStaticDailyNotificationRequests() async throws -> [DailyNotificationRequest] {
        let morningText = try await OpenAIService.shared.sendMessage(text: "write me a short text to help me have a good day start")
        let nightText = try await OpenAIService.shared.sendMessage(text: "write me a short text to help me have a good cozy night")
        return [
            DailyNotificationRequest(time: DateComponents(hour: 7), title: "Good morning", body: morningText, sound: .default),
            DailyNotificationRequest(time: DateComponents(hour: 21), title: "Have a cozy night", body: nightText, sound: .default),
        ]
    }
}
