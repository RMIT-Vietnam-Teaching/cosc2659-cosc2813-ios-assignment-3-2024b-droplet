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

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var orderViewModel: OrderViewModel
    let order: Order
    let orderItems: [OrderItem]
    
    @State private var isShowingUpdateStatusAlert: Bool = false
    @State private var medicines: [String: Medicine] = [:]

    @Environment(\.dismiss) private var dismiss
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

                if let userType = orderViewModel.user?.type {
                    if userType == .admin {
                        adminStatusButton
                    } else if userType == .customer && order.status == .delivering {
                        customerCompleteButton
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var adminStatusButton: some View {
        let nextStatus: OrderStatus
        
        // Determine the next status based on the current order status
        switch order.status {
        case .pending:
            nextStatus = .accepted
        case .accepted:
            nextStatus = .delivering
        case .delivering:
            nextStatus = .completed // admin can mark order as completed
        case .completed:
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }
        
        return AnyView(
            Button(action: {
                isShowingUpdateStatusAlert = true
            }) {
                Text(statusButtonText(for: order.status))
                    .font(.headline)
                    .foregroundColor(.red)
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
                    Task {
                        await orderViewModel.updateOrderStatus(orderId: order.id, newStatus: nextStatus) // update order
                        dismiss()
                    }
                }
            }
        )
    }
    
    // Customer's button to complete the order if the status is delivering
    var customerCompleteButton: some View {
        Button(action: {
            isShowingUpdateStatusAlert = true
            
        }) {
            Text("Complete Order")
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
            Button("Complete", role: .none) {
                Task {
                    await orderViewModel.updateOrderStatus(orderId: order.id, newStatus: .completed)
                    dismiss()
                }
            }
        }
    }
    
    // Function to determine the text on the button based on the current status
    func statusButtonText(for status: OrderStatus?) -> String {
        switch status {
        case .pending:
            return "Accept Order"
        case .accepted:
            return "Mark as Delivering"
        case .delivering:
            return "Complete Order"
        default:
            return ""
        }
    }
    
    var orderHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tracking ID \(order.id)")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text(order.createdDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Spacer()
                Text(order.status?.rawValue.capitalized ?? "")
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
