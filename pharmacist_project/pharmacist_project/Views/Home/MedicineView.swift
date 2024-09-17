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

struct MedicineView: View {
    @ObservedObject var viewModel = MedicineViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        ZStack {
                            Color(hex: "2EB5FA")
                                .opacity(DarkLightModeService.shared.isDarkMode() ? 0.2 : 1.0)
                                .ignoresSafeArea(.all, edges: .top) 
                                .frame(height: 80)
                            
                            VStack {
                                HStack {
                                    TextField("Search for products", text: $viewModel.searchText)
                                        .padding(.leading, 20)
                                        .frame(height: 40)
                                        .background(Color(UIColor.systemBackground))
                                        .cornerRadius(8)
                                        .onChange(of: viewModel.searchText) {
                                            viewModel.filterMedicines()
                                        }
                                    
                                    NavigationLink(destination: CartDeliveryView()) {
                                        HStack {
                                            Image(systemName: "cart")
                                                .foregroundColor(.white)
                                                .font(.system(size: 22))
                                        }
                                    }
                                    .navigationBarTitleDisplayMode(.inline)
                                    .padding()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    if viewModel.isSearching {
                        VStack(spacing: 15) {
                            ForEach(viewModel.filteredMedicines) { medicine in
                                HorizontalProductItemCardView(medicine: medicine)
                                    .padding(.horizontal)
                            }
                        }
                    } else {
                        CategorySectionView(
                            selectedCategory: $viewModel.selectedCategory,
                            selectedHomeFilter: $viewModel.selectedHomeFilter,
                            onCategorySelected: { category, filter in
                                if let category = category {
                                    viewModel.handleViewAll(for: category)
                                } else if let filter = filter {
                                    viewModel.handleViewAll(for: filter)
                                } else {
                                    viewModel.clearFilters()
                                }
                            },
                            availableCategories: viewModel.availableCategories
                        )
                        
                        if viewModel.isViewAllActive {
                            FlashSaleSection(viewModel: viewModel)
                            NewReleasesSection(viewModel: viewModel)
                            
                            ForEach(viewModel.availableCategories, id: \.self) { category in
                                if let categoryEnum = Category(rawValue: category.lowercased()) {
                                    CategorySection(viewModel: viewModel, category: categoryEnum)
                                }
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 20) {
                                if let selectedFilter = viewModel.selectedHomeFilter {
                                    headerWithViewAll(title: selectedFilter == .flashSale ? "Flash Sales ⚡" : "New Releases", viewModel: viewModel)
                                }
                                
                                if let selectedCategory = viewModel.selectedCategory {
                                    headerWithViewAll(title: selectedCategory.rawValue.capitalized, viewModel: viewModel)
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredMedicines) { medicine in
                                            VerticalProductItemCardView(medicine: medicine)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Helper for Header with "View All" Button
func headerWithViewAll(title: String, viewModel: MedicineViewModel) -> some View {
    HStack {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
        
        Spacer()
        
        NavigationLink(destination: ViewAllView(viewModel: viewModel, title: title)) {
            Text("View All")
                .foregroundColor(.blue)
        }
    }
    .padding(.horizontal)
}

// MARK: - Flash Sales Section
struct FlashSaleSection: View {
    @ObservedObject var viewModel: MedicineViewModel
    
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

// MARK: - New Releases Section
struct NewReleasesSection: View {
    @ObservedObject var viewModel: MedicineViewModel
    
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

// MARK: - Category Section
struct CategorySection: View {
    @ObservedObject var viewModel: MedicineViewModel
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
    MedicineView()
}
