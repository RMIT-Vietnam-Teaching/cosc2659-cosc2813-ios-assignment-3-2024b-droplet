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
    ) async throws -> Order {
        var cartItems = try await CartItemService.shared.getUserCartItems(userId: userId)
        
        // filter zero quantity items
        cartItems = cartItems.filter { $0.quantity ?? 0 > 0 }
        
        // enforce quantity rules
        var atLeastOneNotEnoughtQuantity = false
        var medicines = [Medicine]()
        var cartItemsToUpdate = [CartItem]()
        for var cartItem in cartItems {
            let medicine = try await MedicineService.shared.getDocument(cartItem.medicineId)
            medicines.append(medicine)
            if cartItem.quantity! > medicine.availableQuantity! {
                cartItem.quantity = medicine.availableQuantity!
                cartItemsToUpdate.append(cartItem)
                
                atLeastOneNotEnoughtQuantity = true
            }
        }
        if atLeastOneNotEnoughtQuantity {
            try await CartItemService.shared.bulkUpdate(documents: cartItemsToUpdate)
            throw BussinessError.notEnoughQuantity("Shortage of some medicine. System adjust cart now..")
        }
        
        // create order
        let priceInfo = try await self.getNotPaymentPriceInformation(cartItems: cartItems, shippingMethod: shippingMethod, medicines: medicines)
        let order = Order(
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
        let orderItems = mapcartItemsToOrderItems(cartItems: cartItems, medicines: medicines, orderId: order.id)
        try await self.createDocument(order)
        try await OrderItemService.shared.bulkCreate(documents: orderItems)
        
        // remove cart items
        try await CartItemService.shared.bulkDelete(documentIds: cartItems.map { $0.id })
        
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
    
    func getCurrentShoppingCartPriceInformation(cartItems: [CartItem], shippingMethod: ShippingMethod) async throws -> OrderPriceInformation {
        var medicines = [Medicine]()
        for cartItem in cartItems {
            let medicine = try await MedicineService.shared.getDocument(cartItem.medicineId)
            medicines.append(medicine)
        }
        return try await getNotPaymentPriceInformation(cartItems: cartItems, shippingMethod: shippingMethod, medicines: medicines)
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
            totalProductFee += _medicines[idx].price!*Double(item.quantity!)
            totalDiscount += (_medicines[idx].price! - _medicines[idx].priceDiscount!)*Double(item.quantity!)
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
        let orders = try await self.fetchDocuments(filter: {query in
            query.whereField("userId", isEqualTo: userId)
        })
        for order in orders {
            res.append((order, try await OrderItemService.shared.getOrderItemsOf(orderId: order.id)))
        }
        return res.sorted(by: {
            $0.0.createdDate! < $1.0.createdDate!
        })
    }
    
    func getOrdersFromAllUsers() async throws -> [(Order, [OrderItem])] {
        var res = [(Order, [OrderItem])]()
        let users: [AppUser] = try await UserService.shared.getAllDocuments()
        
        for user in users {
            let userOrders = try await self.getUserOrderHistory(userId: user.id)
            res.append(contentsOf: userOrders)
        }

        return res.sorted(by: {
            $0.0.createdDate! < $1.0.createdDate!
        })
    }
}
