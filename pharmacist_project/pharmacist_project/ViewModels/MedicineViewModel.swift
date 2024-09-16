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

import Foundation
import SwiftUI

enum HomeFilter: String {
    case flashSale = "Flash Sales"
    case newReleases = "New Releases"
}

class MedicineViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    @Published var filteredMedicines: [Medicine] = []
    @Published var selectedCategory: Category? = nil
    @Published var selectedHomeFilter: HomeFilter? = nil
    @Published var availableCategories: [String] = []
    @Published var searchText: String = ""
    @Published var isViewAllActive: Bool = true
    @Published var isSearching: Bool = false
    
    init() {
        Task {
            await loadMedicines()
        }
    }
    
    // Load Medicines from Firebase
    func loadMedicines() async {
        do {
            let loadedMedicines = try await MedicineService.shared.getAllDocuments()
            DispatchQueue.main.async {
                self.medicines = loadedMedicines
                self.filteredMedicines = loadedMedicines
                self.generateAvailableCategories()
            }
        } catch {
            print("Failed to load medicines: \(error)")
        }
    }
    
    func generateAvailableCategories() {
        let categorySet = Set(medicines.compactMap { $0.category?.rawValue.capitalized })
        availableCategories = Array(categorySet)
        
        if medicines.contains(where: { $0.priceDiscount != nil }) {
            availableCategories.insert(HomeFilter.flashSale.rawValue, at: 0)
        }
        
        if medicines.contains(where: { Calendar.current.isDateInLast30Days($0.createdDate ?? Date()) }) {
            availableCategories.insert(HomeFilter.newReleases.rawValue, at: 1)
        }
    }
    
    func filterMedicines() {
        isSearching = !searchText.isEmpty
        
        var result = medicines.filter { medicine in
            searchText.isEmpty || medicine.name?.localizedCaseInsensitiveContains(searchText) == true
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
            selectedHomeFilter = nil
            isViewAllActive = false
        } else if let homeFilter = selectedHomeFilter {
            switch homeFilter {
            case .flashSale:
                result = result.filter { $0.priceDiscount != nil && $0.priceDiscount! < $0.price! }
            case .newReleases:
                result = result.filter {
                    if let createdDate = $0.createdDate {
                        return Calendar.current.isDateInLast30Days(createdDate)
                    }
                    return false
                }
            }
            selectedCategory = nil
            isViewAllActive = false
        } else if isSearching {
            isViewAllActive = false
        } else {
            isViewAllActive = true
        }
        filteredMedicines = result
    }
    
    func handleViewAll(for category: Category?) {
        selectedCategory = category
        selectedHomeFilter = nil
        isViewAllActive = false
        filterMedicines()
    }
    
    func handleViewAll(for filter: HomeFilter?) {
        selectedHomeFilter = filter
        selectedCategory = nil
        isViewAllActive = false
        filterMedicines()
    }
    
    func clearFilters() {
        selectedCategory = nil
        selectedHomeFilter = nil
        searchText = ""
        isViewAllActive = true
        filterMedicines()
    }
}

extension Calendar {
    // MARK: - Check if Date is within the Last 30 Days
    func isDateInLast30Days(_ date: Date) -> Bool {
        return date >= self.date(byAdding: .day, value: -30, to: Date())!
    }
}
