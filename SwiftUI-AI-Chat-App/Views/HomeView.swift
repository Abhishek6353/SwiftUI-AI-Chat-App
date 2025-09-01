//
//  ContentView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 30/08/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(.primaryOrange)
                        .frame(width: 42, height: 42)
                    
                    Image("placeholderUser")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                }
                
                HStack(spacing: 0) {
                    Text("Hello, ")
                        .font(Font.system(size: 18))
                        .foregroundStyle(.primaryText)
                    
                    Text("Arthur!")
                        .fontWeight(.bold)
                        .font(Font.system(size: 20))
                        .foregroundStyle(.primaryText)
                }
                Spacer()
                
                Button(action: {
                    /// Action here
                }) {
                    Image(systemName: "line.3.horizontal")
                        .tint(.primaryWhite)
                        .imageScale(.large)
                        .frame(width: 42, height: 42)
                }
                
            }
            .frame(height: 42)
            .padding(.horizontal, 20)
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Last Prompts")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20))
                    .foregroundStyle(.primaryText)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<5) { item in
                            HStack {
                                Image(systemName: "ellipsis.message.fill")
                                    .frame(width: 32, height: 32)
                                    .imageScale(.medium)
                                    .foregroundStyle(.primaryWhite)
                                
                                Text("Explain quantum computing in simple terms")
                                    .font(Font.system(size: 16))
                                    .foregroundStyle(.primaryText)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                            .padding(10)
                            .background(.secondaryBackground)
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            
            
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
    }
    
}

#Preview {
    HomeView()
}
