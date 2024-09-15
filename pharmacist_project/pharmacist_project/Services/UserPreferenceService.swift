//
//  UserPreferenceService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 14/9/24.
//

import Foundation

final class UserPreferenceService: CRUDService<UserPreference> {
    static let shared = UserPreferenceService()
    
    override var collectionName: String {"userPreferences"}
    
    func getUserPreference(userId: String) async throws -> UserPreference {
        let preferences = try await self.fetchDocuments(filter: { query in
            query.whereField("userId", isEqualTo: userId)
        })
        
        if preferences.count == 0 {
            // create new
            let newPreference = UserPreference(userId: userId, receiveDailyHealthTip: true, receiveDeliveryStatus: true)
            try await self.createDocument(newPreference)
            return newPreference
        } else if preferences.count == 1 {
            return preferences[0]
        } else {
            fatalError("Invalid user preference count")
        }
    }
}
