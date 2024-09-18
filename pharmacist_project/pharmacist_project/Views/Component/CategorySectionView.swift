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

struct CategorySectionView: View {
    @State private var showAllCategories = false
    @Binding var selectedCategory: Category?
    @Binding var selectedHomeFilter: HomeFilter?
    var onCategorySelected: (Category?, HomeFilter?) -> Void
    
    var availableCategories: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Categories")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    showAllCategories.toggle()
                }) {
                    Text(showAllCategories ? "Collapse" : "View All")
                        .foregroundColor(.blue)
                }
                
                // Clear button
                if selectedCategory != nil || selectedHomeFilter != nil {
                    Button("Reset") {
                        onCategorySelected(nil, nil)
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if showAllCategories {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(availableCategories, id: \.self) { category in
                        CategoryButtonView(title: category, isActive: isCategoryActive(category: category)) {
                            if category == "Flash Sales" {
                                onCategorySelected(nil, .flashSale)
                            } else if category == "New Releases" {
                                onCategorySelected(nil, .newReleases)
                            } else {
                                onCategorySelected(Category(rawValue: category.lowercased()), nil)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(availableCategories, id: \.self) { category in
                            CategoryButtonView(title: category, isActive: isCategoryActive(category: category)) {
                                if category == "Flash Sales" {
                                    onCategorySelected(nil, .flashSale)
                                } else if category == "New Releases" {
                                    onCategorySelected(nil, .newReleases)
                                } else {
                                    onCategorySelected(Category(rawValue: category.lowercased()), nil)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func isCategoryActive(category: String) -> Bool {
        if category == "Flash Sales" && selectedHomeFilter == .flashSale {
            return true
        } else if category == "New Releases" && selectedHomeFilter == .newReleases {
            return true
        } else if selectedCategory?.rawValue.capitalized == category {
            return true
        }
        return false
    }
}

struct CategoryButtonView: View {
    @Environment(\.colorScheme) private var colorScheme
    var title: String
    var isActive: Bool
    var action: () -> Void
    let buttonWidth: CGFloat = 120
    let buttonHeight: CGFloat = 50
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(isActive ? Color.accentColor.opacity(0.2) : Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .foregroundColor(isActive ? .accentColor : .primary)
        }
    }
}

#Preview {
    @State var selectedCategory: Category? = nil
    @State var selectedHomeFilter: HomeFilter? = nil
    return CategorySectionView(
        selectedCategory: $selectedCategory,
        selectedHomeFilter: $selectedHomeFilter,
        onCategorySelected: { category, filter in
            print("Selected category: \(category?.rawValue ?? "None"), filter: \(filter?.rawValue ?? "None")")
        },
        availableCategories: ["Flash Sales", "New Releases", "Vitamin", "Calcium"]
    )
}
