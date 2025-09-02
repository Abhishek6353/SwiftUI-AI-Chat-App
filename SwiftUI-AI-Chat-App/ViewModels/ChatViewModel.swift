//
//  ChatViewModel.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 02/09/25.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    
    // Static sample conversation
    static let sampleConversation: [Message] = [
        Message(text: "Hello Askly 👋", isUser: true),
        Message(text: "Hi there! How can I help you today?", isUser: false),
        Message(text: "Can you explain quantum computing in simple terms?", isUser: true),
        Message(text: "Sure! Quantum computing uses quantum bits (qubits) instead of regular bits. Qubits can be 0 and 1 at the same time, allowing computers to solve some problems much faster.", isUser: false),
        Message(text: "Wow, that’s cool!", isUser: true),
        Message(text: "It really is! Would you like me to give an analogy?", isUser: false)
    ]
    
    init() {
        // Load sample conversation
        self.messages = ChatViewModel.sampleConversation
    }
    
    func sendMessage() {
        guard !currentInput.isEmpty else { return }
        
        let userMessage = Message(text: currentInput, isUser: true)
        messages.append(userMessage)
        
        // Clear input
        currentInput = ""
        
        // Fake AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = Message(text: "🤖 This is a placeholder AI response to: '\(userMessage.text)'", isUser: false)
            self.messages.append(reply)
        }
    }
}
