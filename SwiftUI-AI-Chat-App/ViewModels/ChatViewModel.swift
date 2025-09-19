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
    private(set) var sessionTitle: String?
    
    init(sessionId: String? = nil, sessionTitle: String) {
        self.sessionId = sessionId
        self.sessionTitle = sessionTitle
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
                    // Create session with placeholder title
                    sessionId = try await chatService.createSession(title: "New Chat")
                }
                if let sessionId {
                    // Save user message
                    try await chatService.addMessage(to: sessionId, message: userMsg)
                    // Save AI message
                    try await chatService.addMessage(to: sessionId, message: aiMsg)
                    
                    // Only generate and update title for the first message pair
                    if messages.count == 2 {
                        Task {
                            do {
                                let generatedTitle = try await geminiService.generateTitle(userMessage: userMsg.content, aiReply: aiMsg.content)
                                let trimmedTitle = generatedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedTitle.isEmpty && trimmedTitle != "New Chat" {
                                    try await chatService.updateSessionTitle(sessionId: sessionId, title: trimmedTitle)
                                }
                            } catch {
                                // Ignore title update errors
                            }
                        }
                    }
                }
                
                isLoading = false
            } catch {
                if let sessionId {
                    // Save error message as a Message
                    let errorMsg = Message(content: "❌ \(error.localizedDescription)", isUser: false)
                    try await chatService.addMessage(to: sessionId, message: errorMsg)
                }
                isLoading = false
            }
        }
    }
}
