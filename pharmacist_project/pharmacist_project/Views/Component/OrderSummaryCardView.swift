//
//  OrderSummaryCardView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 6/9/24.
//

import SwiftUI

struct OrderSummaryCardView: View {
    var orderNumber: String
    var date: String
    var quantity: Int
    var totalAmount: Double
    var status: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Order №\(orderNumber)")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Quantity:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text("\(quantity)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text("Total Amount:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text("\(totalAmount.formatAsCurrency())")
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
                
                Text(status)
                    .font(.system(size: 14, weight: .semibold))
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

// Preview
#Preview {
    OrderSummaryCardView(
        orderNumber: "12345",
        date: "01-01-2024",
        quantity: 3,
        totalAmount: 112,
        status: "Delivered"
    )
}
