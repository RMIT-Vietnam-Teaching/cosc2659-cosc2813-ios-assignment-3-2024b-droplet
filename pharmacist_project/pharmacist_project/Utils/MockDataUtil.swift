//
//  MockDataUtil.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 9/9/24.
//

import Foundation

class MockDataUtil {
    static func createMockData() async throws {
        try await cleanDataExceptUsers()
        
        try await createMockPharmacies()
        try await createMockMedicines()
        try await createMockCartItems()
        
        print("Create mock data success")
    }
    
    static func cleanDataExceptUsers() async throws {
        try await OrderService.shared.deleteAllDocuments()
        try await OrderItemService.shared.deleteAllDocuments()
        try await CartItemService.shared.deleteAllDocuments()
        try await MedicineService.shared.deleteAllDocuments()
        try await PharmacyService.shared.deleteAllDocuments()
    }
    
    @discardableResult
    static func createMockUsers(_ cnt: Int) async throws -> [AppUser]{
        var res = [AppUser]()
        for i in 0..<cnt {
            let (_, user) = await AuthenticationService.shared.createUserWithName(email: "user\(i)@gmail.com", password: "123456", name: "user\(i)")
            res.append(user!)
        }
        return res
    }
    
    @discardableResult
    static func createMockPharmacies() async throws -> [Pharmacy] {
        let res = [
            Pharmacy(
                id: "1",
                name: "Pharmacity Pharmacy JSC",
                address: "248A No Trang Long, Ward 12, Binh Thanh District, HCMC",
                description: "At Pharmacity, customers will easily find pharmaceuticals, healthcare products, as well as high-end beauty products at home and abroad. Besides, with the multi-channel model, customers can also easily shop and receive advice from a team of professional pharmacists through the pharmacy’s applications, website and hotline (1800 6821), ect…\nPharmacity has been expanding and building strategic cooperative relationships with many leading suppliers, hospitals as well as specialized medical units to not only contribute to improving professional knowledge and enhancing capabilities consulting ability for pharmacists but also contribute to increasing people’s awareness about health care and protection.",
                createdDate: Date()),
            Pharmacy(
                id: "2",
                name: "",
                address: "",
                description: "",
                createdDate: Date()),
        ]
        
        try await PharmacyService.shared.bulkCreate(documents: res)
        
        return res
    }
    
    @discardableResult
    static func createMockMedicines() async throws -> [Medicine] {
        let res = [
            Medicine(
                id: "1",
                name: "Life Omega-3 Fish Oil 1000mg, 30 Capsules",
                price: 180,
                priceDiscount: 160,
                availableQuantity: 999,
                description: "The Apollo Omega 3 Fish Oil, formally known as Apollo Life Omega-3 Fish Oil 1000 mg, comes in a pack of 30 capsules and provides several health benefits. This product is designed to support the function of various organs including the kidneys, liver, heart, and brain. Apollo Omega 3 contains Omega-3 fatty acids, specifically EPA and DHA. EPA aids in nervous function, blood pressure reduction, and triglyceride lowering. DHA supports memory, focus, vision improvement, brain function, and inflammation reduction. This Apollo Fish Oil is purified to be free from heavy metals. Each softgel delivers 9.02 Kcal of energy and 1.003 g of total fat without any protein, carbohydrates, trans fats, or cholesterol. For usage, adults are advised to take one softgel 1-2 times daily with lukewarm water or as per the instructions of a healthcare practitioner.",
                ingredients: "Fish oil, Food-grade gelatin shell.",
                supplement: "Omega-3 Fatty Acids: Each capsule contains significant amounts of EPA and DHA, which are crucial for:\nEPA: Enhances nervous system function, helps lower blood pressure, and reduces triglyceride levels in the bloodstream.\nDHA: Supports brain function including memory and focus, aids in vision improvement, and helps reduce inflammation.",
                note: "The Apollo Omega 3 Fish Oil targets multiple vital organs - kidneys, liver, heart, and brain. This wide-ranging organ support is due to the high concentration of Omega-3 fatty acids in each capsule.\nThe presence of Eicosapentaenoic Acid (EPA) in the Apollo Fish Oil means it has multiple health benefits. EPA improves nervous function, helps lower high blood pressure and can reduce elevated triglyceride levels in the bloodstream.",
                sideEffect: "No specific side effects were mentioned in the product description. However, common side effects associated with Omega-3 supplements, generally not specific to this product unless experienced, can include:\nFishy aftertaste or breath.\nUpset stomach or loose stools, particularly at high doses.\nPossible interaction with blood-thinning medications, if applicable.",
                dosage: "For adults, take one Apollo Omega 3 Fish Oil softgel 1-2 times a day with lukewarm water.\nThis dosage can be adjusted or modified as directed by a healthcare practitioner.\nEnsure that the softgel is swallowed whole, without chewing or breaking it.",
                supplier: "Apollo Healthco Limited - 19, Bishop Gardens, Raja Annamalaipuram, Chennai - 600028 (Tamil Nadu)",
                images: [
                    "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_174942__front__omega-3_fish_oil_4__1.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_175003__back__omega-3_fish_oil_4_.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/i/m/img_20210108_175032__side__omega-3_fish_oil_4__1.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/A/P/APO0077_4-JULY23_1.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/A/P/APO0077_5-JULY23_1.jpg",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "2",
                name: "",
                price: 1200,
                priceDiscount: 1100,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
        ]
        
        try await MedicineService.shared.bulkCreate(documents: res)
        
        return res
    }
    
    @discardableResult
    static func createMockCartItems() async throws -> [CartItem] {
        let res = [
            CartItem(
                id: "1",
                cartId: PreviewsUtil.getPreviewCartId(),
                medicineId: "1",
                quantity: 3,
                createdDate: Date()
            ),
        ]
        
        try await CartItemService.shared.bulkCreate(documents: res)
        return res
    }
}
