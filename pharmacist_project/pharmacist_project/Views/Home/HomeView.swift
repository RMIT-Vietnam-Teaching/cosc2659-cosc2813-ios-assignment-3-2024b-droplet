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
                }
                // If search text is not empty, show search results
                else if !viewModel.searchText.isEmpty {
                    VStack {
                        ForEach(viewModel.filteredMedicines) { medicine in
                            HorizontalProductItemCardView(medicine: medicine)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
                // Default layout when no "View All" and search is inactive
                else {
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
                    
                    // Display relevant sections based on selected filter/category
                    if let filter = viewModel.selectedHomeFilter {
                        if filter == .flashSale {
                            FlashSaleSection(viewModel: viewModel)
                        } else if filter == .newReleases {
                            NewReleasesSection(viewModel: viewModel)
                        }
                    } else if let category = viewModel.selectedCategory {
                        CategorySection(viewModel: viewModel, category: category)
                    } else {
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
                    
                    Button("View All") {
                        viewModel.handleViewAll(for: .flashSale)
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
                    
                    Button("View All") {
                        viewModel.handleViewAll(for: .newReleases)
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
                    
                    Button("View All") {
                        viewModel.handleViewAll(for: category)
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
