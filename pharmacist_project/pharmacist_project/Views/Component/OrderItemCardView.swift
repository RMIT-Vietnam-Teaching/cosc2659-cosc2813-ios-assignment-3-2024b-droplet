//
//  OrderItemView.swift
//  pharmacy
//
//  Created by Dinh Le Hong Tin on 7/9/24.
//

import SwiftUI

struct OrderItemCardView: View {
    let images: [String]
    let productName: String
    let description: String
    let unitCount: String
    let currentPrice: Double
    let originalPrice: Double
    
    var body: some View {
        Button(action: {
            // go to product details
            print("product details")
        }) {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: images[0])) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else if phase.error != nil {
                        Color.gray.frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else {
                        ProgressView().frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(productName)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
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
                            Text("\(currentPrice.formatAsCurrency())")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("\(originalPrice.formatAsCurrency())")
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(height: 100)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OrderItemCardView(
        images: ["https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P15323_1_l.webp"],
        productName: "Healthkart HK Vitals Super Strength Fish Oil Purity 84%",
        description: "Thuốc trị đau răng Dentanalgi là một loại thuốc được sử dụng để giảm đau và làm giảm triệu chứng đau răng. Thuốc thường chứa các thành phần hoạt chất giúp giảm viêm và giảm đau, hỗ trợ điều trị các vấn đề về răng miệng như sâu răng hoặc viêm nướu.",
        unitCount: "1",
        currentPrice: 599000,
        originalPrice: 999000
    )
}
