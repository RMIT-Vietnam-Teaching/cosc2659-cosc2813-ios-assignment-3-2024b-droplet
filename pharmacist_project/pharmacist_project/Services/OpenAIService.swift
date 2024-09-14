//
//  OpenAIService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 11/9/24.
//

import Foundation
import ChatGPTSwift

enum OpenAIResponseType: String {
    case hyperLink
    case text
}

struct HyperLinkResponse {
    var type: OpenAIResponseType
    var rawText: String
    var medicineId: String
}

class OpenAIService {
    static let shared = OpenAIService()
    private let API_KEY = "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"
    
    private let openAPI: ChatGPTAPI
    
    // configs
    private let model = ChatGPTModel(rawValue: "gpt-4o-mini")!
    private let systemText = "you are a pharmacist"
    private let temperature = 0.5
    
    init() {
        self.openAPI = ChatGPTAPI(apiKey: API_KEY)
    }
    
    func sendAndGetHyperLinkResponse(text: String) async throws -> [HyperLinkResponse] {
        let responseText = try await self.sendMessage(text: text)
        let medicines = try await MedicineService.shared.getAllDocuments()
        var medicineIdToMedicine = [String: Medicine]()
        for medicine in medicines {
            medicineIdToMedicine[medicine.id] = medicine
        }
        
        return parseTextWithMedicineIDs(responseText, medicineIdToMedicine: medicineIdToMedicine)
    }
    
    // full response
    func sendMessage(text: String) async throws -> String {
        let response = try await openAPI.sendMessage(text: text,
                                                     model: model,
                                                     systemText: systemText,
                                                     temperature: temperature)
        return response
    }
    
    // response by chunk
    func sendMessageStream(text: String, 
                           callback: ((_ responseLine: String) -> Void)
    ) async throws {
        let stream = try await openAPI.sendMessageStream(text: text,
                                                         model: model,
                                                         systemText: systemText,
                                                         temperature: temperature)
        for try await line in stream {
            callback(line)
        }
    }
    
    func replaceHistory(_ historyList: [Message]) {
        openAPI.replaceHistoryList(with: historyList)
    }
    
    func deleteHistory() {
        openAPI.deleteHistoryList()
    }
    
    static func getPharmacistHistoryList() -> [Message] {
        var message = "Pretend that you are a professional pharmacist or doctor and you own an online pharmacy application. Everyday, user will use your application to buy medicines. Before purchasing, user will ask you issues related to his/her health and want to hear your advice. Please give user advices to improve his/her health and also if you can find any kind of medicines in your pharmacy store that can help user response with the ids of the medicines (do not specify the name of the medicines), please note that the ids of the medicines must be wrapped by triple asterisk symbols. Here is list of medicines with their description currently available in your store:\n"
        
        for medicine in MockDataUtil.getMockMedicines() {
            if medicine.name != nil && !medicine.name!.isEmpty {
                message += "\n"
                message += "id: \(medicine.id)\n"
                message += "name: \(medicine.name ?? "")\n"
                message += "description: \(medicine.description ?? "")\n"
                message += "\n"
            }
        }
        
        let myHistoryList = [
            Message(role: "user", content: message),
            Message(role: "assistant", content: "Yes, I am ready to advice with user."),
        ]
        return myHistoryList
    }
    
    func parseTextWithMedicineIDs(_ input: String, medicineIdToMedicine: [String: Medicine]) -> [HyperLinkResponse] {
        // Regular expression to match text segments and IDs wrapped in ***
        let pattern = #"(\*\*\*\d+\*\*\*)|([^*]+)"#
        
        // Create a regex object
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // Find matches in the input string
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        
        // Initialize an array to store the result
        var result: [HyperLinkResponse] = []
        
        // Loop through matches
        for match in matches {
            if let range1 = Range(match.range(at: 1), in: input) {
                // If the match group 1 is non-nil, it's an ID wrapped in ***
                let idWithAsterisks = String(input[range1])
                let id = idWithAsterisks.replacingOccurrences(of: "***", with: "")
                result.append(HyperLinkResponse(type: .hyperLink, rawText: medicineIdToMedicine[id]?.name ?? "", medicineId: id))
            } else if let range2 = Range(match.range(at: 2), in: input) {
                // If the match group 2 is non-nil, it's a normal text segment
                let text = String(input[range2])
                result.append(HyperLinkResponse(type: .text, rawText: text, medicineId: ""))
            }
        }
        
        return result
    }
}
