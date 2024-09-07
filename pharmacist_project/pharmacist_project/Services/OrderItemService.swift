//
//  OrderItemService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

final class OrderItemService: CRUDService<OrderItem> {
    static let shared = OrderItemService()
    
    override var collectionName: String {"orderItems"}
}
