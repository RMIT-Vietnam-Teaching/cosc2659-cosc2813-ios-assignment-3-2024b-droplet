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
    
    func placeOrder(userId: String,
                    fullName: String,
                    phoneNumber: String,
                    address: String,
                    note: String,
                    paymentMethod: PaymentMethod,
                    shippingMethod: ShippingMethod
    ) async throws -> Order? {
        var cartItems = try await CartItemService.shared.getUserCartItems(userId: userId)
        
        // enforce quantity rules
        var atLeastOneNotEnoughtQuantity = false
        var medicines = [Medicine]()
        for var cartItem in cartItems {
            let medicine = try await MedicineService.shared.getDocument(cartItem.medicineId)
            medicines.append(medicine)
            if cartItem.quantity! > medicine.availableQuantity! {
                cartItem.quantity = medicine.availableQuantity!
                try await CartItemService.shared.updateDocument(cartItem)
                
                atLeastOneNotEnoughtQuantity = true
            }
        }
        if atLeastOneNotEnoughtQuantity {
            throw BussinessError.notEnoughQuantity("Shortage of some medicine. System adjust cart now..")
        }
        
        // create order
        let priceInfo = try await self.getNotPaymentPriceInformation(cartItems: cartItems, shippingMethod: shippingMethod, medicines: medicines)
        var order = Order(
            userId: userId,
            fullName: fullName,
            phoneNumber: phoneNumber,
            address: address,
            note: note,
            status: .pending,
            payable: priceInfo.totalPayable,
            totalDiscount: priceInfo.totalDiscount,
            paymentMethod: paymentMethod,
            shippingMethod: shippingMethod,
            createdDate: Date()
        )
        var orderItems = mapcartItemsToOrderItems(cartItems: cartItems, medicines: medicines, orderId: order.id)
        try await self.createDocument(order)
        try await OrderItemService.shared.bulkCreate(documents: orderItems)
        
        // remove cart items
        try await bulkDelete(documentIds: cartItems.map {
            $0.cartId
        })
        
        return order
    }
    
    func mapcartItemsToOrderItems(cartItems: [CartItem], medicines: [Medicine], orderId: String) -> [OrderItem] {
        var res = [OrderItem]()
        for (idx, item) in cartItems.enumerated() {
            res.append(OrderItem(
                orderId: orderId,
                medicineId: item.medicineId,
                quantity: item.quantity,
                pricePerUnit: medicines[idx].price,
                pricePerUnitDiscount: medicines[idx].priceDiscount,
                createdDate: item.createdDate
            ))
        }
        return res
    }
    
    func getNotPaymentPriceInformation(cartItems: [CartItem], shippingMethod: ShippingMethod, medicines: [Medicine]? = nil) async throws -> OrderPriceInformation {
        var totalProductFee: Double = 0
        var totalDiscount: Double = 0
        var shippingFree: Double = 0
        var totalPayable: Double = 0
        
        // validate
        var _medicines = [Medicine]()
        if medicines == nil {
            for item in cartItems {
                _medicines.append(try await MedicineService.shared.getDocument(item.medicineId))
            }
        } else {
            if cartItems.count != medicines!.count {
                throw BussinessError.cartArrayAndMedicineArrayIsNotSizeEqual
            }
            for (idx, item) in cartItems.enumerated() {
                if item.medicineId != medicines![idx].id {
                    throw BussinessError.cartArrayAndMedicineArrayMismatched
                }
            }
            _medicines = medicines!
        }
        
        // calculate
        for (idx, item) in cartItems.enumerated() {
            totalProductFee += _medicines[idx].price!
            totalDiscount += _medicines[idx].price! - _medicines[idx].priceDiscount!
        }
        shippingFree = shippingMethod.fee
        totalPayable = totalProductFee + shippingFree - totalDiscount
        
        return OrderPriceInformation(totalProductFee: totalProductFee,
                                     totalDiscount: totalDiscount,
                                     shippingFree: shippingFree,
                                     totalPayable: totalPayable)
    }
    
    func getShippingFee(shippingMethod: ShippingMethod) -> Double {
        return shippingMethod.fee
    }
}

// Order history
extension OrderService {
    func getUserOrderHistory(userId: String) async throws -> [(Order, [OrderItem])] {
        var res = [(Order, [OrderItem])]()
        var orders = try await self.fetchDocuments(filter: {query in
            query.whereField("userId", isEqualTo: userId)
        })
        for order in orders {
            res.append((order, try await OrderItemService.shared.getOrderItemsOf(orderId: order.id)))
        }
        return res.sorted(by: {
            $0.0.createdDate! < $1.0.createdDate!
        })
    }
}
