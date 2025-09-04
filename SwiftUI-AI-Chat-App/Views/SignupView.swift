//
//  SignupView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct SignupView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        
        VStack {
            Text("Sign Up")
                .foregroundColor(.primaryText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                
                // Name Field
                TextField(text: $name, prompt: Text("Name").foregroundColor(.primaryWhite.opacity(0.7))) {
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

                
                // Email Field
                TextField(text: $email, prompt: Text("Email").foregroundColor(.primaryWhite.opacity(0.7))) {
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
                
                // Password Field
                SecureField(text: $password, prompt: Text("Password").foregroundColor(.primaryWhite.opacity(0.7))) {
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
                
                Spacer().frame(height: 10)
                
                // Sign Up Button
                Button(action: {
                    // Sign Up action
                }) {
                    Text("Sign Up")
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
    SignupView()
}
