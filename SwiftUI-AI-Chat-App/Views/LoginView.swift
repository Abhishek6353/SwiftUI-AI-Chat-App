//
//  LoginView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        
        VStack {
            Text("Login")
                .foregroundColor(.primaryText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                TextField(text: $email, prompt: Text("Email").foregroundColor(.gray)) {
                    EmptyView()
                }
                .padding()
                .background(Color(.secondaryBackground))
                .foregroundColor(.primaryText)
                .cornerRadius(8)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primaryBorder, lineWidth: 2)
                })
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                
                
                SecureField(text: $password, prompt: Text("Password").foregroundColor(.gray)) {
                    EmptyView()
                }
                .padding()
                .background(Color(.secondaryBackground))
                .foregroundColor(.primaryText)
                .cornerRadius(8)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                })
                .cornerRadius(8)
                .autocapitalization(.none)
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password action
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.primaryOrange)
                    }
                }
                
                Button(action: {
                    // Login action
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                        .foregroundStyle(.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.primaryOrange)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }
                
            }
            .padding(.horizontal, 25)
            .padding(.top, 40)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        
    }
}

#Preview {
    LoginView()
}
