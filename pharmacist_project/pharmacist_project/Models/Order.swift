//
//  Order.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 7/9/24.
//

import Foundation

enum OrderStatus: String, Codable, CaseIterable {
    case pending
    case accepted
    case delivering
    case completed
}

enum PaymentMethod: String, Codable, CaseIterable {
    case COD
    case visa
    
    var toString: String {
        switch self {
        case .COD:
            return "Cash on delivery"
        case .visa:
            return "Visa card"
        }
    }
}

enum ShippingMethod: String, Codable, CaseIterable {
    case ShopeeExpress
    case NinjaVan
    
    var toString: String {
        switch self {
        case .ShopeeExpress:
            return "Shopee Express"
        case .NinjaVan:
            return "Ninja Van"
        }
    }
    
    var fee: Double {
        switch self {
        case .ShopeeExpress:
            return 30000.0
        case .NinjaVan:
            return 50000.0
        }
    }
}

struct Order: FirebaseModel {
    let id: String
    let userId: String
    var fullName: String?
    var phoneNumber: String?
    var address: String?
    var note: String?
    var status: OrderStatus?
    var payable: Double?
    var totalDiscount: Double?
    var paymentMethod: PaymentMethod?
    var shippingMethod: ShippingMethod?
    let createdDate: Date?
    
    init(
        id: String,
        userId: String,
        fullName: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        note: String? = nil,
        status: OrderStatus? = nil,
        payable: Double? = nil,
        totalDiscount: Double? = nil,
        paymentMethod: PaymentMethod? = nil,
        shippingMethod: ShippingMethod? = nil,
        createdDate: Date?
    ) {
        self.id = id
        self.userId = userId
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.address = address
        self.note = note
        self.status = status
        self.payable = payable
        self.totalDiscount = totalDiscount
        self.paymentMethod = paymentMethod
        self.shippingMethod = shippingMethod
        self.createdDate = createdDate
    }
    
    init(
        userId: String,
        fullName: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        note: String? = nil,
        status: OrderStatus? = nil,
        payable: Double? = nil,
        totalDiscount: Double? = nil,
        paymentMethod: PaymentMethod? = nil,
        shippingMethod: ShippingMethod? = nil,
        createdDate: Date?
    ) {
        self.id = CRUDService<Order>.generateUniqueId(collection: OrderService.shared.collection)
        self.userId = userId
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.address = address
        self.note = note
        self.status = status
        self.payable = payable
        self.totalDiscount = totalDiscount
        self.paymentMethod = paymentMethod
        self.shippingMethod = shippingMethod
        self.createdDate = createdDate
    }
}
