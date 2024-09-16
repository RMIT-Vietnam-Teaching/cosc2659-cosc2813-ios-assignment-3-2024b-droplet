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
//        try await MedicineService.shared.deleteAllDocuments()
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
                name: "Morningkids Multivitamin Syrup Vitamin and Mineral Supplement (150ml)",
                price: 275000,
                priceDiscount: 275000,
                availableQuantity: 999,
                description: "The first years of life are an important stage of development for your baby. Providing your baby with a complete source of nutrients is the way to help your baby grow comprehensively and the best way is to choose a product that provides additional multivitamins in addition to the nutrition in meals to ensure that your baby's body has the necessary micronutrients.",
                ingredients: "Vitamin B3, Canxi, Magie, Vitamin E, Vitamin B5, Vitamin B9",
                supplement: "Morningkids Multivitamin is manufactured by ERBEX S.R.L, Italy. ERBEX S.R.L is one of the world's famous brands with product lines of nutritional supplements, natural herbal medicines, herbal products to help improve health. With a factory strictly controlled according to international HACCP (Hazard Analysis and Critical Control Point) rules. All raw materials imported by ERBEX S.r.l have certificates from quality assurance analysts, no pesticides, no radioactive waste and chemicals, carefully selected by reputable suppliers, so the company's products always ensure the best quality for the health of users.",
                note: "Do not exceed the recommended daily dose. The product is not a substitute for a varied diet and a healthy lifestyle. Due to the natural herbal origin and content of the ingredients, the product may have sediment. This does not affect the effectiveness and safety of the product.",
                sideEffect: "There is no information about side effects of the product.",
                dosage: "Take 10 ml daily. Shake well before use. Feed your child with a hygienic cup and spoon.",
                supplier: "ERBEX S.R.L",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/320x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00017886_special_kid_multivitamins_125ml_8621_5fb3_large_78ae9d56db.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/768x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00029661_morningkids_multivitamin_150ml_8650_6019_large_f260d0cf62.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00029661_morningkids_multivitamin_150ml_3113_6019_large_1f82be5de3.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00029661_morningkids_multivitamin_150ml_7939_6019_large_116d308ede.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00029661_morningkids_multivitamin_150ml_5382_6019_large_cf6fc371d5.JPG",
                ],
                category: .vitamin,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "7",
                name: "Phuc Nhan Khang premium eye supplement helps improve eyesight (1 bottle x 30 pills)",
                price: 220000,
                priceDiscount: 200000,
                availableQuantity: 999,
                description: "Phuc Nhan Khang helps improve eyesight, reduce eye pain, eye fatigue, blurred vision, dry eyes, night blindness. Helps limit vision loss in people with macular degeneration and cataracts. Helps limit myopia and progressive myopia. Provides antioxidants, helps reduce the risk of eye aging.",
                ingredients: "DHA, L-acetylcysteine, Vitamin C, acetyl-L-carnitine",
                supplement: "Phuc Nhan Khang premium eye supplement is designed to support eye health and improve vision. It helps to alleviate eye pain, fatigue, blurred vision, dry eyes, and night blindness. Additionally, it assists in reducing the risk of vision loss in people with macular degeneration and cataracts, and limits the progression of myopia. The supplement provides antioxidants that protect the eyes from aging effects. The key ingredients, such as DHA, L-acetylcysteine, Vitamin C, and acetyl-L-carnitine, are essential nutrients that contribute to overall eye health and function.",
                note: "Do not use for people who are sensitive to any ingredient of the product. Do not exceed the recommended dose. This product is not a medicine and is not intended to replace medicine. Read the instructions carefully before use.",
                sideEffect: "Possible side effects of using Phuc Nhan Khang may include mild gastrointestinal discomfort, such as nausea or upset stomach, especially if taken on an empty stomach. Rarely, allergic reactions may occur in individuals sensitive to any of its ingredients, which could manifest as rash, itching, or swelling. In such cases, discontinue use immediately and consult a healthcare professional. Always use the supplement as directed and do not exceed the recommended dose.",
                dosage: "Children from 5 to 7 years old: 1 tablet each time, 2 times a day. Children from 8 to 12 years old: 2 tablets each time, 2 times a day. From 12 years old and adults: 2 tablets each time, 2 - 3 times a day. Each course of use is 4 - 6 weeks, 2 consecutive courses should be 1 week apart. Preventive nutritional supplement for the eyes: 1 tablet per day.",
                supplier: "RIO PHARMACY Vietnam",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/768x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/1_32a481a86a.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/768x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/3_d89b786838.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/4_042dd4baf5.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/5_d9765683b7.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/2_8a6f4c898e.jpg",
                ],
                category: .vitamin,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "8",
                name: "Nat B tablets treat Vitamin B deficiency and support health maintenance functions (3 blisters x 10 tablets)",
                price: 170000,
                priceDiscount: 140000,
                availableQuantity: 999,
                description: "Nat - B is manufactured by Mega Lifesciences Public Company Limited., with main ingredients including B vitamins, nicotinamide, folic acid, choline bitartrate, biotin and inositol, is a medicine used to treat vitamin B deficiency and support health maintenance functions when the need for vitamin B increases (stress, surgery...).",
                ingredients: "Choline, Inositol, Nicotinamide, Canxi Pantothenate, Vitamin B12, Vitamin B6, Vitamin B2, Vitamin B1, Biotin, Acid folic",
                supplement: "Nat B tablets are formulated to treat vitamin B deficiency and support overall health maintenance, especially during periods when the body requires additional vitamin B, such as times of stress, recovery from surgery, or increased physical activity. The combination of B vitamins (B1, B2, B6, B12), nicotinamide, folic acid, choline bitartrate, biotin, and inositol provides comprehensive support for energy metabolism, nerve function, red blood cell formation, and the maintenance of healthy skin and muscles. Regular intake of Nat B can help to prevent deficiencies that might result from poor diet, lifestyle factors, or certain medical conditions.",
                note: "Do not use for people who are sensitive to any ingredient of the product. Do not exceed the recommended dose. This product is not a medicine and is not intended to replace medicine. Read the instructions carefully before use.",
                sideEffect: "Nat B tablets are generally well tolerated, but some users may experience mild side effects, particularly when taking the supplement for the first time. Possible side effects include gastrointestinal discomfort such as nausea, diarrhea, or abdominal pain. Some individuals may also experience headaches, dizziness, or skin reactions like itching or rash. If any of these symptoms persist or worsen, it is advisable to stop taking the supplement and consult a healthcare professional. Always use the product as directed and consult a doctor if you have any pre-existing conditions or concerns.",
                dosage: "Adults take 1 tablet per day. Note: The above dosage is for reference only. The specific dosage depends on your physical condition and the progression of the disease. For the appropriate dosage, you should consult your doctor or health professional.",
                supplier: "Mega Vietnam, 5805/2020/ÐKSP",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00005138_nat_b_50mg_3693_60a2_large_a62f652a85.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00005138_nat_b_50mg_1629800481_e2aa5aa5e1.jpg",
                    "https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2022/07/natb-3-e1658920094517.jpg",
                    "https://cdn.thegioididong.com/Products/Images/11478/237548/nat-b-h-30v-2.jpg",
                    "https://vn.megawecare.com/wp-content/uploads/2022/06/Hinh-Packshot-3.png",
                ],
                category: .vitamin,
                pharmacyId: "1",
                createdDate: Date()),

            Medicine(
                id: "9",
                name: "Blood Pressure+++ Jpanwell pills support blood pressure (60 pills)",
                price: 960000,
                priceDiscount: 768000,
                availableQuantity: 999,
                description: "Blood Pressure+++ helps stabilize and regulate blood pressure, increase blood flow to the body, and enhance blood circulation to organs. Reduces symptoms: Dizziness, headache, rapid heartbeat, anxiety and restlessness. Helps reduce numbness in hands, feet, shoulders, neck and nape.",
                ingredients: "Taurine , Onion Peel Powder , Vitamin B12 , Vitamin B1 , Black Sesame , Fermented Soybeans , Magnesium , Black Garlic , Potassium , GABA , Calcium , Maca Extract , Sardine Peptides",
                supplement: "Sardine peptides: Is an ingredient extracted from fresh sardine meat. Helps reduce blood pressure , improve endothelial function and reduce stiffness in the arteries of people with prehypertension and hypertension. Nattokinase: Dissolves abnormally entangled fibrin strands and blood clots that block cerebral blood vessels - the cause of 80% of strokes.",
                note: "Do not use for people who are sensitive to any ingredient of the product. This product is not a medicine and is not a substitute for medicine. Read instructions carefully before use.",
                sideEffect: "There is no information about side effects of the product.",
                dosage: "Take 2 capsules/day with cold or warm water.",
                supplier: "GENSEI CO.,LTD",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00032919_vien_uong_ho_tro_huyet_ap_blood_pressure_jpanwell_60v_2806_61aa_large_085443011e.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00032919_vien_uong_ho_tro_huyet_ap_blood_pressure_jpanwell_60v_4878_61aa_large_98962d8591.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00032919_vien_uong_ho_tro_huyet_ap_blood_pressure_jpanwell_60v_6708_61aa_large_fe219b764f.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00032919_vien_uong_ho_tro_huyet_ap_blood_pressure_jpanwell_60v_1521_61a5_large_61a889f10b.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00032919_vien_uong_ho_tro_huyet_ap_blood_pressure_jpanwell_60v_5669_61a5_large_1e2df2f228.jpg",
                ],
                category: .cardiovascular,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "10",
                name: "Omexxel Cardio Excelife tablets help maintain cardiovascular health (2 blisters x 15 tablets)",
                price: 405000,
                priceDiscount: 243000,
                availableQuantity: 999,
                description: "Omexxel Cardio Excelife helps increase antioxidant capacity, helps limit atherosclerosis, and helps maintain cardiovascular health.",
                ingredients: "Grape seed extract , Coenzyme Q10 , Vitamin K2 , Vitamin B6 , Folic acid , Vitamin B12 , Excipients just enough",
                supplement: "An important substance in the process of cellular respiration. CoQ10 's effect in preventing and treating heart disease is due to its ability to improve energy production in cells, improve heart muscle contraction, inhibit blood clot formation, and act as an antioxidant. A major clinical study showed that people who supplemented with CoQ10 daily for 3 days after a heart attack had fewer heart attacks and chest pain.",
                note: "Do not use for children under 12 years old or people who are sensitive to any ingredient of the product. Pregnant or nursing women should consult a physician before use. This product is not a medicine and is not a substitute for medicine.",
                sideEffect: "There is no information about side effects of the product.",
                dosage: "Adults 18 years of age and older: Take 1 tablet/time x 2 - 3 times/day. Drink 30 minutes before meals.",
                supplier: "Excelife Technology",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00030899_omexxel_cardio_excelife_2x15_1932_60d2_large_744b3a60dc.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00030899_omexxel_cardio_excelife_2x15_1455_60d2_large_94283673b2.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00030899_omexxel_cardio_excelife_2x15_1678_60d2_large_677ea33ab1.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00030899_omexxel_cardio_excelife_2x15_1980_6327_large_631cdd5f4e.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00030899_omexxel_cardio_excelife_2x15_5005_6327_large_fdb47a661b.jpg",
                ],
                category: .cardiovascular,
                pharmacyId: "1",
                createdDate: Date()),
            
            Medicine(
                id: "11",
                name: "BiogastroIBS BiovaGen tablets supplement beneficial bacteria to help balance intestinal microflora (30 tablets)",
                price: 655000,
                priceDiscount: 524000,
                availableQuantity: 999,
                description: "Biogastro IBS supplements beneficial bacteria to help balance intestinal microflora, support improvement of symptoms of irritable bowel syndrome such as abdominal pain , bloating, flatulence, diarrhea, constipation, reduce digestive disorders caused by intestinal dysbiosis.",
                ingredients: "Lactobacillus plantarum , Bulking agent , Anti-caking agent , Capsule shell",
                supplement: "Irritable bowel syndrome, also known as IBS, is a common digestive disorder characterized by symptoms such as constipation, diarrhea, abdominal pain, and discomfort after eating. IBS can affect a person’s quality of life and productivity, so finding ways to manage these symptoms is important.",
                note: "Do not use for people who are sensitive to any ingredient of the product. Do not exceed recommended dose. This product is not a medicine and is not a substitute for medicine. Read instructions carefully before use.",
                sideEffect: "There is no information about side effects of the product.",
                dosage: "Adults and children over 6 years: 1 tablet daily, taken with water.",
                supplier: "LALLEMAND HEALTH SOLUTIONS INC",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/DSC_04798_c7a03c49df.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/DSC_04799_cf79032986.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/DSC_04790_06ac5c2a6b.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/DSC_04792_3432f2ccb8.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/DSC_04800_84b37a5a6a.jpg",
                ],
                category: .probiotic,
                pharmacyId: "1",
                createdDate: Date()
            ),
            
            Medicine(
                id: "12",
                name: "Bifina R Health Aid probiotics supplement beneficial bacteria for digestion, reduce digestive and colon disorders (60 packs)",
                price: 1000000,
                priceDiscount: 0,
                availableQuantity: 999,
                description: "Bifina R probiotics supplement beneficial bacteria for the digestive system, helping to reduce symptoms of digestive and colon disorders.",
                ingredients: "Lactobacilus , Bifidobacterium , Excipients just enough",
                supplement: "Bifina R probiotics contain the two most important types of intestinal probiotics, including 2.5 billion Bifido probiotics and 1 billion Lactobacillus probiotics. When entering the intestines, Lactobacillus will stimulate Bifido to grow stronger. In addition, the product also provides Oligosaccharide, a type of soluble fiber and a favorite food of probiotics. Therefore, when entering the intestines, probiotics will multiply rapidly because they have been provided with a ready source of food for growth.",
                note: "Do not use for people who are sensitive to any ingredient of the product. Do not exceed recommended dose. This product is not a medicine and is not a substitute for medicine.",
                sideEffect: "There is no information about side effects of the product.",
                dosage: "Children 3 years and older: Use 1 packet/day. Adults: Use 1 - 3 packs/day. Don't chew, just swallow. Use immediately after opening the package.",
                supplier: "MORISHITA JINTAN CO.LTD",
                images: [
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00008385_men_vi_sinh_bifina_60_goi_8831_5fdb_large_f4d431b3e4.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00008385_men_vi_sinh_bifina_60_goi_4915_5fdb_large_8d3da0df02.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00008385_men_vi_sinh_bifina_60_goi_4539_5fdb_large_751797f254.JPG",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00008385_men_vi_sinh_bifina_60_goi_1608200761_cbd969b798.jpg",
                    "https://cdn.nhathuoclongchau.com.vn/unsafe/636x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/00008385_men_vi_sinh_bifina_60_goi_7049_5fdb_large_b0442313cd.JPG",
                ],
                category: .probiotic,
                pharmacyId: "1",
                createdDate: Date()),

            
            Medicine(
                id: "13",
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
