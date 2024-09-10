//
//  homeView.swift
//  pharmacist_project
//
//  Created by Leon Do on 5/9/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Search Bar, Cart Section
                    VStack(spacing: 10) {
                        ZStack {
                            Color(hex: "2EB5FA")
                                .ignoresSafeArea(.all, edges: .top)
                                .frame(height: 80)
                            VStack {
                                HStack {
                                    TextField("Search for products", text: $viewModel.searchText)
                                        .padding(.leading, 20)
                                        .frame(height: 40)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .onChange(of: viewModel.searchText) {
                                            viewModel.filterMedicines()
                                        }
                                    Button(action: {
                                        // Navigate to cartView
                                    }) {
                                        Image(systemName: "cart")
                                            .foregroundColor(.white)
                                            .font(.system(size: 22))
                                    }
                                    .padding()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    if viewModel.isViewAllActive {
                        VStack {
                            ForEach(viewModel.filteredMedicines) { medicine in
                                HorizontalProductItemCardView(medicine: medicine)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                            }
                        }
                    } else if !viewModel.searchText.isEmpty {
                        VStack {
                            ForEach(viewModel.filteredMedicines) { medicine in
                                HorizontalProductItemCardView(medicine: medicine)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // MARK: - Category Section
                        CategorySectionView(
                            selectedCategory: $viewModel.selectedCategory,
                            selectedHomeFilter: $viewModel.selectedHomeFilter,
                            onCategorySelected: { category, filter in
                                viewModel.selectedCategory = category
                                viewModel.selectedHomeFilter = filter
                                viewModel.filterMedicines()
                            },
                            availableCategories: viewModel.availableCategories
                        )
                        
                        FlashSaleSection(viewModel: viewModel)
                        NewReleasesSection(viewModel: viewModel)
                        
                        ForEach(viewModel.availableCategories, id: \.self) { category in
                            if let categoryEnum = Category(rawValue: category.lowercased()) {
                                CategorySection(viewModel: viewModel, category: categoryEnum)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - New Releases Section
struct NewReleasesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        if !viewModel.filteredMedicines.isEmpty && viewModel.filteredMedicines.contains(where: { Calendar.current.isDateInLast30Days($0.createdDate ?? Date()) }) {
            VStack(alignment: .leading) {
                HStack {
                    Text("New Releases")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: ViewAllView(viewModel: viewModel, filterType: .newReleases, title: "New Releases")) {
                        Text("View All")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.filteredMedicines.filter {
                            Calendar.current.isDateInLast30Days($0.createdDate ?? Date())
                        }) { medicine in
                            VerticalProductItemCardView(medicine: medicine)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Flash Sales Section
struct FlashSaleSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        if !viewModel.filteredMedicines.isEmpty && viewModel.filteredMedicines.contains(where: { $0.priceDiscount != nil }) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Flash Sales ⚡")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: ViewAllView(viewModel: viewModel, filterType: .flashSale, title: "Flash Sales")) {
                        Text("View All")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.filteredMedicines.filter { $0.priceDiscount != nil }) { medicine in
                            VerticalProductItemCardView(medicine: medicine)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}


// MARK: - Category Section
struct CategorySection: View {
    @ObservedObject var viewModel: HomeViewModel
    var category: Category
    
    var body: some View {
        if !viewModel.filteredMedicines.isEmpty {
            VStack(alignment: .leading) {
                HStack {
                    Text(category.rawValue.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: ViewAllView(viewModel: viewModel, filterType: nil, selectedCategory: category, title: category.rawValue.capitalized)) {
                        Text("View All")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.filteredMedicines.filter { $0.category == category }) { medicine in
                            VerticalProductItemCardView(medicine: medicine)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
