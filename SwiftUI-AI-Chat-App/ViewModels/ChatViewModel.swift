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
    
    func sendMessage(_ text: String) {
        let userMsg = Message(text: text, isUser: true)
        messages.append(userMsg)
        
        Task {
            do {
                isLoading = true
                let reply = try await geminiService.sendMessage(prompt: text)
                let aiMsg = Message(text: reply, isUser: false)
                messages.append(aiMsg)
                isLoading = false
            } catch {
                messages.append(Message(text: "❌ \(error.localizedDescription)", isUser: false))
                isLoading = false
            }
        }
    }
}
