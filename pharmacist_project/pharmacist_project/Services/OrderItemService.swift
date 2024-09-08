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
    
    func getOrderItemsOf(orderId: String) async throws -> [OrderItem] {
        return try await self.fetchDocuments(filter: { query in
            query.whereField("orderId", isEqualTo: orderId)
        }).sorted(by: {
            $0.createdDate! > $1.createdDate!
        })
    }
}
