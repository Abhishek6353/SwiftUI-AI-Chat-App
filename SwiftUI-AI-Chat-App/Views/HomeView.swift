//
//  ContentView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 30/08/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLogoutAlert = false
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                        
                        Text(vm.userName.isEmpty ? "User" : vm.userName)
                            .fontWeight(.bold)
                            .font(Font.system(size: 20))
                            .foregroundStyle(.primaryOrange)
                    }
                    Spacer()
                    
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .tint(.primaryWhite)
                            .imageScale(.large)
                            .frame(width: 42, height: 42)
                    }
                    
                }
                .frame(height: 42)
                .padding(.horizontal, 20)
                
                Spacer(minLength: 30)
                
                VStack(alignment: .leading, spacing: 15) {
                    if !vm.sessions.isEmpty {
                        Text("Recent Chats")
                            .fontWeight(.bold)
                            .font(Font.system(size: 20))
                            .foregroundStyle(.primaryText)
                    }
                    
                    if vm.isLoading {
                        ProgressView("Loading chats...")
                            .foregroundColor(.primaryText)
                            .padding()
                    } else if vm.sessions.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No chats yet")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            Text("Start a new chat by tapping\n'Ask Me Anything' below.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    } else {
                        List {
                            ForEach(vm.sessions) { item in
                                NavigationLink(destination: ChatView(sessionId: item.id, sessionTitle: item.title)) {
                                    SessionRowView(session: item)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        Task {
                                            await vm.deleteSession(item)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                            .listRowBackground(Color.primaryBackground)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                    
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
                
                NavigationLink(destination: ChatView(sessionId: nil, sessionTitle: "New Chat")) {
                    Text("Start New Chat")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .foregroundStyle(.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.primaryOrange)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
                
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.primaryBackground)
            .navigationBarHidden(true)
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    authVM.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
}

struct SessionRowView: View {
    let session: Session
    var body: some View {
        HStack {
            Image(systemName: "ellipsis.message.fill")
                .frame(width: 32, height: 32)
                .imageScale(.medium)
                .foregroundStyle(.primaryWhite)
            Text(session.title)
                .font(.system(size: 16))
                .foregroundStyle(.primaryText)
                .lineLimit(1)
            Spacer()
        }
        .padding(10)
        .background(.secondaryBackground)
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
}
