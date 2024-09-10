//
//  HomeViewModel.swift
//  pharmacist_project
//
//  Created by Leon Do on 10/9/24.
//

import Foundation
import SwiftUI

enum HomeFilter: String {
    case flashSale = "Flash Sales"
    case newReleases = "New Releases"
}

class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var medicines: [Medicine] = []
    @Published var filteredMedicines: [Medicine] = []
    @Published var selectedCategory: Category? = nil
    @Published var selectedHomeFilter: HomeFilter? = nil
    @Published var availableCategories: [String] = []
    @Published var searchText: String = ""
    @Published var isViewAllActive: Bool = false
    
    // MARK: - Initializer
    init() {
        loadMedicines()
        generateAvailableCategories()
        filterMedicines()
    }
    
    // MARK: - Load Test Data
    func loadMedicines() {
        let exampleMedicine = Medicine(
            id: "1",
            name: "Dung dịch Dentanalgi điều trị đau răng, viêm nướu răng, nha chu (chai 7ml)",
            price: 19000,
            priceDiscount: 15000,
            availableQuantity: 50,
            description: "Thuốc trị đau răng Dentanalgi là một loại thuốc được sử dụng để giảm đau và làm giảm triệu chứng đau răng.",
            ingredients: "Hoạt chất: Camphor 420mg, Menthol 280mg, Procain hydroclorid 35mg...",
            supplement: "N/A",
            note: "Consult your doctor if pregnant",
            sideEffect: "Khi sử dụng thuốc...",
            dosage: "Tẩm thuốc vào bông đặt nơi đau, 3 - 4 lần/ngày...",
            supplier: "Dược phẩm OPC",
            images: ["https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P15323_1_l.webp"],
            category: .vitamin,
            pharmacyId: "123",
            createdDate: Calendar.current.date(byAdding: .day, value: -40, to: Date())
        )
        
        let exampleMedicine2 = Medicine(
            id: "2",
            name: "Dung dịch Dentanalgi điều trị đau răng, viêm nướu răng, nha chu (chai 7ml)",
            price: 25000,
            priceDiscount: nil,
            availableQuantity: 30,
            description: "A new product launched recently.",
            ingredients: "Example ingredient list",
            supplement: "N/A",
            note: "Consult your doctor if pregnant",
            sideEffect: "No significant side effects.",
            dosage: "Take one tablet per day.",
            supplier: "New Supplier",
            images: ["https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P15323_1_l.webp"],
            category: .calcium,
            pharmacyId: "456",
            createdDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())
        )
        
        medicines = [exampleMedicine, exampleMedicine2]
        filteredMedicines = medicines
    }
    
    // MARK: - Generate Available Categories
    func generateAvailableCategories() {
        // Create categories based on the loaded medicines
        let categorySet = Set(medicines.compactMap { $0.category?.rawValue.capitalized })
        availableCategories = Array(categorySet)
        
        // Add Flash Sales filter if there are discounted products
        if medicines.contains(where: { $0.priceDiscount != nil }) {
            availableCategories.insert(HomeFilter.flashSale.rawValue, at: 0)
        }
        
        // Add New Releases filter if there are products created within the last 30 days
        if medicines.contains(where: { Calendar.current.isDateInLast30Days($0.createdDate ?? Date()) }) {
            availableCategories.insert(HomeFilter.newReleases.rawValue, at: 1)
        }
    }
    
    // MARK: - Filter Medicines
    func filterMedicines() {
        var result = medicines.filter { medicine in
            searchText.isEmpty || medicine.name?.localizedCaseInsensitiveContains(searchText) == true
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
            selectedHomeFilter = nil
        }
        else if let homeFilter = selectedHomeFilter {
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
        }
        filteredMedicines = result
    }
    
    // MARK: - View All Handler
    func handleViewAll(for category: Category?) {
        selectedCategory = category
        selectedHomeFilter = nil
        isViewAllActive = true
        filterMedicines()
    }
    
    func handleViewAll(for filter: HomeFilter?) {
        selectedHomeFilter = filter
        selectedCategory = nil
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
