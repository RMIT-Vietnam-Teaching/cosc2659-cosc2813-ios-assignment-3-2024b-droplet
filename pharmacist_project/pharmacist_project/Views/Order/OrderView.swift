//
//  OrderView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 5/9/24.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var orderViewModel: OrderViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                statusPickerView
                
                ScrollView {
                    if orderViewModel.isLoading {
                        ProgressView("Loading Orders...")
                    } else if let errorMessage = orderViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        filteredOrdersView
                    }
                }
            }
            .navigationTitle("My Orders")
            .onAppear {
                Task {
                    // delete when have real data
                    //await orderViewModel.loadOrderHistory()
                }
            }
        }
    }
    
    var statusPickerView: some View {
        Picker("Order Status", selection: $orderViewModel.selectedStatus) {
            ForEach(OrderStatus.allCases, id: \.self) { status in
                Text(status.rawValue.capitalized)
                    .tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    var filteredOrdersView: some View {
        VStack(spacing: 16) {
            ForEach(orderViewModel.filteredOrders, id: \.0.id) { order, orderItems in
                OrderSummaryCardView(orderViewModel: orderViewModel, order: order, orderItem: orderItems)
            }
        }
        .padding()
    }
}

#Preview {
    let mockOrder1 = Order(
        id: "1947034",
        userId: "user123",
        fullName: "John Doe",
        phoneNumber: "123-456-7890",
        address: "123 Main St, City",
        note: nil,
        status: .delivering,
        payable: 11200.00,
        totalDiscount: 0.0,
        paymentMethod: .visa,
        shippingMethod: .ShopeeExpress,
        createdDate: Date()
    )
    
    let mockOrder2 = Order(
        id: "1947035",
        userId: "user456",
        fullName: "Jane Doe",
        phoneNumber: "987-654-3210",
        address: "456 Main St, City",
        note: nil,
        status: .pending,
        payable: 15000.00,
        totalDiscount: 10.0,
        paymentMethod: .COD,
        shippingMethod: .NinjaVan,
        createdDate: Date()
    )
    
    let mockOrderItems1 = [
        OrderItem(id: "item1", orderId: "1947034", medicineId: "1", quantity: 3, pricePerUnit: 40.00, pricePerUnitDiscount: 35.00, createdDate: Date())
    ]
    
    let mockOrderItems2 = [
        OrderItem(id: "item2", orderId: "1947035", medicineId: "1", quantity: 2, pricePerUnit: 75.00, pricePerUnitDiscount: 65.00, createdDate: Date())
    ]
    
    let mockViewModel = OrderViewModel(orders: [
        (mockOrder1, mockOrderItems1),
        (mockOrder2, mockOrderItems2)
    ])
    
    return OrderView(orderViewModel: mockViewModel)
        .previewLayout(.sizeThatFits)
}

