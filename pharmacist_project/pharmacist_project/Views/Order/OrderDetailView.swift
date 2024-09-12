//
//  OrderDetailView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 11/9/24.
//

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var orderViewModel: OrderViewModel
    let order: Order
    let orderItems: [OrderItem]
    
    @State private var isShowingUpdateStatusAlert: Bool = false
    @State private var medicines: [String: Medicine] = [:]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
 
                orderHeaderView
                
                ForEach(orderItems, id: \.id) { item in
                    if let medicine = medicines[item.medicineId] {
                        OrderItemCardView(orderItem: item, medicine: medicine)
                    } else {
                        ProgressView()
                            .frame(height: 100)
                            .task {
                                if let fetchedMedicine = await orderViewModel.getMedicineDetails(orderItem: item) {
                                    medicines[item.medicineId] = fetchedMedicine
                                }
                            }
                    }
                }
                
                OrderInfoView(order: order)
                
                Button(action: {
                    isShowingUpdateStatusAlert = true
                }) {
                    Text("Update status")
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .alert("Confirm action", isPresented: $isShowingUpdateStatusAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Update", role: .none) {
                        // update status
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var orderHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order №\(order.id)")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text(order.createdDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Spacer()
                Text(order.status!.rawValue.capitalized)
                    .font(.footnote)
                    .foregroundColor(Color.statusColor(for: order.status!))
            }
            
            Text("\(orderItems.count) items")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}
