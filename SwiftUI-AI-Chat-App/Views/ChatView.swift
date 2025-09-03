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
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.messages) { msg in
                            ChatBubbleView(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.top, 30)
                }
                .onChange(of: vm.messages.count) { _ in
                    if let lastID = vm.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)

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
//                    vm.messages.append(Message(text: messageText, isUser: true))
                    vm.currentInput = messageText
                    vm.sendMessage()
                    messageText = ""
                    
                }) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.primaryWhite)
                        .frame(width: 40, height: 40)
                        .background(.primaryOrange)
                    
                }
                .clipShape(.circle)
                .padding(.trailing, 6)
                
            }
            .frame(height: 52)
            .background(.secondaryBackground)
            .border(.primaryBorder, width: 2)
            .clipShape(.capsule)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
    }
}

#Preview {
    ChatView()
}
