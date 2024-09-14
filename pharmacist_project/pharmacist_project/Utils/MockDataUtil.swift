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
        let res = getMockMedicines()
        
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
    
    static func getMockMedicines() -> [Medicine] {
        let res = [
            Medicine(
                id: "1",
                name: "Life Omega-3 Fish Oil 1000mg, 30 Capsules",
                price: 180000,
                priceDiscount: 160000,
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
                category: .vitamin,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "2",
                name: "Life Multi Vitamin for Men, 30 Tablets",
                price: 225000,
                priceDiscount: 200000,
                availableQuantity: 999,
                description: "Apollo Life multivitamin tablets for men are formulated with a selection of vitamins, minerals and herbal extracts designed to support the mental and physical health needs of adult men. Containing Panax ginseng, ashwagandha, and green tea extract, these tablets aim to revitalise the body and mind, helping you stay physically active.\nThe blend of nutrients is also tailored to help relieve stress and tension, contributing to an improvement in overall mental health. These are intended as a nutraceutical addition to your daily diet; they are not meant as a replacement for medicinal treatment.",
                ingredients: "Vitamins, Minerals With Potent Natural Extract, Panax Ginseng Extract, Curcumin, Lutein.",
                supplement: "Vitamins and Minerals: A broad spectrum of essential vitamins and minerals that support overall health, vitality, and well-being.\nPanax Ginseng Extract: Known for its ability to boost energy levels, improve physical stamina, and enhance cognitive function.\nAshwagandha: This traditional herb is included for its stress-reducing and vitality-enhancing properties.\nGreen Tea Extract: Provides antioxidant benefits, supports metabolic health, and may enhance mental alertness.",
                note: "Revitalising energy boost: The multivitamin for men tablets are formulated with essential vitamins and minerals that revitalise the body and mind. They replenish your energy levels, making you feel refreshed and invigorated throughout the day.\nPhysical vitality: The active ingredients in this multivitamin for men contribute to physical vitality. These nutrients help to keep you physically active, promoting a healthier and more energetic lifestyle.\nStress relief: It also aids in alleviating tension and stress, helping you manage your daily tasks more effectively without feeling overwhelmed.",
                sideEffect: "No specific side effects were mentioned for this multivitamin in the description. However, general side effects associated with multivitamin supplements can include:\nNausea or upset stomach, especially when taken on an empty stomach.\nHeadaches or dizziness, although rare, could occur depending on individual sensitivity to certain ingredients.\nAllergic reactions, particularly if sensitive to any specific component.",
                dosage: "Men Daily Supplement. Consume one tablet daily or as directed by your healthcare professional. Remember not to exceed the recommended daily usage.",
                supplier: "Apollo Healthco Limited - 19, Bishop Gardens, Raja Annamalaipuram, Chennai - 600028 (Tamil Nadu)",
                images: [
                    "https://images.apollo247.in/pub/media/catalog/product/a/p/apm0025-01_2.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/a/p/apm0025-02_2.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/a/p/apm0025-03_1.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/a/p/apm0025-07.jpg",
                    "https://images.apollo247.in/pub/media/catalog/product/a/p/apm0025-06_1.jpg",
                ],
                category: .vitamin,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "3",
                name: "DHC Calcium + CBP calcium supplement pills (Pack of 120 pills)",
                price: 173000,
                priceDiscount: 138000,
                availableQuantity: 999,
                description: "DHC Calcium + CBP is a calcium supplement to help strengthen bones; Supports height development in children, prevents rickets, reduces the risk of osteoporosis in the elderly, and helps bones stay healthy in the long term. The product comes from the Japanese brand DHC.",
                ingredients: "Protein, Fat, Carbohydrate, Vitamin D, Canxi, CBP",
                supplement: "Calcium: The most abundant mineral in the body, makes up much of the structure of bones and teeth, and allows the body to move normally by keeping tissues strong and flexible. A small pool of calcium present in the circulatory system, extracellular fluids, and various tissues mediates blood vessel contraction and dilation, muscle function, neurotransmission, and hormones. \nVitamin D: Promotes intestinal calcium absorption and maintains serum calcium and phosphorus concentrations. It is necessary for bone growth and bone regeneration. Vitamin D also has other roles in the body, including reducing inflammation, regulating cell growth, neuromuscular and immune function, and glucose metabolism. \nCBP: The main protein ingredient extracted from colostrum, supports calcium metabolism, helps children increase resistance, absorb nutrients, thereby increasing height better.",
                note: "Enhance bone development \nDHC Calcium + CBP simultaneously provides 3 essential nutrients for the body: calcium, vitamin D3 and CBP. These ingredients all play an important role in helping bones develop evenly, maintaining a strong skeleton, and supporting optimal height increase during the golden growth stages. Therefore, it is especially suitable for children during puberty. \nOn the other hand, using DHC Calcium + CBP also helps prevent some common bone diseases due to calcium deficiency such as porous, brittle, easily broken bones, slow walking, etc. The product is also known for its effectiveness for people with glass bones. \nIn addition to having a positive impact on the skeletal system, regular and reasonable calcium supplementation will help strengthen teeth. Not only that, calcium and protein-rich colostrum extract in the product are also ideal sources of nutrition to increase resistance and support the comprehensive development of children.",
                sideEffect: "No specific side effects were mentioned for this product in the description.",
                dosage: "Take 4 pills/day. Take with water or warm water, or chew.",
                supplier: "Biholon Company, Ltd., Osawano factory",
                images: [
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25941_1.jpg"
                ],
                category: .calcium,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "4",
                name: "Pharmacity Bone Health Calcium, Magnesium, Vitamin D3, K2, Zinc tablets to support bones and joints (60 tablets)",
                price: 320000,
                priceDiscount: 100000,
                availableQuantity: 999,
                description: "Bone Health health protection food is a health protection food that helps supplement calcium, DHA, insulin, lysine HCl, zinc and vitamins for the body to help strengthen bones.",
                ingredients: "Calcium Carbonate, Inulin, Magnesium Oxide, Glucose, Vitamin D3, Vitamin K2",
                supplement: "Calcium nano carbonate: Prepared by nano technology with super small size to increase the body's absorption capacity. Calcium plays an important role in the formation and development of the fetus's bones and teeth. \nBecause of the small size of the nano particles, nano calcium can penetrate well into the blood vessels, thereby helping the nervous system function normally and develop the fetus's bones and teeth optimally. \nNano Calcium also helps improve the ability to absorb nutrients, prevent and support the treatment of digestive diseases, balance intestinal bacteria and increase the body's resistance.",
                note: "Supplementing nano calcium and vitamin D3 for the body helps support calcium deficiency conditions such as rickets, osteoporosis, numbness in limbs. \nPrevention of calcium deficiency in calcium-poor diets, little exposure to sunlight, people using corticosteroids for a long time, the elderly, pregnant and breastfeeding women, people who have fallen, people with injuries, people with heavy labor hard work, children are in the stage of height development.",
                sideEffect: "No specific side effects were mentioned for this product in the description.",
                dosage: "Take in the morning. \nChildren over 6 years old: Take 1 tablet, once a day. \nAdults: Take 2 tablets, once a day.",
                supplier: "La Terre France Pharmaceutical Joint Stock Company 08A Phu Thanh Hamlet, Phuoc Ly Commune, Can Giuoc District, Long An Province, Vietnam",
                images: [
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/20240731095147-1-P21969_1.jpg",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P21969_3.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P21969_4.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P21969_5.png",
                ],
                category: .calcium,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "5",
                name: "VROHTO Mineral Tear Eye Drops Moisturize and Replenish Minerals (13ml Bottle)",
                price: 62000,
                priceDiscount: 56000,
                availableQuantity: 999,
                description: "V.ROHTO Mineral Tear is a popular eye drop product, trusted by many people to soothe and moisturize the eyes. This product is especially useful for people who often work with computers, wear contact lenses or live in polluted environments, causing dry eyes.",
                ingredients: "Sodium Chloride, Sodium Bicarbonate, Potassium Chloride, Calcium Chloride Hydrate, Sodium Chondroitin Sulfate, Hypromellose, Boric Acid, Sodium Borate, Sodium Hyaluronate, Polysorbate, Polyoxyethylene Polyoxypropylene Glycol, Disodium Edetate Hydrate, Polyhexamethylene Biguanide",
                supplement: "Rohto Mineral Tear also contains 4 mineral ingredients: Na+, K+, Ca2+, HCO3- to provide elements similar to natural tears, helping to regenerate tears, moisturize and soothe dry eyes. In addition, this is also an eye drop product that can be used even when wearing contact lenses. In particular, V.Rohto Mineral Tear moisturizes, creating a film between the eyes and contact lenses, which helps protect the eyes, creating a comfortable, pleasant feeling when wearing and removing lenses. The operation of removing and inserting contact lenses also becomes easier thanks to the moisture film that the eye drops bring.",
                note: "Reduce dry eyes, moisturize eyes. Supplement artificial tears and minerals, help moisturize, soothe dry eyes. Restore and create comfort for tired eyes, mild eye irritation, eye discomfort due to wearing contact lenses, blurred vision.",
                sideEffect: "",
                dosage: "Drop 1-2 drops into the eye at a time. \nCan be used several times a day depending on dry eyes, eye fatigue and eye discomfort. \nCan be used for people who do not wear contact lenses, are wearing or after removing contact lenses.",
                supplier: "Rohto - Mentholatum (Vietnam) Company Limited",
                images: [
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25354_11.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25354_1.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25354_3.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25354_4.png",
                    "https://prod-cdn.pharmacity.io/e-com/images/ecommerce/1000x1000/P25354_5.png",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "6",
                name: "",
                price: 1,
                priceDiscount: 1,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [
                    "",
                    "",
                    "",
                    "",
                    "",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "7",
                name: "",
                price: 1,
                priceDiscount: 1,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [
                    "",
                    "",
                    "",
                    "",
                    "",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "8",
                name: "",
                price: 1,
                priceDiscount: 1,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [
                    "",
                    "",
                    "",
                    "",
                    "",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "9",
                name: "",
                price: 1,
                priceDiscount: 1,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [
                    "",
                    "",
                    "",
                    "",
                    "",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
            Medicine(
                id: "10",
                name: "",
                price: 1,
                priceDiscount: 1,
                availableQuantity: 999,
                description: "",
                ingredients: "",
                supplement: "",
                note: "",
                sideEffect: "",
                dosage: "",
                supplier: "",
                images: [
                    "",
                    "",
                    "",
                    "",
                    "",
                ],
                category: .mineral,
                pharmacyId: "1",
                createdDate: Date()),
        ]
        
        return res
    }
}
