//
//  ProductDetailView.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import SwiftUI

struct MedicineDetailView: View {
    @ObservedObject var viewModel: MedicineDetailViewModel
    @StateObject private var cartViewModel = CartDeliveryViewModel()
    @State private var selectedImageIndex = 0
    @State private var showDescription = false
    @State private var showIngredients = false
    @State private var showSupplements = false
    @State private var showNote = false
    @State private var showSideEffects = false
    @State private var showDosage = false
    @State private var showSupplier = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Product Image Carousel
                    if !viewModel.medicine.images.isEmpty {
                        TabView(selection: $selectedImageIndex) {
                            ForEach(0..<viewModel.medicine.images.count, id: \.self) { index in
                                AsyncImage(url: URL(string: viewModel.medicine.images[index])) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 300)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .padding()
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.medicine.name ?? "Product Name Unavailable")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // Price and discount
                    HStack {
                        Text(viewModel.medicine.priceDiscount?.formatAsCurrency() ?? "Price Unavailable")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let price = viewModel.medicine.price {
                            Text(price.formatAsCurrency())
                                .strikethrough()
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            if let discountPercentage = viewModel.medicine.price?.calculateDiscountPercentage(priceDiscount: viewModel.medicine.priceDiscount ?? price) {
                                Text("\(discountPercentage)% OFF")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            } else {
                                Text("No discount available")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quantity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity: \(viewModel.medicine.availableQuantity != nil ? "\(viewModel.medicine.availableQuantity!)" : "Unavailable")")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    
                    AddToCartButtonView(medicine: viewModel.medicine)
                        .padding(.horizontal)
                    
                    // Seller Information
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Seller Information")
                            .font(.headline)
                        if let pharmacy = viewModel.pharmacy {
                            Text("Sold & Marked by: \(pharmacy.name ?? "Unknown Pharmacy")")
                            Text(pharmacy.address ?? "No address available")
                        } else {
                            Text("No seller information available")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    Divider()
                    
                    // Details Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Details")
                            .font(.headline)
                        
                        DisclosureBox(title: "Description", isExpanded: $showDescription) {
                            Text(viewModel.medicine.description ?? "No description available")
                        }
                        
                        DisclosureBox(title: "Ingredients", isExpanded: $showIngredients) {
                            Text(viewModel.medicine.ingredients ?? "No ingredients available")
                        }
                        
                        DisclosureBox(title: "Supplements", isExpanded: $showSupplements) {
                            Text(viewModel.medicine.supplement ?? "No supplement information available")
                        }
                        
                        DisclosureBox(title: "Note", isExpanded: $showNote) {
                            Text(viewModel.medicine.note ?? "No note available")
                        }
                        
                        DisclosureBox(title: "Side Effects", isExpanded: $showSideEffects) {
                            Text(viewModel.medicine.sideEffect ?? "No side effects available")
                        }
                        
                        DisclosureBox(title: "Dosage", isExpanded: $showDosage) {
                            Text(viewModel.medicine.dosage ?? "No dosage information available")
                        }
                        
                        DisclosureBox(title: "Supplier", isExpanded: $showSupplier) {
                            Text(viewModel.medicine.supplier ?? "No supplier information available")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
                
                Divider()
                
                if !viewModel.similarProducts.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Similar Products")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.similarProducts) { similarMedicine in
                                    VerticalProductItemCardView(medicine: similarMedicine)
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .navigationTitle("Product details")
        .onAppear {
            viewModel.fetchPharmacyDetails()
        }
    }
}

import SwiftUI

struct DisclosureBox<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(DarkLightModeService.shared.isDarkMode() ? .white : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(DarkLightModeService.shared.isDarkMode() ? .white : .gray)
                }
                .padding()
                .background(DarkLightModeService.shared.isDarkMode() ? Color.gray.opacity(0.2) : Color.white)
                .cornerRadius(10)
                .shadow(color: DarkLightModeService.shared.isDarkMode() ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    content()
                        .padding(.top, 5)
                }
                .padding()
                .background(DarkLightModeService.shared.isDarkMode() ? Color.gray.opacity(0.2) : Color.white)
                .cornerRadius(10)
                .shadow(color: DarkLightModeService.shared.isDarkMode() ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                .transition(.slide)
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    let mockMedicine = Medicine(
        id: "1",
        name: "Life Omega-3 Fish Oil 1000mg, 30 Capsules",
        price: 180000,
        priceDiscount: 160000,
        availableQuantity: 999,
        description: "The Apollo Omega 3 Fish Oil...",
        ingredients: "Fish oil, Food-grade gelatin shell.",
        supplement: "Omega-3 Fatty Acids: EPA and DHA",
        note: "Supports multiple vital organs",
        sideEffect: "Fishy aftertaste, upset stomach",
        dosage: "1-2 capsules daily with lukewarm water",
        supplier: "Apollo Healthco Limited",
        images: [
            "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_174942__front__omega-3_fish_oil_4__1.jpg",
            "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_175003__back__omega-3_fish_oil_4_.jpg"
        ],
        category: .vitamin,
        pharmacyId: "1",
        createdDate: Date()
    )
    
    let mockPharmacy = Pharmacy(
        id: "1",
        name: "Pharmacity Pharmacy JSC",
        address: "248A No Trang Long, Ward 12, Binh Thanh District, HCMC",
        description: "At Pharmacity, customers can find pharmaceuticals...",
        createdDate: Date()
    )
    
    let viewModel = MedicineDetailViewModel(medicine: mockMedicine)
    viewModel.medicine = mockMedicine
    viewModel.pharmacy = mockPharmacy
    
    return MedicineDetailView(viewModel: viewModel)
}
