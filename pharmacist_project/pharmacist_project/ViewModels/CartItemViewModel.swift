/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
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

@MainActor
final class CartItemViewModel: ObservableObject {
    @Published var representImage: String = GlobalUtils.getLoadingImageString()
    @Published var medicineName: String = "loading.."
    @Published var medicine: Medicine? = nil
    @Published var cartItem: CartItem? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let medicineId: String
    
    init(medicineId: String) {
        self.medicineId = medicineId
    }
    
    func loadMedicine() async {
        isLoading = true
        do {
            medicine = try await MedicineService.shared.getDocument(medicineId)
            medicineName = medicine?.name ?? ""
            representImage = medicine?.getRepresentImageStr() ?? GlobalUtils.getLoadingImageString()
        } catch {
            errorMessage = "Failed to load medicine: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func increaseQuantity() async {
        guard let cartItem = cartItem else { return }
        isLoading = true
        do {
            self.cartItem = try await CartItemService.shared.increaseQuantity(cartItemId: cartItem.id)
        } catch {
            errorMessage = "Failed to increase quantity: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func decreaseQuantity() async {
        guard let cartItem = cartItem else { return }
        isLoading = true
        do {
            self.cartItem = try await CartItemService.shared.decreaseQuantity(cartItemId: cartItem.id)
        } catch {
            errorMessage = "Failed to decrease quantity: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
