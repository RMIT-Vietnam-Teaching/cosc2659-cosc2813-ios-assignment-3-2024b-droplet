//
//  UserPreference.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 14/9/24.
//

import Foundation

struct UserPreference: FirebaseModel {
    let id: String
    let userId: String
    var receiveDailyHealthTip: Bool
    var receiveDeliveryStatus: Bool
    
    init(id: String, userId: String, receiveDailyHealthTip: Bool, receiveDeliveryStatus: Bool) {
        self.id = id
        self.userId = userId
        self.receiveDailyHealthTip = receiveDailyHealthTip
        self.receiveDeliveryStatus = receiveDeliveryStatus
    }
    
    init(userId: String, receiveDailyHealthTip: Bool, receiveDeliveryStatus: Bool) {
        self.id = CRUDService<UserPreference>.generateUniqueId(collection: UserPreferenceService.shared.collection)
        self.userId = userId
        self.receiveDailyHealthTip = receiveDailyHealthTip
        self.receiveDeliveryStatus = receiveDeliveryStatus
    }
}
