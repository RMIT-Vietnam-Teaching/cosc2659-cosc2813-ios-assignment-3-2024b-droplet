//
//  VerticalProductItemView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 6/9/24.
//

import SwiftUI

struct VerticalProductItemCardView: View {
    let medicine: Medicine
    @StateObject private var cartViewModel = CartDeliveryViewModel()
    
    var body: some View {
        NavigationLink(destination: MedicineDetailView(viewModel: MedicineDetailViewModel(medicine: medicine))) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: medicine.getRepresentImageStr())) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                                .cornerRadius(10)
                        } else if phase.error != nil {
                            Color.gray.frame(height: 150)
                        } else {
                            ProgressView().frame(height: 150)
                        }
                    }
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    Text(medicine.name ?? "")
                        .font(.headline)
                        .padding(.horizontal, 5)
                }
                .frame(maxHeight: 50)
                
                HStack {
                    Text((medicine.price ?? 0.0).formatAsCurrency())
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let priceDiscount = medicine.priceDiscount, priceDiscount > 0 {
                        Text(priceDiscount.formatAsCurrency())
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if let price = medicine.price, let priceDiscount = medicine.priceDiscount {
                        Text("\(price.calculateDiscountPercentage(priceDiscount: priceDiscount))% Off")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
                
                Text("In stock: \(medicine.availableQuantity ?? 0)")
                    .font(.subheadline)
                    .padding(.top, -5)
                
                AddToCartButtonView(medicine: medicine)

            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .frame(width: 300)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let exampleMedicine = Medicine(
        id: "1",
        name: "Dung dịch Dentanalgi điều trị đau răng, viêm nướu răng, nha chu (chai 7ml)",
        price: 19000,
        priceDiscount: 15000,
        availableQuantity: 50,
        description: "Thuốc trị đau răng Dentanalgi là một loại thuốc được sử dụng để giảm đau và làm giảm triệu chứng đau răng. Thuốc thường chứa các thành phần hoạt chất giúp giảm viêm và giảm đau, hỗ trợ điều trị các vấn đề về răng miệng như sâu răng hoặc viêm nướu. Sản phẩm có thể được bào chế dưới dạng viên nén, gel hoặc dung dịch tùy thuộc vào loại thuốc và cách sử dụng.",
        ingredients: "Hoạt chất: Camphor 420mg, Menthol 280mg, Procain hydroclorid 35mg, Tinh dầu Đinh hương (Oleum Caryophylli) 439mg, Sao đen (Cortex Hopea) 700mg, Tạo giác (Fructus Gleditsiae australis) 140mg, Thông bạch (Herba Allium fistulosum) 140mg.\nTá dược: (ethanol 96%, nước tinh khiết) vừa đủ 7ml.",
        supplement: "N/A",
        note: "Consult your doctor if pregnant",
        sideEffect: "Khi sử dụng thuốc Thuốc Trị Đau Răng Dentanalgi 7Ml Opc, bạn có thể gặp tác dụng không mong muốn (ADR).",
        dosage: "Tẩm thuốc vào bông đặt nơi đau, 3 - 4 lần/ngày. Nhỏ 1 ml thuốc (30 giọt) vào khoảng 60 ml nước chín, khuấy đều, ngậm và súc miệng 3 lần/ngày.",
        supplier: "Dược phẩm OPC",
        images: ["https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P15323_1_l.webp"],
        category: .vitamin,
        pharmacyId: "123"
    )
    
    return VerticalProductItemCardView(medicine: exampleMedicine)
}
