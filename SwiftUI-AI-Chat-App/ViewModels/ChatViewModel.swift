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
        print("[DEBUG] Appended user message: \(userMsg.content)")
        isLoading = true
        // Add a placeholder AI message for streaming
        let aiMsg = Message(content: "", isUser: false)
        messages.append(aiMsg)
        print("[DEBUG] Appended placeholder AI message. Total messages: \(messages.count)")
        let aiMsgIndex = messages.count - 1
        var fullAIText = ""
        geminiService.streamMessage(prompt: content, onChunk: { chunk in
            print("[DEBUG] Received AI chunk: \(chunk)")
            Task { @MainActor in
                fullAIText = chunk
                if aiMsgIndex < self.messages.count {
                    self.messages[aiMsgIndex].content = fullAIText
                    print("[DEBUG] Updated AI message content: \(fullAIText)")
                }
            }
        }, onComplete: { finalText in
            print("[DEBUG] AI streaming complete: \(finalText)")
            Task { @MainActor in
                fullAIText = finalText
                if aiMsgIndex < self.messages.count {
                    self.messages[aiMsgIndex].content = fullAIText
                }
                await self.handlePostStreaming(userMsg: userMsg, aiText: fullAIText)
                self.isLoading = false
            }
        }, onError: { error in
            print("[DEBUG] AI streaming error: \(error.localizedDescription)")
            Task { @MainActor in
                if aiMsgIndex < self.messages.count {
                    self.messages[aiMsgIndex].content = "❌ " + error.localizedDescription
                }
                self.isLoading = false
            }
        })
    }

    private func handlePostStreaming(userMsg: Message, aiText: String) async {
        do {
            if sessionId == nil {
                sessionId = try await chatService.createSession(title: "New Chat")
            }
            if let sessionId {
                try await chatService.addMessage(to: sessionId, message: userMsg)
                let savedAI = Message(content: aiText, isUser: false)
                try await chatService.addMessage(to: sessionId, message: savedAI)
                // Only generate and update title for the first message pair
                if messages.count == 2 {
                    do {
                        let generatedTitle = try await geminiService.generateTitle(userMessage: userMsg.content, aiReply: aiText)
                        let trimmedTitle = generatedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedTitle.isEmpty && trimmedTitle != "New Chat" {
                            try await chatService.updateSessionTitle(sessionId: sessionId, title: trimmedTitle)
                        }
                    } catch {
                        // Ignore title update errors
                    }
                }
            }
        } catch {
            if let sessionId {
                let errorMsg = Message(content: "❌ \(error.localizedDescription)", isUser: false)
                try? await chatService.addMessage(to: sessionId, message: errorMsg)
            }
        }
    }
}
