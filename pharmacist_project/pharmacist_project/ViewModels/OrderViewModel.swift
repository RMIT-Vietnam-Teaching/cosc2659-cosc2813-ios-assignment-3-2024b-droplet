/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Long Hoang Pham
  ID: s3938007
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

@MainActor
class OrderViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var orders: [(Order, [OrderItem])] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStatus: OrderStatus = .pending

    var orderService: OrderService = OrderService.shared
    
    init() {
        loadAuthenticatedUser()
    }
    
    // for mock data
    init(orders: [(Order, [OrderItem])] = []) {
        loadAuthenticatedUser()
        self.orders = orders
    }
    
    func loadAuthenticatedUser() {
        isLoading = true
        errorMessage = nil
        
        Task {
            if let offlineUser = AuthenticationService.shared.getAuthenticatedUserOffline() {
                self.user = offlineUser
                print("Loaded offline user: \(offlineUser)")
            }
            
            if let onlineUser = await AuthenticationService.shared.getAuthenticatedUser() {
                self.user = onlineUser
                print("Loaded online user: \(onlineUser)")
                self.isLoading = false
                
                await loadOrderHistory()
            } else {
                self.errorMessage = "Please login"
                print("Please login")
                self.isLoading = false
            }
        }
    }
    
    // Load the user's order history
    func loadOrderHistory() async {
        guard let user = user else {
            self.errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            if user.type == .admin {
                let allOrders = try await orderService.getOrdersFromAllUsers()
                self.orders = allOrders
                print("Loaded all orders: \(allOrders.count) orders")
            } else {
                let orderHistory = try await orderService.getUserOrderHistory(userId: user.id)
                self.orders = orderHistory
                print("Loaded order history: \(orderHistory.count) orders")
            }
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load order history: \(error.localizedDescription)"
            print("Failed to load order history: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
    
    // Update the status of an order
    func updateOrderStatus(orderId: String, newStatus: OrderStatus) async {
        guard let orderIndex = orders.firstIndex(where: { $0.0.id == orderId }) else {
            self.errorMessage = "Order not found"
            return
        }
        
        var orderToUpdate = orders[orderIndex].0
        orderToUpdate.status = newStatus
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await orderService.updateDocument(orderToUpdate)
            self.orders[orderIndex].0 = orderToUpdate
            print("Updated order status to: \(newStatus.rawValue)")
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to update order status: \(error.localizedDescription)"
            print("Failed to update order status: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
    
    func getMedicineDetails(orderItem: OrderItem) async -> Medicine? {
        do {
            let medicine = try await MedicineService.shared.getDocument(orderItem.medicineId)
            
            return medicine
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var filteredOrders: [(Order, [OrderItem])] {
        orders.filter { order, _ in
            order.status == selectedStatus
        }
    }
}
