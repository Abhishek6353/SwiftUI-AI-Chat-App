//
//  ContentView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 30/08/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
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
            
            Spacer(minLength: 30)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Last Prompts")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20))
                    .foregroundStyle(.primaryText)
                
                List {
                    ForEach(0..<5) { item in
                        HStack {
                            Image(systemName: "ellipsis.message.fill")
                                .frame(width: 32, height: 32)
                                .imageScale(.medium)
                                .foregroundStyle(.primaryWhite)
                            
                            Text("Explain quantum computing in simple terms")
                                .font(.system(size: 16))
                                .foregroundStyle(.primaryText)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .padding(10)
                        .background(.secondaryBackground)
                        .cornerRadius(10)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                print("Delete item \(item)")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                print("Liked item \(item)")
                            } label: {
                                Label("Like", systemImage: "hand.thumbsup.fill")
                            }
                            .tint(.green)
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.primaryBackground)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            .overlay(
                // Fade effect at the bottom
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryBackground.opacity(0),  // fully transparent
                        Color.primaryBackground              // solid background
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100), // adjust height of fade
                alignment: .bottom
            )
            
            
            Button(action: {
                /// Action here
            }) {
                Text("Ask Me Anything")
                    .fontWeight(.bold)
                    .font(Font.system(size: 22))
                    .foregroundStyle(.primaryWhite)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.primaryOrange)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
    }
    
}

#Preview {
    HomeView()
}
