//
//  ChatView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 01/09/25.
//

import SwiftUI

struct ChatView: View {
    
    @Environment(\.dismiss) var dismiss

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
                    .background(.secondaryBackground)
                    .clipShape(Circle())
                    
                    Spacer()
                }
                
                Text("New Chat")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20))
                    .foregroundStyle(.primaryText)
                
            }
            .padding(.horizontal, 20)
            
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
    }
}

#Preview {
    ChatView()
}
