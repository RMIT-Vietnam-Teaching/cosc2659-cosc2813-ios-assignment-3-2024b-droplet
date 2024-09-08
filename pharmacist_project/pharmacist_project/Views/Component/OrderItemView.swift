//
//  OrderItemView.swift
//  pharmacy
//
//  Created by Dinh Le Hong Tin on 7/9/24.
//

import SwiftUI

struct OrderItemView: View {
    let imageName: String
    let productName: String
    let description: String
    let unitCount: String
    let currentPrice: Double
    let originalPrice: Double
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(productName)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    HStack {
                        Text("Unit:")
                            .font(.subheadline)
                        .foregroundColor(.secondary)
                        Text(unitCount)
                            .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("$\(String(format: "%.0f", currentPrice))")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("$\(String(format: "%.0f", originalPrice))")
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    OrderItemView(
        imageName: "Healthkart_FishOil",
                    productName: "Healthkart HK Vitals Super Strength Fish Oil Purity 84%",
                    description: "60 Softgels",
                    unitCount: "1",
                    currentPrice: 599,
                    originalPrice: 999
    ).previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.1))
}
