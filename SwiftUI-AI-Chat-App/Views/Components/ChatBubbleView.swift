//
//  ChatBubbleView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 02/09/25.
//

import SwiftUI

struct ChatBubbleView: View {
    
    let message: Message
    
    var body: some View {
        
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(10)
                .background(message.isUser ? ._3_C_3_C_4_A : ._1_C_1_B_20)
                .foregroundColor(.white)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10).stroke(message.isUser ? Color.clear : .primaryBorder, lineWidth: 2)
                })
                .cornerRadius(10)
                .frame(maxWidth: 320, alignment: message.isUser ? .trailing : .leading)
            if !message.isUser {
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        
    }
}

#Preview {
    ChatBubbleView(message: Message(content: "Hi", isUser: true))
    ChatBubbleView(message: Message(content: "How can I help you?", isUser: false))
    ChatBubbleView(message: Message(content: "create an app which require info from user and create an working portfolio website.", isUser: true))
    ChatBubbleView(message: Message(content: "Great question 👍 Let’s walk step-by-step on how to build a basic chat UI in SwiftUI. I’ll show you the MVP version (simple user + AI messages, scrollable bubbles, input bar). Later, you can enhance with real API calls, persistence, and streaming.", isUser: false))
}
