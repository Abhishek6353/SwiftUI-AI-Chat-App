//
//  ChatViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 02/09/25.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    
    private let geminiService = GeminiService()
    private let chatService = ChatService()

    private(set) var sessionId: String?
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        if let sessionId {
            Task {
                do {
                    messages = try await chatService.fetchMessages(for: sessionId)
                    print("✅ Fetched \(messages.count) messages for session \(sessionId)")
                } catch {
                 print("❌ Error fetching messages: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sendMessage(_ content: String) {
        let userMsg = Message(content: content, isUser: true)
        messages.append(userMsg)
        
        Task {
            do {
                isLoading = true
                
                let reply = try await geminiService.sendMessage(prompt: content)
                let aiMsg = Message(content: reply, isUser: false)
                messages.append(aiMsg)
                
                // Save chat session if not already saved
                if sessionId == nil {
                    sessionId = try await chatService.createSession()
                }
                if let sessionId {
                    // Save user message
                    try await chatService.addMessage(to: sessionId, message: userMsg)
                    
                    // Save AI message
                    try await chatService.addMessage(to: sessionId, message: aiMsg)
                }
                
                isLoading = false
            } catch {
                messages.append(Message(content: "❌ \(error.localizedDescription)", isUser: false))
                isLoading = false
            }
        }
    }
}
