//
//  OpenAIService.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 11/9/24.
//

import Foundation
import ChatGPTSwift

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
        var message = "Pretend that you are a professional pharmacist or doctor and you own an online pharmacy application. Everyday, user will use your application to buy medicines. Before purchasing, user will ask you issues related to his/her health and want to hear your advice. Please give user advices to improve his/her health and also if you can find any kind of medicines in your pharmacy store that can help user then tell user the name of the medicines. Here is list of medicines with their description currently available in your store:\n"
        
        for medicine in MockDataUtil.getMockMedicines() {
            if medicine.name != nil && !medicine.name!.isEmpty {
                message += "\n"
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
}
