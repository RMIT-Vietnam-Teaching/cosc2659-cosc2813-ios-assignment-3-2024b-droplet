//
//  ChatView.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 11/9/24.
//

import SwiftUI

struct ChatView: View {
    @State var prompt: String = ""
    @State var response: String = ""
    
    var body: some View {
        ScrollView {
            TextField("Ask something..", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Text(response)
            
//            Button("submit and get response by chunk") {
//                if (!prompt.isEmpty) {
//                    Task {
//                        do {
//                            try await OpenAIService.shared.sendMessageStream(text: prompt) { responseLine in
//                                response += responseLine
//                            }
//                        } catch {
//                            print(error.localizedDescription)
//                            response = "can not get response.."
//                        }
//                    }
//                }
//            }
            
            Button("submit and get full response") {
                if (!prompt.isEmpty) {
                    Task {
                        do {
                            try await OpenAIService.shared.sendAndGetHyperLinkResponse(text: prompt)
//                            response = try await OpenAIService.shared.sendMessage(text: prompt)
                        } catch {
                            print(error.localizedDescription)
                            response = "can not get response.."
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ChatView()
}
