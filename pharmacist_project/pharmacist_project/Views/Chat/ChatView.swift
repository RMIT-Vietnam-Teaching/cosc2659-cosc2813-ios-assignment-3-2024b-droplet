//
//  ChatView.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 11/9/24.
//

import SwiftUI
import ActivityIndicatorView

struct ChatView: View {
    @State var prompt: String = ""
    @State private var messages: [([HyperLinkResponse], Bool)] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("Medical Assistant")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Divider()
            }
            .background(Color(.systemBackground))
            
            Spacer()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages.indices, id: \.self) { index in
                            let message = messages[index].0
                            let isUser = messages[index].1
                            HStack {
                                if isUser {
                                    Spacer()
                                    HyperLinkTextView(responses: message)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                                    
                                } else {
                                    HyperLinkTextView(responses: message)
                                        .padding()
                                        .background(Color(.systemGray5))
                                        .cornerRadius(12)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                                    
                                    Spacer()
                                }
                            }
                            .id(index)
                        }
                        
                        if isLoading {
                            HStack {
                                Spacer()
                                ActivityIndicatorView(isVisible: $isLoading, type: .opacityDots(count: 3, inset: 4))
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: $messages.count) { newValue in
                    // Scroll to the last message whenever messages are updated
                    withAnimation {
                        proxy.scrollTo(newValue - 1, anchor: .bottom)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                HStack {
                    TextField("Ask something...", text: $prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        if !prompt.isEmpty {
                            messages.append(([HyperLinkResponse(type: .text, rawText: prompt, medicineId: "")], true))
                            
                            let currentPrompt = prompt
                            prompt = ""
                            
                            isLoading = true
                            
                            Task {
                                do {
                                    let aiResponse = try await OpenAIService.shared.sendAndGetHyperLinkResponse(text: currentPrompt)
                                    messages.append((aiResponse, false))
                                } catch {
                                    messages.append(([HyperLinkResponse(type: .text, rawText: "Unable to get a response.", medicineId: "")], false))
                                }
                                isLoading = false
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .padding(.horizontal)
                
            }
            .padding(.bottom, 10)
        }
        .background(Color(.systemBackground))  
    }
}

#Preview {
    ChatView()
}
