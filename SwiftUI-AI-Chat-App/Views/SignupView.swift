//
//  SignupView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject private var vm = SignupViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Text("Sign Up")
                .foregroundColor(.primaryText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                
                // Name Field
                TextField(text: $vm.name, prompt: Text("Name").foregroundColor(.primaryWhite.opacity(0.7))) {
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
                TextField(text: $vm.email, prompt: Text("Email").foregroundColor(.primaryWhite.opacity(0.7))) {
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
                SecureField(text: $vm.password, prompt: Text("Password").foregroundColor(.primaryWhite.opacity(0.7))) {
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
                
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(alignment: .trailing)
                }
                
                
                Spacer().frame(height: 10)
                
                // Sign Up Button
                Button(action: {
                    Task {
                        await vm.signUp()
                    }
                }) {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.primaryOrange)
                            .cornerRadius(10)
                    } else {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                            .foregroundStyle(.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.primaryOrange)
                            .cornerRadius(10)
                    }
                }

                
                Spacer().frame(height: 10)
                
                // Navigate back to Login
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.primaryText)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Login")
                            .foregroundColor(vm.isLoading ? .primaryOrange.opacity(0.5) : .primaryOrange)
                            .fontWeight(.bold)
                    }
                    .disabled(vm.isLoading)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 40)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
        
    }
}

#Preview {
    SignupView()
}
