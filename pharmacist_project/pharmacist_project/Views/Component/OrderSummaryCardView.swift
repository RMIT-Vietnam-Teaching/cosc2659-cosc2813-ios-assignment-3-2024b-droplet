//
//  OrderSummaryCardView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 6/9/24.
//

import SwiftUI

struct OrderSummaryCardView: View {
    var order: Order
    var orderItem: [OrderItem]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Order №\(order.id)")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(order.createdDate!.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Quantity:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text("\(orderItem.count)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text("Total Amount:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text("\(order.payable!.formatAsCurrency())")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            
            // Button and Status
            HStack {
                Button(action: {
                    // Handle button action
                }) {
                    Text("Details")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 100, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text(order.status!.rawValue.capitalized)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .frame(width: 370)
    }
}

#Preview {
    let mockOrder = Order(
        id: "123456",
        userId: "user123",
        fullName: "John Doe",
        phoneNumber: "123-456-7890",
        address: "123 Main St",
        note: "Deliver before 5 PM",
        status: .completed,
        payable: 120000,
        totalDiscount: 10.00,
        paymentMethod: .COD,
        shippingMethod: .ShopeeExpress,
        createdDate: Date()
    )
    
    let mockOrderItems = [
        OrderItem(
            id: "item123",
            orderId: "123456",
            medicineId: "med123",
            quantity: 2,
            pricePerUnit: 50000.0,
            pricePerUnitDiscount: 40.0,
            createdDate: Date()
        ),
        OrderItem(
            id: "item124",
            orderId: "123456",
            medicineId: "med124",
            quantity: 1,
            pricePerUnit: 70000.0,
            pricePerUnitDiscount: 30.0,
            createdDate: Date()
        )
    ]
    
    return OrderSummaryCardView(order: mockOrder, orderItem: mockOrderItems)
}
