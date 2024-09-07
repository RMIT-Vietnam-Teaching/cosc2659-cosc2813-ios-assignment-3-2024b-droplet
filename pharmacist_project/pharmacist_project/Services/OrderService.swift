//
//  OrderService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class OrderService: CRUDService<Order> {
    static let shared = OrderService()
    
    override var collectionName: String {"orders"}
}
