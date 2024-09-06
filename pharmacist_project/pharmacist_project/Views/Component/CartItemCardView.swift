/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Do Phan Nhat Anh
 ID: s3915034
 Created date: 06/09/2024
 Last modified: 06/09/2024
 Acknowledgement:
 */


import SwiftUI

struct CartItemCardView: View {
    let cartItem: CartItem
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 16) {
                VStack {
                    Image(cartItem.image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                    
                    HStack(spacing: 10) {
                        Button(action: {}) {
                            Image(systemName: "minus.square")
                                .font(.title2)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(cartItem.quantity)")
                            .font(.headline)
                            .frame(width: 40, height: 20)
                        
                        Button(action: {}) {
                            Image(systemName: "plus.square")
                                .font(.title2)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(cartItem.name)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    
                    Spacer()

                    HStack {
                        Spacer()
                        Text("\(Int(cartItem.price)) ₫")
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
            .frame(width: 328, height: 167)
            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    let exampleCartItem = CartItem(
        id: "1",
        name: "Blackmores Omega Double High Strength Fish Oil bổ sung dầu cá",
        image: "FishOil",
        quantity: 1,
        price: 551650
    )
    
    return CartItemCardView(cartItem: exampleCartItem)
}
