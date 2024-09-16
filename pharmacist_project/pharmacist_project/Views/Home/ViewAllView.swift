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

struct ViewAllView: View {
    @ObservedObject var viewModel: MedicineViewModel
    var filterType: HomeFilter? = nil
    var selectedCategory: Category? = nil
    var title: String
    
    var filteredMedicines: [Medicine] {
        if let category = selectedCategory {
            return viewModel.medicines.filter { $0.category == category }
        } else if let filter = filterType {
            switch filter {
            case .flashSale:
                return viewModel.medicines.filter { $0.priceDiscount != nil }
            case .newReleases:
                return viewModel.medicines.filter {
                    if let createdDate = $0.createdDate {
                        return Calendar.current.isDateInLast30Days(createdDate)
                    }
                    return false
                }
            }
        }
        return viewModel.medicines
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                ForEach(filteredMedicines) { medicine in
                    HorizontalProductItemCardView(medicine: medicine)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle(title)
    }
}
