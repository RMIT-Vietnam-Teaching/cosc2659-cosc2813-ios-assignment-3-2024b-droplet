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

struct HorizontalProductItemCardView: View {
    let medicine: Medicine
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: MedicineDetailView(viewModel: MedicineDetailViewModel(medicine: medicine))) {
            HStack(spacing: 15) {
                AsyncImage(url: URL(string: medicine.images.first ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    } else if phase.error != nil {
                        Color.gray.frame(width: 100, height: 100)
                    } else {
                        ProgressView().frame(width: 100, height: 100)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    ScrollView(.vertical, showsIndicators: true) {
                        Text(medicine.name ?? "")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 5)
                    }
                    .frame(maxHeight: 50)
                    
                    HStack {
                        Text((medicine.price ?? 0.0).formatAsCurrency())
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        if let priceDiscount = medicine.priceDiscount, let price = medicine.price, priceDiscount > 0 {
                            Text(priceDiscount.formatAsCurrency())
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.gray)
                            
                            Text("\(price.calculateDiscountPercentage(priceDiscount: priceDiscount))% Off")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Stock Information
                    Text("In stock: \(medicine.availableQuantity ?? 0)")
                        .font(.subheadline)
                }
            }
            .padding(10)
            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
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
    
    return HorizontalProductItemCardView(medicine: exampleMedicine)
}
