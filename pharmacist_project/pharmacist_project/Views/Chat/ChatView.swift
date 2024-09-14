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
    @State private var messages: [(String, Bool)] = []
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.0) { message, isUser in
                        HStack {
                            if isUser {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                            } else {
                                Text(message)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                                Spacer()
                            }
                        }
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
                            messages.append((prompt, true))
                            
                            let currentPrompt = prompt
                            prompt = ""
                            
                            isLoading = true
                            
                            Task {
                                do {
                                    let aiResponse = try await OpenAIService.shared.sendMessage(text: currentPrompt)
                                    messages.append((aiResponse, false))
                                } catch {
                                    messages.append(("Unable to get a response.", false))
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
