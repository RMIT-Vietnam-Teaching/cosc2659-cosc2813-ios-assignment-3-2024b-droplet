/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Do Phan Nhat Anh
  ID: s3915034
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

struct CartItemCardView: View {
    @StateObject var cartItemVM: CartItemViewModel
    @Binding var cartItem: CartItem
    @EnvironmentObject var viewModel: CartDeliveryViewModel
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false

    init(cartItem: Binding<CartItem>) {
        self._cartItem = cartItem
        self._cartItemVM = StateObject(wrappedValue: CartItemViewModel(medicineId: cartItem.wrappedValue.medicineId))
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 16) {
                VStack {
                    AsyncImage(url: URL(string: cartItemVM.representImage)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .interpolation(.none)
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        } else if phase.error != nil {
                            Color.gray.frame(width: 100, height: 100)
                        } else {
                            ProgressView().frame(width: 100, height: 100)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            Task {
                                await viewModel.updateCartItemQuantity(cartItem, increase: false)
                            }
                        }) {
                            Image(systemName: "minus.square")
                                .font(.title2)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(cartItem.quantity ?? 0)")
                            .font(.headline)
                            .frame(width: 40, height: 20)
                        
                        Button(action: {
                            Task {
                                await viewModel.updateCartItemQuantity(cartItem, increase: true)
                            }
                        }) {
                            Image(systemName: "plus.square")
                                .font(.title2)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(cartItemVM.medicineName)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    
                    Spacer()

                    HStack {
                        Spacer()
                        Text("\(((cartItemVM.medicine?.price ?? 0) * Double(cartItem.quantity ?? 0)).formatAsCurrency())")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding(.top, 4)
                            .frame(alignment: .trailing)
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            if offset < -50 {
                                isSwiped = true
                                offset = -80
                            } else {
                                isSwiped = false
                                offset = 0
                            }
                        }
                    }
            )
            
            if isSwiped {
                Button(action: {
                    Task {
                        await viewModel.removeCartItem(cartItem)
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 80, height: 150)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .frame(height: 150)
        .onAppear {
            Task {
                await cartItemVM.loadMedicine()
            }
        }
    }
}

#Preview {
    @State var exampleCartItem = CartItem(
        id: PreviewsUtil.getPreviewCartItemId(),
        cartId: PreviewsUtil.getPreviewCartId(),
        medicineId: PreviewsUtil.getPreviewMedicineId(),
        quantity: 1,
        createdDate: Date()
    )
    
    return CartItemCardView(cartItem: $exampleCartItem)
        .environmentObject(CartDeliveryViewModel())
}
