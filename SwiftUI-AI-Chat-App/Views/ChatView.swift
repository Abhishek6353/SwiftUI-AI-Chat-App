//
//  ChatView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 01/09/25.
//

import SwiftUI

struct ChatView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = ChatViewModel()
    
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .tint(.primaryWhite)
                            .imageScale(.medium)
                            .frame(width: 42, height: 42)
                    }
                    .background(._3_C_3_C_4_A)
                    .clipShape(Circle())
                    
                    Spacer()
                }
                
                Text("New Chat")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20))
                    .foregroundStyle(.primaryText)
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            .background(.secondaryBackground)
            
            ScrollView {
                ForEach(vm.messages) { msg in
                    ChatBubbleView(message: msg)
                }
                .padding(.top, 30)
            }
            
            
            HStack {
                TextField(
                    text: $messageText,
                    prompt: Text("Ask anything")
                        .foregroundColor(.primaryWhite.opacity(0.7))
                ) {
                    EmptyView()
                }
                .padding(.horizontal, 10)
                .foregroundColor(.primaryText)
                
                Button(action: {
                    guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    vm.messages.append(Message(text: messageText, isUser: true))
                    messageText = ""
                    
                }) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.primaryWhite)
                        .padding()
                        .background(.primaryOrange)
                    
                }
                .clipShape(.circle)
                .padding(.trailing, 10)
                
            }
            .frame(height: 60)
            .background(.secondaryBackground)
            .border(.primaryBorder, width: 2)
            .clipShape(.capsule)
            .padding(.horizontal, 20)
            .padding(.bottom, 35)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ChatView()
}
