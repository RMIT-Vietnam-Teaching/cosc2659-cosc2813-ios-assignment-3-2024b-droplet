//
//  CartDeliveryView.swift
//  pharmacist_project
//
//  Created by Dinh Le Hong Tin on 10/9/24.
//

import SwiftUI

struct CartDeliveryView: View {
    @State private var cartItems: [CartItem] = []
    @State private var totalMRP: Double = 0
    @State private var totalDiscount: Double = 0
    @State private var payableAmount: Double = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress indicators
                    HStack(spacing: 0) {
                        ProgressBar(steps: ["Delivery", "Address", "Payment", "Place Order"], currentStep: 0)
                    }
                    
                    // Delivery date
                    HStack {
                        Image(systemName: "truck")
                        // add 7 days
                        Text("Delivery by Fri, 24 Feb")
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    
                    // Cart items
                    ForEach(cartItems, id: \.id) { item in
                        CartItemCardView(cartItem: item)
                    }
                    
                    // Payment and Shipping methods
                    VStack(spacing: 10) {
                        HStack {
                            Text("Payment Method")
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                        HStack {
                            Text("Shipping Method")
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    // Order Summary
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Summary (1 item)")
                            .font(.headline)
                        
                        HStack {
                            Text("Total MRP")
                            Spacer()
                            Text("₹\(String(format: "%.2f", totalMRP))")
                        }
                        
                        HStack {
                            Text("Shipping Charges")
                            Spacer()
                            Text("Free")
                        }
                        
                        HStack {
                            Text("Total Discount")
                            Spacer()
                            Text("-₹\(String(format: "%.2f", totalDiscount))")
                        }
                        
                        HStack {
                            Text("Payable Amount")
                                .fontWeight(.bold)
                            Spacer()
                            Text("₹\(String(format: "%.2f", payableAmount))")
                                .fontWeight(.bold)
                        }
                        
//                        HStack {
//                            Text("You Earn")
//                            Image(systemName: "dollarsign.circle.fill")
//                                .foregroundColor(.yellow)
//                            Text("34 Hk Cash On This Order.")
//                            Spacer()
//                            Image(systemName: "info.circle")
//                        }
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(6)
                }
                .padding()
            }
            .navigationTitle("Cart (1 items)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                // Handle back action
            }) {
                Image(systemName: "chevron.left")
            })
            .background(Color.white)
        }
        .overlay(
            VStack {
                Spacer()
                NavigationLink(destination: CartAddressView()) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FF6F5C"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .padding()
            }
        )
        .onAppear {
            // Load cart items and calculate totals
            loadCartItems()
        }
    }
    
    private func loadCartItems() {
        let sampleItem = CartItem(
            id: "1",
            cartId: "cart1",
            medicineId: "med1",
            quantity: 2,
            pricePerUnit: 599,
            pricePerUnitDiscount: nil
        )
        cartItems = [sampleItem]
        
        // Calculate totals
        totalMRP = 1998
        totalDiscount = 800
        payableAmount = 1198
    }
}

#Preview {
    CartDeliveryView()
}
